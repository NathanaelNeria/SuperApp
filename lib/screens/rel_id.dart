import 'package:flutter/material.dart';

class RelId extends StatefulWidget {
  final String appBarTitle;

  RelId(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return RelIdState(this.appBarTitle);
  }
}

class RelIdState extends State<RelId> {
  RelIdState(this.appBarTitle);
  String appBarTitle;

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
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}