// SecondScreen.dart
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:logger/logger.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:simple_app/util/Util.dart';

class NotificationHistory extends StatefulWidget {
  late NotificationHistorywidget objNotification;
  final log = getLogger("NotificationHistory");

  @override
  NotificationHistorywidget createState() {
    objNotification = new NotificationHistorywidget();
    objNotification.callGetNotificationHistory();
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
    SchedulerBinding.instance.addPostFrameCallback((_) => {});
  }
}

class NotificationHistorywidget extends State<NotificationHistory> {
  RDNABridge? bridge;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  bool _hasInputError = false;
  String? notification_subject;
  String? notification_body;
  var notification_list = [];
  var notificationUUID;

//Method to get notification history
  void callGetNotificationHistory() {
    bridge = RDNABridge.getInstance(null);
    bridge!.getNotificationHistoryAPI();
    bridge!.on('notificationHistory', notificationHistoryJSON);
  }

  @override
  Widget build(BuildContext context) {
    bridge!.setContext(context);

    //Method to iterate the notifications and return a notification card.
    getCard(item) {
      return Card(
        color: Colors.grey[200],
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            ListTile(
              title: Text(
                item.body[0].subject,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
              subtitle: Padding(
                padding: EdgeInsets.only(top: 15, bottom: 15),
                child: Text(
                  item.body[0].message,
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('Notification History'),
      ),
      body: SingleChildScrollView(
          child: Padding(
        padding: EdgeInsets.all(20),
        child: new Column(
          children: <Widget>[
            ...notification_list.map((e) => getCard(e)).toList(),
          ],
        ),
      )),
    );
  }

//Event subscriber method
  notificationHistoryJSON(res) {
    var notification = res.pArgs.response.responseData.response.history;
    if (notification.length != 0) {
      var notificationBody = notification;
      notification.forEach((entitlement) {
        if (!mounted) return;
        setState(() {
          notification_list.add(entitlement);
          notificationUUID = entitlement.notificationUuid;
        });
      });
    }
  }
}
