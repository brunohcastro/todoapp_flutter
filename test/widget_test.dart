// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:todoappflutter/todoing_app.dart';
import 'package:redux/redux.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/redux/reducers.dart';
import 'package:redux_thunk/redux_thunk.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    final store = Store<AppState>(appReducer,
        initialState: AppState(), middleware: [thunkMiddleware]);

    // Build our app and trigger a frame.
    await tester.pumpWidget(TodoingApp(store));

    // Verify that our counter starts at 0.
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
