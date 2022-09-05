import 'dart:convert';

GetDevicesProfileModel getDevicesProfileModelFromJson(String str) => GetDevicesProfileModel.fromJson(json.decode(str));

String getDevicesProfileModelToJson(GetDevicesProfileModel data) => json.encode(data.toJson());

class GetDevicesProfileModel {
  GetDevicesProfileModel({
    this.device,
    this.status,
    this.statusCode,
    this.statusMessage,
  });

  List<dynamic> device;
  String status;
  int statusCode;
  String statusMessage;

  factory GetDevicesProfileModel.fromJson(Map<String, dynamic> json) => GetDevicesProfileModel(
    device: List<dynamic>.from(json["device"].map((x) => Device.fromJson(x))),
    status: json["status"],
    statusCode: json["status_code"],
    statusMessage: json["status_message"],
  );

  Map<String, dynamic> toJson() => {
    "device": List<dynamic>.from(device.map((x) => x.toJson())),
    "status": status,
    "status_code": statusCode,
    "status_message": statusMessage,
  };
}

class Device {
  Device({
    this.id,
    this.serialNumber,
    this.label,
    this.category,
    this.categoryValue,
    this.firmwareVersion,
    this.applicationId,
    this.tenantId,
    this.online,
    this.sensors,
    this.tags,
  });

  String id;
  String serialNumber;
  String label;
  String category;
  int categoryValue;
  String firmwareVersion;
  String applicationId;
  String tenantId;
  bool online;
  List<dynamic> sensors;
  Tags tags;

  @override toString() =>
  '''
  
  ID: $id
  Serial Number: $serialNumber
  Label: $label
  Category: $category
  Category Value: $categoryValue
  Firmware Version: $firmwareVersion
  Tenant ID: $tenantId
  Online: $online
  Sensors: $sensors
  Tags: $tags
  ''';

  factory Device.fromJson(Map<String, dynamic> json) => Device(
    id: json["id"],
    serialNumber: json["serial_number"],
    label: json["label"],
    category: json["category"],
    categoryValue: json["category_value"],
    firmwareVersion: json["firmware_version"],
    applicationId: json["application_id"],
    tenantId: json["tenant_id"],
    online: json["online"],
    sensors: List<dynamic>.from(json["sensors"].map((x) => Sensor.fromJson(x))),
    tags: Tags.fromJson(json["tags"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "serial_number": serialNumber,
    "label": label,
    "category": category,
    "category_value": categoryValue,
    "firmware_version": firmwareVersion,
    "application_id": applicationId,
    "tenant_id": tenantId,
    "online": online,
    "sensors": List<dynamic>.from(sensors.map((x) => x.toJson())),
    "tags": tags.toJson(),
  };
}

class Sensor {
  Sensor({
    this.datatype,
    this.sensor,
    this.config,
    this.param,
    this.subparam,
  });

  Datatype datatype;
  String sensor;
  Config config;
  String param;
  Subparam subparam;

  @override toString() =>
  '''
  
  Datatype: $datatype
  Sensor: $sensor
  Config: $config
  param: $param
  subparam: $subparam
  
  ''';

  factory Sensor.fromJson(Map<String, dynamic> json) => Sensor(
    datatype: datatypeValues.map[json["datatype"]],
    sensor: json["sensor"],
    config: configValues.map[json["config"]],
    param: json["param"],
    subparam: json["subparam"] == null ? null : Subparam.fromJson(json["subparam"]),
  );

  Map<String, dynamic> toJson() => {
    "datatype": datatypeValues.reverse[datatype],
    "sensor": sensor,
    "config": configValues.reverse[config],
    "param": param,
    "subparam": subparam == null ? null : subparam.toJson(),
  };
}

enum Config { DATA, CONFIG, COMMAND }

final configValues = EnumValues({
  "command": Config.COMMAND,
  "config": Config.CONFIG,
  "data": Config.DATA
});

enum Datatype { OBJECT, NUMBER, BOOLEAN, TEXT }

final datatypeValues = EnumValues({
  "boolean": Datatype.BOOLEAN,
  "number": Datatype.NUMBER,
  "object": Datatype.OBJECT,
  "text": Datatype.TEXT
});

class Subparam {
  Subparam({
    this.number,
    this.decimal,
    this.boolean,
    this.text,
    this.data1,
    this.data2,
    this.data3,
    this.data4,
    this.data5,
  });

  Datatype number;
  Datatype decimal;
  Datatype boolean;
  Datatype text;
  Datatype data1;
  Datatype data2;
  Datatype data3;
  Datatype data4;
  Datatype data5;

  factory Subparam.fromJson(Map<String, dynamic> json) => Subparam(
    number: json["number"] == null ? null : datatypeValues.map[json["number"]],
    decimal: json["decimal"] == null ? null : datatypeValues.map[json["decimal"]],
    boolean: json["boolean"] == null ? null : datatypeValues.map[json["boolean"]],
    text: json["text"] == null ? null : datatypeValues.map[json["text"]],
    data1: json["data1"] == null ? null : datatypeValues.map[json["data1"]],
    data2: json["data2"] == null ? null : datatypeValues.map[json["data2"]],
    data3: json["data3"] == null ? null : datatypeValues.map[json["data3"]],
    data4: json["data4"] == null ? null : datatypeValues.map[json["data4"]],
    data5: json["data5"] == null ? null : datatypeValues.map[json["data5"]],
  );

  Map<String, dynamic> toJson() => {
    "number": number == null ? null : datatypeValues.reverse[number],
    "decimal": decimal == null ? null : datatypeValues.reverse[decimal],
    "boolean": boolean == null ? null : datatypeValues.reverse[boolean],
    "text": text == null ? null : datatypeValues.reverse[text],
    "data1": data1 == null ? null : datatypeValues.reverse[data1],
    "data2": data2 == null ? null : datatypeValues.reverse[data2],
    "data3": data3 == null ? null : datatypeValues.reverse[data3],
    "data4": data4 == null ? null : datatypeValues.reverse[data4],
    "data5": data5 == null ? null : datatypeValues.reverse[data5],
  };
}

class Tags {
  Tags();

  @override toString() => '';

  factory Tags.fromJson(Map<String, dynamic> json) => Tags(
  );

  Map<String, dynamic> toJson() => {
  };
}

class EnumValues<T> {
  Map<String, T> map;
  Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    if (reverseMap == null) {
      reverseMap = map.map((k, v) => new MapEntry(v, k));
    }
    return reverseMap;
  }
}
