import 'package:flutter_test/flutter_test.dart';
import 'package:desafio5/main.dart';

void main() {
  testWidgets('La aplicacion inicia', (WidgetTester tester) async {
    await tester.pumpWidget(const MiApp());

    expect(find.text('Noticias'), findsOneWidget);
  });
}