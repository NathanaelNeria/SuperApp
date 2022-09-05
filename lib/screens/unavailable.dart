import 'package:flutter/material.dart';

class Unavailable extends StatefulWidget {
  final String appBarTitle;

  Unavailable(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return UnavailableState(this.appBarTitle);
  }
}

class UnavailableState extends State<Unavailable> {
  UnavailableState(this.appBarTitle);
  String appBarTitle;

  @override
  Widget build(BuildContext context) {
    final TextStyle textStyle = Theme
        .of(context)
        .textTheme
        .headline4;
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
          body: Card(
            color: Colors.white,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.warning, size: 128.0, color: textStyle.color),
                  Text('Coming Soon', style: textStyle),
                ],
              ),
            ),
          )
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}