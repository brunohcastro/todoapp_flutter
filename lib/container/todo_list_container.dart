import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:redux/redux.dart';
import 'package:todoappflutter/container/todo_editor_container.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/todo_filter.dart';
import 'package:todoappflutter/redux/actions.dart';
import 'package:todoappflutter/redux/selectors.dart';
import 'package:todoappflutter/redux/thunks.dart';

class _TodoListViewModel {
  final List<Todo> todoList;
  final int todoCount;
  final int completedTodoCount;
  final int pendingTodoCount;

  final Function(Completer completer) fetchTodoList;
  final Function(Todo todo) edit;
  final Function(Todo todo) toggleStatus;
  final Function(Todo todo) delete;

  _TodoListViewModel(
      {this.todoList,
      this.todoCount,
      this.completedTodoCount,
      this.pendingTodoCount,
      this.edit,
      this.fetchTodoList,
      this.toggleStatus,
      this.delete});

  factory _TodoListViewModel.fromStore(Store<AppState> store) {
    return _TodoListViewModel(
        todoList: getTodoList(store.state),
        todoCount: store.state.todoCount,
        completedTodoCount: store.state.completedTodoCount,
        pendingTodoCount: store.state.pendingTodoCount,
        edit: (Todo todo) => store.dispatch(EditTodoAction(todo)),
        fetchTodoList: (Completer completer) =>
            store.dispatch(loadTodoListAction(completer)),
        toggleStatus: (Todo todo) =>
            store.dispatch(toggleTodoAction(todo: todo)),
        delete: (Todo todo) => store.dispatch(deleteTodoAction(todo: todo)));
  }
}

/// Manages the contract with the store.
class TodoListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _TodoListViewModel>(
        converter: (store) => _TodoListViewModel.fromStore(store),
        builder: (_, contract) => TodoList(contract));
  }
}

class TodoList extends StatelessWidget {
  final _TodoListViewModel _viewModel;

  TodoList(this._viewModel);

  Future<Null> handleRefresh() {
    Completer<Null> completer = Completer<Null>();

    _viewModel.fetchTodoList(completer);
    return completer.future;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        backgroundColor: Colors.white,
        child: ListView.separated(
            separatorBuilder: (context, index) => Divider(
                  color: Colors.black12,
                  height: 1,
                ),
            itemCount: _viewModel.todoList.length,
            itemBuilder: (context, position) => TodoListItem(
                item: _viewModel.todoList[position],
                toggleStatus: _viewModel.toggleStatus,
                delete: _viewModel.delete,
                edit: _viewModel.edit)),
        onRefresh: handleRefresh);
  }
}

class TodoListItem extends StatelessWidget {
  final Todo item;
  final Function(Todo todo) toggleStatus;
  final Function(Todo todo) delete;
  final Function(Todo todo) edit;

  TodoListItem({this.item, this.toggleStatus, this.delete, this.edit});

  TextStyle _textStyle() {
    if (item.completed == true) {
      return TextStyle(
          decoration: TextDecoration.lineThrough, color: Colors.grey);
    } else {
      return TextStyle(decoration: TextDecoration.none, color: Colors.black87);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Slidable(
      delegate: const SlidableBehindDelegate(),
      child: Container(
          color: Colors.white,
          padding: const EdgeInsets.fromLTRB(0, 10.0, 0, 10.0),
          child: ListTile(
            title: Text(
              item.description,
              style: _textStyle(),
            ),
            onTap: () => toggleStatus(item),
            leading: Checkbox(
              value: item.completed,
              onChanged: (_) => toggleStatus(item),
            ),
          )),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Deletar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => delete(item),
        ),
      ],
      actions: <Widget>[
        IconSlideAction(
          caption: 'Editar',
          color: Colors.blue,
          icon: Icons.edit,
          onTap: () {
            edit(item);
            showDialog(
                context: context, builder: (context) => TodoEditorContainer());
          },
        ),
      ],
    );
  }
}
