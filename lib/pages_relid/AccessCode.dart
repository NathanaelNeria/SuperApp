import 'package:flutter/material.dart';
import 'package:simple_app/pages_relid/Loader.dart';
import 'package:simple_app/util/Constants.dart';

class AccessCode extends StatefulWidget {
  late AccessCodeWidget accesscodeObj;
  var attemptsCount;
  var verificationKey;

  AccessCode({Key? key, this.attemptsCount, this.verificationKey})
      : super(key: key);

  @override
  AccessCodeWidget createState() {
    accesscodeObj = new AccessCodeWidget();
    accesscodeObj.attemptsCount = this.attemptsCount;
    accesscodeObj.verificationKey = this.verificationKey;
    return accesscodeObj;
  }
}

class AccessCodeWidget extends State<AccessCode> {
  final usernameController = TextEditingController();
  final accesscodeController = TextEditingController();
  bool isChecked = false;
  bool showLoader = false;
  int? attemptsCount = 0;
  var verificationKey;
  bool validate_code = false;
  // RDNABridge? bridge; TODO:(wandy) uncomment when solved

//Method to create instance of RDNABridge class
  initBridge() {
    // bridge = RDNABridge.getInstance(null); TODO:(wandy) uncomment when solved
  }

  @override
  Widget build(BuildContext context) {
    // RDNABridge bridge = RDNABridge.getInstance(null)!; TODO:(wandy) uncomment when solved
    // bridge.setContext(context); TODO:(wandy) uncomment when solved
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.blue),
            onPressed: () {
              // bridge.resetAuthenticationAPI(); TODO:(wandy) uncomment when solved
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            WillPopScope(
                onWillPop: () async{
                  // return bridge.onBackPressed(false); TODO:(wandy) uncomment when solved
                  return true;
                },
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
                          padding: EdgeInsets.only(top: 30),
                          child: Text(
                            Constants.appWelcomeText,
                            style: TextStyle(fontSize: 20),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Verification Key : ' + verificationKey,
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: TextField(
                            controller: accesscodeController,
                            obscureText: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                              hintText: Constants.acessCodeTextfieldHint,
                              errorText: validate_code
                                  ? Constants.accessCodeTextfieldErrorText
                                  : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Attempt(s) left ' + attemptsCount.toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                            textAlign: TextAlign.center,
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
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(15.0),
                                  ),
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    accesscodeController.text.isEmpty
                                        ? validate_code = true
                                        : validate_code = false;
                                  });
                                  if (!validate_code) {
                                    setState(() {
                                      showLoader = true;
                                    });
                                    // bridge.setAccessCodeAPI( TODO:(wandy) uncomment when solved
                                    //     accesscodeController.text);
                                  }
                                },
                                child: const Text(
                                  Constants.submitButtonLabel,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                )),
            Positioned(child: ShowCase(showLoader))
          ],
        ));
  }
}
