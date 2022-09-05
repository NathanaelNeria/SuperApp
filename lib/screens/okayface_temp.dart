import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class OkayfaceTemp extends StatefulWidget {
  final String appBarTitle;

  OkayfaceTemp(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return OkayfaceTempState(this.appBarTitle);
  }
}

class OkayfaceTempState extends State<OkayfaceTemp> {
  OkayfaceTempState(this.appBarTitle);
  String appBarTitle;
  File _imageFile;
  bool _uploaded=false;
  String _downloadUrl;
  StorageReference _reference = FirebaseStorage.instance.ref().child('myimage.jpg');

  Future getImage(bool isCamera) async {
    File image;
    if (isCamera) {
      image= await ImagePicker.pickImage(source: ImageSource.camera);
    } else
    {
      image= await ImagePicker.pickImage(source:ImageSource.gallery);
    }
    setState(() {
      _imageFile = image;
    });
  }

  Future uploadImage() async {
    StorageUploadTask uploadTask = _reference.putFile(_imageFile);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;// so when the upload task is complete we can have a snapshot [Maya note]
    setState(() {
      _uploaded = true;
    });
  }

  Future downloadImage() async {
    String downloadAddress=await _reference.getDownloadURL();
    setState(() {
      _downloadUrl=downloadAddress;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () {
          // Write some code to control things, when user press Back navigation button in device navigationBar
          moveToLastScreen();
        },
        child: Scaffold(
            appBar: AppBar(
              title: Text(appBarTitle),
              leading: IconButton(icon: Icon(
                  Icons.arrow_back),
                  onPressed: () {
                    // Write some code to control things, when user press back button in AppBar
                    moveToLastScreen();
                  }
              ),
            ),
            body: SingleChildScrollView(
              child: Center(
                child: Column(
                  children:<Widget> [
                    _imageFile == null? Container(): Image.file(_imageFile, height: 300.0, width: 300.0),
                    RaisedButton(
                      child:Text('Camera'),
                      onPressed: () {
                        getImage(true);
                      },
                    ),
                    SizedBox(height:10.0),
                    RaisedButton(
                      child:Text('Gallery'),
                      onPressed: () {
                        getImage(false);
                      },
                    ),
                    _imageFile == null? Container() : RaisedButton(
                        child:Text("Upload to Storage"),
                        onPressed: () {
                          uploadImage();
                        }
                    ),
                    _uploaded== false? Container (): RaisedButton(
                        child: Text('Download Image'),
                        onPressed: () {
                          downloadImage();
                        }),
                    _downloadUrl==null? Container():Image.network(_downloadUrl),
                  ],
                ),
              ),
            ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}