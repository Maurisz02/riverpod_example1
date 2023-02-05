import 'dart:collection' show MapView;

import 'package:flutter/foundation.dart' show immutable;

import '../../posts/typedefs/user_id.dart';
import '../../constans/firebase_field_name.dart';

//immidiately convert it to json form MapView special constructor mapview
//a : super() az exrend utáni résznek add vissza adatot
//to add to firebase firestorage
@immutable
class UserInfoPayLoad extends MapView<String, String> {
  UserInfoPayLoad({
    required UserId userId,
    required String? displayName,
    required String? email,
  }) : super(
          {
            FirebaseFieldName.userId: userId,
            FirebaseFieldName.displayName: displayName ?? '',
            FirebaseFieldName.email: email ?? '',
          },
        );
}
