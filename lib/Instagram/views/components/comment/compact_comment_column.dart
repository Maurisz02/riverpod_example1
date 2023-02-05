import 'package:flutter/material.dart';
import 'package:riverpod_example1/Instagram/state/comments/models/comment.dart';
import 'package:riverpod_example1/Instagram/views/components/comment/compact_comment_tile.dart';

class CompactCommentCloumn extends StatelessWidget {
  final Iterable<Comment> comments;
  const CompactCommentCloumn({
    super.key,
    required this.comments,
  });

  @override
  Widget build(BuildContext context) {
    if (comments.isEmpty) {
      return const SizedBox();
    }
    return Padding(
      padding: const EdgeInsets.only(
        left: 8.0,
        bottom: 8.0,
        right: 8.0,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: comments.map((comment) {
          return CompactCommentTile(
            comment: comment,
          );
        }).toList(),
      ),
    );
  }
}
