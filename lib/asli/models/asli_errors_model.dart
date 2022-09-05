import 'package:json_annotation/json_annotation.dart';

class AsliErrorsModel {
  //double confidence;
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? identity_photo; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? selfie_photo; // invalid, no face detected

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? message; // Data not found, Internal Server Error

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? phone; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? latitude; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? longitude; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? name; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? birthdate; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? birthplace; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? nik; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? npwp; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? income; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? company_name; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? company_phone; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? nop; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? dob; // invalid

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? pob; // invalid

  AsliErrorsModel({
    //this.confidence,
    this.identity_photo,
    this.selfie_photo,
    this.message,
    this.phone,
    this.latitude,
    this.longitude,
    this.name,
    this.birthdate,
    this.birthplace,
    this.nik,
    this.npwp,
    this.income,
    this.company_name,
    this.company_phone,
    this.nop,
    this.dob,
    this.pob,

  });

  factory AsliErrorsModel.fromJson(Map<String, dynamic> json) => AsliErrorsModel(
    //confidence: json["confidence"].toDouble(),
      identity_photo: json["identity_photo"],
      selfie_photo: json["selfie_photo"],
      message: json["message"],
      phone: json["phone"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      name: json["name"],
      birthdate: json["birthdate"],
      birthplace: json["birthplace"],
      nik: json["nik"],
      npwp: json["npwp"],
      income: json["income"],
      company_name: json["company_name"],
      company_phone: json["company_phone"],
      nop: json["nop"],
      dob: json["dob"],
      pob: json["pob"],
);

  Map<String, dynamic> toJson() => {
    //"confidence": confidence,
    "identity_photo":identity_photo,
    "selfie_photo":selfie_photo,
    "message":message,
    "phone":phone,
    "latitude":latitude,
    "longitude":longitude,
    "name":name,
    "birthdate":birthdate,
    "birthplace":birthplace,
    "nik":nik,
    "npwp":npwp,
    "income":income,
    "company_name":company_name,
    "company_phone":company_phone,
    "nop":nop,
    "dob":dob,
    "pob":pob,
  };
}