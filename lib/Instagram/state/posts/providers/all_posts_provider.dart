import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example1/Instagram/state/constans/firebase_collection_name.dart';
import 'package:riverpod_example1/Instagram/state/constans/firebase_field_name.dart';
import 'package:riverpod_example1/Instagram/state/posts/models/post.dart';

//input value iterable<post>
final allPostsProvider = StreamProvider.autoDispose<Iterable<Post>>((ref) {
  final controller = StreamController<Iterable<Post>>();

  final sub = FirebaseFirestore.instance
      .collection(FirebaseCollectionName.posts)
      .orderBy(
        FirebaseFieldName.createdAt,
        descending: true,
      )
      .snapshots()
      .listen(
    (snapshot) {
      //every doc create a new Post
      final posts = snapshot.docs.map(
        (doc) => Post(
          postId: doc.id,
          json: doc.data(),
        ),
      );

      controller.sink.add(posts);
    },
  );

  ref.onDispose(
    () {
      sub.cancel();
      controller.close();
    },
  );

  return controller.stream;
});
