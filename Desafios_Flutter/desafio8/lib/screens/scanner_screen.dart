
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import '../services/asistencia_service.dart';

import '../services/notificacion_service.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen> {
  final MobileScannerController controlador =
  MobileScannerController();

  final AsistenciaService servicio = AsistenciaService();

  bool procesando = false;

  Future<void> detectarCodigo(BarcodeCapture captura) async {
    if (procesando) return;

    final codigo = captura.barcodes.first.rawValue;

    if (codigo == null || codigo.trim().isEmpty) return;

    setState(() {
      procesando = true;
    });

    try {
      final registrado =
      await servicio.registrarAsistencia(codigo.trim());
      if (!registrado) {
        await NotificacionService.mostrarDuplicado(codigo.trim());
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            registrado
                ? 'Asistencia registrada: $codigo'
                : '$codigo ya tiene asistencia hoy',
          ),
          backgroundColor: registrado ? Colors.green : Colors.orange,
        ),
      );
    } catch (error) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Error al registrar la asistencia'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          procesando = false;
        });
      }
    }
  }

  @override
  void dispose() {
    controlador.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear código QR'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.flash_on),
            tooltip: 'Activar o desactivar linterna',
            onPressed: () => controlador.toggleTorch(),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: MobileScanner(
              controller: controlador,
              onDetect: detectarCodigo,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                const Icon(
                  Icons.qr_code_scanner,
                  size: 40,
                  color: Colors.blue,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Apuntá la cámara al código QR del alumno',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                if (procesando)
                  const Padding(
                    padding: EdgeInsets.all(10),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
