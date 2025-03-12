import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import 'entry_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart'; // Add this for localization

class JournalList extends StatelessWidget {
  final List<JournalEntry> entries;
  final Function(String) onDelete;
  final Function(JournalEntry) onEdit; // Add this required parameter

  JournalList({
    required this.entries,
    required this.onDelete,
    required this.onEdit, // Mark as required
  });

  @override
  Widget build(BuildContext context) {
    return entries.isEmpty
        ? Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.book_rounded, size: 80, color: Colors.grey[400]),
          SizedBox(height: 16),
          Text(
            AppLocalizations.of(context)!.noEntries, // Use localized string
            style: TextStyle(fontSize: 20, color: Colors.grey[600]),
          ),
        ],
      ),
    )
        : ListView.builder(
      itemCount: entries.length,
      itemBuilder: (context, index) => EntryCard(
        entry: entries[index],
        onDelete: () => onDelete(entries[index].id),
        onEdit: onEdit, // Pass the onEdit function
      ),
    );
  }
}