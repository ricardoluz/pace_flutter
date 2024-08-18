import 'dart:async';
import 'dart:convert';
import 'dart:io';
import '/services/web_client_service.dart';
// import 'package:shared_preferences/shared_preferences.dart';

import 'package:http/http.dart' as http;

class AuthService {
  //
  static String url = WebClient.url;
  http.Client client = WebClient().client;

  List<String> errorMessages = [
    "{detail: O token é inválido ou expirado, code: token_not_valid}",
    "{token: [Este campo é obrigatório.]}",
    "{refresh: [Este campo é obrigatório.]}",
    "{detail: Usuário e/ou senha incorreto(s)}",
    "{detail: O token informado não é válido para qualquer tipo de token}",
    "{detail: No User matches the given query.}",
    "{detail: As credenciais de autenticação não foram fornecidas.}",
    "{detail: No active account found with the given credentials}",
  ];

  Future<Map<String, dynamic>> xApi({
    required String apiUrl,
    required String method,
    String tokenBearer = "",
    required Map<String, dynamic>? body,
  }) async {
    http.Response response;

    switch (method) {
      case "get":
        response = await client.get(
          Uri.parse('$url$apiUrl'),
          headers: {
            "ContentType": "application/json",
            if (tokenBearer.isNotEmpty) "authorization": "Bearer $tokenBearer",
          },
        );
      case "post":
        response = await client.post(
          Uri.parse('$url$apiUrl'),
          headers: {
            "ContentType": "application/json",
            if (tokenBearer.isNotEmpty) "authorization": "Bearer $tokenBearer",
          },
          body: body,
        );
      case "patch":
        response = await client.patch(
          Uri.parse('$url$apiUrl'),
          headers: {
            "ContentType": "application/json",
            if (tokenBearer.isNotEmpty) "authorization": "Bearer $tokenBearer",
          },
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

      if (errorMessages.contains(error)) {
        return {"Error": error};
      } else {
        throw HttpException(error);
      }
    }

    return content;
  }
}

class UserNotFindException implements Exception {
  //TODO: Implement this class.
}
