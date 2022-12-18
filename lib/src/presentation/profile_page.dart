import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_chat_app/src/actions/index.dart';
import 'package:group_chat_app/src/models/index.dart';
import 'package:group_chat_app/src/presentation/containers/user_container.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _image = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
    _image.dispose();
    _password.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return UserContainer(
      builder: (BuildContext context, AppUser? user) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('My Profile'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Center(
                    child: Text(
                      'Hello, ${user!.displayName}',
                      style: const TextStyle(
                        fontSize: 26,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: user.imageUrl == null
                        ? const SizedBox.shrink()
                        : Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border.all(width: 10),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.network(
                              user.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _name,
                    decoration: const InputDecoration(
                      labelText: 'Name',
                    ),
                    validator: (String? value) {
                      if (value == null || value.length < 3) {
                        return 'Your name must be at least 3 characters.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _image,
                    decoration: const InputDecoration(
                      labelText: 'Avatar URL',
                    ),
                  ),
                  TextFormField(
                    controller: _password,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'New Password',
                    ),
                    validator: (String? value) {
                      if (value == null || value.length < 6) {
                        return 'Please enter a password with at least 6 characters.';
                      }
                      return null;
                    },
                  ),
                  Builder(
                    builder: (BuildContext context) {
                      return Row(
                        children: <Widget>[
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                              onPressed: () {
                                final UpdateUsername nameAction = UpdateUsername(name: _name.text);
                                final UpdatePhoto photoAction = UpdatePhoto(url: _image.text);
                                final UpdatePassword passwordAction = UpdatePassword(password: _password.text);
                                StoreProvider.of<AppState>(context).dispatch(nameAction);
                                StoreProvider.of<AppState>(context).dispatch(photoAction);
                                StoreProvider.of<AppState>(context).dispatch(passwordAction);
                              },
                              child: const Text(
                                'Save',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
