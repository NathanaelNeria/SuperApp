import 'package:flutter/material.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:simple_app/pages_relid/Loader.dart';
import 'package:simple_app/util/Constants.dart';

class ActivationCode extends StatefulWidget {
  ActivationCodeWidget activationcodeObj;
  var attemptsCount;
  var verificationKey;

  ActivationCode({Key key, this.attemptsCount, this.verificationKey})
      : super(key: key);
  @override
  ActivationCodeWidget createState() {
    activationcodeObj = new ActivationCodeWidget();
    activationcodeObj.attemptsCount = this.attemptsCount;
    activationcodeObj.verificationKey = this.verificationKey;
    return activationcodeObj;
  }
}

class ActivationCodeWidget extends State<ActivationCode> {
  final usernameController = TextEditingController();
  final activationCodeController = TextEditingController();
  bool isChecked = false;
  bool validate_code = false;
  var attemptsCount = 0;
  var verificationKey;
  bool showLoader = false;

  @override
  Widget build(BuildContext context) {
    RDNABridge bridge = RDNABridge.getInstance(null);
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
                        padding: EdgeInsets.only(top: 40),
                        child: Text(
                          Constants.appWelcomeText,
                          style: TextStyle(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.only(top: 50),
                        child: Text(
                          'Verification Key : ' + verificationKey,
                          style: Theme.of(context).textTheme.body2,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: TextField(
                          textAlign: TextAlign.center,
                          controller: activationCodeController,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            hintText: Constants.activationCodeTextfieldHint,
                            errorText: validate_code
                                ? Constants.activationCodeTextfieldErrorText
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
                                  activationCodeController.text.isEmpty
                                      ? validate_code = true
                                      : validate_code = false;
                                });
                                if (!validate_code) {
                                  setState(() {
                                    showLoader = true;
                                  });
                                  bridge.setActivationAPI(
                                      activationCodeController.text);
                                }
                               
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
