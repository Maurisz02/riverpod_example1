import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example1/Instagram/state/comments/providers/delete_comment_provider.dart';
import 'package:riverpod_example1/Instagram/state/comments/providers/send_comment_provider.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/providers/image_uploader_provider.dart';
import 'package:riverpod_example1/Instagram/state/posts/providers/delete_post_provider.dart';

import '../auth/providers/auth_state_provider.dart';

final isLoadingProvder = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);

  final isUploadigImage = ref.watch(imageUploadProvider);

  final isSendingComment = ref.watch(sendCommentProvider);

  final isDeletingComment = ref.watch(deleteCommentProvider);

  final isDeletingPost = ref.watch(deletePostProvider);

  return authState.isLoading ||
      isUploadigImage ||
      isSendingComment ||
      isDeletingComment ||
      isDeletingPost;
});
