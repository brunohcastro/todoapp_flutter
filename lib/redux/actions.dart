import 'package:flutter/foundation.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/view_model_dto.dart';

enum Action {
  TODO_LIST_DELETED,
  COMPLETED_TODO_LIST_DELETED,
  TODO_LIST_TOGGLED,
  STOP_EDITING,
  LOADING_DATA,
  DATA_LOADED,
  LOADING_ERROR,
  RESET_ERROR,
  CLEAR_FILTER,
  TOGGLE_COMPLETED_FILTER,
  TOGGLE_PENDING_FILTER
}

@immutable
class TodoCreatedAction {
  final Todo todo;

  TodoCreatedAction(this.todo);
}

@immutable
class EditTodoAction {
  final Todo todo;

  EditTodoAction(this.todo);
}

@immutable
class TodoUpdatedAction {
  final int id;
  final String description;

  TodoUpdatedAction(this.id, this.description);
}

@immutable
class TodoDeletedAction {
  final Todo todo;

  TodoDeletedAction(this.todo);
}

@immutable
class TodoToggledAction {
  final Todo todo;

  TodoToggledAction(this.todo);
}

@immutable
class TodoListLoadedAction {
  final ViewModelDTO viewModelDTO;

  TodoListLoadedAction(this.viewModelDTO);
}
