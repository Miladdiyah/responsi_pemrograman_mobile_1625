import 'package:flutter/material.dart';

import '../models/student.dart';

/// Kartu yang menampilkan data profil mahasiswa.
class ProfileCard extends StatelessWidget {
  /// Membuat kartu profil untuk [student].
  const ProfileCard({super.key, required this.student});

  /// Data mahasiswa yang ditampilkan.
  final Student student;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.all(16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CircleAvatar(
              radius: 44,
              backgroundColor: scheme.primaryContainer,
              child: Text(
                student.initials,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: scheme.onPrimaryContainer,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              student.name,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Divider(),
            _InfoRow(
              icon: Icons.badge_outlined,
              label: 'NIM',
              value: student.nim,
            ),
            _InfoRow(
              icon: Icons.school_outlined,
              label: 'Program Studi',
              value: student.programStudi,
            ),
            _InfoRow(
              icon: Icons.email_outlined,
              label: 'Email',
              value: student.email,
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: Theme.of(context).textTheme.labelMedium),
                Text(value, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
