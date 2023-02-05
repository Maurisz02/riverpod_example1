import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:riverpod_example1/Instagram/views/components/animations/empty_contents_with_animation_view.dart';
import 'package:riverpod_example1/Instagram/views/components/animations/error_animation_view.dart';
import 'package:riverpod_example1/Instagram/views/components/animations/loading_animation_view.dart';
import 'package:riverpod_example1/Instagram/views/components/post/posts_grid_view.dart';
import '../../../state/posts/providers/user_posts_provider.dart';
import '../../constants/strings.dart';

class UserPostsView extends ConsumerWidget {
  const UserPostsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(userPostsProvider);

    return RefreshIndicator(
      onRefresh: () {
        ref.refresh(userPostsProvider);
        return Future.delayed(
          const Duration(
            seconds: 1,
          ),
        );
      },
      child: posts.when(
        data: (posts) {
          if (posts.isEmpty) {
            return const EmptyContentsWithAnimationView(
              text: Strings.youHaveNoPosts,
            );
          } else {
            return PostsGridView(
              posts: posts,
            );
          }
        },
        error: (error, stackTrace) {
          return const ErrorAnimationView();
        },
        loading: () {
          return const LoadingAnimationView();
        },
      ),
    );
  }
}
