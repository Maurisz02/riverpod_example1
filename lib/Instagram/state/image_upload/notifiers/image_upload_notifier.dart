import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show Uint8List;
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image/image.dart' as img;
import 'package:uuid/uuid.dart';
import 'package:video_thumbnail/video_thumbnail.dart';

import 'package:riverpod_example1/Instagram/state/image_upload/constants/constants.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/models/file_type.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/typedefs/is_loading.dart';
import 'package:riverpod_example1/Instagram/state/post_setings/models/post_setting.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/user_id.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/exceptions/could_not_build_thumbnail_exception.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/extensions/get_image_data_aspect_ratio.dart';
import 'package:riverpod_example1/Instagram/state/constans/firebase_collection_name.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/extensions/get_collection_name_from_file_type.dart';
import 'package:riverpod_example1/Instagram/state/posts/models/post_payload.dart';

class ImageUploadNotifier extends StateNotifier<IsLoading> {
  //imageuploadnotifier is false at the begining
  ImageUploadNotifier() : super(false);

  set isLoading(bool value) => state = value;

  Future<bool> upload({
    required File file,
    required FileType fileType,
    required String message,
    required Map<PostSetting, bool> postSettings,
    required UserId userId,
  }) async {
    isLoading = true;

    late Uint8List thumbnailUnit8List;

    switch (fileType) {
      case FileType.image:
        final fileAsImage = img.decodeImage(file.readAsBytesSync());
        if (fileAsImage == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        }
        final thumbnail = img.copyResize(
          fileAsImage,
          width: Constants.imageThumbnailWidth,
        );
        final thumbnailData = img.encodeJpg(thumbnail);
        thumbnailUnit8List = Uint8List.fromList(thumbnailData);
        break;
      case FileType.video:
        final thumb = await VideoThumbnail.thumbnailData(
          video: file.path,
          imageFormat: ImageFormat.JPEG,
          maxHeight: Constants.videoThumbnailMaxHeight,
          quality: Constants.videoThumbnailQuality,
        );
        if (thumb == null) {
          isLoading = false;
          throw const CouldNotBuildThumbnailException();
        } else {
          thumbnailUnit8List = thumb;
        }
        break;
    }

    //calculate ascpectRatio
    final thumbnailAspectRatio = await thumbnailUnit8List.getAspectRatio();

    //calculate references
    final fileName = const Uuid().v4();

    //create references to the thumbnail and the image itself
    final thumbnailRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(FirebaseCollectionName.thumbnails)
        .child(fileName);

    final originalFileRef = FirebaseStorage.instance
        .ref()
        .child(userId)
        .child(fileType.collectionName)
        .child(fileName);

    try {
      //upload the thumnail
      final thumbnailUploadTask =
          await thumbnailRef.putData(thumbnailUnit8List);
      final thumbnailStorageId = thumbnailUploadTask.ref.name;

      //upload the original file
      final originalFileUploadTask = await originalFileRef.putFile(file);
      final originalStorageId = originalFileUploadTask.ref.name;

      //upload the post itself
      final postPayLoad = PostPayload(
        userId: userId,
        message: message,
        thumbnailUrl: await thumbnailRef.getDownloadURL(),
        fileUrl: await originalFileRef.getDownloadURL(),
        fileType: fileType,
        fileName: fileName,
        aspectRatio: thumbnailAspectRatio,
        thumbnailStorageId: thumbnailStorageId,
        originalFileStorageId: originalStorageId,
        postSettings: postSettings,
      );
      await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.posts)
          .add(postPayLoad);

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoading = false;
    }
  }
}
