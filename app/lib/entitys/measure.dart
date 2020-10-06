import 'package:app/utils/helper.dart';

class Measure {
  double temperature;
  double moisture;
  double luminosity;

  Measure({this.temperature, this.moisture, this.luminosity});

  Measure.fromMap(Map<String, dynamic> map) {
    temperature = convertToDouble(map['temperature']);
    moisture = convertToDouble(map['moisture']);
    luminosity = convertToDouble(map['luminosity']);
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['temperature'] = this.temperature;
    data['moisture'] = this.moisture;
    data['luminosity'] = this.luminosity;
    return data;
  }
}