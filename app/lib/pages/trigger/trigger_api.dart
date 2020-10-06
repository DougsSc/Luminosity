import 'dart:convert';

import 'package:app/entitys/trigger.dart';
import 'package:http/http.dart' as http;
import 'package:app/utils/api.dart';

class TriggerApi {
  static Future<List<Trigger>> alerts() async {
    print("GET => alerts()");

    String url = 'http://$DOMAIN/api/alerts';

    http.Response response = await http.get(url);

    print('Response Body: ${response.body}');

    List<Trigger> alerts = [];
    if (response.statusCode == 200) {
      final map = json.decode(response.body);
      alerts = map.map<Trigger>((map) => Trigger.fromMap(map)).toList();
    }

    return alerts;
  }
}
