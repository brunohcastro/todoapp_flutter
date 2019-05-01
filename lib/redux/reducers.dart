import 'package:redux/redux.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/todo_filter.dart';
import 'package:todoappflutter/model/view_model_dto.dart';
import 'package:todoappflutter/redux/actions.dart';

final appReducer = combineReducers<AppState>([
  TypedReducer<AppState, Action>(_rootReducer),
  TypedReducer<AppState, EditTodoAction>(_editTodoReducer),
  TypedReducer<AppState, TodoListLoadedAction>(_todoListLoadedReducer),
  TypedReducer<AppState, TodoCreatedAction>(_todoCreatedReducer),
  TypedReducer<AppState, TodoUpdatedAction>(_todoUpdatedReducer),
  TypedReducer<AppState, TodoToggledAction>(_todoToggledReducer),
  TypedReducer<AppState, TodoDeletedAction>(_todoDeletedReducer)
]);

AppState _rootReducer(AppState state, Action action) {
  switch (action) {
    case Action.LOADING_DATA:
      return state.copyWith(loading: true);
    case Action.DATA_LOADED:
      return state.copyWith(loading: false);
    case Action.LOADING_ERROR:
      return state.copyWith(error: true, loading: false);
    case Action.RESET_ERROR:
      return state.copyWith(error: false);
    case Action.TOGGLE_COMPLETED_FILTER:
      if (state.filter == TodoFilter.SHOW_COMPLETED) {
        return state.copyWith(filter: TodoFilter.SHOW_ALL);
      }

      return state.copyWith(filter: TodoFilter.SHOW_COMPLETED);
    case Action.TOGGLE_PENDING_FILTER:
      if (state.filter == TodoFilter.SHOW_PENDING) {
        return state.copyWith(filter: TodoFilter.SHOW_ALL);
      }

      return state.copyWith(filter: TodoFilter.SHOW_PENDING);
    case Action.CLEAR_FILTER:
      return state.copyWith(filter: TodoFilter.SHOW_ALL);
    case Action.TODO_LIST_DELETED:
      return state.copyWith(
          todoList: const <Todo>[],
          todoCount: 0,
          pendingTodoCount: 0,
          completedTodoCount: 0);
    case Action.COMPLETED_TODO_LIST_DELETED:
      return state.copyWith(
          todoList: state.todoList.where((it) => !it.completed).toList(),
          todoCount: state.todoCount - state.completedTodoCount,
          completedTodoCount: 0);
    case Action.TODO_LIST_TOGGLED:
      if (state.completedTodoCount != state.todoCount) {
        return state.copyWith(
            completedTodoCount: state.todoCount,
            pendingTodoCount: 0,
            todoList: state.todoList
                .map((it) => it.copyWith(completed: true))
                .toList());
      } else {
        return state.copyWith(
            pendingTodoCount: state.todoCount,
            completedTodoCount: 0,
            todoList: state.todoList
                .map((it) => it.copyWith(completed: false))
                .toList());
      }
      break;
    case Action.STOP_EDITING:
      return state.copyWith(editing: null);
    default:
      return state;
  }
}

AppState _todoListLoadedReducer(AppState state, TodoListLoadedAction action) {
  ViewModelDTO viewModelDTO = action.viewModelDTO;
  return state.copyWith(
      todoCount: viewModelDTO.todoCount,
      completedTodoCount: viewModelDTO.completedTodoCount,
      pendingTodoCount: viewModelDTO.pendingTodoCount,
      todoList: viewModelDTO.todos);
}

AppState _todoCreatedReducer(AppState state, TodoCreatedAction action) {
  return state.copyWith(
      todoList: List.from(state.todoList)..add(action.todo),
      todoCount: state.todoCount + 1,
      pendingTodoCount: state.pendingTodoCount + 1);
}

AppState _editTodoReducer(AppState state, EditTodoAction action) {
  return state.copyWith(editing: action.todo);
}

AppState _todoUpdatedReducer(AppState state, TodoUpdatedAction action) {
  return state.copyWith(
      todoList: state.todoList
          .map((it) => it.id == action.id
              ? it.copyWith(description: action.description)
              : it)
          .toList(),
      editing: null);
}

AppState _todoToggledReducer(AppState state, TodoToggledAction action) {
  Todo todo = action.todo;

  return state.copyWith(
      todoList: state.todoList
          .map((it) =>
              it.id == todo.id ? it.copyWith(completed: !it.completed) : it)
          .toList(),
      completedTodoCount: todo.completed
          ? state.completedTodoCount - 1
          : state.completedTodoCount + 1,
      pendingTodoCount: todo.completed
          ? state.pendingTodoCount + 1
          : state.pendingTodoCount - 1);
}

AppState _todoDeletedReducer(AppState state, TodoDeletedAction action) {
  Todo todo = action.todo;

  return state.copyWith(
      todoList: state.todoList.where((it) => it.id != todo.id).toList(),
      todoCount: state.todoCount - 1,
      pendingTodoCount:
          todo.completed ? state.pendingTodoCount : state.pendingTodoCount - 1,
      completedTodoCount: todo.completed
          ? state.completedTodoCount - 1
          : state.completedTodoCount);
}
