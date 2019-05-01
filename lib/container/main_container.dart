import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:todoappflutter/component/loading_barrier.dart';
import 'package:todoappflutter/container/todo_editor_container.dart';
import 'package:todoappflutter/container/todo_list_container.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/model/todo_filter.dart';
import 'package:todoappflutter/redux/actions.dart';
import 'package:todoappflutter/redux/selectors.dart';
import 'package:todoappflutter/redux/thunks.dart';

class _MainContainerViewModel {
  final bool isLoading;
  final bool hasError;
  final bool hasTodo;
  final bool hasPending;
  final bool hasCompleted;

  final TodoFilter filter;

  final Function() deleteAll;
  final Function() deleteCompleted;
  final Function() toggleAll;

  final Function() toggleCompletedFilter;
  final Function() togglePendingFilter;

  _MainContainerViewModel(
      {this.isLoading,
      this.hasError,
      this.hasTodo,
      this.hasPending,
      this.hasCompleted,
      this.filter,
      this.deleteAll,
      this.deleteCompleted,
      this.toggleAll,
      this.toggleCompletedFilter,
      this.togglePendingFilter});

  factory _MainContainerViewModel.fromStore(Store<AppState> store) {
    return _MainContainerViewModel(
        isLoading: store.state.loading,
        hasError: store.state.error,
        hasTodo: hasAnyTodo(store.state),
        hasPending: hasPendingTodo(store.state),
        hasCompleted: hasCompletedTodo(store.state),
        filter: store.state.filter,
        deleteAll: () => store.dispatch(deleteTodoListAction()),
        deleteCompleted: () => store.dispatch(deleteCompletedTodoListAction()),
        toggleAll: () => store.dispatch(toggleTodoListAction()),
        toggleCompletedFilter: () =>
            store.dispatch(Action.TOGGLE_COMPLETED_FILTER),
        togglePendingFilter: () =>
            store.dispatch(Action.TOGGLE_PENDING_FILTER));
  }
}

class MainContainer extends StatelessWidget {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return new StoreConnector<AppState, _MainContainerViewModel>(
        converter: (store) => _MainContainerViewModel.fromStore(store),
        onInit: (store) => store.dispatch(loadTodoListAction()),
        onDidChange: (viewModel) {
          if (viewModel.hasError) {
            _scaffoldKey.currentState.showSnackBar(
                const SnackBar(content: Text('Erro ao carregar recurso')));
          }
        },
        builder: (context, _viewModel) {
          return Stack(
            children: <Widget>[
              Scaffold(
                  key: _scaffoldKey,
                  appBar: AppBar(
                    title: const Text('Todoing App'),
                    backgroundColor: Colors.white,
                    textTheme: const TextTheme(
                        title: TextStyle(
                            fontSize: 21,
                            fontWeight: FontWeight.w500,
                            color: Color.fromARGB(90, 0, 0, 0))),
                  ),
                  body: TodoListContainer(),
                  floatingActionButton: FloatingActionButton(
                    onPressed: () => _openTodoEditorDialog(context),
                    child: Icon(Icons.add),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.centerDocked,
                  resizeToAvoidBottomPadding: false,
                  bottomNavigationBar: AppFooter(_viewModel)),
              LoadingBarrier(_viewModel.isLoading)
            ],
          );
        });
  }
}

enum _AppFooterMenuKey {
  DIVIDER,
  DELETE_ALL,
  DELETE_COMPLETED,
  SHOW_PENDING,
  SHOW_COMPLETED,
  SHOW_ALL
}

class _AppFooterMenuOption {
  final _AppFooterMenuKey key;
  final IconData icon;
  final String text;
  final bool enabled;
  final bool selected;

  _AppFooterMenuOption(
      {this.key,
      this.icon,
      this.text,
      this.enabled = true,
      this.selected = false});
}

class AppFooter extends StatelessWidget {
  final _MainContainerViewModel _viewModel;

  final List<_AppFooterMenuOption> options;

  AppFooter(this._viewModel)
      : options = <_AppFooterMenuOption>[
          _AppFooterMenuOption(
              key: _AppFooterMenuKey.SHOW_PENDING,
              text: 'Filtrar pendentes',
              enabled: _viewModel.hasTodo,
              selected: _viewModel.filter == TodoFilter.SHOW_PENDING),
          _AppFooterMenuOption(
              key: _AppFooterMenuKey.SHOW_COMPLETED,
              text: 'Filtrar completos',
              enabled: _viewModel.hasTodo,
              selected: _viewModel.filter == TodoFilter.SHOW_COMPLETED),
          _AppFooterMenuOption(key: _AppFooterMenuKey.DIVIDER),
          _AppFooterMenuOption(
              key: _AppFooterMenuKey.DELETE_ALL,
              icon: Icons.delete_forever,
              text: 'Deletar todos',
              enabled: _viewModel.hasTodo),
          _AppFooterMenuOption(
              key: _AppFooterMenuKey.DELETE_COMPLETED,
              icon: Icons.clear_all,
              text: 'Deletar finalizados',
              enabled: _viewModel.hasCompleted)
        ];

  void _menuOptionSelected(_AppFooterMenuKey key) {
    switch (key) {
      case _AppFooterMenuKey.DELETE_ALL:
        _viewModel.deleteAll();
        break;
      case _AppFooterMenuKey.SHOW_COMPLETED:
        _viewModel.toggleCompletedFilter();
        break;
      case _AppFooterMenuKey.SHOW_PENDING:
        _viewModel.togglePendingFilter();
        break;
      case _AppFooterMenuKey.DELETE_COMPLETED:
        _viewModel.deleteCompleted();
        break;
      default:
        break;
    }
  }

  Widget _getItemIcon(_AppFooterMenuOption item) {
    if (item.icon == null) {
      if (item.selected) {
        return Icon(Icons.check, color: Colors.blue);
      } else {
        return Icon(Icons.check, color: Colors.black12);
      }
    } else {
      return Icon(item.icon, color: Colors.black87);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: CircularNotchedRectangle(),
      notchMargin: 6.0,
      child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              tooltip: 'Marcar todos',
              icon: Icon(
                Icons.done_all,
                color: _viewModel.hasPending == true
                    ? Colors.black87
                    : Colors.black12,
              ),
              onPressed: _viewModel.toggleAll,
            ),
            PopupMenuButton<_AppFooterMenuKey>(
                icon: Icon(Icons.menu),
                onSelected: _menuOptionSelected,
                itemBuilder: (context) => options.map((it) {
                      if (it.key == _AppFooterMenuKey.DIVIDER) {
                        return PopupMenuItem<_AppFooterMenuKey>(
                            child: PopupMenuDivider(height: 1));
                      } else {
                        return PopupMenuItem<_AppFooterMenuKey>(
                            value: it.key,
                            enabled: it.enabled,
                            child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [_getItemIcon(it), Text(it.text)]));
                      }
                    }).toList())
          ]),
    );
  }
}

_openTodoEditorDialog(BuildContext context) {
  showDialog(context: context, builder: (context) => TodoEditorContainer());
}
