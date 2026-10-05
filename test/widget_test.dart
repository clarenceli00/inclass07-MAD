import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:inclass07/main.dart';

void main() {
  Future<void> tap(WidgetTester tester, String label) async {
    await tester.tap(find.widgetWithText(ElevatedButton, label));
    await tester.pump();
  }

  void expectLevels(WidgetTester tester, List<int> levels) {
    final bars = tester.widgetList<LinearProgressIndicator>(
      find.byType(LinearProgressIndicator),
    );
    expect(bars.map((bar) => bar.value), levels.map((value) => value / 100));
    for (final entry in ['Happiness', 'Hunger', 'Energy'].asMap().entries) {
      expect(
        find.text('${entry.value}: ${levels[entry.key]}/100'),
        findsOneWidget,
      );
    }
  }

  testWidgets('Actions update levels and reset restores starting values', (
    tester,
  ) async {
    await tester.pumpWidget(const PetApp());
    expectLevels(tester, [50, 50, 70]);
    await tap(tester, 'Play');
    expectLevels(tester, [60, 55, 60]);
    await tap(tester, 'Feed');
    expectLevels(tester, [70, 45, 60]);
    await tap(tester, 'Rest');
    expectLevels(tester, [70, 45, 80]);
    await tap(tester, 'Reset');
    expectLevels(tester, [50, 50, 70]);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Repeated actions keep all levels within bounds', (tester) async {
    await tester.pumpWidget(const PetApp());
    for (var i = 0; i < 20; i++) {
      await tap(tester, 'Play');
    }
    expectLevels(tester, [100, 100, 0]);
    for (var i = 0; i < 20; i++) {
      await tap(tester, 'Feed');
      await tap(tester, 'Rest');
    }
    expectLevels(tester, [0, 0, 100]);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Hunger timer stops at game over and reset restarts it', (
    tester,
  ) async {
    await tester.pumpWidget(const PetApp());
    for (var i = 0; i < 12; i++) {
      await tester.pump(const Duration(seconds: 5));
    }
    expectLevels(tester, [10, 100, 70]);
    expect(find.text('Game over! Reset to try again.'), findsOneWidget);
    final play = tester.widget<ElevatedButton>(
      find.widgetWithText(ElevatedButton, 'Play'),
    );
    expect(play.onPressed, isNull);
    await tap(tester, 'Reset');
    await tester.pump(const Duration(seconds: 5));
    expectLevels(tester, [50, 55, 70]);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('Reset cancels the previous high mood timer', (tester) async {
    await tester.pumpWidget(const PetApp());
    for (var i = 0; i < 4; i++) {
      await tap(tester, 'Play');
    }
    await tester.pump(const Duration(seconds: 10));
    await tap(tester, 'Reset');
    for (var i = 0; i < 4; i++) {
      await tap(tester, 'Play');
    }
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('You won! Reset to play again.'), findsNothing);
    await tester.pump(const Duration(seconds: 10));
    expect(find.text('You won! Reset to play again.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox());
  });
}
