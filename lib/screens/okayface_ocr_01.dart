import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:simple_app/model/fetchIdCardModel.dart';
import 'package:simple_app/model/ktpModel.dart';
import 'package:simple_app/model/ocrModel.dart';
import 'package:simple_app/views/fetchIdCard.dart';
import "package:image_cropper/image_cropper.dart";


class OkayfaceOcr extends StatefulWidget {
//  File imageFileProfile;
//  OkayfaceOcr1({this.imageFileProfile});

  @override
  _OkayfaceOcrState createState() => _OkayfaceOcrState();
}

class _OkayfaceOcrState extends State<OkayfaceOcr> {
  File? _imageFileIdCard;
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
    var picture = await (ImagePicker()).pickImage(source: source);

    if(picture != null){
      File cropped = await (ImageCropper()).cropImage(
          sourcePath: picture.path,
          aspectRatio: CropAspectRatio(ratioX: 8, ratioY: 5),
          compressQuality: 100,
          maxWidth: 640,
          maxHeight: 480,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Colors.deepOrange,
              toolbarTitle: "RPS Cropper",
              statusBarColor: Colors.deepOrange.shade900,
              backgroundColor: Colors.white,
            )
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
        height: 180.0,
        fit: BoxFit.cover,);
    } else {
      return Image.file(
        _imageFileIdCard!,
        width: 300.0,
        height: 180.0,
        fit: BoxFit.cover,
      );
    }
  }

  //OKAY FACE API START HERE
  comparingImages(BuildContext context) async {
    setState(() {
      loading = true;
    });

    FetchIdCardModel ficModel = new FetchIdCardModel();

    String dialog = "";
    final imageBytes = _imageFileIdCard!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    String url =
        'https://okaydocdemo.innov8tif.com/ekyc/api/ekyc/v1/doc-verify/ektp-front';
    Map map = {
      'apiKey': 'aXtpWPxvnqPulVYCAY9RALWJfcv4rn-M',
      'idImageBase64Image': base64Image
    };

//    print(map);

    KtpModel ktp = await apiRequest(url, map);
    int pass = 0;
    if (ktp.status == "success") {
      //for (int i = 0; i < 5; i++) { // NOTE: ERROR API: SEMENTARA DARI 5 DIGANTI 4 20200915
      for (int i = 0; i < 4; i++) {
        print(double.parse(ktp.methodList![0].componentList![i].value!));
        if (double.parse(ktp.methodList![0].componentList![i].value!) > 30) {
          pass = pass + 1;
        }
      }
      print("pass : " + pass.toString());
      //if (pass < 3) { // NOTE: ERROR API: SEMENTARA DARI 3 DIGANTI 2 20200915
      if (pass < 2) {
        dialog = "Check authentication of your Id Card!";
      } else {

        try {
          var streamIdCard = http.ByteStream(
              DelegatingStream.typed(_imageFileIdCard!.openRead()));
          var lengthIdCard = await _imageFileIdCard!.length();

          //start ocr
          String url = 'https://okayiddemo.innov8tif.com/okayid/api/v1/ocr';
          Map map = {
            'apiKey': 'm9c1urQ4b8SL7cBIEzzXDUviSadSfPJB',
            'base64ImageString': base64Image
          };

          OcrModel ocr = await apiRequestOcr(url, map);

          for (int i = 0;
          i < ocr.result![0].listVerifiedFields!.pFieldMaps!.length;
          i++) {
            switch (
            ocr.result![0].listVerifiedFields!.pFieldMaps![i].fieldType) {
              case 2:
                {
                  ficModel.nik = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 25:
                {
                  ficModel.nama = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 6:
                {
                  ficModel.tempatLahir = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 5:
                {
                  ficModel.tglLahir = "17/12/1984";
//                  ficModel.tglLahir = ocr
//                      .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
                }
                break;
              case 69271564:
                {
                  ficModel.jenisKelamin = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 17:
                {
                  ficModel.alamat = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 189:
                {
                  ficModel.rtrw = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 77:
                {
                  ficModel.kelurahan = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 64:
                {
                  ficModel.kecamatan = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 363:
                {
                  ficModel.agama = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 160:
                {
                  ficModel.status = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
              case 312:
                {
                  ficModel.pekerjaan = ocr
                      .result![0].listVerifiedFields!.pFieldMaps![i].fieldVisual;
                }
                break;
            }
          }
          //end ocr
          dialog="Real eKTP Document confirmed";
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => FetchIdCard(ficModel)));

        } catch (e) {
          dialog = "ERROR NO FACE DETECTED";
          debugPrint("Error $e");
        }
      }
    } else {
      dialog = "Unexpected Error";
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
        title: Text('OCR KTP'),
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
                      child: Text("Select Image Id Card!",
                          style: TextStyle(color: Colors.white)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue,
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (_imageFileIdCard==null) ? Colors.black12: Colors.lightBlue,
                          ),
                          onPressed: () {
                            (_imageFileIdCard==null) ? null: comparingImages(context);
                          },
                          child: Text("Process",
                              style: TextStyle(color: Colors.white)),
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

  showProcessButton()
  {

  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
