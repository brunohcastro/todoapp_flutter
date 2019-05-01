import 'package:redux/redux.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/view_model.dart';
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
  ViewModel viewModel = state.viewModel;
  Todo todo = action.todo;

  return state.copyWith(
      viewModel: state.viewModel.copyWith(
          todos: viewModel.todos
              .map((it) =>
                  it.id == todo.id ? it.copyWith(completed: !it.completed) : it)
              .toList(),
          completedTodosCount: todo.completed
              ? viewModel.completedTodosCount - 1
              : viewModel.completedTodosCount + 1,
          pendingTodosCount: todo.completed
              ? viewModel.pendingTodosCount + 1
              : viewModel.pendingTodosCount - 1));
}

AppState _loadTodosReducer(AppState state, LoadTodosAction action) {
  return state.copyWith(viewModel: action.viewModel);
}

AppState _deleteTodoReducer(AppState state, DeleteTodoAction action) {
  ViewModel viewModel = state.viewModel;
  Todo todo = action.todo;

  return state.copyWith(
    viewModel: state.viewModel.copyWith(
        todos: viewModel.todos.where((it) => it.id != todo.id).toList(),
        todoCount: viewModel.todoCount - 1,
        pendingTodosCount: todo.completed
            ? viewModel.pendingTodosCount
            : viewModel.pendingTodosCount - 1,
        completedTodosCount: todo.completed
            ? viewModel.completedTodosCount - 1
            : viewModel.completedTodosCount),
  );
}
