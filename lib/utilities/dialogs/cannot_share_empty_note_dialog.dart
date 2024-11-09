import 'package:flutter/material.dart';
import 'package:notesapp/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyDialog(BuildContext context) {
  return showGenericDialog(
    context: context,
    title: 'Sharing',
    content: 'Cannot share an empty Note',
    optionsBuilder:() =>{
      'OK' : null,
    },
  );
}
