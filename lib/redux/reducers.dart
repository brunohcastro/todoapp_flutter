import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/view_model.dart';
import 'package:todoappflutter/redux/actions.dart';

AppState appReducer(AppState state, dynamic action) {
  if (action is LoadTodosAction) {
    return state.copyWith(viewModel: action.viewModel);
  } else if (action is ToggleTodoAction) {
    List<Todo> todos = state.viewModel.todos;

    return state.copyWith(
        viewModel: state.viewModel.copyWith(
            todos: todos
                .map((it) => it.id == action.id
                    ? it.copyWith(completed: !it.completed)
                    : it)
                .toList()));
  } else if (action == Action.LoadingData) {
    return state.copyWith(loading: true);
  } else if (action == Action.DataLoaded) {
    return state.copyWith(loading: false);
  } else if (action is DeleteTodoAction) {
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

  return state;
}
