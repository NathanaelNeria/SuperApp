import 'dart:convert';

NodefluxFaceLivenessModel nodefluxFaceLivenessModelFromJson(String str) => NodefluxFaceLivenessModel.fromJson(json.decode(str));

String nodefluxFaceLivenessModelToJson(NodefluxFaceLivenessModel data) => json.encode(data.toJson());

class NodefluxFaceLivenessModel {
  Job job;
  String message;
  bool ok;

  NodefluxFaceLivenessModel({
    this.job,
    this.message,
    this.ok,
  });

  factory NodefluxFaceLivenessModel.fromJson(Map<String, dynamic> json) => NodefluxFaceLivenessModel(
    job: Job.fromJson(json["job"]),
    message: json["message"],
    ok: json["ok"],
  );

  factory NodefluxFaceLivenessModel.fromJson00(Map<String, dynamic> json) => NodefluxFaceLivenessModel(
    // job: Job.fromJson(json["job"]),
    message: json["message"],
    ok: json["ok"],
  );

  Map<String, dynamic> toJson() => {
    "job": job.toJson(),
    "message": message,
    "ok": ok,
  };

  factory NodefluxFaceLivenessModel.fromJson0(Map<String, dynamic> json) => NodefluxFaceLivenessModel(
    message: json["message"],
    ok: json["ok"],
    job: Job.fromJson(json["job"]),
  );
}

class Job {
  Job({
    this.id,
    this.result,
  });

  String id;
  JobResult result;

  factory Job.fromJson(Map<String, dynamic> json) => Job(
    id: json["id"],
    result: JobResult.fromJson(json["result"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "result": result.toJson(),
  };

  factory Job.fromJson0(Map<String, dynamic> json) => Job(
    id: json["id"],
    result: JobResult.fromJson0(json["result"]),
  );
}

class JobResult {
  JobResult({
    this.status,
    this.analyticType,
    this.result,
    this.result2
  });

  String status;
  String analyticType;
  List<ResultElement1> result;
  List<ResultElement2> result2;

  factory JobResult.fromJson(Map<String, dynamic> json) => JobResult(
    status: json["status"],
    analyticType: json["analytic_type"],
    result: List<ResultElement1>.from(json["result"].map((x) => ResultElement1.fromJson(x))),
    result2: List<ResultElement2>.from(json["result"].map((x) => ResultElement2.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "analytic_type": analyticType,
    "result": List<dynamic>.from(result.map((x) => x.toJson())),
  };

  factory JobResult.fromJson0(Map<String, dynamic> json) => JobResult(
    status: json["status"],
    analyticType: json["analytic_type"],
  );
}

class ResultElement1 {
  ResultElement1({
    this.faceLiveness,
  });

  FaceLiveness faceLiveness;

  factory ResultElement1.fromJson(Map<String, dynamic> json) => ResultElement1(
    faceLiveness: json["face_liveness"] == null ? null : FaceLiveness.fromJson(json["face_liveness"]),
  );

  Map<String, dynamic> toJson() => {
    "face_liveness": faceLiveness == null ? null : faceLiveness.toJson(),
  };
}

class ResultElement2 {
  ResultElement2({
    this.faceMatch,
  });

  FaceMatch faceMatch;

  factory ResultElement2.fromJson(Map<String, dynamic> json) => ResultElement2(
    faceMatch: json["face_match"] == null ? null : FaceMatch.fromJson(json["face_match"]),
  );

  Map<String, dynamic> toJson() => {
    "face_match": faceMatch == null ? null : faceMatch.toJson(),
  };
}

class FaceLiveness {
  FaceLiveness({
    this.live,
    this.liveness,
  });

  bool live;
  double liveness;

  factory FaceLiveness.fromJson(Map<String, dynamic> json) => FaceLiveness(
    live: json["live"],
    liveness: json["liveness"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "live": live,
    "liveness": liveness,
  };
}

class FaceMatch {
  FaceMatch({
    this.match,
    this.similarity,
  });

  bool match;
  double similarity;

  factory FaceMatch.fromJson(Map<String, dynamic> json) => FaceMatch(
    match: json["match"],
    similarity: json["similarity"],
  );

  Map<String, dynamic> toJson() => {
    "match": match,
    "similarity": similarity,
  };
}
