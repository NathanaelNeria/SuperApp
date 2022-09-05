import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
// import 'package:simple_app/iotera/model/getDeviceProfileModel.dart';
import '../model/refreshTokenModel.dart';
import '../model/atmSensorModel.dart';

// ignore: must_be_immutable, camel_case_types
class getDeviceProfileScreen extends StatefulWidget {
  final String appBarTitle;

  getDeviceProfileScreen(this.appBarTitle);

  // @override
  // _getDeviceProfileScreenState createState() => _getDeviceProfileScreenState();
  @override
  State<StatefulWidget> createState() {
    return _getDeviceProfileScreenState(this.appBarTitle);
  }
}

// ignore: camel_case_types
class _getDeviceProfileScreenState extends State<getDeviceProfileScreen> {
  _getDeviceProfileScreenState(this.appBarTitle);
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

  var deviceIdEnum = ['14e1a2d8-d4b4-4e05-9399-ab9592b83d00'];
  var sensorEnum = [
    'Please select a sensor',
    'door_sensor_switch',
    'box_sensor_switch',
    'mcb_sensor_switch',
    'motion_sensor_switch',
    'ir_sensor_switch',
    'temp_sensor_switch',
    'siren_switch',
    'alarmState',
    'takePicture',
    'sendImageTo',
    'motion_operational_time',
    'temp_threshold',
    'tempSensor',
    'motionSensor',
    'battSensor',
    'mcbSensor',
    'doorSensor',
    'boxSensor',
    'irSensor',
    'pinSensor',
    'smartBox',
    'atmBox',
    'cardTrap',
    'cpuTemp',
    'camera',
  ];
  var currentSensorSelected = '';
  int sensorSelected = 99;
  var currentDeviceIdSelected = '';
  int deviceIdSelected;

  var dataType;
  var sensor;
  var configType;
  var param;
  var sensorName;

