
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificacionService {
  static final FlutterLocalNotificationsPlugin _plugin =
  FlutterLocalNotificationsPlugin();

  static Future<void> inicializar() async {
    const configuracionAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const configuracion = InitializationSettings(
      android: configuracionAndroid,
    );

    await _plugin.initialize(configuracion);

    await _plugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> mostrarDuplicado(String nombre) async {
    const detallesAndroid = AndroidNotificationDetails(
      'canal_asistencia',
      'Asistencia',
      channelDescription: 'Avisos del sistema de asistencia',
      importance: Importance.high,
      priority: Priority.high,
    );

    const detalles = NotificationDetails(
      android: detallesAndroid,
    );

    await _plugin.show(
      1,
      'Asistencia duplicada',
      '$nombre ya fue registrado hoy.',
      detalles,
    );
  }
}
