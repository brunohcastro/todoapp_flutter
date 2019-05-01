import 'package:flutter/foundation.dart';

@immutable
class Todo {
  final int id;
  final String description;
  final bool completed;

  const Todo({this.id, @required this.description, this.completed = false});

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

  Map<String, dynamic> toJson() =>
      {'id': id, 'description': description, 'completed': completed};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Todo && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Todo{id: $id, description: $description, completed: $completed}';
  }
}
