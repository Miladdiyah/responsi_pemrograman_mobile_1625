/// Model data profil mahasiswa (immutable).
class Student {
  /// Membuat data mahasiswa.
  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  /// Nama lengkap.
  final String name;

  /// Nomor Induk Mahasiswa.
  final String nim;

  /// Program studi.
  final String programStudi;

  /// Alamat email.
  final String email;

  /// Inisial nama (maksimal 2 huruf) untuk CircleAvatar.
  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts[0][0] + parts[1][0]).toUpperCase();
  }

  /// Membuat salinan dengan sebagian field diganti.
  Student copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }
}
