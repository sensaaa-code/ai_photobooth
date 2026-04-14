import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ai_photobooth/app/app.dart';

void main() {
  testWidgets('Welcome screen smoke test — app renders without error',
      (WidgetTester tester) async {
    // Build the app (wrapped in ProviderScope as in main.dart).
    await tester.pumpWidget(
      const ProviderScope(child: PhotoboothApp()),
    );

    // Wait for routing to settle.
    await tester.pumpAndSettle();

    // The welcome screen should show the app title and the "Mulai" button.
    expect(find.text('AI Photobooth'), findsOneWidget);
    expect(find.text('Mulai'), findsOneWidget);
  });
}
