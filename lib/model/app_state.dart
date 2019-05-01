import 'package:flutter/foundation.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/todo_filter.dart';

@immutable
class AppState {
  final bool loading;
  final bool error;
  final TodoFilter filter;
  final Todo editing;

  final int todoCount;
  final int completedTodoCount;
  final int pendingTodoCount;
  final List<Todo> todoList;

  AppState(
      {this.loading = false,
      this.error = false,
      this.filter = TodoFilter.SHOW_ALL,
      this.editing,
      this.todoCount = 0,
      this.completedTodoCount = 0,
      this.pendingTodoCount = 0,
      this.todoList = const <Todo>[]});

  AppState copyWith(
      {bool loading,
      bool error,
      TodoFilter filter,
      Todo editing,
      int todoCount,
      int completedTodoCount,
      int pendingTodoCount,
      List<Todo> todoList}) {
    return AppState(
        loading: loading ?? this.loading,
        error: error ?? this.error,
        filter: filter ?? this.filter,
        editing: editing,
        todoCount: todoCount ?? this.todoCount,
        completedTodoCount: completedTodoCount ?? this.completedTodoCount,
        pendingTodoCount: pendingTodoCount ?? this.pendingTodoCount,
        todoList: todoList ?? this.todoList);
  }
}
