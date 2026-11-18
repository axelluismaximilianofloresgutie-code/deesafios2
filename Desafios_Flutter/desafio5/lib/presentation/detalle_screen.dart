import 'package:flutter/material.dart';
import '../domain/post.dart';

class DetalleScreen extends StatelessWidget {
  final Post post;

  const DetalleScreen({
    super.key,
    required this.post,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalle de noticia'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              post.body,
              style: const TextStyle(fontSize: 17),
            ),
          ],
        ),
      ),
    );
  }
}