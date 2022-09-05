
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/refreshTokenModel.dart';
import '../model/commandDeviceModel.dart';

class CommandDeviceScreen extends StatefulWidget {
  final String appBarTitle;

  CommandDeviceScreen(this.appBarTitle);

  // @override
  // _CommandDeviceScreenState createState() => _CommandDeviceScreenState();
  @override
  State<StatefulWidget> createState() {
    return _CommandDeviceScreenState(this.appBarTitle);
  }
}

class _CommandDeviceScreenState extends State<CommandDeviceScreen> {
  _CommandDeviceScreenState(this.appBarTitle);
  String appBarTitle;
  String contentType = 'application/json';
  String ioteraAppDomName = 'Iotera-Application-Domain';
  String ioteraAccIdName = 'Iotera-Account-Id';
  String ioteraAppDom = 'infosystest';
  String ioteraAccId = '1000000155-1000000001';
  String ioteraAccRefToken = 'Iotera-Account-Refresh-Token';
  String ioteraAccAccessToken = 'Iotera-Account-Access-Token';
  String? accessToken = '';
  String device = '14e1a2d8-d4b4-4e05-9399-ab9592b83d00';
  String token =
      'b46e69391acecd970e15d8af33e43ca044a3ff677bacb5ddaf15f3d8a5b42d5f';

  var sensorEnum = [
    'Please select a sensor',
    // 'door_sensor_switch',
    // 'box_sensor_switch',
    // 'mcb_sensor_switch',
    'motion_sensor_switch',
    // 'ir_sensor_switch',
    'temp_sensor_switch',
    // 'siren_switch',
    // 'alarmState',
    // 'takePicture',
    // 'sendImageTo',
    'motion_operational_time (start hour)',
    'motion_operational_time (start minute)',
    'motion_operational_time (end hour)',
    'motion_operational_time (end minute)',
    'temp_threshold',
  ];
  var boolEnum =[
    'Select a value',
    'True',
    'False'
  ];

  String? currentSensorSelected = '';
  int sensorSelected = 99;
  String? currentBoolSelected = '';
  bool? userBoolValue;
  bool emailValidate = false;

  String? param;
  String? sensorName;
  var userValue;
  var userChoice;
  bool boolVal = false;
  bool intVal = false;
  bool strVal = false;
  bool isNotNull = false;
  bool correctBoolVal = false;
  String? statusMsg = '';

  // TextEditingController textEditingController;
  var txt = TextEditingController();

