import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend_app/main.dart';

void main() {
  testWidgets('TicTacToeApp renders game UI with correct title', (WidgetTester tester) async {
    await tester.pumpWidget(const TicTacToeApp());

    // Title of main screen should be visible
    expect(find.text('Tic Tac Toe'), findsOneWidget);

    // Should have score widgets for X, Draw, O
    expect(find.text('X'), findsOneWidget);
    expect(find.text('Draw'), findsOneWidget);
    expect(find.text('O'), findsOneWidget);

    // Should show player's turn on a new game start
    expect(find.textContaining("Player "), findsOneWidget);

    // Should have 9 cells for board
    expect(find.byType(GestureDetector), findsNWidgets(9));
  });
}
