import 'package:simple_app/model/resultOcr.dart';

class OcrModel {
  String? status;
  String? message;
  List<ResultOcr>? result;

  OcrModel({
    this.status,
    this.message,
    this.result,
  });

  factory OcrModel.fromJson(Map<String, dynamic> json) => OcrModel(
    status: json["status"],
    message: json["message"],
    result: List<ResultOcr>.from(json["result"].map((x) => ResultOcr.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "message": message,
    "result": List<dynamic>.from(result!.map((x) => x.toJson())),
  };
}