import 'dart:convert';
// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple_app/iotera/screen/commandDeviceScreen.dart';
import 'package:simple_app/iotera/screen/newestDeviceData.dart';
import 'model/refreshTokenModel.dart';
// import 'model/atmSensorModel.dart';
import 'model/getDeviceProfileModel.dart';
import 'constans.dart';
import 'model/commandDeviceModel.dart';
import 'screen/getDeviceProfile.dart';
import 'package:simple_app/screens/unavailable.dart';

class Iotera extends StatefulWidget {

  final String appBarTitle;

  Iotera(this.appBarTitle);

  @override
  State<StatefulWidget> createState() {
    return IoteraState(this.appBarTitle);
  }
}

class IoteraState extends State<Iotera> {
  IoteraState(this.appBarTitle);
  String appBarTitle;
  TabController tabController;
  String token =
      'b46e69391acecd970e15d8af33e43ca044a3ff677bacb5ddaf15f3d8a5b42d5f';
  String contentType = 'application/json';
  String ioteraAppDomName = 'Iotera-Application-Domain';
  String ioteraAccIdName = 'Iotera-Account-Id';
  String ioteraAppDom = 'infosystest';
  String ioteraAccId = '1000000155-1000000001';
  String ioteraAccRefToken = 'Iotera-Account-Refresh-Token';
  String ioteraAccAccessToken = 'Iotera-Account-Access-Token';
  String accessToken = '';
  String testing = 'testing';
  String commandDeviceSuccess = '';
  String commandDeviceStatusMessage = '';
  String device = '14e1a2d8-d4b4-4e05-9399-ab9592b83d00';
  String accessCode;

  var deviceIdEnum = ['14e1a2d8-d4b4-4e05-9399-ab9592b83d00'];
  var sensorEnum = [
    'Select a sensor',
    'door sensor switch',
    'box sensor switch',
    'mcd sensor switch',
    'motion sensor switch',
    'ir sensor swtich',
    'temp sensor switch',
    'siren switch',
    'alarm state',
    'take picture',
    'send image to',
    'motion operational time',
    'temp threshold',
    'temp sensor',
    'motion sensor',
    'batt sensor',
    'mcd sensor',
    'door sensor',
    'box sensor',
    'ir sensor',
    'pin sensor',
    'smart box',
    'atm box',
    'card trap',
    'cpu temp',
    'camera',
  ];
  var currentSensorSelected = '';
  int sensorSelected = 99;
  var currentDeviceIdSelected = '';
  String deviceIdSelected = '';

