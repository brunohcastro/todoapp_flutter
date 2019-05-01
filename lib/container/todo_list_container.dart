import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:redux/redux.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/view_model.dart';
import 'package:todoappflutter/redux/thunks.dart';

/// The contract between the TodoList and the Store
class TodoListStoreContract {
  ViewModel viewModel;

  Function(Completer completer) fetchTodos;
  Function(int id) toggleStatus;
  Function(Todo todo) delete;

  TodoListStoreContract(Store<AppState> store) {
    this.viewModel = store.state.viewModel;

    this.fetchTodos =
        (Completer completer) => store.dispatch(fetchAllTodos(completer));
    this.toggleStatus = (int id) => store.dispatch(toggleTodoStatus(id: id));
    this.delete = (Todo todo) => store.dispatch(deleteTodo(todo: todo));
  }
}

/// Manages the contract with the store.
class TodoListContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TodoListStoreContract>(
        converter: (store) => TodoListStoreContract(store),
        builder: (_, contract) => TodoList(contract));
  }
}

class TodoList extends StatelessWidget {
  final TodoListStoreContract contract;

  TodoList(this.contract);

  Future<Null> handleRefresh() {
    Completer<Null> completer = Completer<Null>();

    contract.fetchTodos(completer);
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
            itemCount: contract.viewModel.todoCount,
            itemBuilder: (context, position) => TodoListItem(
                contract.viewModel.todos[position],
                contract.toggleStatus,
                contract.delete)),
        onRefresh: handleRefresh);
  }
}

class TodoListItem extends StatelessWidget {
  final Todo item;
  final Function(int id) toggleStatus;
  final Function(Todo todo) delete;

  TodoListItem(this.item, this.toggleStatus, this.delete);

  @override
  Widget build(BuildContext context) {
    return Slidable(
      delegate: SlidableBehindDelegate(),
      child: Container(
          color: Colors.white,
          child: ListTile(
            title: Padding(
                padding: EdgeInsets.fromLTRB(0, 20.0, 0, 20.0),
                child: Text(
                  item.description,
                  style: TextStyle(
                      decoration: item.completed
                          ? TextDecoration.lineThrough
                          : TextDecoration.none,
                      color: item.completed ? Colors.grey : Colors.black87),
                )),
            leading: Checkbox(
                value: item.completed, onChanged: (_) => toggleStatus(item.id)),
          )),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: 'Deletar',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => delete(item),
        ),
      ],
    );
  }
}