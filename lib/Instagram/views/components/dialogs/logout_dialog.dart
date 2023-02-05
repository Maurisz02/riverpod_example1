import 'package:flutter/foundation.dart' show immutable;

import 'package:riverpod_example1/Instagram/views/components/constants/strings.dart';
import 'package:riverpod_example1/Instagram/views/components/dialogs/alert_dialog_model.dart';

@immutable
class LogoutDialog extends AlertDialogModel<bool> {
  //a mainview ba azert tudjunk igy meghivni LogoutDialog() és azért .present mert van egy olyan Future function ami egy widgetet returnel
  const LogoutDialog()
      : super(
          title: Strings.logOut,
          message: Strings.areYouSureYouWantToLogOutOfTheApp,
          buttons: const {
            Strings.cancel: false,
            Strings.logOut: true,
          },
        );
}
