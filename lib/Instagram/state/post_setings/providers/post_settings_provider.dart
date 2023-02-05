import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:riverpod_example1/Instagram/state/post_setings/models/post_setting.dart';
import 'package:riverpod_example1/Instagram/state/post_setings/notifiers/post_settings_notifier.dart';

final postSettingProvider =
    StateNotifierProvider<PostSettingNotifier, Map<PostSetting, bool>>(
  (ref) => PostSettingNotifier(),
);
