import 'package:group_chat_app/src/actions/index.dart';
import 'package:group_chat_app/src/data/auth_api.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:redux_epics/redux_epics.dart';
import 'package:rxdart/transformers.dart';

class AuthEpics {
  const AuthEpics(this._api);

  final AuthApi _api;

  Epic<AppState> get epic {
    return combineEpics(<Epic<AppState>>[
      TypedEpic<AppState, CreateUserStart>(_createUserStart),
      TypedEpic<AppState, LoginStart>(_loginStart),
      TypedEpic<AppState, LogoutStart>(_logoutStart),
      TypedEpic<AppState, InitializeUserStart>(_initializeUserStart),
      TypedEpic<AppState, UpdateUsernameStart>(_updateUsernameStart),
      TypedEpic<AppState, UpdatePhotoStart>(_updatePhotoStart),
      TypedEpic<AppState, UpdatePasswordStart>(_updatePasswordStart),
    ]);
  }

  Stream<dynamic> _createUserStart(Stream<CreateUserStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((CreateUserStart action) {
      return Stream<void>.value(null) //
          .asyncMap((_) => _api.createUser(email: action.email, password: action.password))
          .map((AppUser user) => CreateUser.successful(user))
          .onErrorReturnWith((Object error, StackTrace stackTrace) => CreateUser.error(error, stackTrace))
          .doOnData(action.response);
    });
  }

  Stream<dynamic> _loginStart(Stream<LoginStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((LoginStart action) {
      return Stream<void>.value(null) //
          .asyncMap((_) => _api.login(email: action.email, password: action.password))
          .map((AppUser user) => Login.successful(user))
          .onErrorReturnWith((Object error, StackTrace stackTrace) => Login.error(error, stackTrace))
          .doOnData(action.response);
    });
  }

  Stream<dynamic> _logoutStart(Stream<LogoutStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((LogoutStart action) {
      return Stream<void>.value(null) //
          .asyncMap((_) => _api.logout())
          .map((_) => const Logout.successful())
          .onErrorReturnWith((Object error, StackTrace stackTrace) => Logout.error(error, stackTrace));
    });
  }

  Stream<dynamic> listenForUsersStart(Stream<dynamic> actions, EpicStore<AppState> store) {
    return actions.whereType<ListenForUsersStart>().flatMap((ListenForUsersStart action) {
      return Stream<void>.value(null) //
          .flatMap((_) => _api.getUsers())
          .map((List<AppUser> users) => ListenForUsers.event(users))
          .takeUntil(actions.whereType<ListenForUsersDone>())
          .onErrorReturnWith((Object error, StackTrace stackTrace) => ListenForUsers.error(error, stackTrace));
    });
  }

  Stream<void> _initializeUserStart(Stream<InitializeUserStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((InitializeUser action) {
      return Stream<void>.value(null) //
          .asyncMap((_) => _api.getUser())
          .map((AppUser? user) => InitializeUser.successful(user))
          .onErrorReturnWith((Object error, StackTrace stackTrace) => InitializeUser.error(error, stackTrace));
    });
  }

  Stream<dynamic> _updateUsernameStart(Stream<UpdateUsernameStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((UpdateUsernameStart action) {
      return Stream<void>.value(null) //
          .asyncMap((_) => _api.updateName(name: action.name))
          .map((AppUser user) => UpdateUsername.successful(user))
          .onErrorReturnWith((Object error, StackTrace stackTrace) => UpdateUsername.error(error, stackTrace));
    });
  }

  Stream<dynamic> _updatePhotoStart(Stream<UpdatePhotoStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((UpdatePhotoStart action) {
      return Stream<void>.value(null) //
          .asyncMap((_) => _api.updatePhoto(url: action.url))
          .map((AppUser user) => UpdatePhoto.successful(user))
          .onErrorReturnWith((Object error, StackTrace stackTrace) => UpdatePhoto.error(error, stackTrace));
    });
  }

  Stream<dynamic> _updatePasswordStart(Stream<UpdatePasswordStart> actions, EpicStore<AppState> store) {
    return actions.flatMap((UpdatePasswordStart action) {
      return Stream<void>.value(null) //
          .asyncMap((_) => _api.updatePassword(password: action.password))
          .map((_) => const UpdatePassword.successful())
          .onErrorReturnWith((Object error, StackTrace stackTrace) => UpdatePassword.error(error, stackTrace));
    });
  }
}
