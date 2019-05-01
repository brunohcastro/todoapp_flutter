import 'package:todoappflutter/model/view_model.dart';
import 'package:todoappflutter/model/todo.dart';

enum Action {
  DeleteAllTodos,
  ToggleAllTodos,
  LoadingData,
  DataLoaded
}

class AddTodoAction {
  String _content;

  String get content => this._content;

  AddTodoAction(this._content);
}

class DeleteTodoAction {
  Todo _todo;

  Todo get todo => this._todo;

  DeleteTodoAction(this._todo);
}

class ToggleTodoAction {
  int _id;

  int get id => this._id;

  ToggleTodoAction(this._id);
}

class LoadTodosAction {
  ViewModel _viewModel;

  ViewModel get viewModel => this._viewModel;

  LoadTodosAction(this._viewModel);
}