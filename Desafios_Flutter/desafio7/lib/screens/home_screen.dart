
import 'package:flutter/material.dart';

import '../services/auth_service.dart';
import 'tareas_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _indiceActual = 0;

  final AuthService _authService = AuthService();

  Future<void> cerrarSesion() async {
    await _authService.cerrarSesion();
  }

  @override
  Widget build(BuildContext context) {
    final pantallas = [
      const TareasScreen(),
      const Center(
        child: Text(
          'Bienvenido a tu aplicación de tareas',
          style: TextStyle(fontSize: 20),
          textAlign: TextAlign.center,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis tareas'),
        centerTitle: true,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Icon(
                    Icons.account_circle,
                    size: 55,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Menú principal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Mis tareas'),
              onTap: () {
                setState(() {
                  _indiceActual = 0;
                });
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                setState(() {
                  _indiceActual = 1;
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: cerrarSesion,
            ),
          ],
        ),
      ),
      body: pantallas[_indiceActual],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceActual,
        onDestinationSelected: (indice) {
          setState(() {
            _indiceActual = indice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
        ],
      ),
    );
  }
}
