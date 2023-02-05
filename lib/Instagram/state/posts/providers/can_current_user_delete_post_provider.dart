import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example1/Instagram/state/auth/providers/user_id_provider.dart';
import 'package:riverpod_example1/Instagram/state/posts/models/post.dart';

//it tells that if the user id is equal to that one who created the post
//return bool, work with post
final canCurrentUserDeletePostProvider =
    StreamProvider.family.autoDispose<bool, Post>(
  (ref, Post post) async* {
    final userId = ref.watch(userIdProvider);
    yield userId == post.userId;
  },
);
