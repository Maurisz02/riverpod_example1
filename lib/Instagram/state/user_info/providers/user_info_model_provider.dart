import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example1/Instagram/state/constans/firebase_collection_name.dart';
import 'package:riverpod_example1/Instagram/state/constans/firebase_field_name.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/user_id.dart';
import 'package:riverpod_example1/Instagram/state/user_info/models/user_info_model.dart';

//<output-UserInfoModel, input-UserId>
//family because need an extra argument the UserId
//auto-dispose because if we dont use it then dispose itself
final userInfoModelProvider =
    StreamProvider.family.autoDispose<UserInfoModel, UserId>(
  (ref, UserId userId) {
    //streams need a controller
    final controller = StreamController<UserInfoModel>();

    //this is where we want to watch and stream the canges -- give the collection and document name
    final sub = FirebaseFirestore.instance
        .collection(FirebaseCollectionName.users)
        .where(
          FirebaseFieldName.userId,
          isEqualTo: userId,
        )
        .limit(1)
        .snapshots()
        .listen(
      (snapshot) {
        final doc = snapshot.docs.first;
        final json = doc.data();

        //need to create a UserModel to dislay it on app
        final userInfoModel = UserInfoModel.fromJson(
          json,
          userId: userId,
        );
        //you can add conroller.sink.add but not neccessary
        controller.add(userInfoModel);
      },
    );

    //need to handle th on dispose method
    ref.onDispose(() {
      sub.cancel();
      controller.close();
    });

    return controller.stream;
  },
);
