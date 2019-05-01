import 'package:flutter/foundation.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/view_model.dart';

enum Action { DeleteAllTodos, ToggleAllTodos, LoadingData, DataLoaded }

@immutable
class AddTodoAction {
  final String _content;

  String get content => this._content;

  AddTodoAction(this._content);
}

@immutable
class DeleteTodoAction {
  final Todo _todo;

  Todo get todo => this._todo;

  DeleteTodoAction(this._todo);
}

@immutable
class ToggleTodoAction {
  final Todo _todo;

  Todo get todo => this._todo;

  ToggleTodoAction(this._todo);
}

@immutable
class LoadTodosAction {
  final ViewModel _viewModel;

  ViewModel get viewModel => this._viewModel;

  LoadTodosAction(this._viewModel);
}
