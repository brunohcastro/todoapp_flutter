import 'package:flutter/foundation.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/todo_filter.dart';

@immutable
class AppState {
  final bool loading;
  final TodoFilter filter;
  final Todo editing;

  final int todoCount;
  final int completedTodosCount;
  final int pendingTodosCount;
  final List<Todo> todos;

  AppState(
      {this.loading = false,
      this.filter = TodoFilter.SHOW_ALL,
      this.editing,
      this.todoCount = 0,
      this.completedTodosCount = 0,
      this.pendingTodosCount = 0,
      this.todos = const <Todo>[]});

  AppState copyWith(
      {bool loading,
      TodoFilter filter,
      Todo editing,
      int todoCount,
      int completedTodosCount,
      int pendingTodosCount,
      List<Todo> todos}) {
    return AppState(
        loading: loading ?? this.loading,
        filter: filter ?? this.filter,
        editing: editing ?? this.editing,
        todoCount: todoCount ?? this.todoCount,
        completedTodosCount: completedTodosCount ?? this.completedTodosCount,
        pendingTodosCount: pendingTodosCount ?? this.pendingTodosCount,
        todos: todos ?? this.todos);
  }
}
