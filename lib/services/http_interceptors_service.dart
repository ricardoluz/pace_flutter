import 'dart:async';
import 'dart:developer';
import 'package:http_interceptor/http_interceptor.dart';

class InterceptedAccess extends InterceptorContract {
  @override
  Future<BaseRequest> interceptRequest({
    required BaseRequest request,
  }) async {
    log("\n");
    log('----- Request -----');
    log("Request made: $request");
    log(request.headers.toString());
    log("\n");
    return request;
  }

  @override
  Future<BaseResponse> interceptResponse({
    required BaseResponse response,
  }) async {
    log("\n");
    log('----- Response -----');
    if (response is Response) {
      log('Code: ${response.statusCode}');
      log("Headers:");
      response.headers.forEach((key, value) => log("\t$key: $value"));
      log('Body : ${response.body}');
      log("\n");
    }
    return response;
  }
}
