import 'dart:io';

import 'package:flutter/foundation.dart' show immutable;
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../posts/typedefs/user_id.dart';
import '../../constans/firebase_collection_name.dart';
import '../../constans/firebase_field_name.dart';
import '../models/user_info_payload.dart';

@immutable
class UserInfoStorage {
  const UserInfoStorage();

  Future<bool> saveUserInfo({
    required UserId userId,
    required String displayName,
    required String? email,
  }) async {
    //first we chechk if we have this users's info from before
    //if we dont have we create one with the help of userinfopayload

    try {
      final userInfo = await FirebaseFirestore.instance
          .collection(FirebaseCollectionName.users)
          .where(
            FirebaseFieldName.userId,
            isEqualTo: userId,
          )
          .limit(1)
          .get();

      if (userInfo.docs.isNotEmpty) {
        await userInfo.docs.first.reference.update({
          FirebaseFieldName.displayName: displayName,
          FirebaseFieldName.email: email ?? '',
        });
        return true;
      }

      final payLoad = UserInfoPayLoad(
        userId: userId,
        displayName: displayName,
        email: email,
      );
      await FirebaseFirestore.instance
          .collection(
            FirebaseCollectionName.users,
          )
          .add(payLoad);

      return true;
    } catch (e) {
      return false;
    }
  }
}
