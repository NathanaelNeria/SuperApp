import 'package:flutter/material.dart';
import 'package:simple_app/views/profile.dart';
import 'package:simple_app/screens/okayface_facevsface_01.dart';
import 'package:simple_app/screens/okayface_ocr_01.dart';
import 'package:simple_app/screens/okayface_ff_cloud.dart';


class OkayFace extends StatefulWidget {
  final String appBarTitle;

  OkayFace(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return OkayFaceState(this.appBarTitle);
  }
}

class OkayFaceState extends State<OkayFace> {
  OkayFaceState(this.appBarTitle);
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
                      getProductFeatureItem('OCR KTP'),
                      getProductFeatureItem('Face vs KTP'),
                      getProductFeatureItem('Face vs Face \n Local'),
                      getProductFeatureItem('Face vs Face \n Cloud'),
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
        case 'OCR KTP':
          return OkayfaceOcr();
          break;
        case 'Face vs KTP':
          return Profile();
          break;
        case 'Face vs Face \n Local':
          return OkayfaceFacevsface();
          break;
        case 'Face vs Face \n Cloud':
          return OkayfaceFfCloud('Face vs Face Cloud', false);
          break;
        default:
          return OkayFace(title);
      }
    }
    ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}