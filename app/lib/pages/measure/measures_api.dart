import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:app/entitys/measure.dart';
import 'package:app/utils/api.dart';

class MeasuresApi {
  static Future<List<Measure>> measures() async {
    print("GET => measures()");

    String url = '$DOMAIN/data';

    http.Response response = await http.get(url);

    print('Response Body: ${response.body}');

    List<Measure> sensors = [];
    if (response.statusCode == 200) {
      var map = json.decode(response.body);
      sensors = map.map<Measure>((map) => Measure.fromMap(map)).toList();
    }

    return sensors;
  }
}
