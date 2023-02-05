import 'package:flutter/material.dart';
import 'package:riverpod_example1/Instagram/state/posts/models/post.dart';
import 'package:riverpod_example1/Instagram/views/components/animations/loading_animation_view.dart';

class PostImageView extends StatelessWidget {
  final Post post;
  const PostImageView({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: post.ascpectRatio,
      child: Image.network(
        post.fileUrl,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return const LoadingAnimationView();
          }
        },
      ),
    );
  }
}
