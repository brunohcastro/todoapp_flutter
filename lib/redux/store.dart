import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:todoappflutter/model/app_state.dart';
import 'package:todoappflutter/redux/reducers.dart';

Store<AppState> createStore() {
  return Store<AppState>(appReducer,
      initialState: AppState(), middleware: [thunkMiddleware]);
}
