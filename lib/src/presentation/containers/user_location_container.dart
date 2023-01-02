import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:redux/redux.dart';

class UserLocationsContainer extends StatelessWidget {
  const UserLocationsContainer({super.key, required this.builder});

  final ViewModelBuilder<List<UserLocation>> builder;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, List<UserLocation>>(
      converter: (Store<AppState> store) => store.state.location.locations,
      builder: builder,
    );
  }
}
