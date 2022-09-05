import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/refreshTokenModel.dart';
import 'dart:convert';
import '../model/newestDeviceDataModel.dart';

class NewestDeviceData extends StatefulWidget {
  final String appBarTitle;

  NewestDeviceData(this.appBarTitle);

  @override
  _NewestDeviceDataState createState() => _NewestDeviceDataState(this.appBarTitle);
}

class _NewestDeviceDataState extends State<NewestDeviceData> {
  _NewestDeviceDataState(this.appBarTitle);
  String newestDeviceDataAPI = 'https://api.iotera.io/v3/device/data/newest';
  String appBarTitle;
  String contentType = 'application/json';
  String ioteraAppDomName = 'Iotera-Application-Domain';
  String ioteraAccIdName = 'Iotera-Account-Id';
  String ioteraAppDom = 'infosystest';
  String ioteraAccId = '1000000155-1000000001';
  String ioteraAccRefToken = 'Iotera-Account-Refresh-Token';
  String ioteraAccAccessToken = 'Iotera-Account-Access-Token';
  String accessToken = '';
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
    // 'sendImageTo',
    'motion_operational_time (start hour)',
    'motion_operational_time (start minute)',
    'motion_operational_time (end hour)',
    'motion_operational_time (end minute)',
    'temp_threshold',
    'tempSensor',
    'motionSensor (motionStat)',
    'motionSensor (tamperStat)',
    'motionSensor (cableStat)',
    // 'battSensor',
    // 'mcbSensor',
    // 'doorSensor',
    // 'boxSensor',
    // 'irSensor',
    // 'pinSensor',
    // 'smartBox',
    // 'atmBox',
    // 'cardTrap',
    // 'cpuTemp',
  ];

  var currentSensorSelected = '';
  int sensorSelected = 99;
  var refreshTokenAPI = 'https://api.iotera.io/v3/token/refresh';

  String nData = '5';
  String sensorName;
  String config;
  String param;

  bool intVal;
  bool strVal;
  bool boolVal;

  String showTime;
  String showTimestamp;
  String showSensor;
  String showConfig;
  String showParam;
  String showValue;
  String showDataType;

  void initState(){
    super.initState();
    refreshToken();
    currentSensorSelected = sensorEnum[0];
  }

  newDeviceData() async {
    try {
      Map<String, dynamic> queryParams = {
        'device_id': device,
        'ndata': nData,
        'config': config,
        'sensor': sensorName,
        'param': param,
      };

      String queryString = Uri(queryParameters: queryParams).query;

      var uri = Uri.parse(newestDeviceDataAPI + '?' + queryString);
      var request = new http.Request('GET', uri);

      request.headers[ioteraAppDomName] = ioteraAppDom;
      request.headers[ioteraAccIdName] = ioteraAccId;
      request.headers[ioteraAccAccessToken] = accessToken;

      var response = await request.send();
      var res = await response.stream.bytesToString();
      print(res);

      Map<String, dynamic> listResult = jsonDecode(res.toString());
      NewestDeviceDataModel newestDeviceDataModel = NewestDeviceDataModel.fromJson(listResult);
      print(newestDeviceDataModel.data);

      var status = newestDeviceDataModel.status;
      var name = newestDeviceDataModel.data[0];
      var startTime = 'Time: ';
      var endTime = 'Timestamp: ';
      var startSensor = 'Sensor: ';
      var endSensor = 'Config: ';
      var endConfig = 'Param: ';
      var endParam = 'Value: ';
      if(status!= null){
        if(status == 'success'){
          var startIndexTime = name.toString().indexOf(startTime);
          var endIndexTime = name.toString().indexOf(endTime, startIndexTime + startTime.length);
          showTime = name.toString().substring(startIndexTime + startTime.length, endIndexTime);
          var startIndexStamp = name.toString().indexOf(endTime);
          var endIndexStamp = name.toString().indexOf(startSensor, startIndexStamp + endTime.length);
          showTimestamp = name.toString().substring(startIndexStamp + endTime.length, endIndexStamp);
          var startIndexSensor = name.toString().indexOf(startSensor);
          var endIndexSensor = name.toString().indexOf(endSensor, startIndexSensor + startSensor.length);
          showSensor = name.toString().substring(startIndexSensor + startSensor.length, endIndexSensor);
          var startIndexConfig = name.toString().indexOf(endSensor);
          var endIndexConfig = name.toString().indexOf(endConfig, startIndexConfig + endConfig.length);
          showConfig = name.toString().substring(startIndexConfig + startSensor.length, endIndexConfig);
          var startIndexParam = name.toString().indexOf(endConfig);
          var endIndexParam = name.toString().indexOf(endParam, startIndexParam + endConfig.length);
          showParam = name.toString().substring(startIndexParam + endConfig.length, endIndexParam);
          var startIndexValue = name.toString().indexOf(endParam);
          showValue = name.toString().substring(startIndexValue + endParam.length);
          if(intVal){
            showDataType = 'Number';
          }
          else if(boolVal){
            showDataType = 'Boolean';
          }
          else if(strVal){
            showDataType = 'String';
          }
        }
      }
    }
    catch(e){
      debugPrint('Error $e');
    }
    createAlertDialog(context, 'Request Details', 'Data Type: $showDataType\n\nTime: $showTime\nTimeStamp: $showTimestamp\nSensor: $showSensor\nConfig: $showConfig\nParam: $showParam\nValue: $showValue');
    }

    Widget newDeviceDataUI(){
    return Scaffold(
      appBar: AppBar(
        title: Text('Newest Device Data'),
      ),
      body: ListView(
        children: [
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
      FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
          ),
      child: Text('Submit'),
        onPressed: () {
        newDeviceData();
        }),
        ],
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
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'box_sensor_switch':
                //   sensorName = sensorEnum[2];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'mcb_sensor_switch':
                //   sensorName = sensorEnum[3];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                case 'motion_sensor_switch':
                  sensorName = 'motion_sensor_switch';
                  param = 'value';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = true;
                  intVal = false;
                  strVal = false;
                  break;
                // case 'ir_sensor_switch':
                //   sensorName = sensorEnum[5];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                case 'temp_sensor_switch':
                  sensorName = 'temp_sensor_switch';
                  param = 'value';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = true;
                  intVal = false;
                  strVal = false;
                  break;
                // case 'siren_switch':
                //   sensorName = sensorEnum[7];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'alarmState':
                //   sensorName = sensorEnum[8];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'sendImageTo':
                //   sensorName = sensorEnum[9];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = false;
                //   intVal = false;
                //   strVal = true;
                //   break;
                case 'motion_operational_time (start hour)':
                  sensorName = 'motion_operational_time';
                  param = 'motion_start_hour';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  break;
                case 'motion_operational_time (start minute)':
                  sensorName = 'motion_operational_time';
                  param = 'motion_start_minute';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  break;
                case 'motion_operational_time (end hour)':
                  sensorName = 'motion_operational_time';
                  param = 'motion_end_hour';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  break;
                case 'motion_operational_time (end minute)':
                  sensorName = 'motion_operational_time';
                  param = 'motion_end_minute';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  break;
                case 'temp_threshold':
                  sensorName = 'temp_threshold';
                  param = 'value';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  break;
                case 'tempSensor':
                  sensorName = 'tempSensor';
                  param = 'tempVal';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = false;
                  intVal = true;
                  strVal = false;
                  break;
                case 'motionSensor (motionStat)':
                  sensorName = 'motionSensor';
                  param = 'motionStat';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = true;
                  intVal = false;
                  strVal = false;
                  break;
                case 'motionSensor (tamperStat)':
                  sensorName = 'motionSensor';
                  param = 'tamperStat';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = true;
                  intVal = false;
                  strVal = false;
                  break;
                case 'motionSensor (cableStat)':
                  sensorName = 'motionSensor';
                  param = 'cableStat';
                  config = 'data';
                  sensorSelected = 25;
                  boolVal = true;
                  intVal = false;
                  strVal = false;
                  break;
                // case 'battSensor':
                //   sensorName = sensorEnum[18];
                //   param = 'battVal';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = false;
                //   intVal = true;
                //   strVal = false;
                //   break;
                // case 'mcbSensor':
                //   sensorName = sensorEnum[19];
                //   param = 'mcbStat';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'doorSensor':
                //   sensorName = sensorEnum[20];
                //   param = 'doorStat';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'boxSensor':
                //   sensorName = sensorEnum[21];
                //   param = 'boxStat';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'irSensor':
                //   sensorName = sensorEnum[22];
                //   param = 'irStat';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'pinSensor':
                //   sensorName = sensorEnum[23];
                //   param = 'cableStat';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'smartBox':
                //   sensorName = sensorEnum[24];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'atmBox':
                //   sensorName = sensorEnum[25];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'cardTrap':
                //   sensorName = sensorEnum[26];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = true;
                //   intVal = false;
                //   strVal = false;
                //   break;
                // case 'cpuTemp':
                //   sensorName = sensorEnum[27];
                //   param = 'value';
                //   config = 'data';
                //   sensorSelected = 25;
                //   boolVal = false;
                //   intVal = true;
                //   strVal = false;
                //   break;
              // default:
              //   sensorSelected = 25;
              //   break;
              }
              print(sensorSelected);
              _onSensorDropDownItemSelected(value);
            });
          },
          isExpanded: true,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: newDeviceDataUI(),
    );
  }

  createAlertDialog(BuildContext context, String title, String message) {
    Widget okButton = TextButton(
      child: Text("Close"),
      onPressed: () {Navigator.of(context).pop(); },
    );

    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(title), content: Text(message),  actions: [
            okButton,
          ],);
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

  void _onSensorDropDownItemSelected(String newValueSelected) {
    setState(() {
      this.currentSensorSelected = newValueSelected;
    });
  }
}
