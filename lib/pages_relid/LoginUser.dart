import 'package:flutter/material.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:simple_app/pages_relid/RegisterUser.dart';
import 'package:simple_app/pages_relid/VerifyUsername.dart';
import 'package:simple_app/util/Constants.dart';

class LoginUser extends StatefulWidget {
  LoginUserwidget loginUserObj;
  @override
  LoginUserwidget createState() {
    loginUserObj = new LoginUserwidget();
    loginUserObj.initBridge();
    return loginUserObj;
  }
}

class LoginUserwidget extends State<LoginUser> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hasInputError = false;
  RDNABridge bridge;

//Method to create instance of RDNABridge class
  initBridge() {
    bridge = RDNABridge.getInstance(null);
  }

  @override
  Widget build(BuildContext context) {
    bridge.setContext(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: 
       WillPopScope(
        onWillPop:()=>bridge.onBackPressed(true),
        child:
      SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 100),
                  child: Image.asset(
                    Constants.relIdLogo,
                    width: 120,
                    height: 120,
                    alignment: Alignment.topCenter,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: Text(
                   Constants.appWelcomeText,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                
                Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: new Container(
                      child: new Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          ButtonTheme(
                            minWidth: 100.0,
                            height: 50.0,
                            child: new RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(13.0),
                              ),
                              onPressed: () {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            VerifyUsername(null)));
                              },
                              child: const Text(Constants.loginButtonLabel,
                                  style: TextStyle(fontSize: 20)),
                              color: Colors.blue,
                              textColor: Colors.white,
                            ), 
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 30),
                              child: ButtonTheme(
                                minWidth: 80.0,
                                height: 50.0,
                                padding: EdgeInsets.only(top: 5),
                                child: new RaisedButton(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                  ),
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                Register_User()
                                            ));
                                  },
                                  child: const Text(Constants.registerButtonLabel,
                                      style: TextStyle(fontSize: 20)),
                                  color: Colors.blue,
                                  textColor: Colors.white,
                                ),
                              ))
                        ],
                      ),
                    )),
              ],
            )),
      ),
    ));
  }
}
