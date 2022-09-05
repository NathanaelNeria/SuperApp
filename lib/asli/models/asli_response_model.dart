import 'package:simple_app/asli/models/asli_data_model.dart';
import 'package:simple_app/asli/models/asli_errors_model.dart';
import 'package:simple_app/asli/models/asli_gestures_set_results_model.dart';
import 'package:simple_app/asli/models/asli_gestures_set_names_model.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable()
class AsliResponseModel {

  @JsonKey(defaultValue: 0)
  int? timestamp;

  @JsonKey(defaultValue: 0)
  int? status;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? trx_id;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? ref_id;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  String? error;

  // Liveness Verification
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  bool? passed;

  //ResultIdcard resultIdcard;
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  AsliDataModel? data;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  AsliErrorsModel? errors;

  // Liveness Verification
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  AsliGesturesSetResultsModel? gestures_set_results;

  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  AsliGesturesSetNamesModel? gestures_set_names;

  AsliResponseModel({
    this.timestamp,
    this.status,
    this.trx_id,
    this.ref_id,
    this.error,
    this.passed,
    this.errors,
    this.data,
    this.gestures_set_results,
    this.gestures_set_names,
//    this.requestId,
//    this.error,
//    this.resultIdcard,
  });

  factory AsliResponseModel.fromJson(Map<String, dynamic> json) => AsliResponseModel(
    timestamp: json["timestamp"],
    status: json["status"],
    trx_id: json["trx_id"],
    ref_id: json["ref_id"],
    data: AsliDataModel.fromJson(json["data"]),
    errors: AsliErrorsModel.fromJson(json["errors"]),
    error:json["error"],
    passed:json["_passed"],
    //gestures_set_results: AsliGesturesSetResultsModel.fromJson(json["_gestures_set_results"]),
    //gestures_set_names: AsliGesturesSetNamesModel.fromJson(json["_gestures_set_names"]),
  );

  Map<String, dynamic> toJson() => {
    "timestamp": timestamp,
    "status": status,
    "data": data!.toJson(),
    "errors": errors!.toJson(),
    "trx_id": trx_id,
    "ref_id": ref_id,
    "error": error,
    "_passed":passed,
    "_gestures_set_results":gestures_set_results!.toJson(),
    "_gestures_set_names":gestures_set_names!.toJson(),
  };

//  factory AsliResponseModel.mouldMap(Map<String, dynamic> json)
//  {
////    timestamp=null;
////    status=null;
////    trx_id=null;
////    ref_id=null;
////    error=null;
////    passed=false;
////    data=null;
////    errors=null;
////    gestures_set_results=null;
////    gestures_set_names=null;
//
//    int timestamp=json.containsKey('trx_id')?json["timestamp"]:null;
//    int status=json.containsKey('trx_id')?json["status"]:null;
//    String trx_id=json.containsKey('trx_id')?json["trx_id"]:null;
//    String ref_id=json.containsKey('ref_id')?json["ref_id"]:null;
//    String error=json.containsKey('ref_id')?json["error"]:null;
//    String passed=json.containsKey('trx_id')?json["passed"]:null;
//
//    AsliDataModel data=json.containsKey('data')?AsliDataModel.mouldMap(json):null;
//    AsliErrorsModel errors=json.containsKey('errors')?AsliErrorsModel.mouldMap(json):null;
//    AsliGesturesSetResultsModel gestures_set_results=json.containsKey('gestures_set_results')?AsliGesturesSetResultsModel.mouldMap(json):null;
//    AsliGesturesSetNamesModel gestures_set_names=json.containsKey('trx_id')?AsliGesturesSetNamesModel.mouldMap(json):null;
//
//    return AsliResponseModel(timestamp,status,trx_id,ref_id,error,passed,errors,data,gestures_set_results,gestures_set_names);
//  }
}