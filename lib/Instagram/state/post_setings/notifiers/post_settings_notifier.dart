import 'package:collection/collection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:riverpod_example1/Instagram/state/post_setings/models/post_setting.dart';

class PostSettingNotifier extends StateNotifier<Map<PostSetting, bool>> {
  //main the likes and comments are true
  PostSettingNotifier()
      : super(
          UnmodifiableMapView(
            {for (final setting in PostSetting.values) setting: true},
          ),
        );

  void setSetting(
    PostSetting setting,
    bool value,
  ) {
    final existingValue = state[setting];
    if (existingValue == null || existingValue == value) {
      return;
    }
    state = Map.unmodifiable(
      Map.from(state)..[setting] = value,
    );
  }
}
