import 'package:flutter/material.dart';

class KataAi extends StatefulWidget {
  final String appBarTitle;

  KataAi(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return KataAiState(this.appBarTitle);
  }
}

class KataAiState extends State<KataAi> {
  KataAiState(this.appBarTitle);
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
        )

    );

  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}