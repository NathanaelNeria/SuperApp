import 'package:simple_app/asli/models/asli_data_model.dart';
import 'package:simple_app/asli/models/asli_errors_model.dart';
import 'package:simple_app/asli/models/asli_gestures_set_results_model.dart';
import 'package:simple_app/asli/models/asli_gestures_set_names_model.dart';


class AsliResponse2Model {
  int? timestamp;
  int? status;
  String? trx_id;
  String? ref_id;
  String? error;
  // Liveness Verification
  bool? passed;

  //ResultIdcard resultIdcard;
  AsliDataModel? data;
  AsliErrorsModel? errors;

  // Liveness Verification
  AsliGesturesSetResultsModel? gestures_set_results;
  AsliGesturesSetNamesModel? gestures_set_names;

  AsliResponse2Model({
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

//  Map<String, dynamic> responseMap(Map<String, dynamic> originalMap) {
//    Map<String, dynamic> responseMap;
//    if (originalMap.containsKey('trx_id')){
//      // do your work
//
//    }
//    return responseMap;
//  }
  AsliResponse2Model mouldMap(Map<String, dynamic> json)
  {
    timestamp=null;
    status=null;
    trx_id=null;
    ref_id=null;
    error=null;
    passed=false;
    data=null;
    errors=null;
    gestures_set_results=null;
    gestures_set_names=null;

    timestamp=json.containsKey('trx_id')?json[timestamp as String]:null;
    status=json.containsKey('trx_id')?json[status as String]:null;
    trx_id=json.containsKey('trx_id')?json[trx_id!]:null;
    ref_id=json.containsKey('ref_id')?json[ref_id!]:null;
    error=json.containsKey('ref_id')?json[error!]:null;
    passed=json.containsKey('trx_id')?json[passed as String]:null;
    //data=mouldData(json);

    return AsliResponse2Model();
  }


}