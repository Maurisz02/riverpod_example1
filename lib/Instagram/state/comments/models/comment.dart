import 'package:flutter/foundation.dart' show immutable;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:riverpod_example1/Instagram/state/comments/typedefs/comment_id.dart';
import 'package:riverpod_example1/Instagram/state/constans/firebase_field_name.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/post_id.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/user_id.dart';

//how a simple comment looks like inside an app and its payload how it look like on the firebase firestorage
//payload is for adding something to firebase firestore
//a simple model is for read something from firebasefirestore and store it +need operator and hash
@immutable
class Comment {
  final CommentId id;
  final String comment;
  final DateTime createdAt;
  final UserId fromUserId;
  final PostId onPostId;

  Comment(Map<String, dynamic> json, {required this.id})
      : comment = json[FirebaseFieldName.comment],
        createdAt = (json[FirebaseFieldName.createdAt] as Timestamp).toDate(),
        fromUserId = json[FirebaseFieldName.userId],
        onPostId = json[FirebaseFieldName.postId];

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Comment &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          comment == other.comment &&
          createdAt == other.createdAt &&
          fromUserId == other.fromUserId &&
          onPostId == other.onPostId;

  @override
  int get hashCode => Object.hashAll(
        [
          id,
          comment,
          createdAt,
          fromUserId,
          onPostId,
        ],
      );
}
