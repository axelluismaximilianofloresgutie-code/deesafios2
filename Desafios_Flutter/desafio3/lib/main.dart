
import 'package:flutter/material.dart';

void main() {
  runApp(const MiApp());
}

class MiApp extends StatefulWidget {
  const MiApp({super.key});

  @override
  State<MiApp> createState() => _MiAppState();
}

class _MiAppState extends State<MiApp> {

  // =====================================
  // 📸 FOTO DE PERFIL
  // Enlace de la fotografía
  // =====================================
  final String linkFoto =
      'https://raw.githubusercontent.com/axelluismaximilianofloresgutie-code/foto/main/axel.jpeg';

  bool modoOscuro = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Desafio 3',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: modoOscuro ? ThemeMode.dark : ThemeMode.light,
      home: PantallaPrincipal(
        modoOscuro: modoOscuro,
        cambiarTema: (valor) {
          setState(() {
            modoOscuro = valor;
          });
        },
        linkFoto: linkFoto,
      ),
    );
  }
}

class PantallaPrincipal extends StatefulWidget {
  final bool modoOscuro;
  final Function(bool) cambiarTema;
  final String linkFoto;

  const PantallaPrincipal({
    super.key,
    required this.modoOscuro,
    required this.cambiarTema,
    required this.linkFoto,
  });

  @override
  State<PantallaPrincipal> createState() =>
      _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int paginaActual = 0;

  final List<String> titulos = [
    'Inicio',
    'Tareas',
    'Perfil',
    'Configuración',
  ];

  void cambiarPagina(int pagina) {
    setState(() {
      paginaActual = pagina;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(titulos[paginaActual]),
        backgroundColor: cs.surface,
      ),

      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: cs.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: NetworkImage(widget.linkFoto),
                    onBackgroundImageError: (_, __) {},
                  ),

                  const SizedBox(height: 10),

                  Text(
                    'Mi aplicación',
                    style: TextStyle(
                      color: cs.onPrimary,
                      fontSize: 20,
                    ),
                  ),

                  Text(
                    'Bienvenido',
                    style: TextStyle(
                      color: cs.onPrimary,
                    ),
                  ),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                cambiarPagina(0);
              },
            ),

            ListTile(
              leading: const Icon(Icons.task),
              title: const Text('Tareas'),
              onTap: () {
                Navigator.pop(context);
                cambiarPagina(1);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                cambiarPagina(2);
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.settings),
              title: const Text('Configuración'),
              onTap: () {
                Navigator.pop(context);
                cambiarPagina(3);
              },
            ),
          ],
        ),
      ),

      body: paginaActual == 0
          ? pantallaInicio(cs)
          : paginaActual == 1
          ? pantallaTareas(cs)
          : paginaActual == 2
          ? pantallaPerfil(cs)
          : pantallaConfiguracion(cs),

      bottomNavigationBar: paginaActual == 3
          ? null
          : NavigationBar(
        selectedIndex: paginaActual,
        onDestinationSelected: cambiarPagina,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.task_outlined),
            selectedIcon: Icon(Icons.task),
            label: 'Tareas',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),

      floatingActionButton: paginaActual == 1
          ? FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                '¡Botón para agregar una tarea!',
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      )
          : null,
    );
  }

  Widget pantallaInicio(ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: cs.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: cs.onPrimaryContainer,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Esta es mi aplicación Flutter.',
                  style: TextStyle(
                    color: cs.onPrimaryContainer,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Estadísticas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 15),

          Row(
            children: [
              Expanded(
                child: tarjetaEstadistica(
                  'Tareas',
                  '12',
                  Icons.task,
                  cs,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: tarjetaEstadistica(
                  'Completadas',
                  '8',
                  Icons.check_circle,
                  cs,
                ),
              ),

              const SizedBox(width: 8),

              Expanded(
                child: tarjetaEstadistica(
                  'Pendientes',
                  '4',
                  Icons.pending_actions,
                  cs,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget tarjetaEstadistica(
      String titulo,
      String numero,
      IconData icono,
      ColorScheme cs,
      ) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            icono,
            color: cs.primary,
            size: 28,
          ),

          const SizedBox(height: 8),

          Text(
            numero,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),

          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  Widget pantallaTareas(ColorScheme cs) {
    return const Center(
      child: Text(
        'Mis tareas',
        style: TextStyle(fontSize: 24),
      ),
    );
  }

  Widget pantallaPerfil(ColorScheme cs) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 50,
            child: Icon(
              Icons.person,
              size: 60,
            ),
          ),

          SizedBox(height: 15),

          Text(
            'Mi perfil',
            style: TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }

  Widget pantallaConfiguracion(ColorScheme cs) {
    return SwitchListTile(
      title: const Text('Modo oscuro'),
      subtitle: const Text(
        'Activar o desactivar el tema oscuro',
      ),
      secondary: const Icon(Icons.dark_mode),
      value: widget.modoOscuro,
      onChanged: widget.cambiarTema,
    );
  }
}
