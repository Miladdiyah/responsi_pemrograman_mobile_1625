import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

/// Data post dari API publik.
class Post {
  /// Membuat post.
  const Post({required this.id, required this.title, required this.body});

  /// Membuat [Post] dari JSON.
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: (json['id'] as num).toInt(),
      title: (json['title'] ?? '').toString(),
      body: (json['body'] ?? '').toString(),
    );
  }

  /// ID post.
  final int id;

  /// Judul post.
  final String title;

  /// Isi post.
  final String body;
}

/// Error yang pesannya aman ditampilkan ke pengguna.
class PostException implements Exception {
  /// Membuat exception dengan [message].
  const PostException(this.message);

  /// Pesan untuk pengguna.
  final String message;

  @override
  String toString() => message;
}

/// Repository untuk mengambil data post dari API publik.
class PostRepository {
  /// Membuat repository. [client] opsional untuk testing.
  PostRepository({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  /// Mengambil daftar post (GET /posts) dengan timeout dan error handling.
  Future<List<Post>> fetchPosts({int limit = 20}) async {
    final baseUrl = AppConfig.baseUrl;
    if (baseUrl.isEmpty) {
      throw const PostException('BASE_URL belum dikonfigurasi di file .env.');
    }

    final uri = Uri.parse('$baseUrl/posts')
        .replace(queryParameters: {'_limit': '$limit'});
    final apiKey = AppConfig.apiKey;

    try {
      final response = await _client
          .get(
            uri,
            headers: {
              'Accept': 'application/json',
              if (apiKey.isNotEmpty) 'X-API-Key': apiKey,
            },
          )
          .timeout(const Duration(seconds: 10));

      // Log aman: hanya status code, tanpa header/API key/body.
      debugPrint('GET /posts -> status ${response.statusCode}');

      if (response.statusCode != 200) {
        throw PostException(
          'Server mengembalikan status ${response.statusCode}.',
        );
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! List) {
        throw const PostException('Format data dari server tidak sesuai.');
      }
      return decoded
          .map((e) => Post.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostException {
      rethrow;
    } on TimeoutException {
      throw const PostException('Koneksi timeout. Coba lagi nanti.');
    } on SocketException {
      throw const PostException('Tidak ada koneksi internet.');
    } on http.ClientException {
      throw const PostException('Gagal terhubung ke server.');
    } on FormatException {
      throw const PostException('Data dari server tidak dapat dibaca.');
    } catch (_) {
      throw const PostException('Terjadi kesalahan tak terduga.');
    }
  }

  /// Menutup koneksi HTTP.
  void dispose() => _client.close();
}
