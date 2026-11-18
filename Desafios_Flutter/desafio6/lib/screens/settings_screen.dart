import 'package:flutter/material.dart';
import '../data/settings_service.dart';

class SettingsScreen extends StatefulWidget {
  final Function(bool) onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;
  bool notifications = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() {
    darkMode = SettingsService.getDarkMode();
    notifications = SettingsService.getNotifications();
  }

  Future<void> changeDarkMode(bool value) async {
    setState(() {
      darkMode = value;
    });

    await SettingsService.saveDarkMode(value);
    widget.onThemeChanged(value);
  }

  Future<void> changeNotifications(bool value) async {
    setState(() {
      notifications = value;
    });

    await SettingsService.saveNotifications(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configuración'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Modo oscuro'),
            value: darkMode,
            onChanged: changeDarkMode,
          ),
          SwitchListTile(
            title: const Text('Notificaciones'),
            value: notifications,
            onChanged: changeNotifications,
          ),
        ],
      ),
    );
  }
}