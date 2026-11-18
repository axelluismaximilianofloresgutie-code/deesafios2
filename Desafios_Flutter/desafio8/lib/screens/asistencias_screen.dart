
import 'package:flutter/material.dart';
import '../services/asistencia_service.dart';
import '../models/asistencia.dart';

class AsistenciasScreen extends StatelessWidget {
  const AsistenciasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final servicio = AsistenciaService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Asistencias de hoy'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Limpiar registro del día',
            onPressed: () async {
              final confirmar = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Limpiar asistencias'),
                  content: const Text(
                    '¿Deseás eliminar todos los registros de hoy?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancelar'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Eliminar'),
                    ),
                  ],
                ),
              );

              if (confirmar == true) {
                await servicio.limpiarAsistenciasDelDia();

                if (!context.mounted) return;

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Registros eliminados'),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Asistencia>>(
        stream: servicio.obtenerAsistenciasDelDia(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar las asistencias'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final asistencias = snapshot.data ?? [];

          if (asistencias.isEmpty) {
            return const Center(
              child: Text('Todavía no hay asistencias registradas'),
            );
          }

          return ListView.builder(
            itemCount: asistencias.length,
            itemBuilder: (context, index) {
              final asistencia = asistencias[index];

              return Card(
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(asistencia.nombre),
                  subtitle: Text(
                    'Fecha: ${asistencia.fecha} - Hora: ${asistencia.hora}',
                  ),
                  trailing: const Icon(
                    Icons.check_circle,
                    color: Colors.green,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
