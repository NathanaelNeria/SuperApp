// To parse this JSON data, do
//
//     final atmSensorModel = atmSensorModelFromJson(jsonString);

import 'dart:convert';

AtmSensorModel atmSensorModelFromJson(String str) => AtmSensorModel.fromJson(json.decode(str));

String atmSensorModelToJson(AtmSensorModel data) => json.encode(data.toJson());

class AtmSensorModel {
  AtmSensorModel({
    this.id,
    this.serialNumber,
    this.label,
    this.category,
    this.categoryValue,
    this.firmwareVersion,
    this.online,
    this.sensors,
    this.tags,
    this.mqttUrl,
    this.mqttUsername,
    this.mqttPassword,
    this.status,
    this.statusCode,
    this.statusMessage,
  });

  String? id;
  String? serialNumber;
  String? label;
  String? category;
  int? categoryValue;
  String? firmwareVersion;
  bool? online;
  List<dynamic>? sensors;
  Tags? tags;
  String? mqttUrl;
  String? mqttUsername;
  String? mqttPassword;
  String? status;
  int? statusCode;
  String? statusMessage;


  factory AtmSensorModel.fromJson(Map<String, dynamic> json) => AtmSensorModel(
    id: json["id"],
    serialNumber: json["serial_number"],
    label: json["label"],
    category: json["category"],
    categoryValue: json["category_value"],
    firmwareVersion: json["firmware_version"],
    online: json["online"],
    sensors: List<dynamic>.from(json["sensors"].map((x) => Sensor.fromJson(x))),
    tags: Tags.fromJson(json["tags"]),
    mqttUrl: json["mqtt_url"],
    mqttUsername: json["mqtt_username"],
    mqttPassword: json["mqtt_password"],
    status: json["status"],
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serial_number": serialNumber,
    "label": label,
    "category": category,
    "category_value": categoryValue,
    "firmware_version": firmwareVersion,
    "online": online,
    "sensors": List<dynamic>.from(sensors!.map((x) => x.toJson())),
    "tags": tags!.toJson(),
    "mqtt_url": mqttUrl,
    "mqtt_username": mqttUsername,
    "mqtt_password": mqttPassword,
    "status": status,
    "status_code": statusCode,
    "status_message": statusMessage,
  };
}

class Sensor {
  Sensor({
    this.dt,
    this.sensor,
    this.configtype,
    this.param,
  });

  Dt? dt;
  String? sensor;
  Configtype? configtype;
  String? param;

  @override toString() =>
'''

Data Type: $dt
Sensor: $sensor
Config Type: $configtype
Param: $param
''';

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
    dt: dtValues.map[json["dt"]],
    sensor: json["sensor"],
    configtype: configtypeValues.map[json["configtype"]],
    param: json["param"],
  );

  Map<String, dynamic> toJson() => {
    "dt": dtValues.reverse![dt!],
    "sensor": sensor,
    "configtype": configtypeValues.reverse![configtype!],
    "param": param,
  };
}

enum Configtype { COMMAND, DATA }

final configtypeValues = EnumValues({
  "command": Configtype.COMMAND,
  "data": Configtype.DATA
});

enum Dt { BOOLEAN, TEXT, NUMBER, IMAGE }

final dtValues = EnumValues({
  "boolean": Dt.BOOLEAN,
  "image": Dt.IMAGE,
  "number": Dt.NUMBER,
  "text": Dt.TEXT
});

class Tags {
  Tags();

  factory Tags.fromJson(Map<String, dynamic>? json) => Tags(
  );

  Map<String, dynamic> toJson() => {
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
