import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/tarea.dart';

class TareaService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener las tareas del usuario actual.
  Stream<List<Tarea>> obtenerTareas() {
    final usuario = _auth.currentUser;

    if (usuario == null) {
      return Stream.value([]);
    }

    return _firestore
        .collection('tareas')
        .where('userId', isEqualTo: usuario.uid)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((documento) => Tarea.fromFirestore(documento))
          .toList();
    });
  }

  // Agregar una tarea.
  Future<void> agregarTarea({
    required String titulo,
    required String prioridad,
  }) async {
    final usuario = _auth.currentUser;

    if (usuario == null) {
      throw Exception('No hay un usuario autenticado.');
    }

    final tarea = Tarea(
      id: '',
      titulo: titulo,
      completada: false,
      prioridad: prioridad,
      userId: usuario.uid,
    );

    await _firestore
        .collection('tareas')
        .add(tarea.toFirestore());
  }

  // Cambiar el estado de una tarea.
  Future<void> cambiarEstado(Tarea tarea) async {
    await _firestore
        .collection('tareas')
        .doc(tarea.id)
        .update({
      'completada': !tarea.completada,
    });
  }

  // Eliminar una tarea.
  Future<void> eliminarTarea(String id) async {
    await _firestore
        .collection('tareas')
        .doc(id)
        .delete();
  }
}