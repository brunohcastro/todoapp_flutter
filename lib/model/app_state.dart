import 'package:todoappflutter/model/view_model.dart';
import 'package:todoappflutter/model/todo.dart';
import 'package:todoappflutter/model/todo_filter.dart';
import 'package:flutter/foundation.dart';

@immutable
class AppState {
  final bool loading;
  final TodoFilter filter;
  final Todo editing;
  final ViewModel viewModel;

  AppState({
    this.loading,
    this.filter = TodoFilter.SHOW_ALL,
    this.editing,
    ViewModel viewModel
  }) : this.viewModel = viewModel ?? ViewModel();

  AppState copyWith(
      {bool loading,
      TodoFilter filter,
      Todo editing,
      ViewModel viewModel}) {

        return AppState(
          loading: loading ?? this.loading,
          filter: filter ?? this.filter,
          editing: editing ?? this.editing,
          viewModel: viewModel ?? this.viewModel
        );

      }
}
