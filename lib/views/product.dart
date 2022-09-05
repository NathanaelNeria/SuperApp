import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:simple_app/helper/api.dart';
import 'package:simple_app/model/productModel.dart';
import 'package:simple_app/views/addProduct.dart';
import 'package:simple_app/views/updateProduct.dart';

class Product extends StatefulWidget {
  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<Product> {
  final money = NumberFormat("#,##0","en_US");
  
  var loading = false;
  final list = new List<ProductModel>();

  final GlobalKey<RefreshIndicatorState> _refresh = GlobalKey<RefreshIndicatorState>();

  Future<void> _getProduct() async {
    list.clear();
    setState(() {
      loading = true;
    });
    final response = await http.get(BaseUrl.getProduct);
    if (response.contentLength == 2) {
    } else {
      final data = jsonDecode(response.body);
      data.forEach((api) async{
        final ab = new ProductModel(api['id'], api['productName'], api['qty'],
            api['harga'], api['createdDate'], api['createdBy'], api['name'], api['image']);


        list.add(ab);

//        Uint8List byteImage = await networkImageToByte('http://172.19.247.249/api/upload/'+api['image']);
//        String encoded = base64Encode(byteImage);
//        print(api['productName']);
//        print(encoded);

      });
      setState(() {
        loading = false;
      });
    }
  }

  dialogDelete(String id){
    showDialog(
        context: context,
        builder: (context){
          return Dialog(
            child: ListView(
              padding: EdgeInsets.all(16.0),
              shrinkWrap: true,
              children: <Widget>[
                Text("Confirm to delete product?", style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    InkWell(
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Text("No")),
                    SizedBox(
                      width: 16.0,
                    ),
                    InkWell(
                        onTap: (){
                          _delete(id);
                        },
                        child: Text("Yes")),
                  ],
                )
              ],
            ),
          );
        }
    );
  }

  _delete(String id)async{
    final response = await http.post(BaseUrl.deleteProduct, body: {
       "productId" : id
    });
    final data = jsonDecode(response.body);
    int value = data['value'];
    String message = data['message'];
    if(value == 1){
      setState(() {
        Navigator.pop(context);
        _getProduct();
      });
    }else{
      print(message);
    }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getProduct();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddProduct(_getProduct)));
        },
      ),
      body: RefreshIndicator(
        onRefresh: _getProduct,
        key: _refresh,
        child : loading ? Center(child: CircularProgressIndicator()) : ListView.builder(
          itemCount: list.length,
          itemBuilder: (context, i) {
            final x = list[i];
            return Container(
                padding: EdgeInsets.all(10.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Image.network('http://172.19.247.249/api/upload/'+x.image, width: 100.0, height: 180.0, fit: BoxFit.cover,),
                    SizedBox(width: 10.0,),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            x.productName,
                            style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(x.qty),
                          Text(money.format(int.parse(x.harga))),
                          Text(x.name),
                          Text(x.createdDate),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => UpdateProduct(x, _getProduct)));
                      },
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        dialogDelete(x.id);
                      },
                      icon: Icon(Icons.delete),
                    )
                  ],
                ));
          },
        ),
      )
    );
  }
}
