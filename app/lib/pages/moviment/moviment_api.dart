import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:app/entitys/measure.dart';
import 'package:app/utils/api.dart';

class MovimentApi {
  static Future<void> move(double value) async {
    // print("POST => move($value)");

    String url = '$DOMAIN/action';

    String body = json.encode({
      'type': 'turnPaddles',
      'value': value
    });

    print('Request Body: $body');

    http.Response response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    print('Response Body: ${response.body}');
  }
}
