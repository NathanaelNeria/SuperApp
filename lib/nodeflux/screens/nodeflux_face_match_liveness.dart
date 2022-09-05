import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/nodeflux/screens/nodeflux_face_match_liveness2.dart';

class NodefluxFaceMatchLiveness extends StatefulWidget {
  @override
  _NodefluxFaceMatchLivenessState createState() =>
      _NodefluxFaceMatchLivenessState();
}

class _NodefluxFaceMatchLivenessState extends State<NodefluxFaceMatchLiveness> {
  File? _imageFileProfile, _imageFileIdCard;
  String? idProfile;
  bool _inProcess = false;
  final _key = new GlobalKey<FormState>();

  getPerf() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      idProfile = preferences.getString("id");
    });
  }

  _getImage(BuildContext context, ImageSource source) async {
    this.setState(() {
      _inProcess = true;
    });

    final picker = ImagePicker();
    var picture = await picker.pickImage(source: source);
    if (picture != null) {
      File cropped = picture as File;
      // File cropped = await ImageCropper.cropImage(
      //     sourcePath: picture.path,
      //     aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
      //     //compressQuality: 100,
      //     maxWidth: 300,
      //     maxHeight: 400,
      //     //compressFormat: ImageCompressFormat.jpg,
      //     androidUiSettings: AndroidUiSettings(
      //       toolbarColor: Colors.blueAccent,
      //       toolbarTitle: "RPS Cropper",
      //       statusBarColor: Colors.blue,
      //       backgroundColor: Colors.white,
      //     )
      // );
      this.setState(() {
        _imageFileProfile = cropped;
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }
    Navigator.of(context).pop();
  }

  createAlertDialogProfile(BuildContext context) {
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

  Widget _decideImageProfileView() {
    if (_imageFileProfile == null) {
      return Image.asset(
        "images/no_photo_selected.png",
        width: 300.0,
        height: 400.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        _imageFileProfile!,
        width: 300.0,
        height: 400.0,
        fit: BoxFit.cover,
      );
    }
  }

  // check(BuildContext context) {
  //   submit(context);
  //
  // }
  //
  // submit(BuildContext context) async {
  //   try {
  //     var stream = http.ByteStream(DelegatingStream.typed(_imageFileProfile.openRead()));
  //     var length = await _imageFileProfile.length();
  //     var streamIdCard = http.ByteStream(DelegatingStream.typed(_imageFileIdCard.openRead()));
  //     var lengthIdCard = await _imageFileIdCard.length();
  //     var uri = Uri.parse(BaseUrl.updateProfile);
  //     var request = http.MultipartRequest("POST", uri);
  //
  //     request.fields['id'] = idProfile;
  //     request.files.add(http.MultipartFile("imageProfile",stream,length,filename: path.basename(_imageFileProfile.path)));
  //     request.files.add(http.MultipartFile("imageIdCard",streamIdCard,lengthIdCard,filename: path.basename(_imageFileIdCard.path)));
  //
  //     var response = await request.send();
  //     if(response.statusCode > 2){
  //       print("image uploaded");
  //       comparingImages(context);
  //     }else{
  //       print("image failed upload");
  //     }
  //   } catch (e) {
  //     debugPrint("Error $e");
  //   }
  // }

  //START OKAYFACE
  comparingImages(BuildContext context) async {
    try {
      var streamIdCard =
          http.ByteStream(DelegatingStream.typed(_imageFileIdCard!.openRead()));
      var lengthIdCard = await _imageFileIdCard!.length();
      var streamProfile =
          http.ByteStream(DelegatingStream.typed(_imageFileProfile!.openRead()));
      var lengthProfile = await _imageFileProfile!.length();
      var uri = Uri.parse("http://demo.faceid.asia/api/faceid/v2/verify");
      var request = http.MultipartRequest("POST", uri);

      request.fields['apiKey'] = "9TCM5oQ72DlXJK0ukbP6Aa0TM2KKKxlT";
      request.files.add(http.MultipartFile(
          "imageIdCard", streamIdCard, lengthIdCard,
          filename: path.basename(_imageFileIdCard!.path)));
      request.files.add(http.MultipartFile(
          "imageBest", streamProfile, lengthProfile,
          filename: path.basename(_imageFileProfile!.path)));

      var fileContent = _imageFileIdCard!.readAsBytesSync();
      var fileContentBase64IdCard = base64.encode(fileContent);
      print(fileContentBase64IdCard.toString());

      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      createAlertDialog(context,
          respStr.substring(respStr.indexOf(",") + 1, respStr.length - 1));
    } catch (e) {
      debugPrint("Error $e");
    }
  }

  //END OKAYFACE

//  Future<void> _getImages() async{
//
//    final response = await http.post(BaseUrl.getProfileImages,
//        body: {"id": idProfile});
//    final data = jsonDecode(response.body);
//    int value = data['value'];
//    String message = data['message'];
//    String imageProfile = data['imageProfile'];
//    String imageIdCard = data['imageIdCard'];
//    if (value == 1) {
//      setState(() {
//        _imageFileIdCard = File('http://172.19.247.249/api/upload/'+imageIdCard);
//        _imageFileProfile = File('http://172.19.247.249/api/upload/'+imageProfile);
//      });
//      print(message);
//    } else {
//      print(message);
//    }
//
//  }
  createAlertDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(message));
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPerf();
//    _getImages();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        } as Future<bool> Function()?,
        child: Scaffold(
            appBar: AppBar(
              title: Text('Face vs Ktp - Take Selfie'),
              leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    // Write some code to control things, when user press back button in AppBar
                    moveToLastScreen();
                  }),
            ),
            body: Container(
                key: _key,
                child: Center(
                    child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _decideImageProfileView(),
                        ElevatedButton(
                          onPressed: () {
                            createAlertDialogProfile(context);
                          },
                          child: Text("Select Selfie Image!"),
                        ),
//                    _decideImageIdCardView(),
//                    ElevatedButton(
//                      onPressed: () {
//                        createAlertDialogIdCard(context);
//                      },
//                      child: Text("Select Image Id Card!"),
//                    ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
//                        ElevatedButton(
//                          onPressed: () {
//                            check(context);
//                          },
//                          child: Text("Upload"),
//                        ),
//                        Padding(padding: EdgeInsets.all(8.0)),
                            ElevatedButton(
                              onPressed: () {
//                            comparingImages(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    //builder: (context) => UploadIdCard(imageFileProfile: _imageFileProfile,)));
                                    builder: (context) =>
                                        NodefluxFaceMatchLiveness2(
                                          imageFileProfile: _imageFileProfile,
                                        )));
                              },
                              child: Text("Get Started"),
                            )
                          ],
                        )
                      ],
                    ),
                    (_inProcess)
                        ? Container(
                            color: Colors.white,
                            height: MediaQuery.of(context).size.height * 0.95,
                            child: Center(
                              child: CircularProgressIndicator(),
                            ),
                          )
                        : Center()
                  ],
                )))));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
/*@override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          key: _key,
            child: Center(
                child: Stack(
                  children: <Widget>[
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _decideImageProfileView(),
                        ElevatedButton(
                          onPressed: () {
                            createAlertDialogProfile(context);
                          },
                          child: Text("Select Selfie Image!"),
                        ),
//                    _decideImageIdCardView(),
//                    ElevatedButton(
//                      onPressed: () {
//                        createAlertDialogIdCard(context);
//                      },
//                      child: Text("Select Image Id Card!"),
//                    ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
//                        ElevatedButton(
//                          onPressed: () {
//                            check(context);
//                          },
//                          child: Text("Upload"),
//                        ),
//                        Padding(padding: EdgeInsets.all(8.0)),
                            ElevatedButton(
                              onPressed: () {
//                            comparingImages(context);
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => UploadIdCard(imageFileProfile: _imageFileProfile,)));

                              },
                              child: Text("Get Started"),
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
    )));
  }*/
}
