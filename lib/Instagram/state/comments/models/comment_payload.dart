import 'dart:collection' show MapView;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod_example1/Instagram/state/constans/firebase_field_name.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/post_id.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/user_id.dart';

//payload is for adding something to firebase firestore
//a simple model is for read something from firebasefirestore and store it
@immutable
class CommentPayload extends MapView<String, dynamic> {
  CommentPayload({
    required UserId fromUserId,
    required PostId onPostId,
    required String comment,
  }) : super(
          {
            FirebaseFieldName.userId: fromUserId,
            FirebaseFieldName.postId: onPostId,
            FirebaseFieldName.comment: comment,
            FirebaseFieldName.createdAt: FieldValue.serverTimestamp(),
          },
        );
}
