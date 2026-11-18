import 'package:hive_flutter/hive_flutter.dart';

class SettingsService {
  static const String boxName = 'settings';

  static Future<void> saveDarkMode(bool value) async {
    final box = Hive.box(boxName);
    await box.put('darkMode', value);
  }

  static Future<void> saveNotifications(bool value) async {
    final box = Hive.box(boxName);
    await box.put('notifications', value);
  }

  static bool getDarkMode() {
    final box = Hive.box(boxName);
    return box.get('darkMode', defaultValue: false);
  }

  static bool getNotifications() {
    final box = Hive.box(boxName);
    return box.get('notifications', defaultValue: true);
  }
}