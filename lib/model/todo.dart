import 'package:flutter/foundation.dart';

class Todo {
  final int id;
  final String description;
  final bool completed;

  const Todo(
      {@required this.id, @required this.description, this.completed = false});

  Todo copyWith({int id, String description, bool completed}) {
    return Todo(
        id: id ?? this.id,
        description: description ?? this.description,
        completed: completed ?? this.completed);
  }

  Todo.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        description = json['description'],
        completed = json['completed'];
}
