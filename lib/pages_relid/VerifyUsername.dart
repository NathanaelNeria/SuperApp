import 'package:flutter/material.dart';
import 'package:simple_app/pages_relid/Loader.dart';
import 'package:simple_app/pages_relid/LoginUser.dart';
import 'package:simple_app/util/Constants.dart';

class VerifyUsername extends StatefulWidget {
  var response;
  late VerifyUsernamewidget verifyUsernameObj;
  VerifyUsername(this.response);

  @override
  VerifyUsernamewidget createState() {
    verifyUsernameObj = new VerifyUsernamewidget();
    if (response != null) {
      verifyUsernameObj.recentlyLoginUser = this.response.recentLoggedInUser;
    }
    verifyUsernameObj.initBridge();
    return verifyUsernameObj;
  }
}

class VerifyUsernamewidget extends State<VerifyUsername> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hasInputError = false;
  bool validate_firstname = false;
  bool showLoader = false;
  var recentlyLoginUser;
  // RDNABridge? bridge; TODO:(wandy) uncomment when solved

//Method to create instance of RDNABridge class
  initBridge() {
    // bridge = RDNABridge.getInstance(null); TODO:(wandy) uncomment when solved
    if (recentlyLoginUser != null && recentlyLoginUser != "") {
      usernameController.text = recentlyLoginUser;
    }
  }


  @override
  Widget build(BuildContext context) {
    // bridge!.setContext(context); TODO:(wandy) uncomment when solved
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: new IconButton(
                icon: new Icon(Icons.arrow_back, color: Colors.blue),
                onPressed: () => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginUser())))),
        body: Stack(
          children: <Widget>[
            WillPopScope(
                onWillPop: (() => Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginUser())).then((value) => value as bool)),
                child: SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.all(60.0),
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
                            padding: EdgeInsets.only(top: 50),
                            child: Text(
                              Constants.appWelcomeText,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: new Container(
                                child: new Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.only(top: 10),
                                      child: TextField(
                                        textAlign: TextAlign.center,
                                        controller: usernameController,
                                        decoration: InputDecoration(
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                new BorderRadius.circular(15.0),
                                          ),
                                          hintText: Constants
                                              .verifyUsernameTextFieldHint,
                                          errorText: validate_firstname
                                              ? Constants
                                                  .verifyUsernameTextFieldErrorText
                                              : null,
                                        ),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(top: 10),
                                        child: ButtonTheme(
                                          minWidth: 100.0,
                                          height: 60.0,
                                          padding: EdgeInsets.only(top: 5),
                                          child: new ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                              elevation: 5,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: new BorderRadius.circular(15.0),
                                              ),
                                              backgroundColor: Colors.blue,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                usernameController.text.isEmpty
                                                    ? validate_firstname = true
                                                    : validate_firstname =
                                                        false;
                                              });
                                              if (!validate_firstname) {
                                                setState(() {
                                                  showLoader = true;
                                                });

                                                // bridge!.setUserAPI( TODO:(wandy) uncomment when solved
                                                //     usernameController.text);
                                              }
                                            },
                                            child: const Text(
                                                Constants.submitButtonLabel,
                                                style: TextStyle(fontSize: 20)),
                                          ),
                                        )),
                                  ],
                                ),
                              )),
                        ],
                      )),
                )),
            Positioned(child: ShowCase(showLoader))
          ],
        ));
  }
}
