import 'package:flutter/material.dart';
import '../data/api_service.dart';
import '../domain/post.dart';
import 'detalle_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService apiService = ApiService();

  late Future<List<Post>> noticias;

  String busqueda = '';

  @override
  void initState() {
    super.initState();
    noticias = apiService.getPosts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Noticias'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<Post>>(
        future: noticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar las noticias'),
            );
          }

          final lista = snapshot.data ?? [];

          final filtradas = lista.where((post) {
            return post.title.toLowerCase().contains(
              busqueda.toLowerCase(),
            );
          }).toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Buscar noticias...',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (valor) {
                    setState(() {
                      busqueda = valor;
                    });
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: filtradas.length,
                  itemBuilder: (context, index) {
                    final post = filtradas[index];

                    return ListTile(
                      title: Text(post.title),
                      subtitle: Text(
                        post.body,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DetalleScreen(post: post),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}