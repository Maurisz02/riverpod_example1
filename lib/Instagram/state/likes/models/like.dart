import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod_example1/Instagram/state/constans/firebase_field_name.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/post_id.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/user_id.dart';

//to firebase
@immutable
class Like extends MapView<String, String> {
  Like({
    required PostId postId,
    required UserId likedBy,
    required DateTime date,
  }) : super(
          {
            FirebaseFieldName.postId: postId,
            FirebaseFieldName.userId: likedBy,
            FirebaseFieldName.date: date.toIso8601String(),
          },
        );
}
