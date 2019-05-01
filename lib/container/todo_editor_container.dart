import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/redux/actions.dart';
import 'package:todoappflutter/redux/selectors.dart';
import 'package:todoappflutter/redux/thunks.dart';

class _TodoEditorViewModel {
  final Todo editing;

  final Function() stopEditing;
  final Function(String description) createTodo;
  final Function(String description) updateTodo;

  bool get isEditing {
    return editing != null;
  }

  _TodoEditorViewModel(
      {this.editing, this.createTodo, this.updateTodo, this.stopEditing});

  factory _TodoEditorViewModel.fromStore(Store<AppState> store) {
    return _TodoEditorViewModel(
        editing: getTodoInEdit(store.state),
        createTodo: (String description) =>
            store.dispatch(createTodoAction(description: description)),
        updateTodo: (String description) =>
            store.dispatch(updateTodoAction(description: description)),
        stopEditing: () => store.dispatch(Action.STOP_EDITING));
  }
}

class TodoEditorContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _TodoEditorViewModel>(
        converter: (store) => _TodoEditorViewModel.fromStore(store),
        builder: (context, _viewModel) {
          return TodoEditorDialog(_viewModel);
        });
  }
}

class TodoEditorDialog extends StatefulWidget {
  final _TodoEditorViewModel _viewModel;

  TodoEditorDialog(this._viewModel);

  @override
  State<StatefulWidget> createState() => TodoEditorDialogState(_viewModel);
}

class TodoEditorDialogState extends State<TodoEditorDialog> {
  final _formKey = GlobalKey<FormState>();
  final _TodoEditorViewModel _viewModel;

  String _saveLabel;
  TextEditingController _controller = TextEditingController();

  TodoEditorDialogState(this._viewModel) {
    if (_viewModel.editing == null) {
      _saveLabel = 'ADICIONAR';
    } else {
      _saveLabel = 'SALVAR';
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.text =
        _viewModel.isEditing ? _viewModel.editing.description : '';
  }

  @override
  void dispose() {
    _controller.dispose();

    if (_viewModel.isEditing) {
      _viewModel.stopEditing();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new AlertDialog(
      title: Text(_viewModel.isEditing ? 'Editar Todo' : 'Criar Todo'),
      titlePadding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 0),
      contentPadding: const EdgeInsets.all(8.0),
      content: Row(
        children: <Widget>[
          Expanded(
            child: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Por favor, digite a descrição';
                    } else if (value.length > 150) {
                      return 'Use menos que 150 caracteres';
                    }
                  },
                  autofocus: true,
                  decoration: InputDecoration(
                      labelText: 'Descrição',
                      hintText: 'Qual a próxima tarefa?'),
                  controller: _controller,
                )),
          )
        ],
      ),
      actions: <Widget>[
        FlatButton(
            child: const Text('CANCELAR'),
            onPressed: () {
              Navigator.pop(context);

              _controller.clear();
            }),
        FlatButton(
            child: Text(_saveLabel),
            onPressed: () {
              if (_formKey.currentState.validate()) {
                if (_viewModel.isEditing) {
                  _viewModel.updateTodo(_controller.text);
                } else {
                  _viewModel.createTodo(_controller.text);
                }

                _controller.clear();

                Navigator.pop(context);
              }
            })
      ],
    );
  }
}
