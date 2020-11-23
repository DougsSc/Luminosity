import 'package:app/utils/helper.dart';

class Device {
  int id;
  String token;
  String name;

  Device({this.id, this.token, this.name});

  Device.fromMap(Map<String, dynamic> map) {
    id = convertToInt(map['id']);
    token =map['token'];
    name = map['name'];
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['token'] = this.token;
    data['name'] = this.name;
    return data;
  }
}