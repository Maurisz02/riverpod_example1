import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../auth/providers/user_id_provider.dart';
import '../models/post.dart';
import '../models/post_key.dart';
import '../../constans/firebase_collection_name.dart';
import '../../constans/firebase_field_name.dart';

final userPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final userId = ref.watch(userIdProvider);

  final controller = StreamController<Iterable<Post>>();

  controller.onListen = () {
    controller.sink.add([]);
  };

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      )
      .where(PostKey.userId, isEqualTo: userId)
      .snapshots()
      .listen((snapshot) {
    final documents = snapshot.docs;

    final posts = documents
        .where(
          (doc) => !doc.metadata.hasPendingWrites,
        )
        .map(
          (doc) => Post(
            postId: doc.id,
            json: doc.data(),
          ),
        );
    controller.sink.add(posts);
  });

  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });

  return controller.stream;
});
