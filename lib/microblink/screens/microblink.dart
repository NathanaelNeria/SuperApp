import 'package:simple_app/microblink/plugins/microblink_scanner.dart';
import 'package:flutter/material.dart';
import "dart:convert";
import "dart:async";

class Microblink extends StatefulWidget {

  @override
  MicroblinkState createState() => MicroblinkState();
}

class MicroblinkState extends State<Microblink> {
  String _resultString = "";
  String _fullDocumentFrontImageBase64 = "";
  String _fullDocumentBackImageBase64 = "";
  String _faceImageBase64 = "";

  Future<void> scan() async {
    String license;
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      license = "sRwAAAEcbmV0Lm15aW5mb3N5cy5kZW1vcHJvZHVjdGFwcCJSXWHzZqnRlNz++CM754lmYZabAXQ6qiX6mwRKtv+JTihAQJrULagJfFaXS6UQZkugGrqinVTK6/zh8l8KLNC8Fi0cwvqR2u0jWHDkO29G4ok/T+rz8WR2qNwj4IiTKw18dteqycurMcIeyl6tastJYWmwumr/UsN1muSCdDkSKyO0XMyel4nKNbOrhS5VRAgPG4Eu77LBxpUqXVaPxKc/4EaRrFbkyuoqTXtaJeLCRPz701HhkYL6K+LDCSGJSv7A+kIs";
    } else if (Theme.of(context).platform == TargetPlatform.android) {
      license = "sRwAAAAOaWQuaXN0LmlzdGRlbW8R/7b6TYTip9R1+XqkM6WG2BlIzDryhLGjbiPZ/HcwxCJ+4nLAOjTmVf9xZp9DFxCD3S+QTBzqDG6onzL5Bw3vwNPpbdVmMUwA9W/FPcroRqWahCkBWjVVM23SHIm8TLJwYjGbTl8jcRiBOEzymenxSevXAr/E+s88xU7Mzeh72aLuRa2GSrYH8F2u9GvFL/AW6tsxV2e9lQqLDIMAIDEmVTbOieuRYe/e3nN+tAqq5zXXIzr5Hpn03KHH5gWM4O2mW1evyQ==";
    }

    var idRecognizer = BlinkIdCombinedRecognizer();
    idRecognizer.returnFullDocumentImage = true;
    idRecognizer.returnFaceImage = true;

    BlinkIdOverlaySettings settings = BlinkIdOverlaySettings();

    var results = await MicroblinkScanner.scanWithCamera(
        RecognizerCollection([idRecognizer]), settings, license);

    if (!mounted) return;

