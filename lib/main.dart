import 'dart:io';

import 'package:flutter/material.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:simple_app/screens/okayface.dart';
import 'package:simple_app/screens/unavailable.dart';
import 'package:simple_app/services/authentication.dart';
import 'package:simple_app/pages/root_page.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  runApp(MaterialApp(
    //home: Login(),
    debugShowCheckedModeBanner: false,
    builder: (context, child) => Scaffold(
      body: GestureDetector(
        onTap: (){
          if (Platform.isIOS) hideKeyboard(context);
        },
        child: child,
      ),
    ),
    home:  new RootPage(auth: new Auth()),
    //home: LoginSignupOption(),
    //debugShowCheckedModeBanner: false,
  ));
}

void hideKeyboard(BuildContext context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
    FocusManager.instance.primaryFocus!.unfocus();
  }
}

class MainMenu extends StatefulWidget {
  final VoidCallback signOut;

  MainMenu(this.signOut);

  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  RDNABridge? rdnaBridge;
  signOut() {
    setState(() {
      widget.signOut();
    });
  }

  String? username = "", name = "";
  TabController? tabController;
  final _minimumPadding = 5.0;

  getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      username = preferences.getString("username");
      name = preferences.getString("name");
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPref();
  }

  @override
  Widget build(BuildContext context) {
    // TextStyle textStyle = Theme.of(context).textTheme.title;

    return Scaffold(
        appBar: AppBar(
          title: const Text('IST Demo'),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
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
                  getProductMenuItem('ASLI RI'),
                  getProductMenuItem('Rel ID'),
                  getProductMenuItem('Kata.ai'),
                  getProductMenuItem('Other1'),
                  //getProductMenuItem('Other2'),
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

  void navigateToProductPage(String title) async {

    bool? result=await Navigator.push(context, MaterialPageRoute(builder:(context){
      switch (title) {
        case 'OkayFace':
          return OkayFace(title);
          break;
//        case 'LiveBank':
//          return LiveBank(title);
//          break;
//        case 'Rel ID':
//          return RelId(title);
//          break;
//        case 'Kata.ai':
//          return KataAi(title);
//          break;
        default:
          return Unavailable(title);
      }
    }
    ));
  }

}
