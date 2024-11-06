import 'package:flutter/widgets.dart';
import 'package:notesapp/utilities/dialogs/generic_dialog.dart';

Future<void> showPasswordResetSentDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Password Reset',
    content:
        'We have sent a Password Reset Email to your Mail , Please check your email for more information',
    optionsBuilder: () => {
      'OK': null,
    },
  );
}
