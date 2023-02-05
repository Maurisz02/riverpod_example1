import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example1/Instagram/state/auth/providers/user_id_provider.dart';
import 'package:riverpod_example1/Instagram/state/comments/models/comment.dart';
import 'package:riverpod_example1/Instagram/state/comments/providers/delete_comment_provider.dart';
import 'package:riverpod_example1/Instagram/state/user_info/providers/user_info_model_provider.dart';
import 'package:riverpod_example1/Instagram/views/components/animations/small_error_animation_view.dart';
import 'package:riverpod_example1/Instagram/views/components/constants/strings.dart';
import 'package:riverpod_example1/Instagram/views/components/dialogs/alert_dialog_model.dart';
import 'package:riverpod_example1/Instagram/views/components/dialogs/delete_dialog.dart';

class CommentTile extends ConsumerWidget {
  final Comment comment;

  const CommentTile({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userInfo = ref.watch(
      userInfoModelProvider(
        comment.fromUserId,
      ),
    );

    return userInfo.when(
      data: (userInfo) {
        final currentUserId = ref.read(userIdProvider);
        return ListTile(
          trailing: currentUserId == comment.fromUserId
              ? IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () async {
                    final shouldDeleteComment =
                        await displayDeleteDialog(context);
                    if (shouldDeleteComment) {
                      await ref
                          .read(deleteCommentProvider.notifier)
                          .deleteComment(commentId: comment.id);
                    }
                  },
                )
              : null,
          title: Text(
            userInfo.displayName,
          ),
          subtitle: Text(
            comment.comment,
          ),
        );
      },
      error: (error, stackTrace) {
        return const SmallErrorAnimationView();
      },
      loading: () {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  Future<bool> displayDeleteDialog(BuildContext context) {
    return const DeleteDialog(titleOfObjectToDelete: Strings.comment)
        .present(context)
        .then(
          (value) => value ?? false,
        );
  }
}
