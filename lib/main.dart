import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_chat_app/firebase_options.dart';
import 'package:group_chat_app/src/actions/index.dart';
import 'package:group_chat_app/src/data/auth_api.dart';
import 'package:group_chat_app/src/data/location_api.dart';
import 'package:group_chat_app/src/epics/app_epics.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:group_chat_app/src/presentation/chat_page.dart';
import 'package:group_chat_app/src/presentation/home.dart';
import 'package:group_chat_app/src/presentation/profile_page.dart';
import 'package:group_chat_app/src/reducer/reducer.dart';
import 'package:location/location.dart';
import 'package:redux/redux.dart';
import 'package:redux_epics/redux_epics.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding.instance.deferFirstFrame();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final AuthApi authApi = AuthApi(auth: FirebaseAuth.instance);
  final LocationApi locationApi = LocationApi(location: Location());
  final AppEpics epics = AppEpics(authApi: authApi, locationApi: locationApi);

  final StreamController<dynamic> controller = StreamController<dynamic>();

  final Store<AppState> store = Store<AppState>(
    reducer,
    initialState: const AppState(),
    middleware: <Middleware<AppState>>[
      EpicMiddleware<AppState>(epics.epic),
      (Store<AppState> store, dynamic action, NextDispatcher next) {
        next(action);
        controller.add(action);
      },
    ],
  )..dispatch(const InitializeUser());

  await controller.stream
      .where((dynamic action) =>
          action is InitializeUserSuccessful || action is InitializeUserError)
      .first;

  WidgetsBinding.instance.allowFirstFrame();
  runApp(GroupChatApp(store: store));
}

class GroupChatApp extends StatelessWidget {
  const GroupChatApp({super.key, required this.store});

  final Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: store,
      child: MaterialApp(
        title: 'Group Chat App',
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const Home(),
          '/chat': (BuildContext context) => const ChatPage(),
          '/profile': (BuildContext context) => const ProfilePage(),
        },
      ),
    );
  }
}
