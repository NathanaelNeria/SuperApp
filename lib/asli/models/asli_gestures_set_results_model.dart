import 'package:json_annotation/json_annotation.dart';

class AsliGesturesSetResultsModel {
  @JsonKey(defaultValue: null)
  @JsonKey(required: false)
  List<bool> stage_0;

  AsliGesturesSetResultsModel({
    this.stage_0,
  });

  factory AsliGesturesSetResultsModel.fromJson(Map<String, dynamic> json) => AsliGesturesSetResultsModel(
    //stage_0: List<bool>.from(json["stage_0"].map((x)=> bool.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    //"stage_0": List<dynamic>.from(stage_0.map((x)=> x.toJson())),
  };
}

// PENDING masih pending cara parse list bool