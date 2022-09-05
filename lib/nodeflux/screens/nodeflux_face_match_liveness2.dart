import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:image_cropper/image_cropper.dart";
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:simple_app/model/faceVerifModel.dart';
import 'package:simple_app/model/fetchIdCardModel.dart';
import 'package:simple_app/model/ktpModel.dart';
import 'package:simple_app/model/ocrModel.dart';
import 'package:simple_app/nodeflux/models/nodeflux_data_model.dart';
import 'package:simple_app/nodeflux/models/nodeflux_face_liveness_model.dart';
import 'package:simple_app/nodeflux/models/nodeflux_face_match_model.dart';
import 'package:simple_app/nodeflux/models/nodeflux_job_model.dart';
import 'package:simple_app/nodeflux/models/nodeflux_result2_model.dart';
import 'package:simple_app/nodeflux/models/nodeflux_result_model.dart';
import 'package:simple_app/views/fetchIdCard.dart';

class NodefluxFaceMatchLiveness2 extends StatefulWidget {
  File? imageFileProfile;

  NodefluxFaceMatchLiveness2({this.imageFileProfile});

  @override
  _NodefluxFaceMatchLiveness2State createState() =>
      _NodefluxFaceMatchLiveness2State();
}

class _NodefluxFaceMatchLiveness2State
    extends State<NodefluxFaceMatchLiveness2> {
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
    final picker = ImagePicker();
    var picture = await picker.pickImage(source: source);

    if (picture != null) {
      final cropper = ImageCropper();
      final cropped = await cropper.cropImage(
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
            ),
          ]);
      this.setState(() {
        _imageFileIdCard = File(cropped!.path);
        _inProcess = false;
      });
    } else {
      this.setState(() {
        _inProcess = false;
      });
    }

    Navigator.of(context).pop();
  }

  Widget _decideImageIdCardView() {
    if (_imageFileIdCard == null) {
      return Image.asset(
        "images/no_photo_selected.png",
        width: 300.0,
        height: 180.0,
        fit: BoxFit.cover,
      );
    } else {
      return Image.file(
        _imageFileIdCard!,
        width: 300.0,
        height: 180.0,
        fit: BoxFit.cover,
      );
    }
  }

  //nodeflux
  comparingImages(BuildContext context) async {
    setState(() {
      loading = true;
    });

    //String trx_id = 'Liveness_' + DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String authorization =
        'NODEFLUX-HMAC-SHA256 Credential=ZZC8MB2EHH01G3FX60ZNZS7KA/20201110/nodeflux.api.v1beta1.ImageAnalytic/StreamImageAnalytic, SignedHeaders=x-nodeflux-timestamp, Signature=5a6b903b95b8f3c9677169d69b13b4f790799ffba897405b7826770f51fd4a21';
    String contentType = 'application/json';
    String xnodefluxtimestamp = '20201110T135945Z';
    final imageBytesIdCard = _imageFileIdCard!.readAsBytesSync();
    String base64ImageIdCard =
        'data:image/jpeg;base64,' + base64Encode(imageBytesIdCard);
    final imageBytesLiveSelfie = _imageFileIdCard!.readAsBytesSync();
    String base64ImageLiveSelfie =
        'data:image/jpeg;base64,' + base64Encode(imageBytesLiveSelfie);
    String dialog = "";
    bool isPassed = false;
    String? currentStatus = '';
    String? resultMsg = '';
    var respbody;
    NodefluxDataModel nodefluxDataModel = NodefluxDataModel();
    NodefluxJobModel? nodefluxJobModel = NodefluxJobModel();
    NodefluxResultModel? nodefluxResultModel = NodefluxResultModel();
    NodefluxResult2Model nodefluxResult2Model = NodefluxResult2Model();
    FaceLiveness faceLivenessModel = FaceLiveness();
    FaceMatch faceModel = FaceMatch();
    NodefluxFaceLivenessModel nodefluxFaceLivenessModel =
        NodefluxFaceLivenessModel();
    Job? job = Job();
    JobResult? jobResult = JobResult();
    ResultElement1 resultElement1 = ResultElement1();
    ResultElement2 resultElement2 = ResultElement2();

    bool? okValue = true;
    try {
      // var data = "images: ["+ base64Image +"]";

      // var uri = Uri.parse(
      //     'https://api.cloud.nodeflux.io/v1/analytics/face-match-liveness');
      var url =
          'https://api.cloud.nodeflux.io/v1/analytics/face-match-liveness';
      // var response = http.post(uri, headers: {
      //   "Content-Type": "application/json",
      //   "x-nodeflux-timestamp": "20201110T135945Z",
      //       "Authorization": authorization,
      // }, body:data).then((http.Response response) {});
      List<String> photoBase64List = [];
      photoBase64List.add(base64ImageIdCard);
      photoBase64List.add(base64ImageLiveSelfie);

      late var response;
      while (resultMsg != 'Face Match with Liveness Success' || !okValue!) {
        response = await http.post(Uri.encodeFull(url) as Uri,
            body: json.encode({"images": photoBase64List}),
            headers: {
              "Accept": "application/json",
              "Content-Type": "application/json",
              "x-nodeflux-timestamp": "20201110T135945Z",
              "Authorization": authorization,
            });

        print(response.body);

        respbody = response.body;

        // Map<String, dynamic> listResult = jsonDecode(respbody.toString());
        // NodefluxFaceLivenessModel model = NodefluxFaceLivenessModel.fromJson(listResult);
        nodefluxDataModel =
            NodefluxDataModel.fromJson00(jsonDecode(response.body));
        nodefluxFaceLivenessModel =
            NodefluxFaceLivenessModel.fromJson00(jsonDecode(response.body));
        // okValue = nodefluxDataModel.ok;
        okValue = nodefluxFaceLivenessModel.ok;
        resultMsg = nodefluxFaceLivenessModel.message;
      }
      if (okValue) {
        nodefluxDataModel =
            NodefluxDataModel.fromJson0(jsonDecode(response.body));
        nodefluxFaceLivenessModel =
            NodefluxFaceLivenessModel.fromJson0(jsonDecode(respbody));
        nodefluxJobModel = nodefluxDataModel.job;
        nodefluxResultModel = nodefluxJobModel!.result;
        job = nodefluxFaceLivenessModel.job;
        jobResult = job!.result;
        resultElement1 = jobResult!.result![0];
        resultElement2 = jobResult.result2![1];
        // currentStatus = nodefluxResultModel.status;
        currentStatus = jobResult.status;
      } else {
        // dialog = nodefluxDataModel.message;
        dialog = nodefluxFaceLivenessModel.message ?? '';
        isPassed = false;
      }

      NodefluxFaceLivenessModel livenessModel = NodefluxFaceLivenessModel();
      NodefluxFaceMatchModel matchModel = NodefluxFaceMatchModel();
      if (respbody != null && currentStatus == "success") {
        // nodefluxDataModel=NodefluxDataModel.fromJsonForMatchLiveness(jsonDecode(response.body));
        nodefluxJobModel = nodefluxDataModel.job;
        nodefluxResultModel = nodefluxJobModel!.result;
        // nodefluxResult2Model = nodefluxResultModel.result[0];
        // livenessModel=nodefluxResult2Model.face_liveness[0];
        // matchModel=nodefluxResult2Model.face_match[0];
        resultElement1 = resultElement1;
        resultElement2 = resultElement2;
      }

      dialog += 'The selfie and the id photo do ';
      dialog += resultElement2.faceMatch!.match! ? '' : 'not ';
      dialog += 'match (';
      var similarityPercentageRaw = resultElement2.faceMatch!.similarity! * 100;
      dialog +=
          '(' + similarityPercentageRaw.toStringAsFixed(2) + '% similarity). ';
      dialog = 'This photo is taken from ';
      // interpret
      dialog += resultElement1.faceLiveness!.liveness! > 0.75
          ? 'a live person'
          : 'a non-live person';
      if (resultElement1.faceLiveness!.liveness! > 0.75) {
        isPassed = true;
        var livenessPercentage = resultElement1.faceLiveness!.liveness! * 100;
        dialog += '(' + livenessPercentage.toStringAsFixed(2) + '% accuracy)';
      }
    } catch (e) {
      debugPrint('Error $e');
      dialog = e.toString();
      createAlertDialog(context, isPassed ? 'Success!' : 'Failed', dialog);
    }

    setState(() {
      loading = false;
    });
    createAlertDialog(context, isPassed ? 'Success!' : 'Failed', dialog);
  }

  //OKAY FACE API START HERE
  comparingImages_original(BuildContext context) async {
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
          var streamProfile = http.ByteStream(
              DelegatingStream.typed(widget.imageFileProfile!.openRead()));
          var lengthProfile = await widget.imageFileProfile!.length();
          var uri = Uri.parse("http://demo.faceid.asia/api/faceid/v2/verify");
          var request = http.MultipartRequest("POST", uri);

          request.fields['apiKey'] = "9TCM5oQ72DlXJK0ukbP6Aa0TM2KKKxlT";
          request.files.add(http.MultipartFile(
              "imageIdCard", streamIdCard, lengthIdCard,
              filename: path.basename(_imageFileIdCard!.path)));
          request.files.add(http.MultipartFile(
              "imageBest", streamProfile, lengthProfile,
              filename: path.basename(widget.imageFileProfile!.path)));

//      print(imageBytes);
//      var fileContent = _imageFileIdCard.readAsBytesSync();
//      var fileContentBase64IdCard = base64.encode(fileContent);
//      print(base64Image.substring(0, 100));

          var response = await request.send();
          var respStr = await response.stream.bytesToString();
          Map<String, dynamic> listResult = jsonDecode(respStr.toString());
          FaceVerifModel faceVerifResult = FaceVerifModel.fromJson(listResult);

          if (faceVerifResult != null || faceVerifResult.resultIdcard != null) {
            dialog = "confidence: " +
                faceVerifResult.resultIdcard!.confidence.toString();

            if (faceVerifResult.resultIdcard!.confidence! > 75) {
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
                switch (ocr
                    .result![0].listVerifiedFields!.pFieldMaps![i].fieldType) {
                  case 2:
                    {
                      ficModel.nik = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 25:
                    {
                      ficModel.nama = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 6:
                    {
                      ficModel.tempatLahir = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 5:
                    {
                      ficModel.tglLahir = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 69271564:
                    {
                      ficModel.jenisKelamin = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 17:
                    {
                      ficModel.alamat = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 189:
                    {
                      ficModel.rtrw = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 77:
                    {
                      ficModel.kelurahan = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 64:
                    {
                      ficModel.kecamatan = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 363:
                    {
                      ficModel.agama = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 160:
                    {
                      ficModel.status = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                  case 312:
                    {
                      ficModel.pekerjaan = ocr.result![0].listVerifiedFields!
                          .pFieldMaps![i].fieldVisual;
                    }
                    break;
                }
              }
              //end ocr

              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FetchIdCard(ficModel)));
            } else {
              dialog = "Confidence level less than 75";
            }
          } else {
            dialog = "Unexpected Error";
          }

//      final responseIdCard= await http.post("https://okaydocdemo.innov8tif.com/ekyc/api/ekyc/v1/doc-verify/ektp-front",
////        body: {"apiKey": "aXtpWPxvnqPulVYCAY9RALWJfcv4rn-M", "idImageBase64Image": base64Image});
////      final data = jsonDecode(responseIdCard.body);
////      print(data);

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
    createAlertDialog(context, 'Failed', dialog);
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

  createAlertDialog(BuildContext context, String title, String? message) {
    Widget okButton = TextButton(
      child: Text("Close"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: Text(message!),
            actions: [
              okButton,
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Face vs Ktp - Take eKTP'),
        leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              // Write some code to control things, when user press back button in AppBar
              moveToLastScreen();
            }),
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
                                onPressed: () {
                                  (_imageFileIdCard == null)
                                      ? null
                                      : comparingImages(context);
                                },
                                child: Text("Compare",
                                    style: TextStyle(color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: (_imageFileIdCard == null)
                                      ? Colors.grey
                                      : Colors.lightBlue
                                ),
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
                  )),
      ),
    );
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}
