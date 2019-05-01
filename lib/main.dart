import 'package:flutter/material.dart';
import 'package:todoappflutter/redux/store.dart';
import 'package:todoappflutter/todoing_app.dart';

void main() async {
  final store = createStore();

  runApp(TodoingApp(store));
}
