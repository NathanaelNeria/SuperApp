import 'package:json_annotation/json_annotation.dart';

class AsliGesturesSetNamesModel {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  AsliGesturesSetNamesModel({
    this.passed,
    this.gesturesSetResults,
    this.gesturesSetNames,
    this.gesturesSetBin,
  });

  bool passed;
  GesturesSetResults gesturesSetResults;
  GesturesSetNames gesturesSetNames;
  List<dynamic> gesturesSetBin;

  factory AsliGesturesSetNamesModel.fromJson(Map<String, dynamic> json) => AsliGesturesSetNamesModel(
    passed: json["_passed"],
    gesturesSetResults: GesturesSetResults.fromJson(json["_gestures_set_results"]),
    gesturesSetNames: GesturesSetNames.fromJson(json["_gestures_set_names"]),
    gesturesSetBin: List<String>.from(json["_gestures_set_bin"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "_passed": passed,
    "_gestures_set_results": gesturesSetResults.toJson(),
    "_gestures_set_names": gesturesSetNames.toJson(),
    "_gestures_set_bin": List<dynamic>.from(gesturesSetBin.map((x) => x)),
  };
}

class GesturesSetNames {
  GesturesSetNames({
    this.stage0,
  });

  List<dynamic> stage0;

  factory GesturesSetNames.fromJson(Map<String, dynamic> json) => GesturesSetNames(
    stage0: List<String>.from(json["Stage_0"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "Stage_0": List<dynamic>.from(stage0.map((x) => x)),
  };
}

class GesturesSetResults {
  GesturesSetResults({
    this.stage0,
  });

  List<dynamic> stage0;

  factory GesturesSetResults.fromJson(Map<String, dynamic> json) => GesturesSetResults(
    stage0: List<bool>.from(json["stage_0"].map((x) => x)),
  );

  Map<String, dynamic> toJson() => {
    "stage_0": List<dynamic>.from(stage0.map((x) => x)),
  };
}
