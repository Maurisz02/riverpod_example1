import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:riverpod_example1/Instagram/state/auth/providers/user_id_provider.dart';
import 'package:riverpod_example1/Instagram/state/likes/models/like_dislike_request.dart';
import 'package:riverpod_example1/Instagram/state/likes/providers/has_liked_post_provider.dart';
import 'package:riverpod_example1/Instagram/state/likes/providers/like_dislike_post_provider.dart';
import 'package:riverpod_example1/Instagram/state/posts/typedefs/post_id.dart';
import 'package:riverpod_example1/Instagram/views/components/animations/small_error_animation_view.dart';

class LikeButton extends ConsumerWidget {
  //need to know which post's like button is this therefore need postId
  final PostId postId;
  const LikeButton({
    super.key,
    required this.postId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //this provider teell if its liked or not
    final hasLiked = ref.watch(
      hasLikedPostProvider(postId),
    );
    return hasLiked.when(
      data: (hasLiked) {
        return IconButton(
          icon: FaIcon(
            hasLiked ? FontAwesomeIcons.solidHeart : FontAwesomeIcons.heart,
          ),
          onPressed: () {
            final userId = ref.read(userIdProvider);
            if (userId == null) {
              return;
            }
            //need a request
            final likeRequest = LikeDislikeRequest(
              postId: postId,
              likedBy: userId,
            );
            //we pass the request to the provider so it can add a like collection or delete one
            //this make an action to delete a like or make a like
            ref.read(
              likeDislikePostProvider(
                likeRequest,
              ),
            );
          },
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
