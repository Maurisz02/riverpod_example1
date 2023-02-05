import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:riverpod_example1/Instagram/state/comments/typedefs/comment_id.dart';
import 'package:riverpod_example1/Instagram/state/constans/firebase_collection_name.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/typedefs/is_loading.dart';

class DeleteCommentNotifier extends StateNotifier<IsLoading> {
  DeleteCommentNotifier() : super(false);

  set isLoadig(bool value) => state = value;

  Future<bool> deleteComment({
    required CommentId commentId,
  }) async {
    try {
      isLoadig = true;

      final query = FirebaseFirestore.instance
          .collection(FirebaseCollectionName.comments)
          .where(
            FieldPath.documentId,
            isEqualTo: commentId,
          )
          .limit(1)
          .get();

      //after query is executed we go through one docs and delete it
      await query.then(
        (query) async {
          for (final doc in query.docs) {
            await doc.reference.delete();
          }
        },
      );

      return true;
    } catch (_) {
      return false;
    } finally {
      isLoadig = false;
    }
  }
}
