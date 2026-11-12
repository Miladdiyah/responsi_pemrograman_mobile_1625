/// Model data catatan mahasiswa.
class Note {
  const Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String content;
  final DateTime createdAt;

  Map<String, dynamic> toMetadataJson() {
    return {'id': id, 'title': title, 'createdAt': createdAt.toIso8601String()};
  }

  factory Note.fromMetadataJson(
    Map<String, dynamic> json, {
    required String content,
  }) {
    return Note(
      id: json['id'] as String,
      title: json['title'] as String? ?? '',
      content: content,
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.now(),
    );
  }

  String get formattedDate {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;

    return '$day/$month/$year';
  }
}
