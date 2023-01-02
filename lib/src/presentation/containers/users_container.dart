import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:redux/redux.dart';

class UsersContainer extends StatelessWidget {
  const UsersContainer({super.key, required this.builder});

  final ViewModelBuilder<List<AppUser>> builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<AppUser>>(
      converter: (Store<AppState> store) => store.state.auth.users,
      builder: builder,
    );
  }
}
