// To parse this JSON data, do
//
//     final commandDeviceModel = commandDeviceModelFromJson(jsonString);

import 'dart:convert';

CommandDeviceModel commandDeviceModelFromJson(String str) => CommandDeviceModel.fromJson(json.decode(str));

String commandDeviceModelToJson(CommandDeviceModel data) => json.encode(data.toJson());

class CommandDeviceModel {
  CommandDeviceModel({
    this.deviceId,
    this.input,
    this.output,
    this.status,
    this.statusCode,
    this.statusMessage,
  });

  String? deviceId;
  List<dynamic>? input;
  List<dynamic>? output;
  String? status;
  int? statusCode;
  String? statusMessage;

  factory CommandDeviceModel.fromJson(Map<String, dynamic> json) => CommandDeviceModel(
    deviceId: json["device_id"],
    input: List<dynamic>.from(json["input"].map((x) => x)),
    output: List<dynamic>.from(json["output"].map((x) => x)),
    status: json["status"],
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "device_id": deviceId,
    "input": List<dynamic>.from(input!.map((x) => x)),
    "output": List<dynamic>.from(output!.map((x) => x)),
    "status": status,
    "status_code": statusCode,
    "status_message": statusMessage,
  };
}

CmdFailModel cmdFailModelFromJson(String str) => CmdFailModel.fromJson(json.decode(str));

String cmdFailModelToJson(CmdFailModel data) => json.encode(data.toJson());

class CmdFailModel {
  CmdFailModel({
    this.commandId,
    this.deviceId,
    this.status,
    this.statusCode,
    this.statusMessage,
  });

  String? commandId;
  String? deviceId;
  String? status;
  int? statusCode;
  String? statusMessage;

  factory CmdFailModel.fromJson(Map<String, dynamic> json) => CmdFailModel(
    commandId: json["command_id"],
    deviceId: json["device_id"],
    status: json["status"],
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "command_id": commandId,
    "device_id": deviceId,
    "status": status,
    "status_code": statusCode,
    "status_message": statusMessage,
  };
}
