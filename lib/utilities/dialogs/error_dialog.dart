import 'package:flutter/material.dart';
import 'package:notesapp/utilities/dialogs/generic_dialog.dart';

Future<void> showErrorDialog(
  BuildContext context,
  String text,
) {
  return showGenericDialog<void>(
    context: context,
    title: 'An error Occured',
    content: text,
    optionsBuilder:() => {
      'OK' : null,
    }
  );
}
