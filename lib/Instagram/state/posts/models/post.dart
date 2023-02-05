import 'package:flutter/foundation.dart' show immutable;
import 'package:cloud_firestore/cloud_firestore.dart';

import './post_key.dart';
import '../../post_setings/models/post_setting.dart';
import '../../image_upload/models/file_type.dart';

//azért nincs szuper mert egy Post ot kapunk vissza azaz öbmagát nem extendel semmin
@immutable
class Post {
  final String postId;
  final String userId;
  final String message;
  final DateTime createdAt;
  final String thumbnailUrl;
  final String fileUrl;
  final FileType fileType;
  final String fileName;
  final double ascpectRatio;
  final Map<PostSetting, bool> postSettings;
  final String thumbnailStorageId;
  final String originalFileStorageId;

//azért nincs super mert ide a Post class ba teszi be az eredményt
//user_posts_provider olvassa be a doc okat ide
  Post({
    required this.postId,
    required Map<String, dynamic> json,
  })  : userId = json[PostKey.userId],
        message = json[PostKey.message],
        createdAt = (json[PostKey.createdAt] as Timestamp).toDate(),
        thumbnailUrl = json[PostKey.thumbnailUrl],
        fileUrl = json[PostKey.fileUrl],
        fileType = FileType.values.firstWhere(
          (fileType) => fileType.name == json[PostKey.fileType],
          orElse: () => FileType.image,
        ),
        fileName = json[PostKey.fileName],
        ascpectRatio = json[PostKey.ascpectRatio],
        thumbnailStorageId = json[PostKey.thumbnailStorageId],
        originalFileStorageId = json[PostKey.originalFileStorageId],
        postSettings = {
          for (final entry in json[PostKey.postSettings].entries)
            PostSetting.values.firstWhere(
              (element) => element.storageKey == entry.key,
            ): entry.value,
        };

  bool get allowsLikes =>
      postSettings[PostSetting.allowLikes] ??
      false; //if the value cannot be found then its value is false
  bool get allowsComments => postSettings[PostSetting.allowComments] ?? false;
}
