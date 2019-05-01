import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/todo_filter.dart';

List<Todo> getTodoList(AppState state) {
  if (state.filter == TodoFilter.SHOW_ALL) {
    return state.todoList;
  } else if (state.filter == TodoFilter.SHOW_COMPLETED) {
    return state.todoList.where((it) => it.completed == true).toList();
  } else if (state.filter == TodoFilter.SHOW_PENDING) {
    return state.todoList.where((it) => it.completed == false).toList();
  }

  return <Todo>[];
}

bool isEditing(AppState state) {
  return state.editing != null;
}

Todo getTodoInEdit(AppState state) {
  return state.editing;
}

bool hasAnyTodo(AppState state) {
  return state.todoCount != 0;
}

bool hasPendingTodo(AppState state) {
  return state.todoCount != 0 && state.todoCount == state.completedTodoCount;
}

bool hasCompletedTodo(AppState state) {
  return state.completedTodoCount != 0;
}
