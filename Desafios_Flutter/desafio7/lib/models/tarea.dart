import 'package:cloud_firestore/cloud_firestore.dart';

class Tarea {
  final String id;
  final String titulo;
  final bool completada;
  final String prioridad;
  final DateTime? fechaCreacion;
  final String userId;

  Tarea({
    required this.id,
    required this.titulo,
    required this.completada,
    required this.prioridad,
    this.fechaCreacion,
    required this.userId,
  });

  factory Tarea.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> documento,
      ) {
    final datos = documento.data()!;

    return Tarea(
      id: documento.id,
      titulo: datos['titulo'] ?? '',
      completada: datos['completada'] ?? false,
      prioridad: datos['prioridad'] ?? 'Media',
      fechaCreacion: (datos['fechaCreacion'] as Timestamp?)?.toDate(),
      userId: datos['userId'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'titulo': titulo,
      'completada': completada,
      'prioridad': prioridad,
      'fechaCreacion': FieldValue.serverTimestamp(),
      'userId': userId,
    };
  }
}