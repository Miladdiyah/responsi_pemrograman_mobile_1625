/// Kumpulan fungsi validasi dan sanitasi input pengguna.
class Validators {
  Validators._();

  /// Menghapus karakter berbahaya (<, >, ", ') dan spasi di tepi teks.
  static String sanitize(String input) {
    return input.replaceAll(RegExp('[<>"\']'), '').trim();
  }

  /// Judul catatan: minimal 3, maksimal 50 karakter.
  static String? validateTitle(String? value) {
    final text = sanitize(value ?? '');
    if (text.isEmpty) return 'Judul tidak boleh kosong';
    if (text.length < 3) return 'Judul minimal 3 karakter';
    if (text.length > 50) return 'Judul maksimal 50 karakter';
    return null;
  }

  /// Isi catatan: minimal 10, maksimal 1000 karakter.
  static String? validateContent(String? value) {
    final text = sanitize(value ?? '');
    if (text.isEmpty) return 'Isi catatan tidak boleh kosong';
    if (text.length < 10) return 'Isi catatan minimal 10 karakter';
    if (text.length > 1000) return 'Isi catatan maksimal 1000 karakter';
    return null;
  }

  /// Nama mahasiswa: 3 sampai 60 karakter.
  static String? validateName(String? value) {
    final text = sanitize(value ?? '');
    if (text.isEmpty) return 'Nama tidak boleh kosong';
    if (text.length < 3) return 'Nama minimal 3 karakter';
    if (text.length > 60) return 'Nama maksimal 60 karakter';
    return null;
  }

  /// NIM: hanya angka dan titik, 5 sampai 20 karakter.
  static String? validateNim(String? value) {
    final text = sanitize(value ?? '');
    if (text.isEmpty) return 'NIM tidak boleh kosong';
    if (!RegExp(r'^[0-9.]{5,20}$').hasMatch(text)) {
      return 'NIM hanya angka/titik (5-20 karakter)';
    }
    return null;
  }

  /// Program studi: 3 sampai 60 karakter.
  static String? validateProgramStudi(String? value) {
    final text = sanitize(value ?? '');
    if (text.isEmpty) return 'Program studi tidak boleh kosong';
    if (text.length < 3) return 'Program studi minimal 3 karakter';
    if (text.length > 60) return 'Program studi maksimal 60 karakter';
    return null;
  }

  /// Format email dasar.
  static String? validateEmail(String? value) {
    final text = sanitize(value ?? '');
    if (text.isEmpty) return 'Email tidak boleh kosong';
    if (!RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$').hasMatch(text)) {
      return 'Format email tidak valid';
    }
    return null;
  }
}
