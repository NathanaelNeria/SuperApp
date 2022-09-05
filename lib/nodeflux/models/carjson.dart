class CarJson {
  String currentBase64Image;
  CarJson(this.currentBase64Image);
  Map<String, dynamic> TojsonData() {
    var map = new Map<String, dynamic>();
    map["images"] = currentBase64Image;
    return map;
  }
}

// class CarJson {
//   String OptionID;
//   CarJson(this.OptionID);
//   Map<String, dynamic> TojsonData() {
//     var map = new Map<String, dynamic>();
//     map["OptionID"] = OptionID;
//     return map;
//   }
// }