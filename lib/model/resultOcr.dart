import 'package:simple_app/model/listVerifiedFieldsOcr.dart';

class ResultOcr {
  ListVerifiedFieldsOcr? listVerifiedFields;

  ResultOcr({
    this.listVerifiedFields,
  });

  factory ResultOcr.fromJson(Map<String, dynamic> json) => ResultOcr(
    listVerifiedFields: ListVerifiedFieldsOcr.fromJson(json["ListVerifiedFields"]),
  );

  Map<String, dynamic> toJson() => {
    "ListVerifiedFields": listVerifiedFields!.toJson(),
  };
}