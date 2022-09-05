import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:simple_app/model/faceVerifModel.dart';
import 'package:simple_app/model/ktpModel.dart';
import 'package:simple_app/model/ocrModel.dart';
import "package:image_cropper/image_cropper.dart";
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart';


class OkayfaceFfCloud2 extends StatefulWidget {
  //File imageFileProfile;
  //OkayfaceFfCloud2({this.imageFileProfile});
  OkayfaceFfCloud2();

  @override
  _OkayfaceFfCloud2State createState() => _OkayfaceFfCloud2State();
}

class _OkayfaceFfCloud2State extends State<OkayfaceFfCloud2> {
  File? _imageFileIdCard;
  var loading = false;
  bool _inProcess = false;
  var _reference = FirebaseStorage.instance.ref().child('myimage.jpg');
  late File imageFileProfile2;

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

  @override
  void initState() {
    _getThingsOnStartup().then((value){
      print('Async done');
    });
    super.initState();
  }

  Future _getThingsOnStartup() async {
    String downloadAddress=await _reference.getDownloadURL();
    Response downloadData = await get(downloadAddress as Uri);
    Directory systemTempDir = Directory.systemTemp;
    imageFileProfile2 = File('${systemTempDir.path}/tmp.jpg');
    if (imageFileProfile2.existsSync()) {
      await imageFileProfile2.delete();
    }
    await imageFileProfile2.create();
    var task = _reference.writeToFile(imageFileProfile2);
  }

  _getImage(BuildContext context, ImageSource source) async {

    this.setState(() {
      _inProcess = true;
    });
    var picked = await (ImagePicker()).pickImage(source: source);
    var picture = File(picked!.path);

    if(picture != null){
      File cropped = await (ImageCropper()).cropImage(
          sourcePath: picture.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 100,
          maxWidth: 300,
          maxHeight: 400,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Colors.blueAccent,
              toolbarTitle: "RPS Cropper",
              statusBarColor: Colors.blue,
              backgroundColor: Colors.white,
            ),
          ]
      ).then((value) => File(value!.path));
      this.setState(() {
        _imageFileIdCard = cropped;
        _inProcess = false;
      });
    }else{
      this.setState(() {
        _inProcess = false;
      });
    }


    Navigator.of(context).pop();
  }

  Widget _decideImageIdCardView() {
    if (_imageFileIdCard == null) {
      return Image.asset("images/no_photo_selected.png",
        width: 300.0,
        height: 400.0,
        fit: BoxFit.cover,);
    } else {
      return Image.file(
        _imageFileIdCard!,
        width: 300.0,
        height: 400.0,
        fit: BoxFit.cover,
      );
    }
  }

//  Future File downloadFirstPicture() async
//  {
//    String downloadAddress=await _reference.getDownloadURL();
//    Response downloadData = await get(downloadAddress);
//    Directory systemTempDir = Directory.systemTemp;
//    File tempFile = File('${systemTempDir.path}/tmp.jpg');
//    if (tempFile.existsSync()) {
//      await tempFile.delete();
//    }
//    await tempFile.create();
//    StorageFileDownloadTask task = _reference.writeToFile(tempFile);
//    int byteCount = (await task.future).totalByteCount;
//    var bodyBytes = downloadData.bodyBytes;
//    String name = await _reference.getName();
//    String path = await _reference.getPath();
//
//    print ('Success downloaded: $name \nUrl: $downloadAddress\nPath: $path\nBytes Count: $byteCount');
//    return tempFile;
//  }
  //OKAY FACE API START HERE
  comparingImages(BuildContext context) async {
    setState(() {
      loading = true;
    });

    // MAYA CODE START
//    String downloadAddress=await _reference.getDownloadURL();
//    Response downloadData = await get(downloadAddress);
//    Directory systemTempDir = Directory.systemTemp;
//    File imageFileProfile2 = File('${systemTempDir.path}/tmp.jpg');
//    if (imageFileProfile2.existsSync()) {
//      await imageFileProfile2.delete();
//    }
//    await imageFileProfile2.create();
//    StorageFileDownloadTask task = _reference.writeToFile(imageFileProfile2);
    // MAYA CODE ENDS

    String dialog = "";
    final imageBytes = _imageFileIdCard!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    try {
      var streamIdCard = http.ByteStream(
          DelegatingStream.typed(_imageFileIdCard!.openRead()));
      var lengthIdCard = await _imageFileIdCard!.length();
      var streamProfile = http.ByteStream(
          DelegatingStream.typed(imageFileProfile2.openRead()));
      var lengthProfile = await imageFileProfile2.length();
      var uri = Uri.parse("http://demo.faceid.asia/api/faceid/v2/verify");
      var request = http.MultipartRequest("POST", uri);


      request.fields['apiKey'] = "9TCM5oQ72DlXJK0ukbP6Aa0TM2KKKxlT";
      request.files.add(http.MultipartFile(
          "imageIdCard", streamIdCard, lengthIdCard,
          filename: path.basename(_imageFileIdCard!.path)));
      request.files.add(http.MultipartFile(
          "imageBest", streamProfile, lengthProfile,
          filename: path.basename(imageFileProfile2.path)));

      var response = await request.send();
      var respStr = await response.stream.bytesToString();


      Map<String, dynamic> listResult = jsonDecode(respStr.toString());
      FaceVerifModel faceVerifResult = FaceVerifModel.fromJson(listResult);

      if (faceVerifResult != null || faceVerifResult.resultIdcard != null) {

        dialog = "confidence: " +
            faceVerifResult.resultIdcard!.confidence.toString();

        if(faceVerifResult.resultIdcard!.confidence! > 75){
          dialog = "Confidence level more than 75. Those 2 photos are from the same person";
        }
        else{
          dialog = "Confidence level less than 75. Those 2 photos are not from the same person";
        }

      } else {
        dialog = "Unexpected Error";
      }
    } catch (e) {
      dialog = "ERROR NO FACE DETECTED";
      debugPrint("Error $e");
    }
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
                    ElevatedButton(
                      onPressed: () {
                        createAlertDialogIdCard(context);
                      },
                      child: Text("Take 2nd Selfie!"),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            comparingImages(context);
                          },
                          child: Text("Compare"),
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