  var refreshTokenAPI = 'https://api.iotera.io/v3/token/refresh';
  var commandDeviceAPI = 'https://api.iotera.io/v3/device/command';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: commandDeviceUI(),
    );
  }

  @override
  void initState(){
    super.initState();
    currentSensorSelected = sensorEnum[0];
    currentBoolSelected = boolEnum[0];
    refreshToken();
    correctBoolVal = false;
  }

  // void dispose(){
  //   txt?.dispose();
  //   super.dispose();
  // }

  commandDevice() async {
    try {
      var parameter = {
        "device_id": device,
        "sensor": sensorName,
        "param": param,
        "value": userValue
      };

      var uri = Uri.parse(commandDeviceAPI);
      var request = new http.Request('POST', uri);

      request.headers[ioteraAppDomName] = ioteraAppDom;
      request.headers[ioteraAccIdName] = ioteraAccId;
      request.headers[ioteraAccAccessToken] = accessToken!;
      request.body = json.encode(parameter);

      var response = await request.send();
      var res = await response.stream.bytesToString();
      print(res);

      Map<String, dynamic> listResult = jsonDecode(res.toString());
      CommandDeviceModel commandDeviceModel =
      CommandDeviceModel.fromJson(listResult);
      CmdFailModel cmdFailModel = CmdFailModel.fromJson(listResult);

      setState(() {
        statusMsg = commandDeviceModel.status;
        print(statusMsg);
        if(statusMsg != null){
          if(statusMsg == 'success'){
            createAlertDialog(context, '$statusMsg', 'Execute command device status: $statusMsg');
          }
          else if(statusMsg == 'failed'){
            createAlertDialog(context, '$statusMsg', 'Execute command device status: $statusMsg');
          }
          else if(cmdFailModel.statusMessage == 'Network Failure'){
            createAlertDialog(context, cmdFailModel.statusMessage, cmdFailModel.statusMessage! + ' please try again later');
          }
        }
      });

    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Widget commandDeviceUI() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Command Device'),
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Padding(padding: EdgeInsets.all(15.0),
                  child: Text('Select Sensor')),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: deviceSensorDropdown(),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(5.0),
              child: Padding(padding: EdgeInsets.all(15.0),
                  child: Text('Enter value')),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0),
              child: booleanTextField(),
            ),
          ),
          FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            child: Text('Submit'),
            onPressed: () {
              if(!correctBoolVal && userValue == null){
                createAlertDialog(context, 'Wrong input!', 'Input true/false only!');
              }
              else {
                if(userValue == null || sensorSelected > 50){
                if(sensorSelected > 50){
                  createAlertDialog(context, 'You have not selected any sensor', 'Please select a sensor from the drop down');
                }
                else if(userValue == null){
                  createAlertDialog(context, 'No input!', 'Please input a value.');
                }
                // else if(strVal && !emailValidate){
                //   createAlertDialog(context, 'Invalid Email Address', 'Enter a valid email address');
                // }
              }
              else{
                commandDevice();
                print(txt.text);
              }
              }
            },
          )
        ],
      ),
    );
  }
  
  Widget boolDropDown(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)
      ),
      child: new DropdownButton<String>(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 42,
        underline: SizedBox(),
        items: boolEnum.map((dynamic value){
          return DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        value: currentBoolSelected,
        onChanged: (value){
          setState(() {
            currentBoolSelected = value;
            print(currentBoolSelected);
            switch(value){
              case 'True':
                userBoolValue = true;
                userValue = userBoolValue;
                correctBoolVal = true;
                break;
              case 'False':
                userBoolValue = false;
                userValue = userBoolValue;
                correctBoolVal = true;
                break;
              case 'Select a value':
                correctBoolVal = false;
                break;
            }
            print(userBoolValue);
            _onBoolDropDownItemSelected(currentBoolSelected);
          });
        },
      ),
    );
  }

  Widget deviceSensorDropdown() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)
        ),
        child: new DropdownButton<String>(
          icon: Icon(Icons.arrow_drop_down),
          iconSize: 42,
          underline: SizedBox(),
          items: sensorEnum.map((dynamic value) {
            return DropdownMenuItem<String>(
              value: value,
              child: new Text(value),
            );
          }).toList(),
          value: currentSensorSelected,
          onChanged: (value) {
            setState(() {
              currentSensorSelected = value;
              print(currentSensorSelected);
              switch (value) {
                // case 'door_sensor_switch':
                //   sensorName = sensorEnum[1];
                //   param = 'value';
                //   value = userChoice;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   sensorSelected = 25;
                //   break;
                // case 'box_sensor_switch':
                //   sensorName = sensorEnum[2];
                //   param = 'value';
                //   value = userChoice;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   sensorSelected = 25;
                //   break;
                // case 'mcb_sensor_switch':
                //   sensorName = sensorEnum[3];
                //   param = 'value';
                //   value = userChoice;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   sensorSelected = 25;
                //   break;
                case 'motion_sensor_switch':
                  sensorName = sensorEnum[1];
                  param = 'value';
                  value = userChoice;
                  boolVal = true;
                  intVal = false;
                  strVal = false;
                  sensorSelected = 25;
                  break;
                // case 'ir_sensor_switch':
                //   sensorName = sensorEnum[5];
                //   param = 'value';
                //   value = userChoice;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   sensorSelected = 25;
                //   break;
                case 'temp_sensor_switch':
                  sensorName = sensorEnum[2];
                  param = 'value';
                  value = userChoice;
                  boolVal = true;
                  intVal = false;
                  strVal = false;
                  sensorSelected = 25;
                  break;
                // case 'siren_switch':
                //   sensorName = sensorEnum[7];
                //   param = 'value';
                //   value = userChoice;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   sensorSelected = 25;
                //   break;
                // case 'alarmState':
                //   sensorName = sensorEnum[8];
                //   param = 'value';
                //   value = userChoice;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   sensorSelected = 25;
                //   break;
                // case 'takePicture':
                //   sensorName = sensorEnum[9];
                //   param = 'value';
                //   value = userChoice;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   sensorSelected = 25;
                //   break;
                // case 'sendImageTo':
                //   sensorName = sensorEnum[10];
                //   param = 'value';
                //   value = userChoice;
                //   boolVal = false;
                //   intVal = false;
                //   strVal = true;
                //   sensorSelected = 25;
                //   break;
                case 'motion_operational_time (start hour)':
                  sensorName = 'motion_operational_time';
                  param = 'motion_start_hour';
                  value = userChoice;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  sensorSelected = 25;
                  break;
                case 'motion_operational_time (start minute)':
                  sensorName = 'motion_operational_time';
                  param = 'motion_start_minute';
                  value = userChoice;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  sensorSelected = 25;
                  break;
                case 'motion_operational_time (end hour)':
                  sensorName = 'motion_operational_time';
                  param = 'motion_end_hour';
                  value = userChoice;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  sensorSelected = 25;
                  break;
                case 'motion_operational_time (end minute)':
                  sensorName = 'motion_operational_time';
                  param = 'motion_end_minute';
                  value = userChoice;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  sensorSelected = 25;
                  break;
                case 'temp_threshold':
                  sensorName = sensorEnum[7];
                  param = 'value';
                  value = userChoice;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  sensorSelected = 25;
                  break;
                case 'Please select a sensor':
                  sensorSelected = 99;
                  sensorName = sensorEnum[0];
                  break;
              // default:
              //   sensorSelected = 25;
              //   break;
              }
              print(sensorSelected);
              _onSensorDropDownItemSelected(currentSensorSelected);
            });
          },
          isExpanded: true,
        ));
  }

  createAlertDialog(BuildContext context, String? title, String message) {
    Widget okButton = TextButton(
      child: Text("Close"),
      onPressed: () {Navigator.of(context).pop(); },
    );

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(title!), content: Text(message),  actions: [
            okButton,
          ],);
        });
  }

  // ignore: non_constant_identifier_names, missing_return
  Widget booleanTextField(){
    if(boolVal){
      return boolDropDown();
    }
    else if(intVal){
      return TextField(
        controller: txt,
        obscureText: false,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        onChanged: (text){
            var value = text;
            // print(userValue):
            // print(value);
            // if(value == ''){
            //   print('kosong');
            // }
          if(value != ''){
            userValue = int.parse(value);
            print(userValue);
          }
          else if(value == ''){
            print('kosong');
            userValue = null;
          }
        },
      );
    }
    else if (strVal){
      return TextFormField(
        controller: txt,
        obscureText: false,
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        validator: validateEmail,
        autovalidateMode: AutovalidateMode.always,
        onChanged: (text){
          setState(() {
            userValue = text;
          });
        },
      );
    }
    return SizedBox();
  }

  // ignore: missing_return
  String? validateEmail(String? value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern as String);
    if (!regex.hasMatch(value!)){
      return 'Enter a valid email address';
    }
    else{
      emailValidate = true;
      return null;
    }
  }

  void _onSensorDropDownItemSelected(String? newValueSelected) {
    setState(() {
      this.currentSensorSelected = newValueSelected;
    });
  }

  void _onBoolDropDownItemSelected(String? newValueSelected) {
    setState(() {
      this.currentBoolSelected = newValueSelected;
    });
  }

  refreshToken() async {
    try {
      var uri = Uri.parse(refreshTokenAPI);
      var request = new http.Request('POST', uri);

      request.headers[ioteraAppDomName] = ioteraAppDom;
      request.headers[ioteraAccIdName] = ioteraAccId;
      request.headers[ioteraAccRefToken] = token;

      var response = await request.send();
      var res = await response.stream.bytesToString();
      // print(res);

      Map<String, dynamic> listResult = jsonDecode(res.toString());
      RefreshToken refreshToken = RefreshToken.fromJson(listResult);

      // print(refreshToken.accessToken);

      setState(() {
        accessToken = refreshToken.accessToken;
        print('Access Token is $accessToken');
      });
    } catch (e) {
      debugPrint('Error $e');
    }
  }
}

