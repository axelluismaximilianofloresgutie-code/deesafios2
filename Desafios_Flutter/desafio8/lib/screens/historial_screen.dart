
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HistorialScreen extends StatelessWidget {
  const HistorialScreen({super.key});

  String obtenerFechaActual() {
    final ahora = DateTime.now();

    return '${ahora.year}-'
        '${ahora.month.toString().padLeft(2, '0')}-'
        '${ahora.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final fechaActual = obtenerFechaActual();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Historial de asistencias'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('asistencias')
            .where('fecha', isLessThan: fechaActual)
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('Error al cargar el historial'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final registros = snapshot.data?.docs ?? [];

          if (registros.isEmpty) {
            return const Center(
              child: Text('Todavía no hay asistencias anteriores'),
            );
          }

          return ListView.builder(
            itemCount: registros.length,
            itemBuilder: (context, index) {
              final datos = registros[index].data();

              final nombre = datos['nombre'] ?? 'Sin nombre';
              final fecha = datos['fecha'] ?? '';
              final hora = datos['hora'] ?? '';

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const CircleAvatar(
                    child: Icon(Icons.person),
                  ),
                  title: Text(nombre),
                  subtitle: Text('Fecha: $fecha | Hora: $hora'),
                  trailing: const Icon(
                    Icons.history,
                    color: Colors.blue,
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
