import 'dart:collection' show MapView;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;

import 'package:riverpod_example1/Instagram/state/image_upload/models/file_type.dart';
import 'package:riverpod_example1/Instagram/state/post_setings/models/post_setting.dart';
import 'package:riverpod_example1/Instagram/state/posts/models/post_key.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/user_id.dart';

@immutable
class PostPayload extends MapView<String, dynamic> {
  PostPayload({
    required UserId userId,
    required String message,
    required String thumbnailUrl,
    required String fileUrl,
    required FileType fileType,
    required String fileName,
    required double aspectRatio,
    required String thumbnailStorageId,
    required String originalFileStorageId,
    required Map<PostSetting, bool> postSettings,
  }) : super(
          {
            PostKey.userId: userId,
            PostKey.message: message,
            PostKey.createdAt: FieldValue.serverTimestamp(),
            PostKey.thumbnailUrl: thumbnailUrl,
            PostKey.fileUrl: fileUrl,
            PostKey.fileType: fileType.name,
            PostKey.fileName: fileName,
            PostKey.ascpectRatio: aspectRatio,
            PostKey.thumbnailStorageId: thumbnailStorageId,
            PostKey.originalFileStorageId: originalFileStorageId,
            PostKey.postSettings: {
              for (final postSettings in postSettings.entries)
                postSettings.key.storageKey: postSettings.value,
            },
          },
        );
}
