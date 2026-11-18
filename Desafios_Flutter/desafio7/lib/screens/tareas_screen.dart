
import 'package:flutter/material.dart';

import '../models/tarea.dart';
import '../services/tarea_service.dart';

class TareasScreen extends StatefulWidget {
  const TareasScreen({super.key});

  @override
  State<TareasScreen> createState() => _TareasScreenState();
}

class _TareasScreenState extends State<TareasScreen> {
  final TareaService _tareaService = TareaService();

  Future<void> mostrarFormulario() async {
    final tituloController = TextEditingController();
    String prioridad = 'Media';

    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, actualizarDialogo) {
            return AlertDialog(
              title: const Text('Nueva tarea'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tituloController,
                    decoration: const InputDecoration(
                      labelText: 'Título de la tarea',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    initialValue: prioridad,
                    decoration: const InputDecoration(
                      labelText: 'Prioridad',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Baja',
                        child: Text('Baja'),
                      ),
                      DropdownMenuItem(
                        value: 'Media',
                        child: Text('Media'),
                      ),
                      DropdownMenuItem(
                        value: 'Alta',
                        child: Text('Alta'),
                      ),
                    ],
                    onChanged: (valor) {
                      if (valor != null) {
                        actualizarDialogo(() {
                          prioridad = valor;
                        });
                      }
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cancelar'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    final titulo = tituloController.text.trim();

                    if (titulo.isEmpty) return;

                    try {
                      await _tareaService.agregarTarea(
                        titulo: titulo,
                        prioridad: prioridad,
                      );

                      if (context.mounted) {
                        Navigator.pop(context);
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('No se pudo guardar la tarea.'),
                          ),
                        );
                      }
                    }
                  },
                  child: const Text('Guardar'),
                ),
              ],
            );
          },
        );
      },
    );

    tituloController.dispose();
  }

  Future<void> eliminarTarea(String id) async {
    try {
      await _tareaService.eliminarTarea(id);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo eliminar la tarea.'),
        ),
      );
    }
  }

  Widget construirLista(List<Tarea> tareas) {
    if (tareas.isEmpty) {
      return const Center(
        child: Text(
          'Todavía no tenés tareas.\n¡Agregá tu primera tarea!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      );
    }

    return ListView.builder(
      itemCount: tareas.length,
      itemBuilder: (context, index) {
        final tarea = tareas[index];

        return Card(
          margin: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 6,
          ),
          child: ListTile(
            leading: Checkbox(
              value: tarea.completada,
              onChanged: (valor) async {
                try {
                  await _tareaService.cambiarEstado(tarea);
                } catch (e) {
                  if (!context.mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No se pudo actualizar la tarea.'),
                    ),
                  );
                }
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
            subtitle: Text('Prioridad: ${tarea.prioridad}'),
            trailing: IconButton(
              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),
              onPressed: () => eliminarTarea(tarea.id),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: mostrarFormulario,
              icon: const Icon(Icons.add),
              label: const Text('Agregar tarea'),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<Tarea>>(
            stream: _tareaService.obtenerTareas(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }

              if (snapshot.hasError) {
                return const Center(
                  child: Text('Error al cargar las tareas.'),
                );
              }

              final tareas = snapshot.data ?? [];

              return construirLista(tareas);
            },
          ),
        ),
      ],
    );
  }
}
