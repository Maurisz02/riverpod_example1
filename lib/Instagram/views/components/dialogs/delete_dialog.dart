import 'package:flutter/foundation.dart' show immutable;

import 'package:riverpod_example1/Instagram/views/components/dialogs/alert_dialog_model.dart';
import 'package:riverpod_example1/Instagram/views/components/constants/strings.dart';

@immutable
class DeleteDialog extends AlertDialogModel<bool> {
  const DeleteDialog({
    required String titleOfObjectToDelete,
  }) : super(
          title: '${Strings.delete} $titleOfObjectToDelete?',
          message:
              '${Strings.areYouSureYouWantToDeleteThis} $titleOfObjectToDelete?',
          buttons: const {
            Strings.cancel: false,
            Strings.delete: true,
          },
        );
}
