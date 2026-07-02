import 'package:flutter_test/flutter_test.dart';

import 'package:fleetlive/main.dart';

void main() {
  testWidgets('Splash screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FleetLiveApp());

    expect(
      find.text('Track Every Vehicle. Anywhere. Anytime.'),
      findsOneWidget,
    );

    await tester.pumpAndSettle();
  });
}
