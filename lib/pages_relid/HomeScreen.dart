import 'dart:async';

import 'package:delayed_display/delayed_display.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:simple_app/util/Constants.dart';

class HomeScreen extends StatefulWidget {
  late HomeScreenWidget homescreenwidgetObj;

  @override
  HomeScreenWidget createState() {
    homescreenwidgetObj = new HomeScreenWidget();
    homescreenwidgetObj.initBridge();
    return homescreenwidgetObj;
  }
}

class HomeScreenWidget extends State<HomeScreen> {
  // RDNABridge? bridge; TODO:(wandy) uncomment when solved
 bool showLoader = true;

//Method to create instance of RDNABridge class
  void initBridge() async {
    // bridge = RDNABridge.getInstance(null); TODO:(wandy) uncomment when solved
    Timer(Duration(seconds: 5), () {
     // bridge!.initializeAPI(ConnectionProfile.agentInfo, ConnectionProfile.host, ConnectionProfile.port); TODO:(wandy) uncomment when solved
    });
  }

  @override
  Widget build(BuildContext context) {
    // bridge!.setContext(context); TODO:(wandy) uncomment when solved
    final Duration initDelay = Duration(seconds: 2);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
      SingleChildScrollView(
          child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(60, 250, 60, 0),
            child: Image.asset(
              Constants.relIdLogo,
              alignment: Alignment.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Text(
              Constants.appWelcomeText,
              style: Theme.of(context).textTheme.headline1,
              textAlign: TextAlign.center,
            ),
          ),
          // Padding(
          //   padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
          //   child: Text(
          //     Constants.verifyText,
          //     style: Theme.of(context).textTheme.headline6,
          //     textAlign: TextAlign.center,
          //   ),
          // ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 30, 20, 0),
            child: Text(
              "Checking device for issues",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0,
              ),
            ),
          ),
          DelayedDisplay(
            slidingBeginOffset: Offset(0.5,0),
            delay: initDelay,
            child: Text(
              "Verifying device identity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0
              ),
            ),
          ),DelayedDisplay(
            slidingBeginOffset: Offset(0.5,0),
            delay: Duration(seconds: initDelay.inSeconds + 2),
            child: Text(
              "Verifying app identity",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.0
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
            child: SpinKitWave(color: Colors.blueAccent),
          ),
        ],
      )),
      ],
      )
    );
  }
}
