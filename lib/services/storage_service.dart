import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/journal_entry.dart';

class StorageService {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> _getFile(String filename) async {
    final path = await _localPath;
    return File('$path/$filename');
  }

  Future<List<JournalEntry>> loadEntries() async {
    try {
      final file = await _getFile('journal_entries.json');
      if (await file.exists()) {
        final contents = await file.readAsString();
        final List<dynamic> jsonData = jsonDecode(contents);
        return jsonData.map((json) => JournalEntry.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      print('Error loading entries: $e');
      return [];
    }
  }

  Future<void> saveEntries(List<JournalEntry> entries) async {
    try {
      final file = await _getFile('journal_entries.json');
      final jsonString = jsonEncode(entries.map((e) => e.toJson()).toList());
      await file.writeAsString(jsonString);
    } catch (e) {
      print('Error saving entries: $e');
    }
  }

  Future<String?> loadPin() async {
    try {
      final file = await _getFile('pin.txt');
      if (await file.exists()) {
        return await file.readAsString();
      }
      return null;
    } catch (e) {
      print('Error loading PIN: $e');
      return null;
    }
  }

  Future<void> savePin(String pin) async {
    try {
      final file = await _getFile('pin.txt');
      await file.writeAsString(pin);
    } catch (e) {
      print('Error saving PIN: $e');
    }
  }

  Future<bool> loadTheme() async {
    try {
      final file = await _getFile('theme.txt');
      if (await file.exists()) {
        return (await file.readAsString()) == 'dark';
      }
      return false;
    } catch (e) {
      print('Error loading theme: $e');
      return false;
    }
  }

  Future<void> saveTheme(bool isDark) async {
    try {
      final file = await _getFile('theme.txt');
      await file.writeAsString(isDark ? 'dark' : 'light');
    } catch (e) {
      print('Error saving theme: $e');
    }
  }
}