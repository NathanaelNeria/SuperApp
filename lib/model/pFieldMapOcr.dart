class PFieldMapOcr {
  int wLcid;
  int fieldType;
  int wFieldType;
  String fieldMrz;
  String fieldVisual;
  String matrix;

  PFieldMapOcr({
    this.wLcid,
    this.fieldType,
    this.wFieldType,
    this.fieldMrz,
    this.fieldVisual,
    this.matrix,
  });

  factory PFieldMapOcr.fromJson(Map<String, dynamic> json) => PFieldMapOcr(
    wLcid: json["wLCID"],
    fieldType: json["FieldType"],
    wFieldType: json["wFieldType"],
    fieldMrz: json["Field_MRZ"],
    fieldVisual: json["Field_Visual"],
    matrix: json["Matrix"],
  );

  Map<String, dynamic> toJson() => {
    "wLCID": wLcid,
    "FieldType": fieldType,
    "wFieldType": wFieldType,
    "Field_MRZ": fieldMrz,
    "Field_Visual": fieldVisual,
    "Matrix": matrix,
  };
}