import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example1/Instagram/state/constans/firebase_collection_name.dart';
import 'package:riverpod_example1/Instagram/state/constans/firebase_field_name.dart';
import 'package:riverpod_example1/Instagram/state/posts/models/post.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/search_term.dart';

final postsBySearchTermProvider =
    StreamProvider.family.autoDispose<Iterable<Post>, SearchTerm>(
  (
    ref,
    SearchTerm searchTerm,
  ) {
    final controller = StreamController<Iterable<Post>>();

    final sub = FirebaseFirestore.instance
        .collection(
          FirebaseCollectionName.posts,
        )
        .orderBy(
          FirebaseFieldName.createdAt,
          descending: true,
        )
        .snapshots()
        .listen(
      (snapshot) {
        //snapshot.docs return all of the docs so we map it to search one by one
        final posts = snapshot.docs
            .map(
              (doc) => Post(
                json: doc.data(),
                postId: doc.id,
              ),
            )
            .where(
              (post) => post.message.toLowerCase().contains(
                    searchTerm.toLowerCase(),
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
  },
);
