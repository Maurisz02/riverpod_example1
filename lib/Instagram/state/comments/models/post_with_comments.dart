import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart' show immutable;
import 'package:riverpod_example1/Instagram/state/comments/models/comment.dart';
import 'package:riverpod_example1/Instagram/state/posts/models/post.dart';

//we grab a post depend on RequestForPostANdComment and make a PostWithComment class
@immutable
class PostWithComments {
  final Post post;
  final Iterable<Comment> comments;

  const PostWithComments({
    required this.post,
    required this.comments,
  });

  @override
  bool operator ==(covariant PostWithComments other) =>
      post == other.post &&
      const IterableEquality().equals(
        comments,
        other.comments,
      );

  @override
  int get hashCode => Object.hashAll(
        [
          post,
          comments,
        ],
      );
}
