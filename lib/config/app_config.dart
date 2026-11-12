import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dibaca dari file `.env`.
class AppConfig {
  AppConfig._();

  static bool _loaded = false;

  /// Memuat file `.env`. Dipanggil sekali di `main()`.
  static Future<void> load() async {
    try {
      await dotenv.load(fileName: '.env');
      _loaded = true;
    } catch (_) {
      _loaded = false;
    }
  }

  /// URL dasar API (BASE_URL). Kosong jika belum dikonfigurasi.
  static String get baseUrl => _loaded ? (dotenv.env['BASE_URL'] ?? '') : '';

  /// API key dummy (API_KEY). Kosong jika belum dikonfigurasi.
  static String get apiKey => _loaded ? (dotenv.env['API_KEY'] ?? '') : '';
}
