import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/typedefs/is_loading.dart';
import 'package:riverpod_example1/Instagram/state/posts/notifiers/delete_post_state_notifier.dart';

final deletePostProvider =
    StateNotifierProvider<DeletePostStateNotifier, IsLoading>(
  (_) => DeletePostStateNotifier(),
);
