import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_chat_app/src/actions/index.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:group_chat_app/src/presentation/containers/user_container.dart';
import 'package:group_chat_app/src/presentation/containers/user_location_container.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    StoreProvider.of<AppState>(context, listen: false).dispatch(const GetLocation());
  }

  @override
  Widget build(BuildContext context) {
    return UserLocationContainer(
      builder: (BuildContext context, UserLocation? location) {
        return UserContainer(
          builder: (BuildContext context, AppUser? user) {
            return Scaffold(
              appBar: AppBar(
                title: Text("${user!.displayName}'s Profile"),
                actions: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed('/profile');
                    },
                    icon: const Icon(Icons.account_circle_rounded),
                  ),
                  IconButton(
                    onPressed: () {
                      StoreProvider.of<AppState>(context).dispatch(const Logout());
                    },
                    icon: const Icon(Icons.logout_rounded),
                  ),
                ],
              ),
              body: Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).size.width,
                      width: MediaQuery.of(context).size.width,
                      child: user.imageUrl == null
                          ? const SizedBox.shrink()
                          : Image.network(
                              user.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Your location is $location',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
