// import 'dart:io';

import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';

import '/screens/login/login_screen.dart';
// import '../home/home_screen.dart';
import '/services/api_access_service.dart';
import '/screens/widgets_partial_screen/custom_app_bar.dart';

final AuthService authService = AuthService();

class SigInScreen extends StatefulWidget {
  const SigInScreen({
    super.key,
  });

  @override
  State<SigInScreen> createState() => _SigInScreenState();
}

class _SigInScreenState extends State<SigInScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  // final TextEditingController nameController = TextEditingController();
  // DateTime currentDay = DateTime.now();

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
      appBar: customAppBar("SigIn"),
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
                  Text('SigIn',
                      style: Theme.of(context).textTheme.headlineSmall),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Username'),
                    controller: emailController,
                    keyboardType: TextInputType.emailAddress,
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
                      child: SigInButton(
                          style: style,
                          formKey: _formKey,
                          emailController: emailController,
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

class SigInButton extends StatelessWidget {
  const SigInButton({
    super.key,
    required this.style,
    required GlobalKey<FormState> formKey,
    required this.emailController,
    required this.passwordController,
  }) : _formKey = formKey;

  final ButtonStyle style;
  final GlobalKey<FormState> _formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: style,
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          try {
            if (await sigInUser(
              email: emailController.value.text,
              password: passwordController.value.text,
            )) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const LoginScreen(),
                  ));
            }
          // } on UserNotFindException {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     const SnackBar(content: Text('User or password error.')),
          //   );
          } on AccessApiFindException catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
               SnackBar(content: Text(e.toString())),
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

Future<bool> sigInUser({
  required String email,
  required String password,
}) async {
  try {
    Map<String, dynamic>? response;
    response = await authService.xApi(
      apiUrl: "/user-system/api/",
      method: 'post',
      body: {
        "email": email,
        "password": password,
        "name": "zzz",
        "last_name": "zzz",
      },
    );
    log(response.toString());
    return true;
  } on AccessApiFindException {
    rethrow;
  } catch (e) {
    log("sigInUser");
    if (e.toString().contains("TimeoutException")) {
      throw TimeoutException("error");
    }
    return false;
  }
}
