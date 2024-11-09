// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notesapp/constants/routes.dart';
import 'package:notesapp/enums/menu_actions.dart';
import 'package:notesapp/services/auth/auth_services.dart';
import 'package:notesapp/services/auth/bloc/auth_bloc.dart';
import 'package:notesapp/services/auth/bloc/auth_event.dart';
import 'package:notesapp/services/cloud/cloud_note.dart';
import 'package:notesapp/services/cloud/firebase_cloud_storage.dart';
import 'package:notesapp/utilities/dialogs/logout_dialog.dart';
import 'package:notesapp/views/notes/notes_list_view.dart';
import 'package:google_fonts/google_fonts.dart';

class NotesView extends StatefulWidget {
  const NotesView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _NotesViewState createState() => _NotesViewState();
}

class _NotesViewState extends State<NotesView> {
  late final FirebaseCloudStorage _notesService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          ' Rasko',
          style: GoogleFonts.montserratAlternates(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            fontStyle: FontStyle.italic,
          ),
        ),
        actions: [
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  final shouldLogout = await showLogOutDialog(context);
                  if (shouldLogout) {
                    context.read<AuthBloc>().add(
                          const AuthEventLogOut(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('Log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: StreamBuilder(
        stream: _notesService.allNotes(ownerUserId: userId),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              if (snapshot.hasData) {
                final allNotes = snapshot.data as Iterable<CloudNote>;
                return NotesListView(
                  notes: allNotes,
                  onDeleteNote: (note) async {
                    await _notesService.deleteNote(documentId: note.documentId);
                  },
                  onTap: (note) {
                    Navigator.of(context)
                        .pushNamed(createOrUpdateNoteRoute, arguments: note);
                  },
                  onCreateNote: () {
                    Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
                  },
                );
              } else {
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
