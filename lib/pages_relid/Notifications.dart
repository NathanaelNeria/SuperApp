// SecondScreen.dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:logger/logger.dart';
// import 'package:rdna_client/rdna_struct.dart'; TODO:(wandy) uncomment when solved
import 'package:simple_app/util/Util.dart';

class Notifications extends StatefulWidget {
  late Notificationswidget objNotification;
  final log = getLogger("Notifications");

  @override
  Notificationswidget createState() {
    objNotification = new Notificationswidget();
    objNotification.callGetNotification();
    return objNotification;
  }

  @override
  void unmount() {
    log.log(Level.debug, "unmount()", null, null);
  }

  void onLoad(BuildContext context) {
    log.log(Level.debug, "onLoad()", null, null);
  }

  @override
  void initState() {
    //super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) => {});
  }
}

class Notificationswidget extends State<Notifications> {
  Completer<GoogleMapController> _controller = Completer();

  // RDNABridge? bridge; TODO:(wandy) uncomment when solved

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hasInputError = false;
  String? notification_subject;
  String? notification_body;
  List<dynamic>? notification_list = [];
  List<dynamic>? notification_action_list = [];
  var notificationUUID;
  static const LatLng _center = LatLng(-6.1856565, 106.8828894);
  MapType _currentMapType = MapType.normal;
  var lon = 0.0;
  var lat = 0.0;

  // getdata() {
  //   Future<http.Response> fetchPost() {
  //     return http.get('https://jsonplaceholder.typicode.com/posts/1');
  //   }
  // }

  // String validatePassword(String value) {
  //   if (!(value.length > 5) && value.isNotEmpty) {
  //     return "Password should contains more then 5 character";
  //   }
  //   return null;
  // }

  void callGetNotification() {
    // bridge = RDNABridge.getInstance(null); TODO:(wandy) uncomment when solved
    // bridge!.getNotificationAPI();
    // bridge!.on('notifications', notificationJSON);
  }

  @override
  Widget build(BuildContext context) {
    // bridge!.setContext(context); TODO:(wandy) uncomment when solved

    getMessage(message) {
      var messageArray = message.split('\n');
      if (messageArray.length > 0) {
        if (messageArray.length >= 5) {
          var msg = messageArray[4];
          if (msg.contains("longitude")) {
            var msgSplit = msg.split(',');
            var lontemp = msgSplit[1].split(' ')[2];
            var lattemp = msgSplit[0].split(' ')[1];
            lon = double.parse(lontemp);
            lat = double.parse(lattemp);
          }
        }
      }
    }

    getAdditionalMessage(message) {
      var messageArray = message.split('\n');
      if (messageArray.length > 0) {
        if (messageArray.length >= 5) {
          var msg = messageArray[5];

          if (msg.contains('Location:')) {
            var msgSplit = msg.split(',');
            var lattemp = msgSplit[0].split(':')[1];
            var lontemp = msgSplit[1];
            lat = double.parse(lattemp);
            lon = double.parse(lontemp);
          }
        }
      }
    }

    getCard() {
      if (notification_list!.length != 0) {
        for (var item in notification_list!) {
          if (item.message.contains('Location:')) {
            getAdditionalMessage(item.message);
          } else {
            getMessage(item.message);
          }
          return (Card(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                ListTile(
                  title: Text(
                    item.subject,
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: Text(
                      item.message,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                ),
                for (var actionItem in notification_action_list!)
                  Padding(
                    padding: EdgeInsets.only(top: 10),
                    child: ButtonTheme(
                      minWidth: 300.0,
                      height: 40.0,
                      padding: EdgeInsets.only(top: 5),
                      child: new ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                          backgroundColor: actionItem.label == "Accept"
                              ? Colors.green[900]
                              : Colors.red[900],
                          foregroundColor: Colors.white,
                        ),
                        onPressed: () {
                          // bridge!.updateNotificationAPI( TODO:(wandy) uncomment when solved
                          //     notificationUUID, actionItem.action);
                        },
                        child: Text(
                          actionItem.label,
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    ),
                  ),
                Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: InkWell(
                      child:
                          Text("Tap here to see the location of the requester"),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    gMaps(lat: lat, lon: lon)));
                      }),
                ),
              ],
            ),
          ));
        }
      } else
        return new Center(
            child: Text(
          "No New Notifications",
          style: TextStyle(fontSize: 15, color: Colors.grey),
          textAlign: TextAlign.center,
        ));
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Notifications'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: getCard(),
        ),
      ),
    );
  }

  // notificationJSON(RDNAStatusGetNotifications res) { TODO:(wandy) uncomment when solved
  //   var notification =
  //       res.pArgs!.response!.responseData!.response.notifications;
  //   if (notification.length != 0) {
  //     var notificationBody = notification;
  //     notification.forEach((entitlement) {
  //       if (!mounted) return;
  //       setState(() {
  //         notification_list = entitlement.body;
  //         notification_action_list = entitlement.actions;
  //         notification_list = entitlement.body;
  //         notificationUUID = entitlement.notificationUuid;
  //       });
  //     });
  //   }
  // }
}

class gMaps extends StatefulWidget {
  late _gMapsState gMapsStateObj;
  var lat;
  var lon;

  gMaps({Key? key, this.lon, this.lat}) : super(key: key);

  @override
  _gMapsState createState() {
    _gMapsState.lat = this.lat;
    _gMapsState.lon = this.lon;
    gMapsStateObj = new _gMapsState();
    // gMapsStateObj.lat = this.lat;
    // gMapsStateObj.lon = this.lon;
    return gMapsStateObj;
  }
}

class _gMapsState extends State<gMaps> {
  final Set<Marker> _markers = {};
  static double? lon = 0.0;
  static double? lat = 0.0;
  LatLng _currentPosition = LatLng(-6.1856565, 106.8828912);

  @override
  void initState() {
    _markers.add(
      Marker(
        markerId: MarkerId("$lat, $lon"),
        position: _currentPosition,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Request Location'),
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: _currentPosition,
          zoom: 14.0,
        ),
        markers: _markers,
        onTap: (position) {
          setState(() {
            _markers.add(
              Marker(
                markerId:
                    MarkerId("${position.latitude}, ${position.longitude}"),
                icon: BitmapDescriptor.defaultMarker,
                position: position,
              ),
            );
          });
        },
      ),
    );
  }
}
