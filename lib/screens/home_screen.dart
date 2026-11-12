import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';
import 'posts_screen.dart';
import 'profile_screen.dart';

/// Layar utama: profil singkat dan daftar catatan.
class HomeScreen extends StatelessWidget {
  /// Membuat layar utama.
  const HomeScreen({super.key});

  Future<void> _openForm(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NoteFormScreen()),
    );
    if (result == true) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Catatan berhasil disimpan')),
      );
    }
  }

  Future<void> _confirmDelete(
    BuildContext context,
    AppProvider provider,
    Note note,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus catatan?'),
        content: Text('Catatan "${note.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await provider.deleteNote(note.id);
      messenger.showSnackBar(const SnackBar(content: Text('Catatan dihapus')));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Gagal menghapus catatan')),
      );
    }
  }

  void _showDetail(BuildContext context, Note note) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(note.title),
        content: SingleChildScrollView(child: Text(note.content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMessage != null) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Terjadi kesalahan',
        message: provider.errorMessage!,
        actionLabel: 'Coba Lagi',
        onAction: () => provider.reload(),
      );
    }
    if (provider.notes.isEmpty) {
      return const EmptyState(
        icon: Icons.note_alt_outlined,
        title: 'Belum ada catatan',
        message: 'Tekan tombol + untuk menambah catatan kuliah.',
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 88),
      itemCount: provider.notes.length,
      itemBuilder: (context, index) {
        final note = provider.notes[index];
        return NoteCard(
          note: note,
          onTap: () => _showDetail(context, note),
          onDelete: () => _confirmDelete(context, provider, note),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    final scheme = Theme.of(context).colorScheme;
    final student = provider.student;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah'),
        actions: [
          IconButton(
            tooltip: 'Data Online',
            icon: const Icon(Icons.cloud_outlined),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const PostsScreen()),
            ),
          ),
          IconButton(
            tooltip: 'Profil',
            icon: const Icon(Icons.person),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: scheme.primaryContainer,
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: scheme.primary,
                  child: Text(
                    student.initials,
                    style: TextStyle(color: scheme.onPrimary),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: scheme.onPrimaryContainer,
                            ),
                      ),
                      Text(
                        'NIM: ${student.nim}',
                        style: TextStyle(color: scheme.onPrimaryContainer),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody(context, provider)),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Tambah catatan',
        onPressed: () => _openForm(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