    if (results.length == 0) return;
    for (var result in results) {
      if (result is BlinkIdCombinedRecognizerResult) {
        if (result.mrzResult.documentType == MrtdDocumentType.Passport) {
          _resultString = getPassportResultString(result);
        } else {
          _resultString = getIdResultString(result);
        }

        setState(() {
          _resultString = _resultString;
          _fullDocumentFrontImageBase64 = result.fullDocumentFrontImage;
          _fullDocumentBackImageBase64 = result.fullDocumentBackImage;
          _faceImageBase64 = result.faceImage;
        });

        return;
      }
    }
  }

  String getIdResultString(BlinkIdCombinedRecognizerResult result) {
    return buildResult(result.firstName, "First name") +
        buildResult(result.lastName, "Last name") +
        buildResult(result.fullName, "Full name") +
        buildResult(result.localizedName, "Localized name") +
        buildResult(result.additionalNameInformation, "Additional name info") +
        buildResult(result.address, "Address") +
        buildResult(
            result.additionalAddressInformation, "Additional address info") +
        buildResult(result.documentNumber, "Document number") +
        buildResult(
            result.documentAdditionalNumber, "Additional document number") +
        buildResult(result.sex, "Sex") +
        buildResult(result.issuingAuthority, "Issuing authority") +
        buildResult(result.nationality, "Nationality") +
        buildDateResult(result.dateOfBirth, "Date of birth") +
        buildIntResult(result.age, "Age") +
        buildDateResult(result.dateOfIssue, "Date of issue") +
        buildDateResult(result.dateOfExpiry, "Date of expiry") +
        buildResult(result.dateOfExpiryPermanent.toString(),
            "Date of expiry permanent") +
        buildResult(result.maritalStatus, "Martial status") +
        buildResult(result.personalIdNumber, "Personal Id Number") +
        buildResult(result.profession, "Profession") +
        buildResult(result.race, "Race") +
        buildResult(result.religion, "Religion") +
        buildResult(result.residentialStatus, "Residential Status") +
        buildDriverLicenceResult(result.driverLicenseDetailedInfo);
  }

  String buildResult(String result, String propertyName) {
    if (result == null || result.isEmpty) {
      return "";
    }

    return propertyName + ": " + result + "\n";
  }

  String buildDateResult(Date result, String propertyName) {
    if (result == null || result.year == 0) {
      return "";
    }

    return buildResult(
        "${result.day}-${result.month}-${result.year}", propertyName);
  }

  String buildIntResult(int result, String propertyName) {
    if (result < 0) {
      return "";
    }

    return buildResult(result.toString(), propertyName);
  }

  String buildDriverLicenceResult(DriverLicenseDetailedInfo result) {
    if (result == null) {
      return "";
    }

    return buildResult(result.restrictions, "Restrictions") +
        buildResult(result.endorsements, "Endorsements") +
        buildResult(result.vehicleClass, "Vehicle class") +
        buildResult(result.conditions, "Conditions");
  }

  String getPassportResultString(BlinkIdCombinedRecognizerResult result) {
    var dateOfBirth = "";
    if (result.mrzResult.dateOfBirth != null) {
      dateOfBirth = "Date of birth: ${result.mrzResult.dateOfBirth.day}."
          "${result.mrzResult.dateOfBirth.month}."
          "${result.mrzResult.dateOfBirth.year}\n";
    }

    var dateOfExpiry = "";
    if (result.mrzResult.dateOfExpiry != null) {
      dateOfExpiry = "Date of expiry: ${result.mrzResult.dateOfExpiry.day}."
          "${result.mrzResult.dateOfExpiry.month}."
          "${result.mrzResult.dateOfExpiry.year}\n";
    }

    return "First name: ${result.mrzResult.secondaryId}\n"
        "Last name: ${result.mrzResult.primaryId}\n"
        "Document number: ${result.mrzResult.documentNumber}\n"
        "Sex: ${result.mrzResult.gender}\n"
        "$dateOfBirth"
        "$dateOfExpiry";
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(this.context).textTheme.title;

    Widget fullDocumentFrontImage = Container();
    if (_fullDocumentFrontImageBase64 != null &&
        _fullDocumentFrontImageBase64 != "") {
      fullDocumentFrontImage = Column(
        children: <Widget>[
          Text("Document Front Image:"),
          Image.memory(
            Base64Decoder().convert(_fullDocumentFrontImageBase64),
            height: 180,
            width: 350,
          )
        ],
      );
    }

    Widget fullDocumentBackImage = Container();
    if (_fullDocumentBackImageBase64 != null &&
        _fullDocumentBackImageBase64 != "") {
      fullDocumentBackImage = Column(
        children: <Widget>[
          Text("Document Back Image:"),
          Image.memory(
            Base64Decoder().convert(_fullDocumentBackImageBase64),
            height: 180,
            width: 350,
          )
        ],
      );
    }

    Widget faceImage = Container();
    if (_faceImageBase64 != null && _faceImageBase64 != "") {
      faceImage = Column(
        children: <Widget>[
          Text("Face Image:"),
          Image.memory(
            Base64Decoder().convert(_faceImageBase64),
            height: 150,
            width: 100,
          )
        ],
      );
    }

    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(appBar: AppBar(
          title: const Text('Microblink'),
        ),
          body: SingleChildScrollView(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                      child: RaisedButton(
                        child: Text("Scan"),
                        onPressed: () => scan(),
                      ),
                      padding: EdgeInsets.only(bottom: 16.0)),
                  Text(_resultString),
                  fullDocumentFrontImage,
                  fullDocumentBackImage,
                  faceImage,
                ],
              )),
        )
    );

  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}