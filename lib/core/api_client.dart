import 'dart:async';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';

enum Method { get }

class ApiClient {
  final Client client;
  ApiClient(this.client);
  Uri _getFinalUri(String partialUrl) {
    return Uri.parse(dotenv.get('baseurl') + partialUrl);
  }

  Map<String, String> _getHeader() {
    return {"Content-Type": "application/json"};
  }

  Future<Response> request(
      {required String url,
      required Method method,
      Map<String, dynamic>? body}) async {
    late Response response;
    print("we are there");
    try {
      if (method == Method.get) {
        response = await client.get(_getFinalUri(url), headers: _getHeader());
      }
      switch (response.statusCode) {
        case 200:
        case 201:
          return response;
        case 401:
        case 403:
          throw Exception('UnAuthorized');
        case 500:
          throw Exception("Server Error");
        default:
          throw Exception("Unhandled Error Occurred");
      }
    } on TimeoutException catch (_) {
      throw Exception("No Internet Connection");
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
