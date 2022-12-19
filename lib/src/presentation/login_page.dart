import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:group_chat_app/src/actions/index.dart';
import 'package:group_chat_app/src/models/index.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  void _onResponse(dynamic action) {
    if (action is CreateUserError) {
      final Object error = action.error;
      if (error is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? error.code)));
      }
    } else if (action is LoginError) {
      final Object error = action.error;
      if (error is FirebaseAuthException) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message ?? error.code)));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text('Login or Register'),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(
                    labelText: 'E-mail address',
                  ),
                  validator: (String? value) {
                    if (value == null || !value.contains('@')) {
                      return 'Please enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _password,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                  ),
                  validator: (String? value) {
                    if (value == null || value.length < 6) {
                      return 'Please enter a password with at least 6 characters.';
                    }
                    return null;
                  },
                ),
                const Spacer(),
                Builder(
                  builder: (BuildContext context) {
                    return Row(
                      children: <Widget>[
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blueGrey),
                            onPressed: () {
                              if (!Form.of(context)!.validate()) {
                                return;
                              }
                              final Login loginUserAction =
                                  Login(email: _email.text, password: _password.text, response: _onResponse);
                              StoreProvider.of<AppState>(context).dispatch(loginUserAction);
                            },
                            child: const Text('Login'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                            onPressed: () {
                              if (!Form.of(context)!.validate()) {
                                return;
                              }
                              final CreateUser createUserAction =
                                  CreateUser(email: _email.text, password: _password.text, response: _onResponse);
                              StoreProvider.of<AppState>(context).dispatch(createUserAction);
                            },
                            child: const Text('Register'),
                          ),
                        ),
                      ],
                    );
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
