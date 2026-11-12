import 'package:flutter/material.dart';

import '../models/student.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';
import '../widgets/profile_card.dart';

/// Layar profil mahasiswa dengan tombol Edit Profil.
class ProfileScreen extends StatelessWidget {
  /// Membuat layar profil.
  const ProfileScreen({super.key});

  Future<void> _edit(BuildContext context, AppProvider provider) async {
    final messenger = ScaffoldMessenger.of(context);
    final result = await showDialog<Student>(
      context: context,
      builder: (_) => _EditProfileDialog(student: provider.student),
    );
    if (result == null) return;
    provider.updateStudent(result);
    messenger.showSnackBar(
      const SnackBar(content: Text('Profil berhasil diperbarui')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ProfileCard(student: provider.student),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => _edit(context, provider),
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

class _EditProfileDialog extends StatefulWidget {
  const _EditProfileDialog({required this.student});

  final Student student;

  @override
  State<_EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<_EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameC = TextEditingController(
    text: widget.student.name,
  );
  late final TextEditingController _nimC = TextEditingController(
    text: widget.student.nim,
  );
  late final TextEditingController _prodiC = TextEditingController(
    text: widget.student.programStudi,
  );
  late final TextEditingController _emailC = TextEditingController(
    text: widget.student.email,
  );

  @override
  void dispose() {
    _nameC.dispose();
    _nimC.dispose();
    _prodiC.dispose();
    _emailC.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      Student(
        name: Validators.sanitize(_nameC.text),
        nim: Validators.sanitize(_nimC.text),
        programStudi: Validators.sanitize(_prodiC.text),
        email: Validators.sanitize(_emailC.text),
      ),
    );
  }

  Widget _field(
    TextEditingController controller,
    String label,
    String? Function(String?) validator, {
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Profil'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(_nameC, 'Nama', Validators.validateName),
              _field(
                _nimC,
                'NIM',
                Validators.validateNim,
                keyboardType: TextInputType.number,
              ),
              _field(_prodiC, 'Program Studi', Validators.validateProgramStudi),
              _field(
                _emailC,
                'Email',
                Validators.validateEmail,
                keyboardType: TextInputType.emailAddress,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Batal'),
        ),
        FilledButton(onPressed: _save, child: const Text('Simpan')),
      ],
    );
  }
}
