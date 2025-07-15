import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:notesapp/services/cloud/cloud_note.dart';
import 'package:notesapp/utilities/dialogs/cannot_share_empty_note_dialog.dart';
import 'package:notesapp/utilities/dialogs/delete_dialog.dart';
import 'package:share_plus/share_plus.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;
  final VoidCallback onCreateNote; // New callback for creating notes

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
    required this.onCreateNote, // Add this to constructor
  });

  Future<void> _handleDelete(BuildContext context, CloudNote note) async {
    final shouldDelete = await showDeleteDialog(context);
    if (shouldDelete) {
      onDeleteNote(note);
    }
  }

  Future<void> _handleShare(BuildContext context, CloudNote note) async {
    if (note.text.isEmpty) {
      await showCannotShareEmptyDialog(context);
      return;
    }
    await Share.share(note.text);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView.builder(
          itemCount: notes.length,
          padding: const EdgeInsets.only(
            top: 8.0,
            bottom: 80.0, // Add bottom padding to avoid FAB overlap
            left: 0,
            right: 0,
          ),
          itemBuilder: (context, index) {
            final note = notes.elementAt(index);
            return _NoteCard(
              note: note,
              onDelete: (context) => _handleDelete(context, note),
              onShare: (context) => _handleShare(context, note),
              onTap: () => onTap(note),
            );
          },
        ),
        Positioned(
          right: 30.0,
          bottom: 30.0,
          child: FloatingActionButton(
            onPressed: onCreateNote,
            elevation: 4,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _NoteCard extends StatelessWidget {
  final CloudNote note;
  final Function(BuildContext) onDelete;
  final Function(BuildContext) onShare;
  final VoidCallback onTap;

  const _NoteCard({
    required this.note,
    required this.onDelete,
    required this.onShare,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
      child: Slidable(
        key: ValueKey(note),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(12)),
            ),
            SlidableAction(
              onPressed: onShare,
              backgroundColor: Theme.of(context).colorScheme.secondary,
              foregroundColor: Colors.white,
              icon: Icons.share,
              label: 'Share',
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(12)),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            onTap: onTap,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            title: Text(
              note.text,
              maxLines: 1,
              softWrap: true,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.roboto(
                fontSize: 18,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
