import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:simple_app/model/faceVerifModel.dart';
import 'package:simple_app/model/fetchIdCardModel.dart';
import 'package:simple_app/model/ktpModel.dart';
import 'package:simple_app/model/ocrModel.dart';
import 'package:simple_app/views/fetchIdCard.dart';
import "package:image_cropper/image_cropper.dart";


class OkayfaceFacevsface2 extends StatefulWidget {
  File imageFileProfile;
  OkayfaceFacevsface2({this.imageFileProfile});

  @override
  _OkayfaceFacevsface2State createState() => _OkayfaceFacevsface2State();
}

class _OkayfaceFacevsface2State extends State<OkayfaceFacevsface2> {
  File _imageFileIdCard;
  var loading = false;
  bool _inProcess = false;

  createAlertDialogIdCard(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Make a Choice!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallery"),
                    onTap: () {
                      _getImage(context, ImageSource.gallery);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: () {
                      _getImage(context, ImageSource.camera);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }


  _getImage(BuildContext context, ImageSource source) async {

    this.setState(() {
      _inProcess = true;
    });
    var picture = await ImagePicker.pickImage(source: source);

    if(picture != null){
//      File cropped = await ImageCropper.cropImage(
//          sourcePath: picture.path,
//          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
//          compressQuality: 100,
//          maxWidth: 300,
//          maxHeight: 400,
//          compressFormat: ImageCompressFormat.jpg,
//          androidUiSettings: AndroidUiSettings(
//            toolbarColor: Colors.blueAccent,
//            toolbarTitle: "RPS Cropper",
//            statusBarColor: Colors.blue,
//            backgroundColor: Colors.white,
//          )
//      );
      this.setState(() {
        //_imageFileProfile = cropped; // commented because cropped is commented
        _imageFileIdCard = picture;
        _inProcess = false;
      });
    }else{
      this.setState(() {
        _inProcess = false;
      });
    }


    //Navigator.of(context).pop(); // COMMENTED BECAUSE PT SOS 20200915
  }

  Widget _decideImageIdCardView() {
    if (_imageFileIdCard == null) {
      return Image.asset("images/no_photo_selected.png",
        width: 300.0,
        height: 400.0,
        fit: BoxFit.cover,);
    } else {
      return Image.file(
        _imageFileIdCard,
        width: 300.0,
        height: 400.0,
        fit: BoxFit.cover,
      );
    }
  }

  //OKAY FACE API START HERE
  comparingImages(BuildContext context) async {
    setState(() {
      loading = true;
    });

    //FetchIdCardModel ficModel = new FetchIdCardModel();

    String dialog = "";
    final imageBytes = _imageFileIdCard.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

//    String url =
//        'https://okaydocdemo.innov8tif.com/ekyc/api/ekyc/v1/doc-verify/ektp-front';
//    Map map = {
//      'apiKey': 'aXtpWPxvnqPulVYCAY9RALWJfcv4rn-M',
//      'idImageBase64Image': base64Image
//    };

//    print(map);

//    KtpModel ktp = await apiRequest(url, map);
//    int pass = 0;
//    if (ktp.status == "success") {
//      for (int i = 0; i < 5; i++) {
//        print(double.parse(ktp.methodList[0].componentList[i].value));
//        if (double.parse(ktp.methodList[0].componentList[i].value) > 30) {
//          pass = pass + 1;
//        }
//      }
//      print("pass : " + pass.toString());
//      if (pass < 3) {
//        dialog = "Check authentication of your Id Card!";
//      } else {

    try {
      var streamIdCard = http.ByteStream(
          DelegatingStream.typed(_imageFileIdCard.openRead()));
      var lengthIdCard = await _imageFileIdCard.length();
      var streamProfile = http.ByteStream(
          DelegatingStream.typed(widget.imageFileProfile.openRead()));
      var lengthProfile = await widget.imageFileProfile.length();
      //var uri = Uri.parse("http://demo.faceid.asia/api/faceid/v2/verify");
      var uri = Uri.parse("http://demo.faceid.asia/api/faceid/v2-1/verify");
      var request = http.MultipartRequest("POST", uri);

      request.fields['apiKey'] = "9TCM5oQ72DlXJK0ukbP6Aa0TM2KKKxlT";
      request.files.add(http.MultipartFile(
          "imageIdCard", streamIdCard, lengthIdCard,
          filename: path.basename(_imageFileIdCard.path)));
      request.files.add(http.MultipartFile(
          "imageBest", streamProfile, lengthProfile,
          filename: path.basename(widget.imageFileProfile.path)));

//      print(imageBytes);
//      var fileContent = _imageFileIdCard.readAsBytesSync();
//      var fileContentBase64IdCard = base64.encode(fileContent);
//      print(base64Image.substring(0, 100));

      var response = await request.send();
      var respStr = await response.stream.bytesToString();


      Map<String, dynamic> listResult = jsonDecode(respStr.toString());
      FaceVerifModel faceVerifResult = FaceVerifModel.fromJson(listResult);

      if (faceVerifResult != null || faceVerifResult.resultIdcard != null) {
        String livenessInfo= faceVerifResult.imageBestLiveness.probability>0.5? "Photo taken from live person. \n":"Photo is not taken live. \n";
        dialog = "confidence: " +
            faceVerifResult.resultIdcard.confidence.toString();

        if(faceVerifResult.resultIdcard.confidence > 75){
          dialog = livenessInfo+"Confidence level more than 75 means those 2 photos are from the same person";
        }
        else{
          dialog = livenessInfo+"Confidence level less than 75 means those 2 photos are not from the same person";
        }

      } else {
        dialog = "Unexpected Error";
      }

//      final responseIdCard= await http.post("https://okaydocdemo.innov8tif.com/ekyc/api/ekyc/v1/doc-verify/ektp-front",
////        body: {"apiKey": "aXtpWPxvnqPulVYCAY9RALWJfcv4rn-M", "idImageBase64Image": base64Image});
////      final data = jsonDecode(responseIdCard.body);
////      print(data);



    } catch (e) {
      dialog = "Error. No face detected or file size is too small";
      debugPrint("Error $e");
    }
//      }
//    }
//    else {
//      dialog = "Unexpected Error";
//    }
    setState(() {
      loading = false;
    });
    createAlertDialog(context, dialog);
  }


  apiRequest(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    var result = new StringBuffer();
    await for (var contents in response.transform(utf8.decoder)) {
      result.write(contents);
    }

    Map<String, dynamic> myList = jsonDecode(result.toString());

    KtpModel sample = KtpModel.fromJson(myList);

    httpClient.close();
    return sample;
  }

  apiRequestOcr(String url, Map jsonMap) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    HttpClientResponse response = await request.close();
    // todo - you should check the response.statusCode
    var result = new StringBuffer();
    await for (var contents in response.transform(utf8.decoder)) {
      result.write(contents);
    }

    Map<String, dynamic> myList = jsonDecode(result.toString());

    OcrModel sample = OcrModel.fromJson(myList);

    httpClient.close();
    return sample;
  }
  //OKAY FACE API END HERE

  createAlertDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(message));
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face vs Face - Take 2nd Selfie'),
        leading: IconButton(icon: Icon(
            Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            }
        ),
      ),
      body: Container(
        child: Center(
            child: loading
                ? Center(child: CircularProgressIndicator())
                : Stack(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    _decideImageIdCardView(),
                    RaisedButton(
                      onPressed: () {
                        //createAlertDialogIdCard(context); // COMMENTED FOR PT SOS 20200915
                        _getImage(context, ImageSource.camera); // Use this for PT SOS 20200915 Commented on 20200916
                      },
                      child: Text("Take 2nd Selfie!",
                          style: TextStyle(color: Colors.white)),
                      color: Colors.lightBlue,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        RaisedButton(
                          onPressed: () {
                            (_imageFileIdCard==null) ? null:comparingImages(context);
                          },
                          child: Text("Compare",
                              style: TextStyle(color: Colors.white)),
                          color: (_imageFileIdCard==null) ? Colors.grey: Colors.lightBlue,
                        )
                      ],
                    )
                  ],
                ),
                (_inProcess) ? Container(
                  color: Colors.white,
                  height: MediaQuery.of(context).size.height * 0.95,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ):Center()
              ],
            )
        ),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
