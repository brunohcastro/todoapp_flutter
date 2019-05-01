import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todoappflutter/component/loading_barrier.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/redux/thunks.dart';
import 'package:todoappflutter/container/todo_list_container.dart';

class MainContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, AppState>(
        converter: (store) => store.state,
        onInit: (store) => store.dispatch(fetchAllTodos()),
        builder: (context, state) {
          return Scaffold(
              appBar: new AppBar(
                title: new Text('Todoing App'),
                backgroundColor: Colors.white,
                textTheme: TextTheme(
                    title: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w500,
                        color: Color.fromARGB(90, 0, 0, 0))),
              ),
              body: Stack(
                children: <Widget>[
                  TodoListContainer(),
                  LoadingBarrier(state.loading)
                ],
              ),
              floatingActionButton: new FloatingActionButton(
                onPressed: () => _openAddItemDialog(context),
                child: Icon(Icons.add),
              ));
        });
  }
}

_openAddItemDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => Text('Testing'));
}
