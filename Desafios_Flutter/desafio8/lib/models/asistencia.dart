
class Asistencia {
  final String id;
  final String nombre;
  final String fecha;
  final String hora;

  Asistencia({
    required this.id,
    required this.nombre,
    required this.fecha,
    required this.hora,
  });

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'fecha': fecha,
      'hora': hora,
    };
  }

  factory Asistencia.fromMap(
      String id,
      Map<String, dynamic> datos,
      ) {
    return Asistencia(
      id: id,
      nombre: datos['nombre'] ?? '',
      fecha: datos['fecha'] ?? '',
      hora: datos['hora'] ?? '',
    );
  }
}

