import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/view_model_dto.dart';
import 'package:todoappflutter/redux/actions.dart';

const String baseUrl = 'https://todoing-app.herokuapp.com/api';

const Map<String, String> headers = {
  'Content-type': 'application/json',
  'Accept': 'application/json',
};

ThunkAction<AppState> loadTodoListAction([Completer<Null> completer]) {
  return (Store<AppState> store) async {
    debugPrint('loadTodoListAction()');

    if (completer == null) {
      store.dispatch(Action.LOADING_DATA);
    }

    try {
      http.Response response = await http.get('$baseUrl/todos');

      dynamic result = json.decode(response.body);

      debugPrint('dispatch(TodoListLoadedAction)');
      store.dispatch(TodoListLoadedAction(ViewModelDTO.fromJson(result)));
      if (completer == null) {
        store.dispatch(Action.DATA_LOADED);
      }
    } catch (_) {
      _triggerResetableError(store);
    } finally {
      if (completer != null) {
        completer.complete();
      }
    }
  };
}

ThunkAction<AppState> createTodoAction(
    {@required String description, Completer<Null> completer}) {
  return (Store<AppState> store) async {
    debugPrint('createTodoAction()');

    if (completer == null) {
      store.dispatch(Action.LOADING_DATA);
    }

    try {
      var data = json.encode(Todo(description: description).toJson());

      http.Response response =
          await http.post('$baseUrl/todos', body: data, headers: headers);

      dynamic result = json.decode(response.body);

      debugPrint('dispatch(TodoCreatedAction)');
      store.dispatch(TodoCreatedAction(Todo.fromJson(result)));

      if (completer == null) {
        store.dispatch(Action.DATA_LOADED);
      }
    } catch (_) {
      _triggerResetableError(store);
    } finally {
      if (completer != null) {
        completer.complete();
      }
    }
  };
}

ThunkAction<AppState> updateTodoAction(
    {int id, @required String description, Completer<Null> completer}) {
  return (Store<AppState> store) async {
    debugPrint('editTodo()');

    Todo editing = store.state.editing;

    if (id == null && editing != null) {
      id = editing.id;
    }

    if (completer == null) {
      store.dispatch(Action.LOADING_DATA);
    }

    var data = json.encode({'description': description});

    try {
      await http.patch('$baseUrl/todos/$id', body: data, headers: headers);

      debugPrint('dispatch(TodoUpdatedAction)');

      store.dispatch(TodoUpdatedAction(id, description));

      if (completer == null) {
        store.dispatch(Action.DATA_LOADED);
      }
    } catch (_) {
      _triggerResetableError(store);
    } finally {
      if (completer != null) {
        completer.complete();
      }
    }
  };
}

ThunkAction<AppState> toggleTodoAction(
    {@required Todo todo, Completer<Null> completer}) {
  return (Store<AppState> store) async {
    debugPrint('toggleTodoStatus()');
    store.dispatch(Action.LOADING_DATA);

    try {
      await http.patch('$baseUrl/todos/${todo.id}/toggle');

      debugPrint('dispatch(TodoToggledAction)');
      store.dispatch(TodoToggledAction(todo));

      store.dispatch(Action.DATA_LOADED);
    } catch (_) {
      _triggerResetableError(store);
    } finally {
      if (completer != null) {
        completer.complete();
      }
    }
  };
}

ThunkAction<AppState> deleteTodoAction(
    {@required Todo todo, Completer<Null> completer}) {
  return (Store<AppState> store) async {
    debugPrint('deleteTodo()');
    store.dispatch(Action.LOADING_DATA);

    try {
      await http.delete('$baseUrl/todos/${todo.id}');

      debugPrint('dispatch(TodoDeletedAction)');
      store.dispatch(TodoDeletedAction(todo));

      store.dispatch(Action.DATA_LOADED);
    } catch (_) {
      _triggerResetableError(store);
    } finally {
      if (completer != null) {
        completer.complete();
      }
    }
  };
}

ThunkAction<AppState> deleteTodoListAction({Completer<Null> completer}) {
  return (Store<AppState> store) async {
    debugPrint('deleteTodoList()');
    store.dispatch(Action.LOADING_DATA);

    try {
      await http.delete('$baseUrl/todos');

      debugPrint('dispatch(Action.TodoListDeleted)');
      store.dispatch(Action.TODO_LIST_DELETED);

      store.dispatch(Action.DATA_LOADED);
    } catch (_) {
      _triggerResetableError(store);
    } finally {
      if (completer != null) {
        completer.complete();
      }
    }
  };
}

ThunkAction<AppState> deleteCompletedTodoListAction(
    {Completer<Null> completer}) {
  return (Store<AppState> store) async {
    debugPrint('deleteCompletedTodoAction()');
    store.dispatch(Action.LOADING_DATA);

    try {
      await http.delete('$baseUrl/todos/completed');

      debugPrint('dispatch(Action.CompletedTodoListDeleted)');
      store.dispatch(Action.COMPLETED_TODO_LIST_DELETED);

      store.dispatch(Action.DATA_LOADED);
    } catch (_) {
      _triggerResetableError(store);
    } finally {
      if (completer != null) {
        completer.complete();
      }
    }
  };
}

ThunkAction<AppState> toggleTodoListAction({Completer<Null> completer}) {
  return (Store<AppState> store) async {
    debugPrint('toggleTodoList()');
    store.dispatch(Action.LOADING_DATA);

    try {
      await http.patch('$baseUrl/todos/toggle-all');

      debugPrint('dispatch(Action.TodoListToggled)');
      store.dispatch(Action.TODO_LIST_TOGGLED);

      store.dispatch(Action.DATA_LOADED);
    } catch (_) {
      _triggerResetableError(store);
    } finally {
      if (completer != null) {
        completer.complete();
      }
    }
  };
}

void _triggerResetableError(store) {
  store.dispatch(Action.LOADING_ERROR);
  Future.delayed(Duration(seconds: 5), () {
    store.dispatch(Action.RESET_ERROR);
  });
}
