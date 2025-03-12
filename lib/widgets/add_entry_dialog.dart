import 'package:flutter/material.dart';
import '../models/journal_entry.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AddEntryDialog extends StatefulWidget {
  final Function(JournalEntry) onAdd;
  final JournalEntry? existingEntry;

  AddEntryDialog({required this.onAdd, this.existingEntry});

  @override
  _AddEntryDialogState createState() => _AddEntryDialogState();
}

class _AddEntryDialogState extends State<AddEntryDialog> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final _pinController = TextEditingController();
  String _selectedMood = 'Neutral';
  bool _usePin = false;
  final List<String> _moods = ['Happy', 'Sad', 'Neutral', 'Excited', 'Angry'];

  @override
  void initState() {
    super.initState();
    if (widget.existingEntry != null) {
      _titleController.text = widget.existingEntry!.title;
      _contentController.text = widget.existingEntry!.content;
      _selectedMood = widget.existingEntry!.mood;
      _pinController.text = widget.existingEntry!.pin ?? '';
      _usePin = widget.existingEntry!.pin != null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      contentPadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20, // Ajustement du clavier
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.existingEntry == null
                  ? AppLocalizations.of(context)!.addEntry
                  : 'Edit Entry',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.titleHint,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _contentController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.contentHint,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
            ),
            SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: _selectedMood,
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.moodLabel,
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
              ),
              items: _moods.map((mood) => DropdownMenuItem(value: mood, child: Text(mood))).toList(),
              onChanged: (value) => setState(() => _selectedMood = value!),
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Protect with PIN'),
              value: _usePin,
              onChanged: (value) => setState(() => _usePin = value!),
            ),
            if (_usePin)
              TextField(
                controller: _pinController,
                keyboardType: TextInputType.number,
                obscureText: true,
                maxLength: 4,
                decoration: InputDecoration(
                  labelText: AppLocalizations.of(context)!.pinHint,
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                ),
              ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(AppLocalizations.of(context)!.cancel, style: TextStyle(color: Colors.grey)),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  onPressed: () {
                    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
                      widget.onAdd(JournalEntry(
                        id: widget.existingEntry?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        title: _titleController.text,
                        content: _contentController.text,
                        dateTime: widget.existingEntry?.dateTime ?? DateTime.now(),
                        mood: _selectedMood,
                        pin: _usePin && _pinController.text.isNotEmpty ? _pinController.text : null,
                      ));
                      Navigator.pop(context);
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.save),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _pinController.dispose();
    super.dispose();
  }
}
