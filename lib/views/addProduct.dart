import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/custom/currency.dart';
import 'package:simple_app/helper/api.dart';


class AddProduct extends StatefulWidget {
  final VoidCallback reload;

  AddProduct(this.reload);

  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String productName, qty, harga, createdBy;
  final _key = new GlobalKey<FormState>();
  File _imageFile;

  getPerf() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      createdBy = preferences.getString("id");
    });
  }

  _chooseGallery(BuildContext context) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.gallery, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
    Navigator.of(context).pop();
  }

  _chooseCamera(BuildContext context) async {
    var image = await ImagePicker.pickImage(
        source: ImageSource.camera, maxHeight: 1920.0, maxWidth: 1080.0);
    setState(() {
      _imageFile = image;
    });
    Navigator.of(context).pop();
  }

  check() {
    final form = _key.currentState;
    if (form.validate()) {
      form.save();
      submit();
    }
  }

  createAlertDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Make a Choice!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  GestureDetector(
                    child: Text("Gallary"),
                    onTap: (){
                      _chooseGallery(context);
                    },
                  ),
                  Padding(padding: EdgeInsets.all(8.0)),
                  GestureDetector(
                    child: Text("Camera"),
                    onTap: (){
                      _chooseCamera(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  submit() async {
    try {
      var stream = http.ByteStream(DelegatingStream.typed(_imageFile.openRead()));
      var length = await _imageFile.length();
      var uri = Uri.parse(BaseUrl.addProduct);
      var request = http.MultipartRequest("POST", uri);

      request.fields['productName'] = productName;
      request.fields['qty'] = qty;
      request.fields['harga'] = harga.replaceAll(",", "");
      request.fields['createdBy'] = createdBy;
      request.files.add(http.MultipartFile("image",stream,length,filename: path.basename(_imageFile.path)));

      var response = await request.send();
      if(response.statusCode > 2){
        print("image uploaded");
        setState(() {
          widget.reload();
          Navigator.pop(context);
        });
      }else{
        print("image failed upload");
      }
    } catch (e) {
      debugPrint("Error $e");
    }


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPerf();
  }

  @override
  Widget build(BuildContext context) {
    var placeholder = Container(
      width: double.infinity,
      height: 150.0,
      child: Image.asset('./images/placeholder.png'),
    );
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
        ),
        body: Form(
          key: _key,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              Container(
                width: double.infinity,
                height: 150.0,
                child: InkWell(
                  onTap: () {
                    createAlertDialog(context);
                  },
                  child: _imageFile == null
                      ? placeholder
                      : Image.file(
                          _imageFile,
                          fit: BoxFit.fill,
                        ),
                ),
              ),
              TextFormField(
                onSaved: (e) => productName = e,
                decoration: InputDecoration(labelText: "Product Name"),
              ),
              TextFormField(
                onSaved: (e) => qty = e,
                decoration: InputDecoration(labelText: "Quantity"),
              ),
              TextFormField(
                inputFormatters: [
                  WhitelistingTextInputFormatter.digitsOnly,
                  CurrencyFormat()
                ],
                onSaved: (e) => harga = e,
                decoration: InputDecoration(labelText: "Harga"),
              ),
              MaterialButton(
                onPressed: () {
                  check();
                },
                child: Text("Add"),
              )
            ],
          ),
        ));
  }
}
