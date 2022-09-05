import 'package:flutter/material.dart';
// import 'package:rdna_client/rdna_struct.dart';
import 'package:simple_app/pages_relid/Loader.dart';
import 'package:simple_app/util/Constants.dart';

class VerifyPassword extends StatefulWidget {
  late VerifyPasswordwidget verifyPasswordObj;
  // RDNAChallengeOpMode? challengeMode;
  // VerifyPassword({Key? key, this.challengeMode}) : super(key: key); TODO:(wandy) uncomment when solved
  VerifyPassword({Key? key}) : super(key: key);
  @override
  VerifyPasswordwidget createState() {
    verifyPasswordObj = new VerifyPasswordwidget();
    // verifyPasswordObj.challengeMode = this.challengeMode;
    return verifyPasswordObj;
  }
}

class VerifyPasswordwidget extends State<VerifyPassword> {
  final password_controller = TextEditingController();
  final confirm_password_controller = TextEditingController();
  var userId;
  bool isChecked = false;
  bool validate_password = false;
  bool validate_confirm_password = false;
  // RDNAChallengeOpMode? challengeMode; TODO:(wandy) uncomment when solved
  bool showLoader = false;
  // RDNABridge? bridge = RDNABridge.getInstance(null); TODO:(wandy) uncomment when solved

  getUserName() async {
    // userId = await bridge!.getLocalData('userId'); TODO:(wandy) uncomment when solved
  }

  @override
  Widget build(BuildContext context) {
    // bridge!.setContext(context); TODO:(wandy) uncomment when solved
    getUserName();

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.blue),
            onPressed: () {
              // bridge!.resetAuthenticationAPI(); TODO:(wandy) uncomment when solved
            },
          ),
        ),
        body: Stack(
          children: <Widget>[
            WillPopScope(
              onWillPop: () {
                // return bridge!.onBackPressed(false); TODO:(wandy) uncomment when solved
                return Future.value(true);
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
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Welcome',
                          style: Theme.of(context).textTheme.displayMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      // Padding( TODO:(wandy) uncomment when solved
                      //   padding: EdgeInsets.all(8.0),
                      //   child: Text(
                      //     bridge!.userName!,
                      //     style: Theme.of(context).textTheme.titleMedium,
                      //     textAlign: TextAlign.center,
                      //   ),
                      // ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: password_controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            hintText: Constants.verifyPasswordTextfieldHint1,
                            errorText: validate_password
                                ? Constants.verifyPasswordTextfieldErrorText
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: confirm_password_controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            hintText: Constants.verifyPasswordTextfieldHint2,
                            errorText: validate_password
                                ? Constants.verifyPasswordTextfieldErrorText
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
                                    password_controller.text.isEmpty
                                        ? validate_password = true
                                        : validate_password = false;
                                    confirm_password_controller.text.isEmpty
                                        ? validate_confirm_password = true
                                        : validate_confirm_password = false;
                                  });
                                  if (!validate_password ||
                                      !validate_confirm_password) {
                                    if (password_controller.text ==
                                        confirm_password_controller.text) {
                                      setState(() {
                                        showLoader = true;
                                      });
                                      // bridge!.setPasswordAPI( TODO:(wandy) uncomment when solved
                                      //     password_controller.text,
                                      //     challengeMode!);
                                    } else {
                                      // bridge!.showAlertMessageDialog(context, TODO:(wandy) uncomment when solved
                                      //     "Password didnt matched", null);
                                    }
                                  }
                                },
                                child: const Text(
                                    Constants.submitButtonLabel,
                                    style: TextStyle(fontSize: 20)),
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
