import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todoappflutter/container/main_container.dart';
import 'package:todoappflutter/model/app_state.dart';

class TodoingApp extends StatelessWidget {
  final Store<AppState> store;

  TodoingApp(this.store);

  @override
  Widget build(BuildContext context) {
    return new StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
          title: 'Todoing App',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: MainContainer(),
          debugShowCheckedModeBanner: false),
    );
  }
}
