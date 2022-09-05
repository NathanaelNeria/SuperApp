import 'package:simple_app/model/resultIdcard.dart';
import 'package:simple_app/model/imageBestLiveness.dart';

class FaceVerifModel {
  String? requestId;
  String? error;
  ResultIdcard? resultIdcard;
  ImageBestLiveness? imageBestLiveness;

  FaceVerifModel({
    this.requestId,
    this.error,
    this.resultIdcard,
    this.imageBestLiveness,
  });

  factory FaceVerifModel.fromJson(Map<String, dynamic> json) => FaceVerifModel(
    requestId: json["request_id"],
    error: json["error"],
    resultIdcard: ResultIdcard.fromJson(json["result_idcard"]),
    imageBestLiveness: ImageBestLiveness.fromJson(json["imageBestLiveness"])
  );

  Map<String, dynamic> toJson() => {
    "request_id": requestId,
    "error": error,
    "result_idcard": resultIdcard!.toJson(),
    "imageBestLiveness":imageBestLiveness!.toJson(),
  };
}