  var refreshTokenAPI = 'https://api.iotera.io/v3/token/refresh';
  var getDeviceProfileAPI = 'https://api.iotera.io/v3/device/get';
  var atmSensorAPI = 'https://api.iotera.io/v3/device/mqtt/get';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: getDeviceProfileUI(),
    );
  }

  void initState(){
    super.initState();
    currentSensorSelected = sensorEnum[0];
    refreshToken();
  }


  getDeviceProfile() async {
    try {
      Map<String, String> queryParams = {'device_id': device};

      String queryString = Uri(queryParameters: queryParams).query;

      var uri = Uri.parse(atmSensorAPI + '?' + queryString);
      var request = new http.Request('GET', uri);

      request.headers[ioteraAppDomName] = ioteraAppDom;
      request.headers[ioteraAccIdName] = ioteraAccId;
      request.headers[ioteraAccAccessToken] = accessToken;

      var response = await request.send();
      var res = await response.stream.bytesToString();
      print(res);

      Map<String, dynamic> listResult = jsonDecode(res.toString());
      // GetDevicesProfileModel getDevicesProfileModel =
      // GetDevicesProfileModel.fromJson(listResult);
      AtmSensorModel atmSensorModel = AtmSensorModel.fromJson(listResult);

      // print(getDevicesProfileModel.device);
      // print(atmSensorModel.sensors);
      var startDT = 'Dt.';
      var endDT = 'Sensor:';
      var startSensor = 'Sensor: ';
      var endSensor = 'Config';
      var startConfig = 'Configtype.';
      var endConfig = 'Param: ';
      sensorName = atmSensorModel.sensors[sensorSelected];
      if(sensorName.toString().contains(sensorEnum[0])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[1])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[2])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[3])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[4])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[5])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[6])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[7])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[8])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[9])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[10])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[11])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[12])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[13])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[14])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[15])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[16])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[17])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[18])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[19])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[20])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[21])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[22])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else if(sensorName.toString().contains(sensorEnum[23])){
        var startIndex = sensorName.toString().indexOf(startDT);
        var endIndex = sensorName.toString().indexOf(endDT, startIndex + startDT.length);
        var dT = sensorName.toString().substring(startIndex + startDT.length, endIndex);
        setState(() {
          dataType = dT;
        });
      }
      else{
        print('error ada yg ga sama');
      }

      var sensorSIndex = sensorName.toString().indexOf(startSensor);
      var sensorEIndex = sensorName.toString().indexOf(endSensor, sensorSIndex + startSensor.length);
      var sensorN = sensorName.toString().substring(sensorSIndex + startSensor.length,sensorEIndex);
      var configStartIndex = sensorName.toString().indexOf(startConfig);
      var configEndIndex = sensorName.toString().indexOf(endConfig, configStartIndex + startConfig.length);
      var configTypeString = sensorName.toString().substring(configStartIndex + startConfig.length, configEndIndex);
      var paramStartIndex = sensorName.toString().indexOf(endConfig);
      var paramString = sensorName.toString().substring(paramStartIndex + endConfig.length);
      setState(() {
        sensor = sensorN;
        configType = configTypeString;
        param = paramString;
      });
      print(dataType);
      print(sensor);
      print(configType);
      print(param);
    } catch (e) {
      debugPrint('Error $e');
    }

    createAlertDialog(context, 'Request results', 'Data Type: $dataType\nSensor: $sensor\nConfig Type: $configType\nParam: $param');
  }

  Widget getDeviceProfileUI() {
    return Scaffold(
      appBar: AppBar(
        title: Text('Get Device Profile'),
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
          FloatingActionButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            child: Text('Submit'),
            onPressed: () {
              if(sensorSelected > 50){
                createAlertDialog(context, 'You have not selected any sensor', 'Please select a sensor from the drop down');
              }
              else{
                getDeviceProfile();
              }
            },
          )
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
                case 'door_sensor_switch':
                  sensorSelected = 0;
                  break;
                case 'box_sensor_switch':
                  sensorSelected = 2;
                  break;
                case 'mcb_sensor_switch':
                  sensorSelected = 4;
                  break;
                case 'motion_sensor_switch':
                  sensorSelected = 6;
                  break;
                case 'ir_sensor_switch':
                  sensorSelected = 8;
                  break;
                case 'temp_sensor_switch':
                  sensorSelected = 10;
                  break;
                case 'siren_switch':
                  sensorSelected = 12;
                  break;
                case 'alarmState':
                  sensorSelected = 14;
                  break;
                case 'takePicture':
                  sensorSelected = 17;
                  break;
                case 'sendImageTo':
                  sensorSelected = 18;
                  break;
                case 'motion_operational_time':
                  sensorSelected = 20;
                  break;
                case 'temp_threshold':
                  sensorSelected = 28;
                  break;
                case 'tempSensor':
                  sensorSelected = 30;
                  break;
                case 'motionSensor':
                  sensorSelected = 34;
                  break;
                case 'battSensor':
                  sensorSelected = 37;
                  break;
                case 'mcbSensor':
                  sensorSelected = 38;
                  break;
                case 'doorSensor':
                  sensorSelected = 39;
                  break;
                case 'boxSensor':
                  sensorSelected = 41;
                  break;
                case 'irSensor':
                  sensorSelected = 43;
                  break;
                case 'pinSensor':
                  sensorSelected = 44;
                  break;
                case 'smartBox':
                  sensorSelected = 45;
                  break;
                case 'atmBox':
                  sensorSelected = 46;
                  break;
                case 'cardTrap':
                  sensorSelected = 47;
                  break;
                case 'cpuTemp':
                  sensorSelected = 48;
                  break;
                case 'camera':
                  sensorSelected = 50;
                  break;
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

  void _onSensorDropDownItemSelected(String newValueSelected) {
    setState(() {
      this.currentSensorSelected = newValueSelected;
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