import 'package:flutter/material.dart';
import 'package:notesapp/utilities/dialogs/generic_dialog.dart';

Future<bool> showDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: "Delete",
    content: "Are you sure you want to Delete this item?",
    optionsBuilder: () => {
      'cancel': false,
      'Delete': true,
    },
  ).then(
    (value) => value ?? false,
  );
}