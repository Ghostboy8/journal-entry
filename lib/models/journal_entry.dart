class JournalEntry {
  final String id;
  final String title;
  final String content;
  final DateTime dateTime;
  final String mood;
  final String? pin; // Optional PIN for this entry

  JournalEntry({
    required this.id,
    required this.title,
    required this.content,
    required this.dateTime,
    required this.mood,
    this.pin,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'dateTime': dateTime.toIso8601String(),
    'mood': mood,
    'pin': pin,
  };

  factory JournalEntry.fromJson(Map<String, dynamic> json) => JournalEntry(
    id: json['id'],
    title: json['title'],
    content: json['content'],
    dateTime: DateTime.parse(json['dateTime']),
    mood: json['mood'] ?? 'Neutral',
    pin: json['pin'],
  );
}