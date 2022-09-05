import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:simple_app/model/ktpModel.dart';
//import 'package:simple_app/views/fetchIdCard.dart';
import "package:image_cropper/image_cropper.dart";



class NodefluxOcrKtp extends StatefulWidget {
//  File imageFileProfile;
//  OkayfaceOcr1({this.imageFileProfile});

  @override
  _NodefluxOcrKtpState createState() => _NodefluxOcrKtpState();
}

class _NodefluxOcrKtpState extends State<NodefluxOcrKtp> {
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

    if(picture != null){
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
          ]
      );
      this.setState(() {
        _imageFileIdCard = File(cropped!.path);
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

  nodefluxOcrKtpProcess(BuildContext context) async{
    setState(() {
      loading = true;
    });
    //String trx_id = 'Liveness_' + DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String authorization = 'NODEFLUX-HMAC-SHA256 Credential=ZZC8MB2EHH01G3FX60ZNZS7KA/20201110/nodeflux.api.v1beta1.ImageAnalytic/StreamImageAnalytic, SignedHeaders=x-nodeflux-timestamp, Signature=5a6b903b95b8f3c9677169d69b13b4f790799ffba897405b7826770f51fd4a21';
    String contentType = 'application/json';
    String xnodefluxtimestamp='20201110T135945Z';
    final imageBytes = _imageFileIdCard!.readAsBytesSync();
    String base64Image = 'data:image/jpeg;base64,'+base64Encode(imageBytes);
    String dialog = "";
    bool isPassed=false;
    try{
      // var data = "images: ["+ base64Image +"]";

      var uri = Uri.parse('https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp');
      var url='https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp';
      // var response = http.post(uri, headers: {
      //   "Content-Type": "application/json",
      //   "x-nodeflux-timestamp": "20201110T135945Z",
      //       "Authorization": authorization,
      // }, body:data).then((http.Response response) {});
      List<String> photoBase64List=[];
      photoBase64List.add(base64Image);

      var response = await http
          .post(Uri.encodeFull(url) as Uri, body: json.encode({
        "images":photoBase64List
      }), headers: {"Accept": "application/json",  "Content-Type": "application/json",
        "x-nodeflux-timestamp": "20201110T135945Z",
        "Authorization": authorization,});

      print(response.body);

      // List<Map> carOptionJson = new List();
      // CarJson carJson = new CarJson(base64Image);
      // carOptionJson.add(carJson.TojsonData());

      // var body = json.encode({
      //   "LstUserOptions": carOptionJson
      // });

      // var data = "images: ["+ base64Image +"]";

      // http.Response response = await http.post("https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp", body: data,
      //     headers: {'Content-type': 'application/json', 'Authorization':authorization, 'x-nodeflux-timestamp':xnodefluxtimestamp});


      // http.Response response = await http.post(
      //     Uri.encodeFull('https://api.cloud.nodeflux.io/v1/analytics/ocr-ktp'),
      //     body: body,
      //     headers: {'Content-type': 'application/json', 'Authorization':authorization, 'x-nodeflux-timestamp':xnodefluxtimestamp});

      var request = new http.MultipartRequest('POST', uri);


      // request.fields['trx_id'] = trx_id;
      // request.fields['gestures_set'] = gestureSetSelected;
      // request.headers['token'] = token;
      request.headers['Content-Type'] = contentType;
      request.headers['Authorization']= authorization;
      request.headers['x-nodeflux-timestamp']=xnodefluxtimestamp;
      // for (int i=0;i<livenessCompressedPhotos.length;i++) {
      //   request.files.add(http.MultipartFile('file', File(livenessCompressedPhotos[i].path).readAsBytes().asStream(), File(livenessCompressedPhotos[i].path).lengthSync(), filename: basename(livenessCompressedPhotos[i].path)));
      // }
      request.fields['images']=base64Image;
      //request.files.add(http.MultipartFile('images', File(photo1Compressed.path).readAsBytes().asStream(), File(photo1Compressed.path).lengthSync(), filename: basename(photo1Compressed.path)));
//      request.files.add(http.MultipartFile('file', File(photo1Compressed.path).readAsBytes().asStream(), File(photo1Compressed.path).lengthSync(), filename: basename(photo1Compressed.path)));

      // comentted start
      // var response = await request.send();
      // var resStr = await response.stream.bytesToString();
      // print(resStr);

      // Map<String, dynamic> listResult = jsonDecode(resStr.toString());
      // NodefluxDataModel nodefluxDataModel=NodefluxDataModel.fromJson(listResult);
      // NodefluxResultModel nodefluxResultModel = nodefluxDataModel.result;
      // //NodefluxResult2Model nodefluxResult2Model = nodefluxResultModel.result[0];
      // //AsliGesturesSetNamesModel gestureModel = AsliGesturesSetNamesModel.fromJson(listResult);
      //
      // // decipherin result
      // if (nodefluxResultModel.status=="on going" && nodefluxDataModel.message=="Job successfully submitted") {
      //   // wait 1 second, call this method again
      //   //await controller.takePicture(filePath);
      //   Future<File> result=Future.delayed(Duration(milliseconds: 1000), () {
      //     nodefluxOcrKtpProcess(context);
      //   });
      // } else if (nodefluxResultModel.status=="success" && nodefluxDataModel.message=="OCR Success") { // if photo ktp
      //     // process
      //     dialog="OCR Process success";
      //     isPassed=true;
      //     Navigator.of(context).push(MaterialPageRoute(
      //         builder: (context) => NodefluxOcrKtpResult(nodefluxResultModel.result[0])));
      // } else if (nodefluxDataModel.message=="The image might be in wrong orientation") { // if photo not ktp/ wrong orientation
      //   dialog=nodefluxDataModel.message+" or photo is not KTP";
      // } else {// if status not success or on going
      //   dialog="The image might be in wrong orientation or photo is not KTP";
      // }
    }
    catch(e){
      debugPrint('Error $e');
    }
//    await photo1Compressed.delete();
//    await photo2Compressed.delete();
//    await photo3Compressed.delete();
//    await photo4Compressed.delete();
//    await photo5Compressed.delete();
//    await photo6Compressed.delete();
//    await photo7Compressed.delete();
//    await photo8Compressed.delete();
    setState(() {
      loading = false;
    });
    createAlertDialog(context,isPassed?'Success!':'Failed',dialog);
  }
  //OKAY FACE API START HERE
//   comparingImages(BuildContext context) async {
//     setState(() {
//       loading = true;
//     });
//
//     FetchIdCardModel ficModel = new FetchIdCardModel();
//
//     String dialog = "";
//     final imageBytes = _imageFileIdCard.readAsBytesSync();
//     String base64Image = base64Encode(imageBytes);
//
//         // try {
//           var streamIdCard = http.ByteStream(
//               DelegatingStream.typed(_imageFileIdCard.openRead()));
//           var lengthIdCard = await _imageFileIdCard.length();
//
//           //start ocr
//           String url = 'https://okayiddemo.innov8tif.com/okayid/api/v1/ocr';
//           Map map = {
//             'apiKey': 'm9c1urQ4b8SL7cBIEzzXDUviSadSfPJB',
//             'base64ImageString': base64Image
//           };
//
//           OcrModel ocr = await apiRequestOcr(url, map);
//
//           for (int i = 0;
//           i < ocr.result[0].listVerifiedFields.pFieldMaps.length;
//           i++) {
//             switch (
//             ocr.result[0].listVerifiedFields.pFieldMaps[i].fieldType) {
//               case 2:
//                 {
//                   ficModel.nik = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 25:
//                 {
//                   ficModel.nama = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 6:
//                 {
//                   ficModel.tempatLahir = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 5:
//                 {
//                   ficModel.tglLahir = "17/12/1984";
// //                  ficModel.tglLahir = ocr
// //                      .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 69271564:
//                 {
//                   ficModel.jenisKelamin = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 17:
//                 {
//                   ficModel.alamat = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 189:
//                 {
//                   ficModel.rtrw = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 77:
//                 {
//                   ficModel.kelurahan = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 64:
//                 {
//                   ficModel.kecamatan = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 363:
//                 {
//                   ficModel.agama = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 160:
//                 {
//                   ficModel.status = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//               case 312:
//                 {
//                   ficModel.pekerjaan = ocr
//                       .result[0].listVerifiedFields.pFieldMaps[i].fieldVisual;
//                 }
//                 break;
//             }
//           }
//           //end ocr
//           dialog="Real eKTP Document confirmed";
//           Navigator.of(context).push(MaterialPageRoute(
//               builder: (context) => NodefluxOcrKtpResult(ficModel)));
//
//         // } catch (e) {
//         //   dialog = "ERROR NO FACE DETECTED";
//         //   debugPrint("Error $e");
//         // }
//       // }
//     // } else {
//     //   dialog = "Unexpected Error";
//     // }
//     setState(() {
//       loading = false;
//     });
//     createAlertDialog(context, dialog);
//   }


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
  //
  // apiRequestOcr(String url, Map jsonMap) async {
  //   HttpClient httpClient = new HttpClient();
  //   HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
  //   request.headers.set('content-type', 'application/json');
  //   request.add(utf8.encode(json.encode(jsonMap)));
  //   HttpClientResponse response = await request.close();
  //   // todo - you should check the response.statusCode
  //   var result = new StringBuffer();
  //   await for (var contents in response.transform(utf8.decoder)) {
  //     result.write(contents);
  //   }
  //
  //   Map<String, dynamic> myList = jsonDecode(result.toString());
  //
  //   OcrModel sample = OcrModel.fromJson(myList);
  //
  //   httpClient.close();
  //   return sample;
  // }
  //OKAY FACE API END HERE

  createAlertDialog(BuildContext context, String title, String message) {
    Widget okButton = TextButton(
      child: Text("Close"),
      onPressed: () {Navigator.of(context).pop(); },
    );

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(title), content: Text(message),  actions: [
            okButton,
          ],);
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
                          onPressed: () {
                            (_imageFileIdCard==null) ? null: nodefluxOcrKtpProcess(context);
                          },
                          child: Text("Process",
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: (_imageFileIdCard==null) ? Colors.black12: Colors.lightBlue,
                          ),
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
