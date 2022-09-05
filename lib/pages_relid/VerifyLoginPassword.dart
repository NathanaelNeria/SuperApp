import 'package:flutter/material.dart';
import 'package:rdna_client/rdna_struct.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:simple_app/pages_relid/Loader.dart';
import 'package:simple_app/util/Constants.dart';

class VerifyLoginPassword extends StatefulWidget {
  VerifyLoginPasswordwidget verifyPasswordObj;
  RDNAChallengeOpMode challengeMode;
  var attemptsCount;
  VerifyLoginPassword({Key key, this.challengeMode, this.attemptsCount})
      : super(key: key);
  @override
  VerifyLoginPasswordwidget createState() {
    verifyPasswordObj = new VerifyLoginPasswordwidget();
    verifyPasswordObj.challengeMode = this.challengeMode;
    verifyPasswordObj.attemptsCount = this.attemptsCount;
    return verifyPasswordObj;
  }
}

class VerifyLoginPasswordwidget extends State<VerifyLoginPassword> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isChecked = false;
  bool validate_password = false;
  bool showLoader = false;
  RDNAChallengeOpMode challengeMode;
  var attemptsCount;
  var password;

  @override
  Widget build(BuildContext context) {
    RDNABridge bridge = RDNABridge.getInstance(context);
    bridge.setContext(context);
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.blue),
            onPressed: () => bridge.resetAuthenticationAPI(),
          ),
        ),
        body: Stack(
          children: <Widget>[
            WillPopScope(
              onWillPop: () => bridge.onBackPressed(false),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(50.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Welcome',
                          style: Theme.of(context).textTheme.display1,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          bridge.userName,
                          style: Theme.of(context).textTheme.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: Text(
                          'Verify Password',
                          style: Theme.of(context).textTheme.headline,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10),
                        child: TextField(
                          controller: passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            hintText:
                                Constants.verifyLoginPasswordTextfieldHint,
                            errorText: validate_password
                                ? Constants
                                    .verifyLoginPasswordTextfieldErrorText
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Attempt(s) left ' + attemptsCount.toString(),
                          style: Theme.of(context).textTheme.body2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ButtonTheme(
                            minWidth: 100.0,
                            height: 60.0,
                            padding: EdgeInsets.only(top: 5),
                            child: new RaisedButton(
                              shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                              onPressed: () {
                                setState(() {
                                  passwordController.text.isEmpty
                                      ? validate_password = true
                                      : validate_password = false;
                                });
                                if (!validate_password)
                                  setState(() {
                                    showLoader = true;
                                  });
                                bridge.setPasswordAPI(
                                    passwordController.text,challengeMode);
                              },
                              child: const Text(Constants.submitButtonLabel,
                                  style: TextStyle(fontSize: 20)),
                              color: Colors.blue,
                              textColor: Colors.white,
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(child: ShowCase(showLoader))
          ],
        ));
  }
}
