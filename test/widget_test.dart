// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:dabba_crew_home_cook_app/main.dart';
import 'package:dabba_crew_home_cook_app/models/language_provider.dart';

void main() {
  testWidgets('App launches and shows the login page', (WidgetTester tester) async {
    // Use a larger test window to avoid layout overflow on the login page.
    const testSize = Size(1200, 900);
    tester.binding.window.physicalSizeTestValue = testSize;
    tester.binding.window.devicePixelRatioTestValue = 1.0;
    addTearDown(() {
      tester.binding.window.clearPhysicalSizeTestValue();
      tester.binding.window.clearDevicePixelRatioTestValue();
    });

    // Build the app with the required provider and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<LanguageProvider>(
        create: (_) => LanguageProvider(),
        child: const DabbaCrewApp(),
      ),
    );

    await tester.pumpAndSettle();

    // The app should navigate to the unified login page on startup.
    expect(find.byType(UnifiedLoginPage), findsOneWidget);
  });
}
