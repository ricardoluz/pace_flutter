import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import '/services/web_client_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class AuthService {
  //
  static String url = WebClient.url;
  http.Client client = WebClient().client;

  Map<String, String> errorMessages = {
    "{detail: O token é inválido ou expirado, code: token_not_valid}": "x",
    "{token: [Este campo é obrigatório.]}": "x",
    "{refresh: [Este campo é obrigatório.]}": "x",
    "{detail: Usuário e/ou senha incorreto(s)}": "x",
    "{detail: O token informado não é válido para qualquer tipo de token}": "x",
    "{detail: No User matches the given query.}": "x",
    "{detail: As credenciais de autenticação não foram fornecidas.}": "x",
    "{detail: No active account found with the given credentials}": "x",
    "{non_field_errors: [Unable to log in with provided credentials.]}":
        "User or password error.",
    "{email: [user system with this email already exists.]}":
        "This email already exists.",
    "{email: [Enter a valid email address.]}": "Email address invalid."
  };

  Future<Map<String, dynamic>> xApi({
    required String apiUrl,
    required String method,
    String tokenBearer = "",
    required Map<String, dynamic>? body,
  }) async {
    http.Response response;

    Map<String, String> headers = {
      "ContentType": "application/json",
      if (tokenBearer.isNotEmpty) "authorization": "Bearer $tokenBearer",
    };

    switch (method) {
      case "get":
        response = await client.get(
          Uri.parse('$url$apiUrl'),
          headers: headers,
        );
      case "post":
        response = await client.post(
          Uri.parse('$url$apiUrl'),
          headers: headers,
          body: body,
        );
      case "patch":
        response = await client.patch(
          Uri.parse('$url$apiUrl'),
          headers: headers,
          body: body,
        );
      default:
        //TODO: Redo this error handling.
        response = {"Error": "Method not defined"} as http.Response;
    }

    Map<String, dynamic> content = json.decode(utf8.decode(response.bodyBytes));

    if (response.statusCode != 200 && response.statusCode != 201) {
      String error =
          {content.keys.first: content[content.keys.first]}.toString();
      if (errorMessages.containsKey(error)) {
        throw AccessApiFindException(errorMessages[error]!);
      } else {
        log("Error : $error\n\n");
        throw HttpException(error);
      }
    }

    return content;
  }
}

class AccessApiFindException implements Exception {
  final String message;

  AccessApiFindException(this.message);

  @override
  String toString() {
    return message;
  }
}
