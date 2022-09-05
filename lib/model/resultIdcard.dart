class ResultIdcard {
  double confidence;

  ResultIdcard({
    this.confidence,
  });

  factory ResultIdcard.fromJson(Map<String, dynamic> json) => ResultIdcard(
    confidence: json["confidence"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "confidence": confidence,
  };
}