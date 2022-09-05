import 'package:simple_app/model/pFieldMapOcr.dart';

class ListVerifiedFieldsOcr {
  List<PFieldMapOcr>? pFieldMaps;

  ListVerifiedFieldsOcr({
    this.pFieldMaps,
  });

  factory ListVerifiedFieldsOcr.fromJson(Map<String, dynamic> json) => ListVerifiedFieldsOcr(
    pFieldMaps: List<PFieldMapOcr>.from(json["pFieldMaps"].map((x) => PFieldMapOcr.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "pFieldMaps": List<dynamic>.from(pFieldMaps!.map((x) => x.toJson())),
  };
}