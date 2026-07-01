// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fleetlive/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FleetLiveApp());

    // Verify that the splash screen elements exist.
    expect(find.text('Track Every Vehicle. Anywhere. Anytime.'), findsOneWidget);

    // Pump and settle to let animations and delayed navigation timers finish.
    await tester.pumpAndSettle();
  });
}
