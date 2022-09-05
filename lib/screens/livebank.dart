import 'package:flutter/material.dart';

class LiveBank extends StatefulWidget {
  final String appBarTitle;

  LiveBank(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return LiveBankState(this.appBarTitle);
  }
}

class LiveBankState extends State<LiveBank> {
  LiveBankState(this.appBarTitle);
  String appBarTitle;

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
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}