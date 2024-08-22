// import 'dart:io';

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import '../home/home_screen.dart';
import '/services/api_access_service.dart';
import '/screens/widgets_partial_screen/custom_app_bar.dart';

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
      appBar: customAppBar("Login"),
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
                      style: Theme.of(context).textTheme.headlineSmall),
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
                      onPressed: () async {},
                      child: LoginButton(
                          style: style,
                          formKey: _formKey,
                          usernameController: usernameController,
                          passwordController: passwordController),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      drawer: const CustomDrawer(),
    );
  }
}

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.style,
    required GlobalKey<FormState> formKey,
    required this.usernameController,
    required this.passwordController,
  }) : _formKey = formKey;

  final ButtonStyle style;
  final GlobalKey<FormState> _formKey;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            if (await getUserToken(
              username: usernameController.value.text,
              password: passwordController.value.text,
            )) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const HomeScreen(),
                  ));
            }
          } on UserNotFindException {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('User or password error.')),
            );
          } on TimeoutException {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content:
                      Text('Time expired. Check your internet connection.\n')),
            );
          } on Exception {
            log("Error in Elevated Button");
          }
        }
      },
      child: const Text('Submit'),
    );
  }
}

Future<bool> getUserToken({
  required String username,
  required String password,
}) async {
  try {
    Map<String, dynamic>? response;
    response = await authService.xApi(
      apiUrl: "/api-token-auth/",
      method: 'post',
      body: {"username": username, "password": password},
    );
    log(response.toString());
    return true;
  } on UserNotFindException {
    rethrow;
  } catch (e) {
    log(e.toString());
    log("getUserToken");
    if (e.toString().contains("TimeoutException")) {
      throw TimeoutException("error");
    }
    return false;
  }
}
