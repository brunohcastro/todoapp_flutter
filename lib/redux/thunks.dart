import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/view_model.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/redux/actions.dart';

const String baseUrl = 'https://todoing-app.herokuapp.com/api';

ThunkAction<AppState> fetchAllTodos([Completer<Null> completer]) {
  return (Store<AppState> store) async {
    debugPrint('fetchAllTodos()');

    if (completer == null) {
      store.dispatch(Action.LoadingData);
    }

    http.Response response =
        await http.get('$baseUrl/todos');

    dynamic result = json.decode(response.body);

    debugPrint('dispatch(LoadTodosAction)');
    store.dispatch(LoadTodosAction(ViewModel.fromJson(result)));

    if (completer != null) {
      completer.complete();
    } else {
      store.dispatch(Action.DataLoaded);
    }
  };
}

ThunkAction<AppState> toggleTodoStatus(
    {@required int id, Completer<Null> completer}) {
  return (Store<AppState> store) async {
    debugPrint('toggleTodoStatus()');
    store.dispatch(Action.LoadingData);

    await http.patch('$baseUrl/todos/$id/toggle');

    debugPrint('dispatch(ToggleTodoAction)');
    store.dispatch(ToggleTodoAction(id));

    store.dispatch(Action.DataLoaded);

    if (completer != null) {
      completer.complete();
    }
  };
}

ThunkAction<AppState> deleteTodo(
    {@required Todo todo, Completer<Null> completer}) {
  return (Store<AppState> store) async {
    debugPrint('deleteTodo()');
    store.dispatch(Action.LoadingData);

    await http.delete('$baseUrl/todos/${todo.id}');

    debugPrint('dispatch(DeleteTodoAction)');
    store.dispatch(DeleteTodoAction(todo));

    store.dispatch(Action.DataLoaded);

    if (completer != null) {
      completer.complete();
    }
  };
}