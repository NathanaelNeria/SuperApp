import 'package:simple_app/pages_relid/UpdatePassword.dart';
import 'package:simple_app/util/Constants.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:simple_app/pages_relid/ConnectedDevices.dart';
import 'package:simple_app/pages_relid/NotificationHistory.dart';
import 'package:simple_app/pages_relid/Notifications.dart';
import 'package:flutter/material.dart';

// class Dashboard extends StatelessWidget {
class Dashboard extends StatefulWidget {
  var response;
  DashboardWidget dashboardWidgetObj;

  @override
  DashboardWidget createState() {
    dashboardWidgetObj = new DashboardWidget();
    dashboardWidgetObj.initBridge();
    return dashboardWidgetObj;
  }
}

class DashboardWidget extends State<Dashboard> {
  int _cIndex = 0;
  double fontsize = 17;
  var flowForInitiatePassword = false;
  var flowForInitiatePattern = false;
  var flowForInitiateCredientials;
  RDNABridge bridge;

  void _incrementTab(index) {}

  initBridge() {
    bridge = bridge = RDNABridge.getInstance(null);
    //  bridge.getAllChallengesAPI(bridge.userName);
     bridge.on('creadientialsAvailable', credientialsAvailableForUpdate);
  }

  getTile() {
    if (flowForInitiateCredientials == 'password')
    return  ListTile(
        title: Text('Update Password',
            style: TextStyle(color: Colors.black, fontSize: fontsize)),
        onTap: () => {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      UpdatePassword(null, flowForInitiateCredientials)))
        },
      );
    else if (flowForInitiateCredientials == 'Pattern')
     return ListTile(
          title: Text('Update Pattern',
              style: TextStyle(color: Colors.black, fontSize: fontsize)),
          onTap: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            UpdatePassword(null, flowForInitiateCredientials)))
              });
  }

  @override
  Widget build(BuildContext context) {
    bridge.setContext(context);

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Dashboard"),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => Notifications(),
                    ));
              },
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Image.asset(
                  Constants.relIdLogo,
                  width: 10.0,
                  height: 10,
                  alignment: Alignment.topCenter,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                ),
              ),
              ListTile(
                title: Text('Device Management',
                    style: TextStyle(color: Colors.black, fontSize: fontsize)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              ConnectedDevices()));
                },
              ),
              ListTile(
                title: Text('Notification History',
                    style: TextStyle(color: Colors.black, fontSize: fontsize)),
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) =>
                              NotificationHistory()));
                },
              ),
             // getTile(),
              ListTile(
                title: Text('Logout',
                    style: TextStyle(color: Colors.black, fontSize: fontsize)),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                            title: Text("Confirm Logout",
                                style: TextStyle(fontSize: 20)),
                            content: Text("Do you want to logout?",
                                style: Theme.of(context).textTheme.body2),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('No'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              FlatButton(
                                child: Text('Yes'),
                                onPressed: () {
                                  bridge.logOutUserAPI(bridge.userName);
                                  Navigator.of(context).pop();
                                },
                              ),
                            ],
                          ));
                },
              ),
            ],
          ),
        ),
        body: new Center(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 100),
                // child: Image.asset(
                //   'images/logoist.jpg',
                //   width: 150,
                //   height: 150,
                //   alignment: Alignment.topCenter,
                // ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _cIndex,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.account_box,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text('')),
            BottomNavigationBarItem(
                icon: Icon(Icons.receipt, color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text('')),
            BottomNavigationBarItem(
                icon: Icon(Icons.attach_money,
                    color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text('')),
            BottomNavigationBarItem(
                icon: Icon(Icons.search, color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text('')),
            BottomNavigationBarItem(
                icon: Icon(Icons.phone, color: Color.fromARGB(255, 0, 0, 0)),
                title: new Text(''))
          ],
          onTap: (index) {
            _incrementTab(index);
          },
        ));
  }

  credientialsAvailableForUpdate(res) {
    setState(() {
      flowForInitiateCredientials = res;
    });
  }
}
