import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

/// InheritedWidget yang membagikan state aplikasi ke seluruh subtree.
class AppProvider extends InheritedWidget {
  /// Membuat provider.
  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.errorMessage,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required this.reload,
    required super.child,
  });

  /// Data mahasiswa saat ini.
  final Student student;

  /// Daftar catatan saat ini.
  final List<Note> notes;

  /// True saat catatan sedang dimuat.
  final bool isLoading;

  /// Pesan error pemuatan catatan, null jika tidak ada error.
  final String? errorMessage;

  /// Mengganti data mahasiswa.
  final void Function(Student) updateStudent;

  /// Menambah catatan baru.
  final Future<void> Function(Note) addNote;

  /// Menghapus catatan berdasarkan id.
  final Future<void> Function(String) deleteNote;

  /// Memuat ulang catatan dari penyimpanan.
  final Future<void> Function() reload;

  /// Mengambil provider dan mendaftarkan widget agar rebuild saat data berubah.
  static AppProvider of(BuildContext context) {
    final provider = context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(provider != null, 'AppProvider tidak ditemukan di widget tree');
    return provider!;
  }

  /// Mengambil provider tanpa mendaftarkan dependency (tidak rebuild).
  static AppProvider read(BuildContext context) {
    final provider = context.getInheritedWidgetOfExactType<AppProvider>();
    assert(provider != null, 'AppProvider tidak ditemukan di widget tree');
    return provider!;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) {
    return !identical(student, oldWidget.student) ||
        !identical(notes, oldWidget.notes) ||
        isLoading != oldWidget.isLoading ||
        errorMessage != oldWidget.errorMessage;
  }
}

/// StatefulWidget yang mengelola state dan menyediakan [AppProvider].
class AppProviderWrapper extends StatefulWidget {
  /// Membuat wrapper yang membungkus [child].
  const AppProviderWrapper({super.key, required this.child});

  /// Subtree yang menerima provider.
  final Widget child;

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  final NoteRepository _repository = NoteRepository();

  Student _student = const Student(
    name: 'Nama Mahasiswa',
    nim: '24.11.0000',
    programStudi: 'S1 Informatika',
    email: 'mahasiswa@students.amikom.ac.id',
  );
  List<Note> _notes = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    if (_errorMessage != null) {
      setState(() {
        _isLoading = true;
        _errorMessage = null;
      });
    }
    try {
      final notes = await _repository.getNotes();
      if (!mounted) return;
      setState(() {
        _notes = notes;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Gagal memuat catatan.';
        _isLoading = false;
      });
    }
  }

  void _updateStudent(Student student) {
    setState(() {
      _student = student;
    });
  }

  Future<void> _addNote(Note note) async {
    await _repository.addNote(note);
    if (!mounted) return;
    setState(() {
      _notes = [note, ..._notes];
    });
  }

  Future<void> _deleteNote(String noteId) async {
    await _repository.deleteNote(noteId);
    if (!mounted) return;
    setState(() {
      _notes = _notes.where((n) => n.id != noteId).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      reload: _loadNotes,
      child: widget.child,
    );
  }
}
