import 'package:rdna_client/rdna_struct.dart';
import 'package:simple_app/pages_relid/Dashboard.dart';
import 'package:flutter/material.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:simple_app/pages_relid/Loader.dart';
import 'package:simple_app/util/Constants.dart';

class UpdatePassword extends StatefulWidget {
  UpdatePasswordwidget updatePasswordObj;
  RDNAChallengeOpMode challengeMode;
  var flowForInitiateCredientials;
  UpdatePassword(this.challengeMode, this.flowForInitiateCredientials);
  @override
  UpdatePasswordwidget createState() {
    updatePasswordObj = new UpdatePasswordwidget();
    updatePasswordObj.challengeMode = this.challengeMode;
    updatePasswordObj.flowForInitiateCredientials = this.flowForInitiateCredientials;
    return updatePasswordObj;
  }
}

class UpdatePasswordwidget extends State<UpdatePassword> {
  final old_password_controller = TextEditingController();
  final new_password_controller = TextEditingController();
  var userId;
  bool isChecked = false;
  bool validate_old_password = false;
  bool validate_new_password = false;
  RDNAChallengeOpMode challengeMode;
  var flowForInitiateCredientials;
  bool showLoader = false;
  RDNABridge bridge = RDNABridge.getInstance(null);

  getUserName() async {
    userId = await bridge.getLocalData('userId');
  }

    updatePattern(flowForInitiateCredientials) async{
    var success= await bridge.initiateUpdateAPI(flowForInitiateCredientials);
  }

  @override
  Widget build(BuildContext context) {
    bridge.setContext(context);


    //getUserName();
if(flowForInitiateCredientials=='Password')
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.blue),
            onPressed: () => 
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => Dashboard())),
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
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: old_password_controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            hintText: Constants.verifyPasswordTextfieldHint1,
                            errorText: validate_old_password
                                ? Constants.verifyPasswordTextfieldErrorText
                                : null,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: TextField(
                          controller: new_password_controller,
                          obscureText: true,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: new BorderRadius.circular(15.0),
                            ),
                            hintText: Constants.verifyPasswordTextfieldHint2,
                            errorText: validate_new_password
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
                            child: new RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    old_password_controller.text.isEmpty
                                        ? validate_old_password = true
                                        : validate_old_password = false;
                                    new_password_controller.text.isEmpty
                                        ? validate_new_password = true
                                        : validate_new_password = false;
                                  });
                                  if (!validate_old_password ||
                                      !validate_new_password) {
                                        if(old_password_controller.text==new_password_controller.text)
                                        {
                                    setState(() {
                                      showLoader = true;
                                    });
                                    // bridge.setPasswordAPI(
                                    //     old_password_controller.text,
                                    //     challengeMode);
                                  }
                                      
                                      else{
                                        bridge.showAlertMessageDialog(context, "Password didnt matched", null);
                                      }
                                }},
                                child: const Text(
                                    Constants.verifyPasswordButtonLabel,
                                    style: TextStyle(fontSize: 20)),
                                color: Colors.blue,
                                textColor: Colors.white),
                          )),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(child: ShowCase(showLoader))
          ],
        )
        );
        if(flowForInitiateCredientials=='Pattern')
       
        return Scaffold(
       body: updatePattern(flowForInitiateCredientials),
        );
  }
}
