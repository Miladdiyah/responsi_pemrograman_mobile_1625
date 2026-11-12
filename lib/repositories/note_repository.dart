import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../services/secure_storage_service.dart';

/// Repository catatan: metadata di SharedPreferences, isi di secure storage.
class NoteRepository {
  /// Membuat repository. [secureStorage] opsional untuk testing.
  NoteRepository({SecureStorageService? secureStorage})
    : _secureStorage = secureStorage ?? SecureStorageService();

  static const String _metadataKey = 'notes_metadata';

  final SecureStorageService _secureStorage;

  List<Map<String, dynamic>> _readMetadata(SharedPreferences prefs) {
    final raw = prefs.getString(_metadataKey);
    if (raw == null || raw.isEmpty) return <Map<String, dynamic>>[];
    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      return decoded.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    } catch (_) {
      debugPrint('NoteRepository: metadata tidak valid, diabaikan.');
      return <Map<String, dynamic>>[];
    }
  }

  /// Mengambil semua catatan (metadata + isi terenkripsi), terbaru di atas.
  Future<List<Note>> getNotes() async {
    final prefs = await SharedPreferences.getInstance();
    final metadata = _readMetadata(prefs);
    final notes = <Note>[];
    for (final meta in metadata) {
      final id = meta['id'] as String;
      final content = await _secureStorage.getContent(id) ?? '';
      notes.add(Note.fromMetadataJson(meta, content: content));
    }
    return notes;
  }

  /// Menyimpan catatan baru.
  Future<void> addNote(Note note) async {
    final prefs = await SharedPreferences.getInstance();
    final metadata = _readMetadata(prefs);
    await _secureStorage.saveContent(note.id, note.content);
    metadata.insert(0, note.toMetadataJson());
    await prefs.setString(_metadataKey, jsonEncode(metadata));
  }

  /// Menghapus catatan beserta isinya.
  Future<void> deleteNote(String noteId) async {
    final prefs = await SharedPreferences.getInstance();
    final metadata = _readMetadata(prefs)
      ..removeWhere((m) => m['id'] == noteId);
    await prefs.setString(_metadataKey, jsonEncode(metadata));
    await _secureStorage.deleteContent(noteId);
  }
}
