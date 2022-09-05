import 'package:json_annotation/json_annotation.dart';

class AsliDataModel {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? name;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? birthdate;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? birthplace;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? address;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  double? selfie_photo;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? result; // true, false, null

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  int? total;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? nik;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? dob; // negative record: null

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? pob;// negative record: null

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? detail;// negative record: null

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? company;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? company_name;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? company_phone;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  int? age;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? mother_name;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? npwp;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? match_result;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? income;

// property
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? property_address;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? property_name;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? property_building_area;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? property_surface_area;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? property_estimation;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? certificate_address;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? certificate_id;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? certificate_name;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? certificate_type;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? certificate_date;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? negative_record;



  //double confidence;

  AsliDataModel({
    //this.confidence,
    this.name,
    this.birthdate,
    this.birthplace,
    this.address,
    this.selfie_photo,
    this.result, // true, false, null
    this.total,
    this.nik,
    this.dob, // negative record: null
    this.pob,// negative record: null
    this.detail,// negative record: null
    this.company,
    this.company_name,
    this.company_phone,
    this.age,
    this.mother_name,
    this.npwp,
    this.match_result,
    this.income,
// property
    this.property_address,
    this.property_name,
    this.property_building_area,
    this.property_surface_area,
    this.property_estimation,
    this.certificate_address,
    this.certificate_id,
    this.certificate_name,
    this.certificate_type,
    this.certificate_date,
    this.negative_record,
  });

  factory AsliDataModel.fromJson(Map<String, dynamic> json) => AsliDataModel(
    //selfie_photo: json["confidence"].toDouble(),
    name: json["name"],
    birthdate: json["birthdate"],
    birthplace: json["birthplace"],
    address: json["address"],
    selfie_photo: json["selfie_photo"],
    result : json["result"],
    total: json["total"],
    nik: json["nik"],
    dob: json["dob"],
    company: json["company"],
    company_name: json["company_name"],
    company_phone: json["company_phone"],
    age: json["age"],
    mother_name: json["mother_name"],
    npwp: json["npwp"],
    match_result: json["match_result"],
    income: json["income"],
    property_name: json["property_name"],
    property_building_area: json["property_building_area"],
    property_surface_area: json["property_surface_area"],
    property_estimation: json["property_estimation"],
    certificate_address: json["certificate_address"],
    certificate_id: json["certificate_id"],
    certificate_name: json["certificate_name"],
    certificate_type: json["certificate_type"],
    certificate_date: json["certificate_date"],
    negative_record: json["negative_record"],
    detail: json["detail"],
  );

  Map<String, dynamic> toJson() => {
    //"confidence": confidence,
    "name":name,
    "birthdate":birthdate,
    "birthplace":birthplace,
    "address":address,
    "selfie_photo":selfie_photo,
    "result ":result ,
    "total":total,
    "nik":nik,
    "dob":dob,
    "company":company,
    "company_name":company_name,
    "company_phone":company_phone,
    "age":age,
    "mother_name":mother_name,
    "npwp":npwp,
    "match_result":match_result,
    "income":income,
    "property_name":property_name,
    "property_building_area":property_building_area,
    "property_surface_area":property_surface_area,
    "property_estimation":property_estimation,
    "certificate_address":certificate_address,
    "certificate_id":certificate_id,
    "certificate_name":certificate_name,
    "certificate_type":certificate_type,
    "certificate_date":certificate_date,
    "negative_record":negative_record,
    "detail":detail,
  };
}

//class PFieldMapOcr {
//  int wLcid;
//  int fieldType;
//  int wFieldType;
//  String fieldMrz;
//  String fieldVisual;
//  String matrix;
//
//  PFieldMapOcr({
//    this.wLcid,
//    this.fieldType,
//    this.wFieldType,
//    this.fieldMrz,
//    this.fieldVisual,
//    this.matrix,
//  });
//
//  factory PFieldMapOcr.fromJson(Map<String, dynamic> json) => PFieldMapOcr(
//    wLcid: json["wLCID"],
//    fieldType: json["FieldType"],
//    wFieldType: json["wFieldType"],
//    fieldMrz: json["Field_MRZ"],
//    fieldVisual: json["Field_Visual"],
//    matrix: json["Matrix"],
//  );
//
//  Map<String, dynamic> toJson() => {
//    "wLCID": wLcid,
//    "FieldType": fieldType,
//    "wFieldType": wFieldType,
//    "Field_MRZ": fieldMrz,
//    "Field_Visual": fieldVisual,
//    "Matrix": matrix,
//  };
//}