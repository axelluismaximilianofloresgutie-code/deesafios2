import 'package:flutter_test/flutter_test.dart';
import 'package:desafio8/main.dart';

void main() {
  testWidgets('La aplicación inicia correctamente', (WidgetTester tester) async {
    await tester.pumpWidget(const MiAplicacion());

    expect(find.text('Sistema de Asistencia QR'), findsOneWidget);
    expect(find.text('Firebase conectado correctamente'), findsOneWidget);
  });
}