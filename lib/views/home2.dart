import 'package:flutter/material.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
// import 'package:location/location.dart';
import 'package:simple_app/nodeflux/screens/nodeflux.dart';
import 'package:simple_app/pages_relid/HomeScreen.dart';
import 'package:simple_app/screens/g_maps.dart';
import 'package:simple_app/screens/okayface.dart';
import 'package:simple_app/screens/livebank.dart';
import 'package:simple_app/screens/rel_id.dart';
import 'package:simple_app/screens/kata_ai.dart';
import 'package:simple_app/screens/unavailable.dart';
import 'package:rdna_client/rdna_client.dart';
import 'package:rdna_client/rdna_struct.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_apns/apns.dart';

import 'package:simple_app/services/authentication.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:async';
import 'dart:io';
//import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:location_permissions/location_permissions.dart';

import 'package:camera/camera.dart';
import 'package:simple_app/asli/screens/asli.dart';
import 'package:simple_app/microblink/screens/microblink.dart';
import 'package:simple_app/iotera/iotera.dart';

class Home extends StatefulWidget {
  Home({Key key, this.auth, this.userId, this.logoutCallback})
      : super(key: key);

  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() {
    return HomeState();
  }
}


class HomeState extends State<Home> {
  var _formKey = GlobalKey<FormState>();
  final _minimumPadding = 5.0;
  FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  RdnaClient rdnaClient;
  String fcmtoken;
  final connector = createPushConnector();

  @override
  void initState() {
    super.initState();
    runFirst();
    firebaseCloudMessaging_Listeners();
    connector.configure(
      onLaunch: (data) => onPush('onLaunch', data),
      onResume: (data) => onPush('onResume', data),
      onMessage: (data) => onPush('onMessage', data),
      onBackgroundMessage: _onBackgroundMessage,
    );
    connector.token.addListener(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Token_id', connector.token.value);
      RDNABridge.getInstance(null).setDeviceToken(connector.token.value);
      print('Token ${connector.token.value}');
    });
    connector.requestNotificationPermissions();
    print("init");
  }

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {

    });
  }

  setPref(token) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString("fcmtoken", token);
  }

  void firebaseCloudMessaging_Listeners() {
    // if (Platform.isIOS) iOS_Permission();

    _firebaseMessaging.getToken().then((token) {
      print("Token => $token");
      setPref(token);
    });

    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  // void iOS_Permission() {
  //   _firebaseMessaging.requestNotificationPermissions(
  //       IosNotificationSettings(sound: true, badge: true, alert: true)
  //   );
  //   _firebaseMessaging.onIosSettingsRegistered
  //       .listen((IosNotificationSettings settings) {
  //     print("Settings registered: $settings");
  //   });
  // }

  runFirst() async{
    PermissionStatus permissionStatus = await LocationPermissions().checkPermissionStatus();
    PermissionStatus permission = await LocationPermissions().requestPermissions();
    print("Loc Permission: " + permissionStatus.toString());
  }

  // void deviceToken(){
  //   // if (Platform.isIOS) iOS_Permission();
  //
  //   _firebaseMessaging.getToken().then((token){
  //     print(token);
  //     // rdnaBridge.setDeviceToken(token);
  //     rdnaClient.setDeviceToken(token);
  //   });
  //
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       print('on message $message');
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print('on resume $message');
  //     },
  //     onLaunch: (Map<String, dynamic> message) async {
  //       print('on launch $message');
  //     },
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
        appBar: AppBar(
          title: const Text('IST Demo'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Hello',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Profile'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
              ),
              ListTile(
                leading: Icon(Icons.exit_to_app),
                title: Text('Logout'),
                onTap: () {
                  signOut();
                  },
              ),
            ],
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
                  getProductMenuItem('LiveBank'),
                  getProductMenuItem('OkayFace'),
                  getProductMenuItem('ASLI'),
                  getProductMenuItem('Microblink'),
                  getProductMenuItem('Rel ID'),
                  getProductMenuItem('Nodeflux'),
                  getProductMenuItem('Iotera'),
                  getProductMenuItem('Others'),
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget getProductMenuItem(String productName) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => navigateToProductPage(productName), // handle your onTap here
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
          ),
          child: Text(productName),
        ),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/livebank_logo.png');
    Image image = Image(image: assetImage, width: 10, height: 10);

    return Container(
        alignment: Alignment.center,
        child: image,
        margin: EdgeInsets.all(_minimumPadding));
  }

  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  void navigateToProductPage(String title) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      cameras = await availableCameras();
    } on CameraException catch (e) {
      logError(e.code, e.description);
    }
    Directory livenessExtDir = await getApplicationDocumentsDirectory();

    bool result=await Navigator.push(context, MaterialPageRoute(builder:(context){
      switch (title) {
        case 'OkayFace':
          return OkayFace(title);
          break;
        case 'ASLI':
          return Asli(title, cameras, livenessExtDir);
//          return Asli(title, cameras, livenessExtDir);
          break;
        case 'Microblink':
          return Microblink();
//          return Asli(title, cameras, livenessExtDir);
          break;
        case 'Nodeflux':
          return Nodeflux(title);
          break;
//        case 'LiveBank':
//          return LiveBank(title);
//          break;
       case 'Rel ID':
         return HomeScreen();
         break;
        case 'Iotera':
          return Iotera(title);
          break;
//       case 'Kata.ai':
//         return KataAi(title);
//         break;
        default:
          return Unavailable(title);
      }
    }
    ));
  }

}

Future<dynamic> onPush(String name, Map<String, dynamic> data) {
  //storage.append('$name: $data');
  RDNABridge rdnaBridge = RDNABridge.getInstance(null);
  if(rdnaBridge.RdnaSession.sessionType == 1){
    rdnaBridge.getNotificationAPI();
  }
  return Future.value();
}

Future<dynamic> _onBackgroundMessage(Map<String, dynamic> data) =>
    onPush('onBackgroundMessage', data);
