import 'package:group_chat_app/src/actions/index.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:redux/redux.dart';

Reducer<AuthState> authReducer = combineReducers(<Reducer<AuthState>>[
  TypedReducer<AuthState, CreateUserSuccessful>(_createUserSuccessful),
  TypedReducer<AuthState, LoginSuccessful>(_loginSuccessful),
  TypedReducer<AuthState, InitializeUserSuccessful>(_initializeUserSuccessful),
  TypedReducer<AuthState, UpdateUsernameSuccessful>(_updateUsernameSuccessful),
  TypedReducer<AuthState, UpdatePhotoSuccessful>(_updatePhotoSuccessful),
]);

AuthState _createUserSuccessful(AuthState state, CreateUserSuccessful action) {
  return state.copyWith(
    user: action.user,
  );
}

AuthState _loginSuccessful(AuthState state, LoginSuccessful action) {
  return state.copyWith(
    user: action.user,
  );
}

AuthState _initializeUserSuccessful(AuthState state, InitializeUserSuccessful action) {
  return state.copyWith(
    user: action.user,
  );
}

AuthState _updateUsernameSuccessful(AuthState state, UpdateUsernameSuccessful action) {
  return state.copyWith(
    user: action.user,
  );
}

AuthState _updatePhotoSuccessful(AuthState state, UpdatePhotoSuccessful action) {
  return state.copyWith(
    user: action.user,
  );
}
