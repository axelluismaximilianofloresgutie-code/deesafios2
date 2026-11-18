
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/asistencia.dart';

class AsistenciaService {
  final CollectionReference<Map<String, dynamic>> _coleccion =
  FirebaseFirestore.instance.collection('asistencias');

  String obtenerFecha() {
    final ahora = DateTime.now();

    return '${ahora.year}-'
        '${ahora.month.toString().padLeft(2, '0')}-'
        '${ahora.day.toString().padLeft(2, '0')}';
  }

  String obtenerHora() {
    final ahora = DateTime.now();

    return '${ahora.hour.toString().padLeft(2, '0')}:'
        '${ahora.minute.toString().padLeft(2, '0')}:'
        '${ahora.second.toString().padLeft(2, '0')}';
  }

  Future<bool> registrarAsistencia(String nombre) async {
    final fecha = obtenerFecha();
    final id = '${nombre.trim().toLowerCase().replaceAll(' ', '_')}_$fecha';

    final documento = _coleccion.doc(id);

    return FirebaseFirestore.instance.runTransaction((transaccion) async {
      final existente = await transaccion.get(documento);

      if (existente.exists) {
        return false;
      }

      final asistencia = Asistencia(
        id: id,
        nombre: nombre,
        fecha: fecha,
        hora: obtenerHora(),
      );

      transaccion.set(documento, asistencia.toMap());

      return true;
    });
  }

  Stream<List<Asistencia>> obtenerAsistenciasDelDia() {
    final fecha = obtenerFecha();

    return _coleccion
        .where('fecha', isEqualTo: fecha)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((documento) {
        return Asistencia.fromMap(
          documento.id,
          documento.data(),
        );
      }).toList();
    });
  }

  Future<void> limpiarAsistenciasDelDia() async {
    final fecha = obtenerFecha();

    final registros = await _coleccion
        .where('fecha', isEqualTo: fecha)
        .get();

    final lote = FirebaseFirestore.instance.batch();

    for (final documento in registros.docs) {
      lote.delete(documento.reference);
    }

    await lote.commit();
  }
}
