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
  final VoidCallback onCreateNote;

  const NotesListView({
    super.key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
    required this.onCreateNote,
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.green[50],
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.green[50]!,
            Colors.green[25] ?? Colors.green[50]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Empty state or notes list
          notes.isEmpty
              ? _buildEmptyState(context)
              : ListView.builder(
                  itemCount: notes.length,
                  padding: const EdgeInsets.only(
                    top: 16.0,
                    bottom: 100.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  itemBuilder: (context, index) {
                    final note = notes.elementAt(index);
                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 300 + (index * 100)),
                      builder: (context, double value, child) {
                        return Transform.translate(
                          offset: Offset(0, 50 * (1 - value)),
                          child: Opacity(
                            opacity: value,
                            child: _NoteCard(
                              note: note,
                              onDelete: (context) =>
                                  _handleDelete(context, note),
                              onShare: (context) => _handleShare(context, note),
                              onTap: () => onTap(note),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),

          // Floating Action Button with enhanced styling
          Positioned(
            right: 24.0,
            bottom: 24.0,
            child: TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green[700]!.withValues(alpha: 0.3),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: FloatingActionButton(
                      onPressed: onCreateNote,
                      elevation: 0,
                      backgroundColor: Colors.green[700],
                      child: const Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0, end: 1),
            duration: const Duration(milliseconds: 800),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.green[100],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.note_outlined,
                    size: 64,
                    color: Colors.green[700],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),
          Text(
            'No Notes Yet',
            style: GoogleFonts.roboto(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the + button to create your first note',
            style: GoogleFonts.roboto(
              fontSize: 16,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
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

  String _getPreviewText(String text) {
    // Remove extra whitespace and get first line or first 100 characters
    final cleanText = text.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (cleanText.isEmpty) return 'Empty note';

    final lines = cleanText.split('\n');
    final firstLine = lines.first;

    if (firstLine.length > 100) {
      return '${firstLine.substring(0, 100)}...';
    }
    return firstLine;
  }

  String _getSecondaryText(String text) {
    final lines = text.trim().split('\n');
    if (lines.length > 1) {
      final secondLine = lines[1].trim();
      if (secondLine.isNotEmpty) {
        return secondLine.length > 60
            ? '${secondLine.substring(0, 60)}...'
            : secondLine;
      }
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final previewText = _getPreviewText(note.text);
    final secondaryText = _getSecondaryText(note.text);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Slidable(
        key: ValueKey(note),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: onDelete,
              backgroundColor: Colors.red[600]!,
              foregroundColor: Colors.white,
              icon: Icons.delete_outline,
              label: 'Delete',
              borderRadius:
                  const BorderRadius.horizontal(left: Radius.circular(16)),
            ),
            SlidableAction(
              onPressed: onShare,
              backgroundColor: Colors.green[600]!,
              foregroundColor: Colors.white,
              icon: Icons.share_outlined,
              label: 'Share',
              borderRadius:
                  const BorderRadius.horizontal(right: Radius.circular(16)),
            ),
          ],
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                spreadRadius: 1,
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onTap,
              borderRadius: BorderRadius.circular(16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Main text with icon
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.green[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.note_outlined,
                            size: 20,
                            color: Colors.green[700],
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                previewText,
                                style: GoogleFonts.roboto(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[800],
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (secondaryText.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  secondaryText,
                                  style: GoogleFonts.roboto(
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ],
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 16,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
