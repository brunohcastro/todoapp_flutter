import 'package:redux/redux.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/view_model_dto.dart';
import 'package:todoappflutter/redux/actions.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, Action>(_rootReducer),
  TypedReducer<AppState, ToggleTodoAction>(_toggleTodoReducer),
  TypedReducer<AppState, LoadTodosAction>(_loadTodosReducer),
  TypedReducer<AppState, DeleteTodoAction>(_deleteTodoReducer)
]);

AppState _rootReducer(AppState state, Action action) {
  if (action == Action.LoadingData) {
    return state.copyWith(loading: true);
  } else if (action == Action.DataLoaded) {
    return state.copyWith(loading: false);
  }

  return state;
}

AppState _toggleTodoReducer(AppState state, ToggleTodoAction action) {
  Todo todo = action.todo;

  return state.copyWith(
      todos: state.todos
          .map((it) =>
              it.id == todo.id ? it.copyWith(completed: !it.completed) : it)
          .toList(),
      completedTodosCount: todo.completed
          ? state.completedTodosCount - 1
          : state.completedTodosCount + 1,
      pendingTodosCount: todo.completed
          ? state.pendingTodosCount + 1
          : state.pendingTodosCount - 1);
}

AppState _loadTodosReducer(AppState state, LoadTodosAction action) {
  ViewModelDTO viewModelDTO = action.viewModel;
  return state.copyWith(
      todoCount: viewModelDTO.todoCount,
      completedTodosCount: viewModelDTO.completedTodosCount,
      pendingTodosCount: viewModelDTO.pendingTodosCount,
      todos: viewModelDTO.todos);
}

AppState _deleteTodoReducer(AppState state, DeleteTodoAction action) {
  Todo todo = action.todo;

  return state.copyWith(
      todos: state.todos.where((it) => it.id != todo.id).toList(),
      todoCount: state.todoCount - 1,
      pendingTodosCount: todo.completed
          ? state.pendingTodosCount
          : state.pendingTodosCount - 1,
      completedTodosCount: todo.completed
          ? state.completedTodosCount - 1
          : state.completedTodosCount);
}
