import 'package:flutter/material.dart';

import '../repositories/post_repository.dart';
import '../widgets/empty_state.dart';

/// Layar yang menampilkan data post dari API publik di ListView.
class PostsScreen extends StatefulWidget {
  /// Membuat layar data online.
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  final PostRepository _repository = PostRepository();
  late Future<List<Post>> _future;

  @override
  void initState() {
    super.initState();
    _future = _repository.fetchPosts();
  }

  @override
  void dispose() {
    _repository.dispose();
    super.dispose();
  }

  void _retry() {
    setState(() {
      _future = _repository.fetchPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Online')),
      body: FutureBuilder<List<Post>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            final message = error is PostException
                ? error.message
                : 'Terjadi kesalahan.';
            return EmptyState(
              icon: Icons.error_outline,
              title: 'Gagal memuat data',
              message: message,
              actionLabel: 'Coba Lagi',
              onAction: _retry,
            );
          }
          final posts = snapshot.data ?? const <Post>[];
          if (posts.isEmpty) {
            return const EmptyState(
              icon: Icons.inbox_outlined,
              title: 'Tidak ada data',
              message: 'Server tidak mengembalikan data.',
            );
          }
          return ListView.separated(
            itemCount: posts.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final post = posts[index];
              return ListTile(
                leading: CircleAvatar(child: Text('${post.id}')),
                title: Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  post.body,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
