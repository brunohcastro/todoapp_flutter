import 'package:flutter/foundation.dart';
import 'package:todoappflutter/model/todo.dart';

@immutable
class ViewModelDTO {
  final int todoCount;
  final int pendingTodoCount;
  final int completedTodoCount;

  final List<Todo> todos;

  ViewModelDTO(
      {this.todoCount = 0,
      this.pendingTodoCount = 0,
      this.completedTodoCount = 0,
      this.todos = const <Todo>[]});

  ViewModelDTO copyWith(
      {int todoCount,
      int pendingTodoCount,
      int completedTodoCount,
      List<Todo> todoList}) {
    return ViewModelDTO(
        todoCount: todoCount ?? this.todoCount,
        pendingTodoCount: pendingTodoCount ?? this.pendingTodoCount,
        completedTodoCount: completedTodoCount ?? this.completedTodoCount,
        todos: todoList ?? this.todos);
  }

  factory ViewModelDTO.fromJson(Map<String, dynamic> json) {
    var todoList = json['todos'] as List;

    List<Todo> todos = todoList.map((it) => Todo.fromJson(it)).toList();

    return ViewModelDTO(
        todoCount: json['todoCount'],
        pendingTodoCount: json['pendingTodosCount'],
        completedTodoCount: json['completedTodosCount'],
        todos: todos);
  }
}
