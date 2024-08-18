// import 'dart:io';

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pace/services/api_access_service.dart';

final AuthService authService = AuthService();

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  // final TextEditingController _emailController = TextEditingController();
  // final TextEditingController _passwordController = TextEditingController();

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
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
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Login"),
            ElevatedButton(
              style: style,
              onPressed: () {
                getToken();
                // Navigator.pushReplacementNamed(context, 'home');
              },
              child: const Text('Login'),
            )
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sair"),
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

  logout() {
    SharedPreferences.getInstance().then((sharedPreferences) {
      sharedPreferences.remove('accessToken');
      sharedPreferences.remove('id');
      sharedPreferences.remove('email');

      Navigator.pushReplacementNamed(context, 'login');
    });
  }

  Future<void> getToken() async {
    String username = 'test1';
    String password = 'dckm#1111';

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
