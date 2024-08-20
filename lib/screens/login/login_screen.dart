// import 'dart:io';

import 'dart:developer';

import 'package:flutter/material.dart';
import '/services/api_access_service.dart';
import '/services/authentication_service.dart';

final AuthService authService = AuthService();

// class LoginInformation {
//   final String username;
//   final String password;
//
//   LoginInformation(this.username, this.password);
// }

class LoginScreen extends StatefulWidget {
  //
  // final ValueChanged<LoginInformation> onLogin;

  const LoginScreen({
    // required this.onLogin,
    super.key,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  DateTime currentDay = DateTime.now();

  @override
  void initState() {
    // refresh();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "${currentDay.day}  |  ${currentDay.month}  |  ${currentDay.year}",
        ),
        actions: [
          IconButton(
            onPressed: () {
              // refresh();
            },
            icon: const Icon(
              Icons.refresh,
            ),
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Center(
          child: Card(
            child: Container(
              constraints: BoxConstraints.loose(const Size(600, 600)),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Login',
                      style: Theme.of(context).textTheme.headlineMedium),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Username'),
                    controller: usernameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Password'),
                    obscureText: true,
                    controller: passwordController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: TextButton(
                      onPressed: () async {
                        // widget.onLogin(
                        //   LoginInformation(
                        //     usernameController.value.text,
                        //     passwordController.value.text,
                        //   ),
                        // );
                      },
                      child: ElevatedButton(
                        style: style,
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await getToken(
                              username: usernameController.value.text,
                              password: passwordController.value.text,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Please fill input')),
                            );
                          }
                        },

                        child: const Text('Login'),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Logout"),
              onTap: () {
                logout();
              },
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text("Home"),
              onTap: () {
                Navigator.pushReplacementNamed(context, 'home');
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> getToken({
    required String username,
    required String password,
  }) async {

    String userToken;

    // Read tokens: refresh e access.
    Map<String, dynamic> token = await readTokens(
      user: username,
      password: password,
    );

    userToken = token['token'];
    log(userToken);
  }
}

Future<Map<String, dynamic>> readTokens({
  required String user,
  required String password,
}) async {
  Map<String, dynamic> response = await authService.xApi(
    apiUrl: "/api-token-auth/",
    method: 'post',
    body: {"username": user, "password": password},
  );

  if (response.containsKey("Error")) {
    //TODO: Create the treatment.
    // exit(0);
  }
  return response;
}
