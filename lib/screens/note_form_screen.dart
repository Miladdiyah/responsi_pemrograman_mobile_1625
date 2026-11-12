import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

/// Form tambah catatan. Mengembalikan `true` lewat Navigator.pop jika berhasil.
class NoteFormScreen extends StatefulWidget {
  /// Membuat form catatan.
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Least privilege: hanya mengambil fungsi addNote, tanpa dependency rebuild.
    final addNote = AppProvider.read(context).addNote;
    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _isSaving = true);
    try {
      final now = DateTime.now();
      final note = Note(
        id: now.microsecondsSinceEpoch.toString(),
        title: Validators.sanitize(_titleController.text),
        content: Validators.sanitize(_contentController.text),
        createdAt: now,
      );
      await addNote(note);
      if (!mounted) return;
      navigator.pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan catatan. Coba lagi.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                textInputAction: TextInputAction.next,
                validator: Validators.validateTitle,
                decoration: const InputDecoration(
                  labelText: 'Judul',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _contentController,
                minLines: 5,
                maxLines: 10,
                keyboardType: TextInputType.multiline,
                validator: Validators.validateContent,
                decoration: const InputDecoration(
                  labelText: 'Isi Catatan',
                  alignLabelWithHint: true,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: _isSaving ? null : _submit,
                  icon: _isSaving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.save),
                  label: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
