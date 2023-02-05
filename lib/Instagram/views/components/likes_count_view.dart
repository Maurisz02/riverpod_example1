import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example1/Instagram/state/likes/providers/post_likes_count_provider.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/post_id.dart';
import 'package:riverpod_example1/Instagram/views/components/animations/small_error_animation_view.dart';
import 'package:riverpod_example1/Instagram/views/components/constants/strings.dart';

class LikesCountView extends ConsumerWidget {
  final PostId postId;
  const LikesCountView({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final likesCount = ref.watch(
      postLikesCountProvider(
        postId,
      ),
    );
    //we can use when because its an async value
    return likesCount.when(
      data: (int likesCount) {
        final personOrPeople =
            likesCount == 1 ? Strings.person : Strings.people;
        final likesText = '$likesCount $personOrPeople ${Strings.likedThis}';
        return Text(
          likesText,
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
}
