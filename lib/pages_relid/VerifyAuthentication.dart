import 'package:flutter/material.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:simple_app/pages_relid/Loader.dart';
import 'package:simple_app/util/Constants.dart';

class VerifyAuthentication extends StatefulWidget {
  var res;
  VerifyAuthentication(this.res);
  VerifyAuthenticationWidget verifyAuthenticationObj;
  @override
  VerifyAuthenticationWidget createState() {
    verifyAuthenticationObj = new VerifyAuthenticationWidget();
    verifyAuthenticationObj.performVerifyAuth();
    verifyAuthenticationObj.userId = this.res.userId;
    return verifyAuthenticationObj;
  }
}

class VerifyAuthenticationWidget extends State<VerifyAuthentication> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isChecked = false;
  RDNABridge bridge;
  var res;
  String userId;
  bool showLoader = false;

  performVerifyAuth() async {
    bridge = RDNABridge.getInstance(null);
    var res = await bridge.performVerifyAuthCall(true);
    bridge.checkSyncError(res.error);
  }

  @override
  Widget build(BuildContext context) {
    bridge.setContext(context);

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: new IconButton(
            icon: new Icon(Icons.close, color: Colors.blue),
            onPressed: () => bridge.resetAuthenticationAPI(),
          ),
        ),
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: <Widget>[
            WillPopScope(
              onWillPop: () => bridge.onBackPressed(false),
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 100),
                        child: Image.asset(
                          Constants.relIdLogo,
                          width: 100,
                          height: 100,
                          alignment: Alignment.topCenter,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          'Welcome',
                          style: Theme.of(context).textTheme.headline,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          userId,
                          style: TextStyle(
                              color: Colors.blue,
                              fontSize:
                                  20), 
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 30),
                        child: Text(
                          Constants.verifyPasswordPageTitle,
                          style: Theme.of(context).textTheme.title,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Text(
                          Constants.verifyAuthenticationEmailSentText,
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: InkWell(
                            child: Text(
                              Constants.verifyAuthenticationNoAccessText,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[300],
                                decoration: TextDecoration.underline,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            onTap: () {
                             
                              bridge.fallBackNewDeviceCall();
                            },
                          )),

                      Padding(
                        padding: EdgeInsets.only(top: 10),
                      ),
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
