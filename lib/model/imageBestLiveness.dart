class ImageBestLiveness {
  double? probability;
  double? score;
  double? quality;
  //ResultIdcard resultIdcard;

  ImageBestLiveness({
    this.probability,
    this.score,
    this.quality,
  });

  factory ImageBestLiveness.fromJson(Map<String, dynamic> json) => ImageBestLiveness(
    probability: json["probability"],
    score: json["score"],
    quality: json["quality"],
  );

  Map<String, dynamic> toJson() => {
    "probability": probability,
    "score": score,
    "quality": quality,
  };
}