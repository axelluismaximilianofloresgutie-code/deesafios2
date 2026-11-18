
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'router/router.dart';
// Pantalla de inicio
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Inicio')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            context.go('/posts');
          },
          child: const Text('Ver publicaciones'),
        ),
      ),
    );
  }
}

// Pantalla de publicaciones
class PostsScreen extends StatelessWidget {
  final String search;

  const PostsScreen({super.key, this.search = ''});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Publicaciones')),
      body: Column(
        children: [
          Text('Búsqueda: $search'),
          ListTile(
            title: const Text('Publicación 1'),
            subtitle: const Text('Ver detalles'),
            onTap: () {
              context.push('/posts/1');
            },
          ),
          ElevatedButton(
            onPressed: () {
              context.go('/posts?search=flutter');
            },
            child: const Text('Buscar Flutter'),
          ),
        ],
      ),
    );
  }
}

// Pantalla de detalle
class DetailScreen extends StatelessWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detalle')),
      body: Center(
        child: Text('Publicación número $id'),
      ),
    );
  }
}

// Pantalla de perfil
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: const Center(child: Text('Mi perfil')),
    );
  }
}

// Pantalla de inicio de sesión

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Iniciar sesión')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            sesionIniciada = true;
            context.go('/');
          },
          child: const Text('Ingresar'),
        ),
      ),
    );
  }
}