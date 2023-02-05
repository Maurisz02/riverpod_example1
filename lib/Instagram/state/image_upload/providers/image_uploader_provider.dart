import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:riverpod_example1/Instagram/state/image_upload/notifiers/image_upload_notifier.dart';
import 'package:riverpod_example1/Instagram/state/image_upload/typedefs/is_loading.dart';

final imageUploadProvider =
    StateNotifierProvider<ImageUploadNotifier, IsLoading>(
  (ref) => ImageUploadNotifier(),
);
