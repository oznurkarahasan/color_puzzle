import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:color_puzzle/main.dart';

void main() {
  testWidgets('Oyun açılış testi', (WidgetTester tester) async {
    await tester.pumpWidget(const RenkPuzzleApp());

    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
