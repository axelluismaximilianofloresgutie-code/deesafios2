
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// FOTO DE PERFIL
const String linkFoto =
    'https://raw.githubusercontent.com/axelluismaximilianofloresgutie-code/foto/main/axel.jpeg';

// MODELO DE TAREA
class Tarea {
  final String titulo;
  final bool completada;

  const Tarea({
    required this.titulo,
    this.completada = false,
  });

  Tarea copyWith({bool? completada}) {
    return Tarea(
      titulo: titulo,
      completada: completada ?? this.completada,
    );
  }
}

// ESTADO DE LAS TAREAS
class TasksState {
  final List<Tarea> tareas;

  const TasksState({this.tareas = const []});

  int get pendientes =>
      tareas.where((tarea) => !tarea.completada).length;
}

// ADMINISTRADOR DE TAREAS
class TasksNotifier extends StateNotifier<TasksState> {
  TasksNotifier() : super(const TasksState());

  // AGREGAR
  void agregar(String titulo) {
    if (titulo.trim().isEmpty) return;

    state = TasksState(
      tareas: [
        ...state.tareas,
        Tarea(titulo: titulo.trim()),
      ],
    );
  }

  // ELIMINAR
  void eliminar(int indice) {
    final nuevas = [...state.tareas];
    nuevas.removeAt(indice);

    state = TasksState(tareas: nuevas);
  }

  // MARCAR COMO COMPLETADA
  void toggleCompletada(int indice) {
    final nuevas = [...state.tareas];

    nuevas[indice] = nuevas[indice].copyWith(
      completada: !nuevas[indice].completada,
    );

    state = TasksState(tareas: nuevas);
  }
}

// PROVIDER
final tasksProvider =
StateNotifierProvider<TasksNotifier, TasksState>(
      (ref) => TasksNotifier(),
);

// INICIO DE LA APLICACIÓN
void main() {
  runApp(
    const ProviderScope(
      child: MiApp(),
    ),
  );
}

class MiApp extends StatelessWidget {
  const MiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mis Tareas',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),
      home: const PantallaPrincipal(),
    );
  }
}

// PANTALLA PRINCIPAL
class PantallaPrincipal extends StatefulWidget {
  const PantallaPrincipal({super.key});

  @override
  State<PantallaPrincipal> createState() =>
      _PantallaPrincipalState();
}

class _PantallaPrincipalState extends State<PantallaPrincipal> {
  int seccion = 0;

  final List<String> titulos = [
    'Inicio',
    'Tareas',
    'Perfil',
  ];

  void cambiarSeccion(int indice) {
    setState(() {
      seccion = indice;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(titulos[seccion]),
        centerTitle: true,
      ),

      // DRAWER
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor:
                    Theme.of(context).colorScheme.surface,
                    child: ClipOval(
                      child: Image.network(
                        linkFoto,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(Icons.person, size: 40);
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Axel Flores',
                    style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('Mi aplicación de tareas'),
                ],
              ),
            ),

            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Inicio'),
              onTap: () {
                Navigator.pop(context);
                cambiarSeccion(0);
              },
            ),

            ListTile(
              leading: const Icon(Icons.task_alt),
              title: const Text('Tareas'),
              onTap: () {
                Navigator.pop(context);
                cambiarSeccion(1);
              },
            ),

            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Perfil'),
              onTap: () {
                Navigator.pop(context);
                cambiarSeccion(2);
              },
            ),

            const Divider(),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Acerca de'),
              onTap: () {
                Navigator.pop(context);
                showAboutDialog(
                  context: context,
                  applicationName: 'Mis Tareas',
                  applicationVersion: '1.0',
                );
              },
            ),
          ],
        ),
      ),

      // CONTENIDO DE LAS SECCIONES
      body: IndexedStack(
        index: seccion,
        children: const [
          InicioScreen(),
          TareasScreen(),
          PerfilScreen(),
        ],
      ),

      // NAVEGACIÓN INFERIOR
      bottomNavigationBar: NavigationBar(
        selectedIndex: seccion,
        onDestinationSelected: cambiarSeccion,
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
    );
  }
}

// PANTALLA DE INICIO
class InicioScreen extends ConsumerWidget {
  const InicioScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(tasksProvider);

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.check_circle_outline, size: 40),
                const SizedBox(height: 12),
                const Text(
                  '¡Bienvenido!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Organizá tus tareas del día.'),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'Resumen de tareas',
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
                  context,
                  'Total',
                  state.tareas.length.toString(),
                  Icons.list_alt,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: tarjetaEstadistica(
                  context,
                  'Pendientes',
                  state.pendientes.toString(),
                  Icons.pending_actions,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: tarjetaEstadistica(
                  context,
                  'Hechas',
                  (state.tareas.length - state.pendientes).toString(),
                  Icons.check_circle,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// TARJETAS DE ESTADÍSTICAS
Widget tarjetaEstadistica(
    BuildContext context,
    String titulo,
    String cantidad,
    IconData icono,
    ) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 6,
      ),
      child: Column(
        children: [
          Icon(icono, size: 28),
          const SizedBox(height: 8),
          Text(
            cantidad,
            style: const TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            titulo,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    ),
  );
}

// PANTALLA DE TAREAS
class TareasScreen extends ConsumerStatefulWidget {
  const TareasScreen({super.key});

  @override
  ConsumerState<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends ConsumerState<TareasScreen> {
  final TextEditingController controlador = TextEditingController();

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  void agregarTarea() {
    ref.read(tasksProvider.notifier).agregar(controlador.text);
    controlador.clear();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(tasksProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controlador,
                  decoration: const InputDecoration(
                    labelText: 'Nueva tarea',
                    hintText: 'Escribí una tarea...',
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.edit),
                  ),
                  onSubmitted: (_) => agregarTarea(),
                ),
              ),
              const SizedBox(width: 8),
              IconButton.filled(
                onPressed: agregarTarea,
                icon: const Icon(Icons.add),
                iconSize: 30,
              ),
            ],
          ),

          const SizedBox(height: 15),

          Expanded(
            child: state.tareas.isEmpty
                ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.assignment_outlined, size: 60),
                  SizedBox(height: 10),
                  Text('Todavía no tenés tareas'),
                ],
              ),
            )
                : ListView.builder(
              itemCount: state.tareas.length,
              itemBuilder: (context, index) {
                final tarea = state.tareas[index];

                return Card(
                  child: ListTile(
                    leading: Checkbox(
                      value: tarea.completada,
                      onChanged: (_) {
                        ref
                            .read(tasksProvider.notifier)
                            .toggleCompletada(index);
                      },
                    ),
                    title: Text(
                      tarea.titulo,
                      style: TextStyle(
                        decoration: tarea.completada
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        ref
                            .read(tasksProvider.notifier)
                            .eliminar(index);
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// PANTALLA DE PERFIL
class PerfilScreen extends StatelessWidget {
  const PerfilScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 55,
            child: ClipOval(
              child: Image.network(
                linkFoto,
                width: 110,
                height: 110,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(Icons.person, size: 60);
                },
              ),
            ),
          ),
          const SizedBox(height: 15),
          const Text(
            'Axel Flores',
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text('Estudiante de programación'),
        ],
      ),
    );
  }
}
