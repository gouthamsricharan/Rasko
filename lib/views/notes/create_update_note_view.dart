import 'package:flutter/material.dart';
import 'package:notesapp/services/auth/auth_services.dart';
import 'package:notesapp/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:notesapp/utilities/generics/get_arguments.dart';
import 'package:notesapp/services/cloud/cloud_note.dart';
import 'package:notesapp/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateUpdateNoteView extends StatefulWidget {
  const CreateUpdateNoteView({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateUpdateNoteViewState createState() => _CreateUpdateNoteViewState();
}

class _CreateUpdateNoteViewState extends State<CreateUpdateNoteView> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;
  // ignore: unused_field
  bool _isLoading = false;

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  void _textControllerListener() async {
    final note = _note;
    if (note == null) return;
    final text = _textController.text;
    await _notesService.updateNote(documentId: note.documentId, text: text);
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    final existingNote = _note;
    if (existingNote != null) return existingNote;

    final currentUser = AuthService.firebase().currentUser!;
    final newNote =
        await _notesService.createNewNote(ownerUserId: currentUser.id);
    _note = newNote;
    return newNote;
  }

  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    if (_textController.text.isEmpty && note != null) {
      _notesService.deleteNote(documentId: note.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      setState(() => _isLoading = true);
      await _notesService.updateNote(documentId: note.documentId, text: text);
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'New Note',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w900,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final text = _textController.text;
              if (_note == null || text.isEmpty) {
                await showCannotShareEmptyDialog(context);
              } else {
                Share.share(text);
              }
            },
            icon: const Icon(Icons.share_rounded),
          ),
        ],
      ),
      body: FutureBuilder(
        future: createOrGetExistingNote(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            _setupTextControllerListener();
            return Container(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _textController,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                style: GoogleFonts.roboto(
                  fontSize: 16,
                  height: 1.5,
                ),
                decoration: InputDecoration(
                  hintText: 'Start typing your note...',
                  hintStyle: GoogleFonts.roboto(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
