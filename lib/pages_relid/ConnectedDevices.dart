import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:simple_app/util/Constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ConnectedDevices extends StatefulWidget {
  @override
  ConnectedDevicesWidget createState() {
    var objConnDevices = new ConnectedDevicesWidget();
    objConnDevices.callConnectedDevice();
    return objConnDevices;
  }
}

class ConnectedDevicesWidget extends State<ConnectedDevices> {
  final device_name_controller = TextEditingController();
  List<dynamic>? deviceslist = [];
  // RDNABridge? bridge; TODO:(wandy) uncomment when solved
  late var userid;
  var prefs = SharedPreferences.getInstance();
  bool validate_devicename = false;


//Method to get connected devices
  void callConnectedDevice() async {
    // bridge = RDNABridge.getInstance(null); TODO:(wandy) uncomment when solved
    // userid = await bridge!.getLocalData('userId'); TODO:(wandy) uncomment when solved
    // bridge!.getConnectedDevicesAPI(userid); TODO:(wandy) uncomment when solved
    // bridge!.on('connectedDevices', devicesJSON); //Event subscriber method TODO:(wandy) uncomment when solved
  }

//Method to update the device details
  updateDetails(json, action, devName) async {
    json.status = action;
    json.devName = devName;
    var devices = deviceslist;

    var arr = {
      'device': [json]
    };
    // bridge!.updateDeviceDetailsAPI(userid, jsonEncode(arr)); TODO:(wandy) uncomment when solved
  }

//Method to show popup for changing device name
  getAlertDialog(item, context) {
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
                    child: Text('Please enter a new device name',
                        style: TextStyle(fontSize: 17)),
                  ),
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: TextField(
                      autofocus: true,
                      controller: device_name_controller,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        errorText: validate_devicename
                            ? 'Device name Can\'t Be Empty'
                            : null,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      child: Text(
                        Constants.submitButtonLabel,
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0),
                        ),
                        backgroundColor: Colors.blue,
                      ),
                      onPressed: () {
                        setState(() {
                          device_name_controller.text.isEmpty
                              ? validate_devicename = true
                              : validate_devicename = false;
                          Navigator.pop(context);
                          getAlertDialog(item, context);
                        });

                        if (!validate_devicename) {
                          updateDetails(
                              item, "Update", device_name_controller.text);
                          Navigator.pop(context);
                          // bridge!.updateDeviceDetailsAPI(userid, item); TODO:(wandy) uncomment when solved
                        }
                      },
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('Device Management'),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: new Column(children: <Widget>[
                  for (var item in deviceslist!)
                    new Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Slidable(
                          child: Container(
                            color: Colors.white,
                            child: ListTile(
                              title: Text(
                                item.devName,
                                style: TextStyle(
                                    fontSize: 20, color: Colors.blue[300]),
                              ),
                              subtitle: Text(
                                'Status:' +
                                    item.status +
                                    '\nCreated:\t' +
                                    item.createdTs +
                                    '\nLast Access:\t' +
                                    item.lastAccessedTs,
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            ),
                          ),

                          // secondaryActions: <Widget>[
                          //   IconSlideAction(
                          //       caption: 'Edit',
                          //       color: Colors.blue,
                          //       icon: Icons.edit,
                          //       onTap: () => {getAlertDialog(item, context)}),
                          //   IconSlideAction(
                          //       caption: 'Delete',
                          //       color: Colors.red,
                          //       icon: Icons.delete,
                          //       onTap: () => showDialog(
                          //           context: context,
                          //           builder: (context) => AlertDialog(
                          //             title: Text("Alert",
                          //                 style: TextStyle(fontSize: 20)),
                          //             content: Text(
                          //                 "Do you want to delete this device?",
                          //                 style: Theme.of(context)
                          //                     .textTheme
                          //                     .body2),
                          //             actions: <Widget>[
                          //               TextButton(
                          //                 child: Text('No'),
                          //                 onPressed: () {
                          //                   Navigator.of(context).pop();
                          //                 },
                          //               ),
                          //               TextButton(
                          //                 child: Text('Yes'),
                          //                 onPressed: () {
                          //                   updateDetails(
                          //                       item,
                          //                       "Delete",
                          //                       device_name_controller
                          //                           .text);
                          //                   Navigator.of(context).pop();
                          //                 },
                          //               ),
                          //             ],
                          //           ))),
                          // ],
                        )),
                ]))));
  }

  devicesJSON(res) {
    if (!mounted)
      return;
    else
      setState(() {
        deviceslist = res.pArgs.response.responseData.response.device;
      });
  }
}

