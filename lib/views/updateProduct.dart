import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_app/helper/api.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/model/productModel.dart';

class UpdateProduct extends StatefulWidget {
  final ProductModel model;
  final VoidCallback reload;
  UpdateProduct(this.model, this.reload);
  @override
  _UpdateProductState createState() => _UpdateProductState();
}

class _UpdateProductState extends State<UpdateProduct> {
  String? productName, qty, harga, createdBy, productId;
  final _key = new GlobalKey<FormState>();

  TextEditingController? txtNama, txtQty, txtHarga;

  setup(){
    txtNama = TextEditingController(text: widget.model.productName);
    txtQty = TextEditingController(text: widget.model.qty);
    txtHarga = TextEditingController(text: widget.model.harga);
  }

  getPerf() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      createdBy = preferences.getString("id");
    });
  }


  check(){
    final form = _key.currentState!;
    if(form.validate()){
      form.save();
      submit();
    }
  }

  submit() async{
    final response = await http.post(BaseUrl.updateProduct as Uri, body: {
      "productId" : widget.model.id,
      "productName" : productName,
      "qty" : qty,
      "harga" : harga,
      "createdBy" : createdBy
    });

    final data = jsonDecode(response.body);
    int? value = data['value'];
    String? message = data['message'];

    if(value == 1){
      print(message);
      setState(() {
        widget.reload();
        Navigator.pop(context);
      });
    }else{
      print(message);
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setup();
    getPerf();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
        ),
        body: Form(
          key: _key ,
          child: ListView(
            padding: EdgeInsets.all(16.0),
            children: <Widget>[
              TextFormField(
                enabled: false,
                controller: txtNama,
                onSaved: (e) => productName = e,
                decoration: InputDecoration(
                    labelText: "Product Name"
                ),
              ),
              TextFormField(
                controller: txtQty,
                onSaved: (e) => qty = e,
                decoration: InputDecoration(
                    labelText: "Quantity"
                ),
              ),
              TextFormField(
                controller: txtHarga,
                onSaved: (e) => harga = e,
                decoration: InputDecoration(
                    labelText: "Harga"
                ),
              ),
              MaterialButton(
                onPressed: (){
                  check();
                },
                child: Text("Update"),
              )
            ],
          ),
        )
    );
  }
}
