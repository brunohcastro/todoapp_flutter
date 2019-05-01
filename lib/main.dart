import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:todoappflutter/todoing_app.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/redux/reducers.dart';

void main() {
  final store = Store<AppState>(appReducer,
      initialState: AppState(), middleware: [thunkMiddleware]);

  runApp(TodoingApp(store));
}
