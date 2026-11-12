import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Layanan penyimpanan isi catatan secara terenkripsi.
class SecureStorageService {
  /// Membuat service. [storage] opsional untuk kebutuhan testing.
  SecureStorageService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  static String _key(String noteId) => 'note_content_$noteId';

  /// Menyimpan [content] terenkripsi untuk catatan [noteId].
  Future<void> saveContent(String noteId, String content) {
    return _storage.write(key: _key(noteId), value: content);
  }

  /// Membaca isi catatan [noteId]. Mengembalikan null jika tidak ada.
  Future<String?> getContent(String noteId) {
    return _storage.read(key: _key(noteId));
  }

  /// Menghapus isi catatan [noteId].
  Future<void> deleteContent(String noteId) {
    return _storage.delete(key: _key(noteId));
  }
}
