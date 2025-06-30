import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_application_1/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Agregar tarea y marcar como completada', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(ToDoApp());

    expect(find.byType(ListTile), findsNothing);

    await tester.enterText(find.byType(TextField), 'Estudiar Flutter');
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('Estudiar Flutter'), findsOneWidget);
    expect(find.byType(ListTile), findsOneWidget);

    await tester.tap(find.byType(Checkbox));
    await tester.pump();

    final textWidget = tester.widget<Text>(find.text('Estudiar Flutter'));
    expect(textWidget.style?.decoration, TextDecoration.lineThrough);
  });
}
