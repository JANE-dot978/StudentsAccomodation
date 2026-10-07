// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:provider/provider.dart';

import 'package:studentsaccomodations/app.dart';
import 'package:studentsaccomodations/providers/auth_provider.dart';

class _TestAuthProvider extends ChangeNotifier implements AuthProvider {
  @override
  User? get user => null;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  testWidgets('App launches and shows login screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<AuthProvider>(
        create: (_) => _TestAuthProvider(),
        child: const App(),
      ),
    );

    // Verify that the app loads
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
