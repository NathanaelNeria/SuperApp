import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:simple_app/screens/okayface_ff_cloud.dart';

class OkayfaceFfCloud1 extends StatefulWidget {
  final String appBarTitle;

  OkayfaceFfCloud1(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return OkayfaceFfCloud1State(this.appBarTitle);
  }
}

class OkayfaceFfCloud1State extends State<OkayfaceFfCloud1> {
  OkayfaceFfCloud1State(this.appBarTitle);
  String appBarTitle;
  File? _imageFile;
  bool _uploaded=false;
  String? _downloadUrl;
  var _reference = FirebaseStorage.instance.ref().child('myimage.jpg');

  Future getImage(bool isCamera) async {
    File? image;
    if (isCamera) {
      final picked = await (ImagePicker()).pickImage(source: ImageSource.camera);
      image = File(picked!.path);
    } else
    {
      final picked = await (ImagePicker()).pickImage(source:ImageSource.gallery);
      image = File(picked!.path);
    }
    setState(() {
      _imageFile = image;
    });
  }

  Future uploadImage() async {
    var uploadTask = _reference.putFile(_imageFile!);
    var taskSnapshot = await uploadTask;// so when the upload task is complete we can have a snapshot [Maya note]
    setState(() {
      _uploaded = true;
    });
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => OkayfaceFfCloud('Face vs Face Cloud', _uploaded)));
    createAlertDialog(context, 'First photo successfully uploaded to cloud');
  }

  Future downloadImage() async {
    String? downloadAddress=await _reference.getDownloadURL();
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
        } as Future<bool> Function()?,
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
                  _imageFile == null? Container(): Image.file(_imageFile!, height: 300.0, width: 300.0),
                  ElevatedButton(
                    child:Text('Camera'),
                    onPressed: () {
                      getImage(true);
                    },
                  ),
                  SizedBox(height:10.0),
                  ElevatedButton(
                    child:Text('Gallery'),
                    onPressed: () {
                      getImage(false);
                    },
                  ),
                  _imageFile == null? Container() : ElevatedButton(
                      child:Text("Upload to Storage"),
                      onPressed: () {
                        uploadImage();
                      }
                  ),
                  _uploaded== false? Container (): ElevatedButton(
                      child: Text('Download Image'),
                      onPressed: () {
                        downloadImage();
                      }),
                  _downloadUrl==null? Container():Image.network(_downloadUrl!),
                ],
              ),
            ),
          ),
        ));
  }

  createAlertDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(message));
        });
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}