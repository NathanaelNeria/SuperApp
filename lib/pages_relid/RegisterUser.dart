import 'package:flutter/material.dart';
import 'package:rdna_client/rdna_client.dart';
import 'package:rdna_client/rdna_struct.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:simple_app/connectionprofile/ConnectionProfile.dart';
import 'package:simple_app/pages_relid/Loader.dart';
import 'package:simple_app/pages_relid/LoginUser.dart';
import 'package:simple_app/util/Constants.dart';

class RegisterUser extends State<Register_User> {
  RdnaClient rdna = new RdnaClient();
  final firstnameController = TextEditingController();
  final lastnameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  bool isChecked = false;
  bool validate_firstname = false;
  bool validate_lastname = false;
  bool validate_email = false;
  bool validate_mobile = false;
  bool validate_slider = false;
  var emailValid = RegExp(
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
  var mobileValid = RegExp(r'(^(?:[+0]9)?[0-9]{10,12}$)');

  var sessionId;
  RDNABridge bridge;
  var userId;
  var userMap = {
    "firstName": "",
    "lastName": "",
    "userId": "",
    "groupName": "group1",
    "emailId": "",
    "mobNum": "",
    "isRELIDZeroEnabled": "true",
    "username": "sruser",
    "sessionId": "",
    "password":
        "1e99b14aa45d6add97271f8e06adacda4e521ad98a4ed18e38cfb0715e7841d2",
    "apiversion": "v1",
    "Content-Type": "application/x-www-form-urlencoded",
    "Content-Length": "0"
  };
  int slidervalue = 6;
  bool showLoader = false;

  getSessionId() async {
    RDNASyncResponse session = await rdna.getSessionID();
    sessionId = session.response;
  }

  registerUser(bridge) async {
    await getSessionId();
    var userMap = {
      "firstName": firstnameController.text,
      "lastName": lastnameController.text,
      "userId": emailController.text,
      "groupName": "group1",
      "emailId": emailController.text,
      "mobNum": mobileController.text,
      "isRELIDZeroEnabled": "true",
      "username": "sruser",
      "sessionId": sessionId,
      "password":
          "1e99b14aa45d6add97271f8e06adacda4e521ad98a4ed18e38cfb0715e7841d2",
      "apiversion": "v1",
      "Content-Type": "application/x-www-form-urlencoded",
      "Content-Length": "0"
    };
    var contentType = userMap;
    var baseUrl =
        "https://${ConnectionProfile.host}:${ConnectionProfile.openHttpPort}/rest/enrollUser.htm";
    bridge.setLocalData('userId', emailController.text);
    bridge.openHttpConnectionAPI(
        RDNAHttpMethods.RDNA_HTTP_POST, baseUrl, contentType, "");
    bridge.on('onHttpSuccess', onHttpSuccessCallback);
  }

  onHttpSuccessCallback(res) async {
    userId = bridge.userName;
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Activation code sent to your email- ' +
                          emailController.text,
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Please check the email for more instructions',
                      style: Theme.of(context).textTheme.body1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(15.0),
                      ),
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.pop(context);
                        bridge.setUserAPI(emailController.text);
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

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
          leading: new IconButton(
              icon: new Icon(Icons.close, color: Colors.blue),
              onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => LoginUser()))),
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
                        Image.asset(
                          Constants.relIdLogo,
                          width: 70,
                          height: 70,
                          alignment: Alignment.topCenter,
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: TextField(
                              autocorrect: false,
                              textAlign: TextAlign.center,
                              controller: firstnameController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                hintText: Constants.firstNameHint,
                                errorText: validate_firstname
                                    ? Constants.firstNameErrorText
                                    : null,
                              ),
                            )),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextField(
                            autocorrect: false,
                            textAlign: TextAlign.center,
                            controller: lastnameController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                              hintText: Constants.lastNameHint,
                              errorText: validate_lastname
                                  ? Constants.lastNameErrorText
                                  : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextField(
                            autocorrect: false,
                            keyboardType: TextInputType.emailAddress,
                            textAlign: TextAlign.center,
                            controller: emailController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                              hintText: Constants.emailHint,
                              errorText: validate_email
                                  ? Constants.emailErrorText
                                  : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: TextField(
                            autocorrect: false,
                            keyboardType: TextInputType.phone,
                            textAlign: TextAlign.center,
                            controller: mobileController,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                              ),
                              hintText: Constants.mobileHint,
                              errorText: validate_mobile
                                  ? Constants.mobileErrorText
                                  : null,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text(
                              "Slide to prove you're human",
                              style:
                                  TextStyle(fontSize: 17, color: Colors.grey),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Slider(
                              value: slidervalue.toDouble(),
                              min: 1.0,
                              max: 10.0,
                              activeColor: Colors.blue,
                              inactiveColor: Colors.grey,
                              onChanged: (double newValue) {
                                setState(() {
                                  slidervalue = newValue.round();
                                  newValue > 9.0
                                      ? validate_slider = true
                                      : validate_slider = false;
                                });
                              },
                            )),
                        CheckboxListTile(
                          title: Text(
                            " I accept terms and conditions",
                            style: TextStyle(fontSize: 15),
                          ),
                          value: isChecked,
                          onChanged: (newValue) {
                            setState(() {
                              isChecked = newValue;
                            });
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                        ),
                        Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: ButtonTheme(
                              minWidth: 100.0,
                              height: 50.0,
                              padding: EdgeInsets.only(top: 5),
                              child: new RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(15.0),
                                ),
                                onPressed: () => {
                                  setState(() {
                                    firstnameController.text.isEmpty
                                        ? validate_firstname = true
                                        : validate_firstname = false;
                                    lastnameController.text.isEmpty
                                        ? validate_lastname = true
                                        : validate_lastname = false;
                                    emailController.text.isEmpty
                                        ? validate_email = true
                                        : validate_email = false;
                                    mobileController.text.isEmpty
                                        ? validate_mobile = true
                                        : validate_mobile = false;
                                  }),
                                  if (!validate_firstname &&
                                      !validate_lastname &&
                                      !validate_mobile &&
                                      !validate_email)
                                    {
                                      if (!validate_slider)
                                        {
                                          bridge.showAlertMessageDialog(
                                              context,
                                              "Please move the slider to right",
                                              null)
                                        }
                                      else if (!isChecked)
                                        {
                                          bridge.showAlertMessageDialog(
                                              context,
                                              "Please accept the terms and conditions",
                                              null)
                                        }
                                      else if (!emailValid
                                          .hasMatch(emailController.text))
                                        {
                                          bridge.showAlertMessageDialog(context,
                                              "Please input valid email", null)
                                        }
                                      else if (!mobileValid
                                          .hasMatch(mobileController.text))
                                        {
                                          bridge.showAlertMessageDialog(
                                              context,
                                              "Please input valid mobile number",
                                              null)
                                        }
                                      else
                                        {
                                          setState(() {
                                            showLoader = false;
                                          }),
                                          registerUser(bridge)
                                        }
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
                )),
            Positioned(child: ShowCase(showLoader))
          ],
        ));
  }
}

class Register_User extends StatefulWidget {
  RegisterUser registerUserObj;

  @override
  RegisterUser createState() {
    registerUserObj = new RegisterUser();
    registerUserObj.initBridge();
    return registerUserObj;
  }
}
