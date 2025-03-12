import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../models/journal_entry.dart';
import '../widgets/journal_list.dart';
import '../widgets/add_entry_dialog.dart';
import '../widgets/mood_filter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  List<JournalEntry> _entries = [];
  List<JournalEntry> _filteredEntries = [];
  final _storageService = StorageService();
  final _searchController = TextEditingController();
  String _selectedMood = 'All';
  bool _isDarkMode = false;
  late AnimationController _fabController;
  Locale _currentLocale = const Locale('en');

  @override
  void initState() {
    super.initState();
    _loadData();
    _fabController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _searchController.addListener(_filterEntries);
  }

  Future<void> _loadData() async {
    final loadedEntries = await _storageService.loadEntries();
    final isDark = await _storageService.loadTheme();
    setState(() {
      _entries = loadedEntries;
      _filteredEntries = loadedEntries;
      _isDarkMode = isDark;
    });
  }

  void _addEntry(JournalEntry entry) {
    setState(() {
      final index = _entries.indexWhere((e) => e.id == entry.id);
      if (index != -1) {
        _entries[index] = entry;
      } else {
        _entries.insert(0, entry);
      }
      _filterEntries();
    });
    _storageService.saveEntries(_entries);
  }

  void _deleteEntry(String id) {
    setState(() {
      _entries.removeWhere((e) => e.id == id);
      _filterEntries();
    });
    _storageService.saveEntries(_entries);
  }

  void _filterEntries() {
    setState(() {
      _filteredEntries = _entries.where((entry) {
        final matchesSearch = entry.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
            entry.content.toLowerCase().contains(_searchController.text.toLowerCase());
        final matchesMood = _selectedMood == 'All' || entry.mood == _selectedMood;
        return matchesSearch && matchesMood;
      }).toList();
    });
  }

  void _toggleTheme() {
    setState(() => _isDarkMode = !_isDarkMode);
    _storageService.saveTheme(_isDarkMode);
  }

  void _toggleLanguage() {
    setState(() {
      _currentLocale = _currentLocale.languageCode == 'en' ? Locale('fr') : Locale('en');
    });
  }

  void _showAboutDialog() {
    showAboutDialog(
      context: context,
      applicationName: AppLocalizations.of(context)!.appTitle,
      applicationVersion: '1.0.0',
      applicationLegalese: '© 2025 Vanie Bi Jean Auguste Bile',
      children: [
        Text(AppLocalizations.of(context)!.aboutAppDescription),
        SizedBox(height: 10),
        Text(AppLocalizations.of(context)!.aboutDeveloper),
        Text(AppLocalizations.of(context)!.aboutEmail),
        Text(AppLocalizations.of(context)!.aboutPhone),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: _isDarkMode ? ThemeData.dark() : ThemeData.light(),
      child: Localizations.override(
        context: context,
        locale: _currentLocale,
        child: Scaffold(
          appBar: AppBar(
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal, Colors.tealAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            title: Text(AppLocalizations.of(context)!.appTitle),
            actions: [
              IconButton(
                icon: Icon(_isDarkMode ? Icons.light_mode : Icons.dark_mode),
                onPressed: _toggleTheme,
              ),
              IconButton(
                icon: Icon(Icons.language),
                onPressed: _toggleLanguage,
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'about') _showAboutDialog();
                },
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'about',
                    child: Text('About'),
                  ),
                ],
              ),
            ],
          ),
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.searchHint,
                      filled: true,
                      fillColor: Colors.white.withOpacity(0.9),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      prefixIcon: Icon(Icons.search),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16),
                  child: MoodFilter(
                    selectedMood: _selectedMood,
                    onMoodSelected: (mood) {
                      setState(() => _selectedMood = mood);
                      _filterEntries();
                    },
                  ),
                ),
                Expanded(
                  child: JournalList(
                    entries: _filteredEntries,
                    onDelete: _deleteEntry,
                    onEdit: _addEntry,
                  ),
                ),
              ],
            ),
          ),
          floatingActionButton: ScaleTransition(
            scale: CurvedAnimation(parent: _fabController..forward(), curve: Curves.easeInOut),
            child: FloatingActionButton(
              onPressed: () => showDialog(
                context: context,
                builder: (_) => AddEntryDialog(onAdd: _addEntry),
              ),
              child: Icon(Icons.add),
              backgroundColor: Colors.teal,
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _fabController.dispose();
    super.dispose();
  }
}