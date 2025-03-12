import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/journal_entry.dart';
import '../utils/animations.dart';
import '../widgets/pin_dialog.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'add_entry_dialog.dart';

class EntryCard extends StatelessWidget {
  final JournalEntry entry;
  final VoidCallback onDelete;
  final Function(JournalEntry) onEdit;

  EntryCard({required this.entry, required this.onDelete, required this.onEdit});

  final Map<String, Color> _moodColors = {
    'Happy': Colors.green,
    'Sad': Colors.blue,
    'Neutral': Colors.grey,
    'Excited': Colors.orange,
    'Angry': Colors.red,
  };

  void _showDetails(BuildContext context, {String? enteredPin}) {
    print('Attempting to show details for entry: ${entry.title}');
    if (entry.pin != null && enteredPin != entry.pin) {
      print('Entry is locked, showing PinDialog');
      showDialog(
        context: context,
        builder: (_) => PinDialog(
          onSubmit: (pin) {
            print('PIN entered: $pin');
            if (entry.pin == pin) {
              print('PIN correct, dismissing dialog');
              Navigator.pop(context); // Dismiss PinDialog
              _showDetails(context, enteredPin: pin); // Show details
            } else {
              print('PIN incorrect');
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(AppLocalizations.of(context)!.invalidPin)),
              );
            }
          },
          onForgotPin: onDelete,
          buttonText: AppLocalizations.of(context)!.unlock,
        ),
      );
      return;
    }

    print('Showing entry details in bottom sheet');
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (_) => Padding(
        padding: EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      entry.title,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (_) => AddEntryDialog(
                              onAdd: onEdit,
                              existingEntry: entry,
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          Navigator.pop(context);
                          onDelete();
                        },
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(entry.dateTime.toString().substring(0, 16), style: TextStyle(color: Colors.grey)),
              SizedBox(height: 16),
              Text(entry.content, style: TextStyle(fontSize: 16)),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: entry.content));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Content copied')),
                  );
                },
                child: Text('Copy Content'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(entry.id),
      onDismissed: (_) => onDelete(),
      background: Container(
        color: Colors.redAccent,
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 16),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 8, offset: Offset(0, 4)),
          ],
        ),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _moodColors[entry.mood] ?? Colors.grey,
            child: Text(entry.mood[0], style: TextStyle(color: Colors.white)),
          ),
          title: Text(entry.title, style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 4),
              Text(
                entry.pin != null
                    ? 'Locked Entry'
                    : (entry.content.length > 50 ? '${entry.content.substring(0, 50)}...' : entry.content),
                style: TextStyle(color: Colors.grey[600]),
              ),
              SizedBox(height: 4),
              Text(
                entry.dateTime.toString().substring(0, 16),
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          onTap: () {
            print('ListTile tapped for entry: ${entry.title}');
            _showDetails(context);
          },
        ),
      ),
    );
  }
}