import 'dart:convert';
import 'dart:io';

import 'package:app/utils/helper.dart';
import 'package:http/http.dart' as http;
import 'package:app/entitys/measure.dart';
import 'package:app/utils/api.dart';

class MovimentApi {
  static Future<void> move(double value) async {
    // print("POST => move($value)");

    String url = '$DOMAIN/action';

    String body = json.encode({
      'value': value
    });

    print('Request Body: $body');

    http.Response response = await http.post(url, body: body, headers: {
      'Content-Type': 'application/json',
    });

    print('Response Body: ${response.body}'); /**/
  }

  static Future<double> state() async {
    // print("POST => move($value)");

    String url = '$DOMAIN/currentPosition';

    http.Response response = await http.get(url);

    print('Response Body: ${response.body}');

    return convertToDouble(response.body);
  }
}
