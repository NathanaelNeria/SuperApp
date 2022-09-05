import 'package:flutter/material.dart';
import 'package:simple_app/views/profile.dart';
import 'package:simple_app/screens/okayface_facevsface_01.dart';
import 'package:simple_app/screens/okayface_ocr_01.dart';
import 'package:simple_app/screens/okayface_ff_cloud_01.dart';
import 'package:simple_app/screens/okayface_ff_cloud_02.dart';
//import 'package:firebase_storage/firebase_storage.dart';

class OkayfaceFfCloud extends StatefulWidget {
  final String appBarTitle;
  final bool isFirstPictureUploaded;

  OkayfaceFfCloud(this.appBarTitle, this.isFirstPictureUploaded);

  @override
  State<StatefulWidget> createState() {
    return OkayfaceFfCloudState(this.appBarTitle, this.isFirstPictureUploaded);
  }
}

class OkayfaceFfCloudState extends State<OkayfaceFfCloud> {
  OkayfaceFfCloudState(this.appBarTitle, this.isFirstPictureUploaded);
  String appBarTitle;
  bool isFirstPictureUploaded;

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
            body: CustomScrollView(
              primary: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverGrid.count(
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    crossAxisCount: 2,
                    children: <Widget>[
                      getProductFeatureItem('First Photo'),
                       isFirstPictureUploaded==false? Container():getProductFeatureItem('Second Photo'),
                    ],
                  ),
                ),
              ],
            )
        ));
  }

  Widget getProductFeatureItem(String featureName) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => navigateToFeaturePage(featureName), // handle your onTap here
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
          ),
          child: Text(featureName,
              textAlign: TextAlign.center),
        ),
      ),
    );
  }

  void navigateToFeaturePage(String title) async {

    bool result=await Navigator.push(context, MaterialPageRoute(builder:(context){
      switch (title) {
        case 'First Photo':
          return OkayfaceFfCloud1(title);
          break;
        case 'Second Photo':
          return OkayfaceFfCloud2();
          break;
        default:
          return OkayfaceFfCloud(title, false);
          break;
      }
    }
    ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}