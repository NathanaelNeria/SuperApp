// To parse this JSON data, do
//
//     final newestDeviceDataModel = newestDeviceDataModelFromJson(jsonString);

import 'dart:convert';

NewestDeviceDataModel newestDeviceDataModelFromJson(String str) => NewestDeviceDataModel.fromJson(json.decode(str));

String newestDeviceDataModelToJson(NewestDeviceDataModel data) => json.encode(data.toJson());

class NewestDeviceDataModel {
  NewestDeviceDataModel({
    this.data,
    this.status,
    this.statusCode,
    this.statusMessage,
  });

  List<dynamic>? data;
  String? status;
  int? statusCode;
  String? statusMessage;

  factory NewestDeviceDataModel.fromJson(Map<String, dynamic> json) => NewestDeviceDataModel(
    data: List<dynamic>.from(json["data"].map((x) => Data.fromJson(x))),
    status: json["status"],
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "status": status,
    "status_code": statusCode,
    "status_message": statusMessage,
  };
}

class Data {
  Data({
    this.time,
    this.timestamp,
    this.sensor,
    this.config,
    this.param,
    this.value,
  });

  DateTime? time;
  int? timestamp;
  String? sensor;
  String? config;
  String? param;
  var value;

  @override toString() =>
  '''
  
  Time: $time
  Timestamp: $timestamp
  Sensor: $sensor
  Config: $config
  Param: $param
  Value: $value
  ''';

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    time: DateTime.parse(json["time"]),
    timestamp: json["timestamp"],
    sensor: json["sensor"],
    config: json["config"],
    param: json["param"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "time": time!.toIso8601String(),
    "timestamp": timestamp,
    "sensor": sensor,
    "config": config,
    "param": param,
    "value": value,
  };
}
