import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('testing for loading work', () {
    dotenv.testLoad(fileInput: File('test/.env').readAsStringSync());
    final baseUrl = dotenv.env['baseurl'];
    expect(baseUrl, 'example.com');
    final token = dotenv.env['token'];
    expect(token, '123');
  });
}
