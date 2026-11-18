
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens.dart';

bool sesionIniciada = false;

final GoRouter appRouter = GoRouter(
  initialLocation: '/',

  // Control de sesión
  redirect: (context, state) {
    final estaEnLogin = state.matchedLocation == '/login';

    if (!sesionIniciada && !estaEnLogin) {
      return '/login';
    }

    if (sesionIniciada && estaEnLogin) {
      return '/';
    }

    return null;
  },

  routes: [
    // Ruta de inicio de sesión
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),

    // Navegación principal
    ShellRoute(
      builder: (context, state, child) {
        final ruta = state.uri.path;

        int indice = 0;

        if (ruta.startsWith('/posts')) {
          indice = 1;
        } else if (ruta == '/perfil') {
          indice = 2;
        }

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            selectedIndex: indice,
            onDestinationSelected: (index) {
              if (index == 0) {
                context.go('/');
              } else if (index == 1) {
                context.go('/posts');
              } else {
                context.go('/perfil');
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: 'Inicio',
              ),
              NavigationDestination(
                icon: Icon(Icons.article),
                label: 'Posts',
              ),
              NavigationDestination(
                icon: Icon(Icons.person),
                label: 'Perfil',
              ),
            ],
          ),
        );
      },

      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),

        GoRoute(
          path: '/posts',
          builder: (context, state) {
            final search =
                state.uri.queryParameters['search'] ?? '';

            return PostsScreen(search: search);
          },
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) {
                final id = state.pathParameters['id']!;

                return DetailScreen(id: id);
              },
            ),
          ],
        ),

        GoRoute(
          path: '/perfil',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
