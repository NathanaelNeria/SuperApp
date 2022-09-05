import 'package:flutter/material.dart';
import 'package:simple_app/nodeflux/screens/nodeflux_face_match_liveness.dart';
import 'package:simple_app/views/profile.dart';
import 'package:simple_app/nodeflux/screens/nodeflux_ocr_ktp.dart';


class Nodeflux extends StatefulWidget {
  final String appBarTitle;

  Nodeflux(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return NodefluxState(this.appBarTitle);
  }
}

class NodefluxState extends State<Nodeflux> {
  NodefluxState(this.appBarTitle);
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
                      getProductFeatureItem('Face Liveness'),
                      getProductFeatureItem('Face Match with Liveness'),
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

    bool? result=await Navigator.push(context, MaterialPageRoute(builder:(context){
      switch (title) {
        case 'OCR KTP':
          return NodefluxOcrKtp();
          break;
        case 'Face Liveness':
          return Profile();
          break;
        case 'Face Match with Liveness':
          return NodefluxFaceMatchLiveness();
          break;
        default:
          return Nodeflux(title);
      }
    }
    ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }
}