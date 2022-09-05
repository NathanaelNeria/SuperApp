import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ShowCase extends StatelessWidget {
  bool showLoader = false;

  ShowCase(showLoader){
    this.showLoader = showLoader;
  }
  @override
  Widget build(BuildContext context) {
    if(showLoader) return Center(
      child: Container(
        color: Color.fromARGB(0x6A, 0x00, 0x00, 0x00),
        child: SpinKitChasingDots(color: Colors.blueAccent),
      )
    );
    else
      return( Center());
  }
}