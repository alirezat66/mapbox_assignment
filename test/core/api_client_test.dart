import 'dart:async';
import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:spa_coding_exercise/core/api_client.dart';

import 'api_client_test.mocks.dart';

@GenerateMocks([http.Client])
void main() async {
  const String url = "https://api.mapbox.com/geocoding/v5/mapbox.places/";
  TestWidgetsFlutterBinding.ensureInitialized();

  await DotEnv().load();
  late MockClient client;
  late ApiClient apiClient;
  setUp(() {
    client = MockClient();
    dotenv.testLoad(fileInput: File('test/.env').readAsStringSync());
    apiClient = ApiClient(client);
  });

  setUpReturnTrueResult() {
    when(client.get(Uri.parse("${url}test"),
            headers: {"Content-Type": "application/json"}))
        .thenAnswer((_) async => http.Response("", 200));
  }

  setUpUnAuthenticationResponse() {
    when(client.get(Uri.parse("${url}test"),
            headers: {"Content-Type": "application/json"}))
        .thenAnswer((_) async => http.Response("", 401));
  }

  setUpServerErrorResponse() {
    when(client.get(Uri.parse("${url}test"),
            headers: {"Content-Type": "application/json"}))
        .thenAnswer((_) async => http.Response("", 500));
  }

  setUpUnhandledResponse() {
    when(client.get(Uri.parse("${url}test"),
            headers: {"Content-Type": "application/json"}))
        .thenAnswer((_) async => http.Response("", 600));
  }

  setUpTimeOutException() {
    when(client.get(Uri.parse("${url}test"),
            headers: {"Content-Type": "application/json"}))
        .thenThrow((_) async => TimeoutException('timeout'));
  }

  setUpUnknownException() {
    when(client.get(Uri.parse("${url}test"),
            headers: {"Content-Type": "application/json"}))
        .thenThrow((_) async => Exception('error'));
  }

  group('testing the api client', () {
    test('testing for true result', () async {
      setUpReturnTrueResult();

      final result = await apiClient.request(url: 'test', method: Method.get);
      expect(result.statusCode, 200);
    });
    test('testing for unauthenticated result', () async {
      setUpUnAuthenticationResponse();

      try {
        await apiClient.request(url: 'test', method: Method.get);
      } catch (e) {
        expect(e.toString(), 'Exception: Exception: UnAuthorized');
      }
    });
    test('testing for serverError result', () async {
      setUpServerErrorResponse();

      try {
        await apiClient.request(url: 'test', method: Method.get);
      } catch (e) {
        expect(e.toString(), 'Exception: Exception: Server Error');
      }
    });
    test('testing for UnhandledError result', () async {
      setUpUnhandledResponse();

      try {
        await apiClient.request(url: 'test', method: Method.get);
      } catch (e) {
        expect(e.toString(), 'Exception: Exception: Unhandled Error Occurred');
      }
    });
    test('testing for TimeOutException result', () async {
      setUpTimeOutException();

      try {
        await apiClient.request(url: 'test', method: Method.get);
      } catch (e) {
        expect(e.toString(),
            'Exception: Closure: (dynamic) => Future<TimeoutException>');
      }
    });
    test('testing for UnknownException result', () async {
      setUpUnknownException();

      try {
        await apiClient.request(url: 'test', method: Method.get);
      } catch (e) {
        expect(
            e.toString(), 'Exception: Closure: (dynamic) => Future<Exception>');
      }
    });
  });
}