  var refreshTokenAPI = 'https://api.iotera.io/v3/token/refresh';
  var atmSensorAPI = 'https://api.iotera.io/v3/device/mqtt/get';
  var getDeviceProfileAPI = 'https://api.iotera.io/v3/device/get';
  var configDeviceAPI = 'https://api.iotera.io/v3/device/config';
  var commandDeviceAPI = 'https://api.iotera.io/v3/device/command';
  var sensorLatestAPI = 'https://api.iotera.io/v3/device/sensors/latest';
  var listTagCategoryAPI = 'https://api.iotera.io/v3/device/tag/category/list';
  var createTagDefinitionAPI =
      'https://api.iotera.io/v3/device/tag/definition/create';
  var listTagDefinitionAPI =
      'https://api.iotera.io/v3/device/tag/definition/list/prefix';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // refreshToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Iotera'),
      ),
        body: CustomScrollView(
          primary: false,
          slivers: <Widget>[
            SliverPadding(
              padding: const EdgeInsets.all(20),
              sliver: SliverGrid.count(
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                children: <Widget>[
                  getProductMenuItem('Get Device Profile'),
                  getProductMenuItem('Command Device'),
                  getProductMenuItem('Newest Device Data'),
                  // getProductMenuItem('ASLI'),
                  // getProductMenuItem('Microblink'),
                  // getProductMenuItem('Rel ID'),
                  // getProductMenuItem('Nodeflux'),
                  // getProductMenuItem('Iotera'),
                  // getProductMenuItem('Others'),
                ],
              ),
            ),
          ],
        )
    );
  }

  Widget getProductMenuItem(String productName) {
    return Material(
      color: Colors.white,
      child: InkWell(
        onTap: () => navigateToProductPage(productName), // handle your onTap here
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.all(
                Radius.circular(5.0)
            ),
          ),
          child: Text(productName),
        ),
      ),
    );
  }

  void navigateToProductPage(String title) async {
    bool result=await Navigator.push(context, MaterialPageRoute(builder:(context){
      switch (title) {
        case 'Get Device Profile':
          return getDeviceProfileScreen(title);
          break;
        case 'Command Device':
          return CommandDeviceScreen(title);
          break;
        case 'Newest Device Data':
          return NewestDeviceData(title);
          break;
//         case 'Microblink':
//           return Microblink();
// //          return Asli(title, cameras, livenessExtDir);
//           break;
//         case 'Nodeflux':
//           return Nodeflux(title);
//           break;
// //        case 'LiveBank':
// //          return LiveBank(title);
// //          break;
//         case 'Rel ID':
//           return HomeScreen();
//           break;
//         case 'Iotera':
//           return Iotera(title);
//           break;
// //       case 'Kata.ai':
// //         return KataAi(title);
// //         break;
        default:
          return Unavailable(title);
      }
    }
    ));
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
      print(res);

      Map<String, dynamic> listResult = jsonDecode(res.toString());
      RefreshToken refreshToken = RefreshToken.fromJson(listResult);

      // print(refreshToken.accessToken);

      setState(() {
        accessToken = refreshToken.accessToken;
        accessCode = refreshToken.accessToken;
        print('Access Token is $accessToken');
      });
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  getDeviceProfile() async {
    try {
      Map<String, String> queryParams = {'device_id': device};

      String queryString = Uri(queryParameters: queryParams).query;

      var uri = Uri.parse(getDeviceProfileAPI + '?' + queryString);
      var request = new http.Request('GET', uri);

      request.headers[ioteraAppDomName] = ioteraAppDom;
      request.headers[ioteraAccIdName] = ioteraAccId;
      request.headers[ioteraAccAccessToken] = accessToken;

      var response = await request.send();
      var res = await response.stream.bytesToString();
      print(res);

      Map<String, dynamic> listResult = jsonDecode(res.toString());
      GetDevicesProfileModel getDevicesProfileModel =
          GetDevicesProfileModel.fromJson(listResult);

      print(getDevicesProfileModel.device);
    } catch (e) {
      debugPrint('Error $e');
    }

    // if(sensorSelected > 24){
    //   createAlertDialog(context, 'You have not selected any sensor', 'Please Select a sensor');
    // }
  }

  Widget getDeviceProfileUI() {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          Center(
            child: Padding(
                padding: EdgeInsets.all(10.0),
              child: Text('Select Sensor'),
            ),
          ),
          deviceSensorDropdown(),
          Center(
            child: Padding(
              padding: EdgeInsets.all(10.0),
              child: Text('Select Device ID'),
            ),
          ),
          // deviceIdDropDown(),
          FloatingActionButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15.0))
            ),
            child: Text('Submit'),
            onPressed: () {
              if(sensorSelected > 24){
                createAlertDialog(context, 'You have not selected any sensor', 'Please Select a sensor');
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

  Widget deviceIdDropDown(){
    Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(10)
      ),
      child: new DropdownButton<String>(
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 42,
        underline: SizedBox(),
        items: deviceIdEnum.map((dynamic value){
          return DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        value: currentDeviceIdSelected,
        onChanged: (value){
          setState(() {
            currentDeviceIdSelected = value;
            print(currentDeviceIdSelected);
            switch(value){
              case '14e1a2d8-d4b4-4e05-9399-ab9592b83d00':
                deviceIdSelected = '1';
                break;
            }
            print(deviceIdSelected);
            _onSensorDeviceIdDropDownItemSelected(value);
          });
        },
        isExpanded: true,
      ),
    );
  }

  Widget deviceSensorDropdown() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10)),
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
                case 'door sensor switch':
                  sensorSelected = 0;
                  break;
                case 'box sensor switch':
                  sensorSelected = 1;
                  break;
                case 'mcd sensor switch':
                  sensorSelected = 2;
                  break;
                case 'motion sensor switch':
                  sensorSelected = 3;
                  break;
                case 'ir sensor switch':
                  sensorSelected = 4;
                  break;
                case 'temp sensor switch':
                  sensorSelected = 5;
                  break;
                case 'siren switch':
                  sensorSelected = 6;
                  break;
                case 'alarm state':
                  sensorSelected = 7;
                  break;
                case 'take picture':
                  sensorSelected = 8;
                  break;
                case 'send image to':
                  sensorSelected = 9;
                  break;
                case 'motion operational time':
                  sensorSelected = 10;
                  break;
                case 'temp threshold':
                  sensorSelected = 11;
                  break;
                case 'temp sensor':
                  sensorSelected = 12;
                  break;
                case 'motion sensor':
                  sensorSelected = 13;
                  break;
                case 'batt sensor':
                  sensorSelected = 14;
                  break;
                case 'mcd sensor':
                  sensorSelected = 15;
                  break;
                case 'door sensor':
                  sensorSelected = 16;
                  break;
                case 'box sensor':
                  sensorSelected = 17;
                  break;
                case 'ir sensor':
                  sensorSelected = 18;
                  break;
                case 'pin sensor':
                  sensorSelected = 19;
                  break;
                case 'smart box':
                  sensorSelected = 20;
                  break;
                case 'atm box':
                  sensorSelected = 21;
                  break;
                case 'card trap':
                  sensorSelected = 22;
                  break;
                case 'cpu temp':
                  sensorSelected = 23;
                  break;
                case 'camera':
                  sensorSelected = 24;
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

  configDevice() async {
    try {
      var param = {
        {
          "device_id": device,
          "sensor": "humid",
          "param": "\$sampling",
          "value": 1000
        }
      };

      var uri = Uri.parse(configDeviceAPI);
      var request = new http.Request('POST', uri);

      request.headers[ioteraAppDomName] = ioteraAppDom;
      request.headers[ioteraAccIdName] = ioteraAccId;
      request.headers[ioteraAccAccessToken] = accessToken;
      request.body = json.encode(param);

      var response = await request.send();
      var res = await response.stream.bytesToString();
      print(res);

      Map<String, dynamic> listResult = jsonDecode(res.toString());
    } catch (e) {}
  }

  commandDevice() async {
    try {
      var param = {
        "device_id": device,
        "sensor": "humid",
        "param": "\$sampling",
        "value": true
      };

      var uri = Uri.parse(commandDeviceAPI);
      var request = new http.Request('POST', uri);

      request.headers[ioteraAppDomName] = ioteraAppDom;
      request.headers[ioteraAccIdName] = ioteraAccId;
      request.headers[ioteraAccAccessToken] = accessToken;
      request.body = json.encode(param);

      var response = await request.send();
      var res = await response.stream.bytesToString();
      print(res);

      Map<String, dynamic> listResult = jsonDecode(res.toString());
      CommandDeviceModel commandDeviceModel =
          CommandDeviceModel.fromJson(listResult);

      commandDeviceSuccess = commandDeviceModel.status;
      commandDeviceStatusMessage = commandDeviceModel.statusMessage;
      print('Status: $commandDeviceSuccess, $commandDeviceStatusMessage');
    } catch (e) {}
  }

  Widget commandDeviceUI() {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          FloatingActionButton(
            child: Text('click'),
            onPressed: () {
              commandDevice();
            },
          )
        ],
      ),
    );
  }

  listTagCategory() async {
    try {
      var uri = Uri.parse(listTagCategoryAPI);
      var request = new http.Request('GET', uri);

      request.headers[ioteraAppDomName] = ioteraAppDom;
      request.headers[ioteraAccIdName] = ioteraAccId;
      request.headers[ioteraAccAccessToken] = accessToken;

      var response = await request.send();
      var res = await response.stream.bytesToString();
      print(res);
    } catch (e) {}
  }

  createTagDefinition() async {
    try {
      var param = {'prefix': 'testing', 'name_lc': ''};
    } catch (e) {}
  }

  listTagDefinition() async {
    try {
      Map<String, String> queryParams = {'prefix': testing};

      String queryString = Uri(queryParameters: queryParams).query;

      var uri = Uri.parse(listTagDefinitionAPI + '?' + queryString);
      var request = new http.Request('GET', uri);

      request.headers[ioteraAppDomName] = ioteraAppDom;
      request.headers[ioteraAccIdName] = ioteraAccId;
      request.headers[ioteraAccAccessToken] = accessToken;

      var response = await request.send();
      var res = await response.stream.bytesToString();
      print(res);
    } catch (e) {
      debugPrint('Error $e');
    }
  }

  Widget listTagDefinitionUI() {
    return Scaffold(
      body: ListView(
        children: <Widget>[
          FloatingActionButton(
            child: Text('click'),
            onPressed: () {
              listTagDefinition();
            },
          )
        ],
      ),
    );
  }

  void _onSensorDropDownItemSelected(String newValueSelected) {
    setState(() {
      this.currentSensorSelected = newValueSelected;
    });
  }

  void _onSensorDeviceIdDropDownItemSelected(String newValueSelected) {
    setState(() {
      this.currentDeviceIdSelected = newValueSelected;
    });
  }

  createAlertDialog(BuildContext context, String title, String message) {
    Widget okButton = FlatButton(
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
}

