import 'package:flutter/foundation.dart';
import 'package:todoappflutter/model/todo.dart';

@immutable
class ViewModel {
  final int todoCount;
  final int pendingTodosCount;
  final int completedTodosCount;

  final List<Todo> todos;

  ViewModel(
      {this.todoCount = 0,
      this.pendingTodosCount = 0,
      this.completedTodosCount = 0,
      this.todos = const <Todo>[]});

  ViewModel copyWith(
      {int todoCount,
      int pendingTodosCount,
      int completedTodosCount,
      List<Todo> todos}) {
    return ViewModel(
        todoCount: todoCount ?? this.todoCount,
        pendingTodosCount: pendingTodosCount ?? this.pendingTodosCount,
        completedTodosCount: completedTodosCount ?? this.completedTodosCount,
        todos: todos ?? this.todos);
  }

  factory ViewModel.fromJson(Map<String, dynamic> json) {
    var todoList = json['todos'] as List;

    List<Todo> todos = todoList.map((it) => Todo.fromJson(it)).toList();

    return ViewModel(
        todoCount: json['todoCount'],
        pendingTodosCount: json['pendingTodosCount'],
        completedTodosCount: json['completedTodosCount'],
        todos: todos);
  }
}
