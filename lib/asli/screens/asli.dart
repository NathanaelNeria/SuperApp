import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

import 'package:async/async.dart';
import 'package:http/http.dart' as http;

import 'package:simple_app/asli/models/asli_data_model.dart';
import 'package:simple_app/asli/models/asli_gestures_set_names_model.dart';
import 'package:simple_app/asli/models/asli_response_model.dart';
import 'package:simple_app/asli/models/asli_errors_model.dart';

import 'package:flutter_image_compress/flutter_image_compress.dart';

import 'package:geolocator/geolocator.dart' as geo;
import 'package:location/location.dart' as loc;


//import 'package:simple_app/model/fetchIdCardModel.dart';
//import 'package:simple_app/model/ktpModel.dart';
//import 'package:simple_app/model/ocrModel.dart';
//import 'package:simple_app/views/fetchIdCard.dart';

import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jiffy/jiffy.dart';
import 'package:path/path.dart';
import 'package:simple_app/asli/screens/photo_compressor.dart';

List<CameraDescription> cameras = [];
Directory livenessExtDir=null;

class Asli extends StatefulWidget {
  final String appBarTitle;
  Asli(this.appBarTitle, cameras, livenessExtDir);

  @override
  State<StatefulWidget> createState() {
    return AsliState(this.appBarTitle);
  }
}

IconData getCameraLensIcon(CameraLensDirection direction) {
  switch (direction) {
    case CameraLensDirection.back:
      return Icons.camera_rear;
    case CameraLensDirection.front:
      return Icons.camera_front;
    case CameraLensDirection.external:
      return Icons.camera;
  }
  throw ArgumentError('Unknown lens direction');
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

void _showCameraException(CameraException e) {
  logError(e.code, e.description);
}

class AsliState extends State<Asli> with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  final _formKey = new GlobalKey<FormState>();
  AsliState(this.appBarTitle);
  String appBarTitle;
  DateTime selectedbirthdate=null;
  DateTime selectedcertificatedate=null;
  var loading;
  File _professionalImage;
  // File photo1;
  // File photo2;
  // File photo3;
  // File photo4;
  // File photo5;
  // File photo6;
  // File photo7;
  // File photo8;
  List<File> livenessPhotos=List(8);
  List<File> livenessCompressedPhotos=List(8);
  // File photo1Compressed;
  // File photo2Compressed;
  // File photo3Compressed;
  // File photo4Compressed;
  // File photo5Compressed;
  // File photo6Compressed;
  // File photo7Compressed;
  // File photo8Compressed;
  String gestureSetSelected;
  var res;
  String gestureValue;
  String gesture;
  bool isGestureSelected = false;


  TextEditingController nikController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController birthdateController = TextEditingController();
  TextEditingController birthplaceController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobilePhoneController = TextEditingController();
  TextEditingController motherNameController = TextEditingController();
  TextEditingController messageResultController=TextEditingController();
  TextEditingController companyNameController=TextEditingController();
  TextEditingController companyPhoneController=TextEditingController();
  TextEditingController homeLatitudeController=TextEditingController();
  TextEditingController homeLongitudeController=TextEditingController();
  TextEditingController workLatitudeController=TextEditingController();
  TextEditingController workLongitudeController=TextEditingController();

  TextEditingController npwpController = TextEditingController();
  TextEditingController incomeController = TextEditingController();

  TextEditingController nopController = TextEditingController();
  TextEditingController propertyNameController = TextEditingController();
  TextEditingController propertySurfaceAreaController = TextEditingController();
  TextEditingController propertyBuildingAreaController = TextEditingController();
  TextEditingController propertyEstimationController=TextEditingController();
  TextEditingController certificateNameController=TextEditingController();
  TextEditingController certificateIdController=TextEditingController();
  TextEditingController certificateTypeController=TextEditingController();
  TextEditingController certificateDateController=TextEditingController();
  TabController tabController;

  var _propertyTypeEnum = ['<Certificate Type>', 'HM', 'HGB'];
  var _currentPropertySelected = '';
  var _taxTypeEnum = ['<Please Choose Tax Type>', 'Personal Tax', 'Company Tax'];
  var _currentTaxSelected = '';
  var _gestureSetEnum = ['left eye closed, mouth closed, right eye closed','left eye closed, mouth closed, right eye open', 'left eye closed, mouth open, right eye closed', 'left eye closed, mouth open, right eye open', 'left eye open, mouth closed, right eye closed', 'left eye open, mouth closed, right eye open', 'left eye open, mouth open, right eye closed', 'left eye open, mouth open, right eye open'];
  var _currentGestureSelected = '';

  Map personalApiResultBool = Map<String, bool>();
  Map personalApiResultMessage=Map<String, String>();
  Map workplaceApiResultBool = Map<String, bool>();
  Map workplaceApiResultMessage=Map<String, String>();
  Map locationApiResultBool = Map<String, bool>();
  Map locationApiResultMessage=Map<String, String>();
  Map taxApiResultBool = Map<String, bool>();
  Map taxApiResultMessage=Map<String, String>();
  Map propertyApiResultBool=new Map<String, bool>();
  Map propertyApiResultMessage=new Map<String, String>();
//  Map officeApiResultBool = Map<String, bool>();
//  Map officeApiResultMessage=Map<String, String>();
  Map livenessApiResultBool = new Map<String, bool>();
  Map livenessApiResultMessage = new Map<String, String>();

  String _nikErrorMessage;
  String _nameErrorMessage;
  String _birthdateErrorMessage;
  String _birthplaceErrorMessage;
  String _addressErrorMessage;
  String _mobilePhoneErrorMessage;
  String _motherNameErrorMessage;
  String _selfieErrorMessage;

  String _companyNameErrorMessage;
  String _companyPhoneErrorMessage;
  String _homeLatitudeErrorMessage;
  String _homeLongitudeErrorMessage;
  String _workLatitudeErrorMessage;
  String _workLongitudeErrorMessage;

  String _taxTypeErrorMessage;
  String _npwpErrorMessage;
  String _incomeErrorMessage;

  String _nopErrorMessage;
  String _propertyNameErrorMessage;
  String _propertySurfaceAreaErrorMessage;
  String _propertyBuildingAreaErrorMessage;
  String _propertyEstimationErrorMessage;
  String _certificateNameErrorMessage;
  String _certificateIdErrorMessage;
  String _certificateTypeErrorMessage;
  String _certificateDateErrorMessage;

  String _homeLatitude='';
  String _homeLongitude='';

  // For Testing
  bool useDummyProfessionalApiResult=false;
  bool useDummyNegativeRecordApiResult=false;
  bool useDummyPhoneAgeApiResult=false;
  bool useDummyPhoneExtraApiResult=false;
  bool useDummyHomeLocationApiResult=false;
  bool useDummyWorkLocationApiResult=false;
  bool useDummyTaxExtraApi=false;
  bool useDummyTaxCompanyApiResult=false;
  bool useDummyPropertyApiResult=false;
  bool useDummyWorkplaceApiResult=false;
  //bool isPersonalTax;

  bool usePrefilledData=false;

  String imgPath;
  CameraController controller;

  int professionalMinPhotoSize=256000;
  int professionalMaxPhotoSize=512000;
  int livenessMinPhotoSize=163840; // 200KB
  int livenessMaxPhotoSize=262144; //256KB
  bool enableAudio = true;

//  bool isContinuePhoto;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _currentPropertySelected = _propertyTypeEnum[1];
    _currentTaxSelected=_taxTypeEnum[1];
    _currentGestureSelected=_gestureSetEnum[0];
    loading=false;

    tabController = TabController(vsync: this, length: 5);
    //_loadLiveness();
  }

  // _loadLiveness() async {
  //   final response =
  //   await http.get("https://jsonplaceholder.typicode.com/posts/");
  //   if (response.statusCode == 200) {
  //     await Future.delayed(const Duration(seconds: 1));
  //     if (mounted) {
  //       setState(() {
  //         list = json.decode(response.body) as List;
  //       });
  //     }
  //   } else {
  //     throw Exception('Failed to load posts');
  //   }
  // }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // App state changed before we got the chance to initialize.
    if (controller == null || !controller.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      if (controller != null) {
        onNewCameraSelected(controller.description);
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(this.context).textTheme.title;
    if (usePrefilledData)
      prefilledInput();

    return DefaultTabController(
      length: 5,
      child: Scaffold(
          appBar: AppBar(
            title: Text('ASLI RI'),
            bottom: TabBar(
              controller: tabController,
              onTap: (int index) async {
                //your currently selected index
                // print('current index is'+index.toString());
                if (index==1) {
                  await showDialog(
                      context: context,
                      builder: (_) => showMessage(context)
                  );
                  setState(() {
                    // controller == null;
                  });
                } else {
                  _currentGestureSelected=_gestureSetEnum[0];
                  //controller.dispose();
                }
                // else {constructHowToLiveness(context);}
              },
              isScrollable: true,
              tabs: [
                Tab(text: 'Personal', icon: Icon(Icons.person)),
                Tab(text: 'Liveness', icon: Icon(Icons.face)),
                Tab(text: 'Location', icon: Icon(Icons.location_on)),
                Tab(text: 'Workplace', icon: Icon(Icons.business)),
                Tab(text: 'Tax', icon: Icon(Icons.business_center)),
                //Tab(text: 'Property', icon: Icon(Icons.home)),
                //Tab(text: 'Camera', icon: Icon(Icons.camera_alt)),
              ],
            ),
          ),
          body:
          Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child:
            SafeArea(
              bottom: false,
              child: TabBarView(
                controller: tabController,
                children: [
                  // PersonalPageUI(textStyle),
                  PersonalPageUI0(textStyle),
                  LivenessPageUI0(),
                  //CameraTestUI(),
                  LocationPageUI0(),
                  WorkplacePageUI0(textStyle),
                  TaxPageUI0(textStyle),
                  //PropertyPageUI(),

                ],
              ),
            ),
          )
      ),
    );
  }

  // constructHowToLiveness(BuildContext context) {
  //   String message='';
  //   message+='1. Choose one of the cameras\n\n';
  //   message+='2. Select one of the gestures\n\n';
  //   message+='3. Click  button.\n\n4. Hold the exact pose as selected on step 2 until picture taking success notification\n\n';
  //   // message+='(return this step if photo taking process is failed)\n';
  //   message+='5. Click  button and wait for Liveness Verification result.\n\n';
  //   //message+='5. Wait for few seconds until your Liveness Verification result shows up.\n\n';
  //   message+='Finish!\nYou have completed Liveness Verification process\n\nClick current tab\n\n\nif you want to view this instruction again.';
  //   createAlertDialog(context, 'How to Check Liveness', message);
  // }


  Widget showApiFieldVerification(Map<String, bool> currentResultBoolMap, Map<String, String> currentResultMessageMap, String key){
    if (currentResultBoolMap.isNotEmpty && currentResultMessageMap.isNotEmpty) {
      if (currentResultMessageMap.containsKey(key)) {
        String message=currentResultMessageMap[key];
        bool isValid=null;
        bool isInfo=null;
        if (currentResultBoolMap.containsKey(key)){
          if (currentResultBoolMap[key]==null){
            isInfo=true;
            isValid=true;
          } else {
            isInfo=false;
            isValid = currentResultBoolMap[key];
          }
          if (message.length > 0 && message != null) {
            return Container(
              //padding: EdgeInsets.all(5),
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top:5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Container(width: 5),
                  isInfo? (Icon(Icons.error, color: Colors.blue)) :
                  (isValid? (Icon(Icons.check_circle, color: Colors.green)):(Icon(Icons.cancel, color: Colors.red))),
                  //Container(width: 5),
                  Text(
                    message,
                    style: TextStyle(
                      color: isInfo? (Colors.blue):
                      (isValid? Colors.green:Colors.red),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 13,
                      height:1.0,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        }
        //bool isValid=personalApiResultBool[key];
        //bool isInfo=personalApiResultBool.containsKey(key);


      } else
        return Container();
      //return null;
    }
  }

  Widget showApiFieldVerification2(String key){
    print('show '+ key +' result');
    if (personalApiResultBool.isNotEmpty && personalApiResultMessage.isNotEmpty) {
      if (personalApiResultMessage.containsKey(key)) {
        String message=personalApiResultMessage[key];
        bool isValid=null;
        bool isInfo=null;
        if (personalApiResultBool.containsKey(key)){
          if (personalApiResultBool[key]==null){
            isInfo=true;
            isValid=true;
          } else {
            isInfo=false;
            isValid = personalApiResultBool[key];
          }
          if (message.length > 0 && message != null) {
            return Container(
              //padding: EdgeInsets.all(5),
              padding: EdgeInsets.only(left: 5.0, right: 5.0, top:5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //Container(width: 5),
                  isInfo? (Icon(Icons.error, color: Colors.blue)) :
                  (isValid? (Icon(Icons.check_circle, color: Colors.green)):(Icon(Icons.cancel, color: Colors.red))),
                  //Container(width: 5),
                  Text(
                    message,
                    style: TextStyle(
                      color: isInfo? (Colors.blue):
                      (isValid? Colors.green:Colors.red),
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      fontSize: 13,
                      height:1.0,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return Container();
          }
        }
        //bool isValid=personalApiResultBool[key];
        //bool isInfo=personalApiResultBool.containsKey(key);


      } else
        return Container();
      //return null;
    }
  }

  prefilledInput() {
    // Maya
//    nikController.text='3578086906850005';
//    nameController.text='Florentina Maya Paramita Harsono';
//    birthdateController.text='29-06-1985';
//    birthplaceController.text='Surabaya';
//    mobilePhoneController.text='6281288140692'; // Maya

    //Dedi
    nikController.text='3274041712840005';
    nameController.text='Dedi Sadikin';
    birthdateController.text='17-12-1984';
    birthplaceController.text='Kota Cirebon';
    mobilePhoneController.text='628111198434';
    npwpController.text='590084968426000';

    addressController.text='Apt. Taman Anggrek Residences Twr. C-27 H';
    motherNameController.text='Test';
    companyNameController.text='Infosys Solusi Terpadu';
    companyPhoneController.text='29529400';
    homeLatitudeController.text='-6.1809';
    homeLongitudeController.text='106.7922';
    workLatitudeController.text='-6.2111'; // true
    workLongitudeController.text='106.8164';

    _currentPropertySelected=_propertyTypeEnum[1];
    nopController.text='123456789012345678';
    propertyNameController.text=nameController.text;
    propertySurfaceAreaController.text='200';
    propertyBuildingAreaController.text='150';
    propertyEstimationController.text='1000000000';
    certificateIdController.text='13040105110291';
    certificateNameController.text=nameController.text;
    certificateDateController.text='17-12-2019';
    incomeController.text='3000000';

    //isPersonalTax=true;
  }

  /**
   *  LOGIC START
   */
  resetProcess(BuildContext context) async {
    setState(() {
      loading = true;
    });

    resetField();
    resetPreSubmitErrorMessage();
    resetPostSubmitErrorMessages();

    setState(() {
      loading = false;
    });
  }

  resetProcess0() {
    //resetField();
    resetPreSubmitErrorMessage();
    resetPostSubmitErrorMessages();
  }

  resetField() {
    //_formKey.currentState.reset();
    // _currentPropertySelected = _propertyTypeEnum[0];
    // _currentTaxSelected=_taxTypeEnum[0];

    nikController.text='';
    nameController.text='';
    birthdateController.text='';
    birthplaceController.text='';
    addressController.text='';
    mobilePhoneController.text='';
    motherNameController.text='';
    messageResultController.text='';
    companyNameController.text='';
    companyPhoneController.text='';
    homeLatitudeController.text='';
    homeLongitudeController.text='';
    workLatitudeController.text='';
    workLongitudeController.text='';

    npwpController.text='';
    incomeController.text='';

    nopController.text='';
    propertyNameController.text='';
    propertySurfaceAreaController.text='';
    propertyBuildingAreaController.text='';
    propertyEstimationController.text='';
    certificateNameController.text='';
    certificateIdController.text='';
    certificateTypeController.text='';
    certificateDateController.text='';

    _professionalImage=null;
    selectedbirthdate=null;
    selectedcertificatedate=null;
    gestureSetSelected='';
    gestureValue='';
    gesture='';
    isGestureSelected = false;

    _currentPropertySelected = '';
    _currentTaxSelected = '';
    _currentGestureSelected = '';
    imgPath='';

    _currentPropertySelected = _propertyTypeEnum[1];
    _currentTaxSelected=_taxTypeEnum[1];
    _currentGestureSelected=_gestureSetEnum[0];
  }

  resetPreSubmitErrorMessage() {
    _nikErrorMessage='';
    _nameErrorMessage='';
    _birthdateErrorMessage='';
    _birthplaceErrorMessage='';
    _addressErrorMessage='';
    _mobilePhoneErrorMessage='';
    _motherNameErrorMessage='';
    _selfieErrorMessage='';

    _companyNameErrorMessage='';
    _companyPhoneErrorMessage='';
    _homeLatitudeErrorMessage='';
    _homeLongitudeErrorMessage='';
    _workLatitudeErrorMessage='';
    _workLongitudeErrorMessage='';

    _taxTypeErrorMessage='';
    _npwpErrorMessage='';
    _incomeErrorMessage='';

    _nopErrorMessage='';
    _propertyNameErrorMessage='';
    _propertySurfaceAreaErrorMessage='';
    _propertyBuildingAreaErrorMessage='';
    _propertyEstimationErrorMessage='';
    _certificateNameErrorMessage='';
    _certificateIdErrorMessage='';
    _certificateTypeErrorMessage='';
    _certificateDateErrorMessage='';
  }

  resetPostSubmitErrorMessages() {
    personalApiResultBool = Map<String, bool>();
    personalApiResultMessage=Map<String, String>();
    workplaceApiResultBool = Map<String, bool>();
    workplaceApiResultMessage=Map<String, String>();
    locationApiResultBool = Map<String, bool>();
    locationApiResultMessage=Map<String, String>();
    taxApiResultBool = Map<String, bool>();
    taxApiResultMessage=Map<String, String>();
    propertyApiResultBool=new Map<String, bool>();
    propertyApiResultMessage=new Map<String, String>();
    livenessApiResultBool = new Map<String, bool>();
    livenessApiResultMessage = new Map<String, String>();
  }

  // Personal Process consist of these APIs:
  // 1. Basic/ Professional
  // 2. Negative Record
  // 3. Phone Extra
  // 4. Phone Age
  personalProcess (BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      bool isStatusCodeValid=false;
      bool isResultValid=false;
      String result ='';
      //resetPreSubmitErrorMessage();
      personalApiResultBool=new Map<String, bool>();
      personalApiResultMessage=new Map<String, String>();

      if (isProfessionalTabInputValid()) {
        // 1. Professional Verification API

        // Input
        // trx_id, nik, name, birthdate, birthplace, identity_photo(null), selfie_photo(base64photo)
        String trx_id = 'ProfessionalVerification_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
        String nik=nikController.text.trim();
        String name = nameController.text;
        String birthdate=birthdateController.text;
        String birthplace=birthplaceController.text.trimRight().trimLeft();
        String phone=mobilePhoneController.text.trim();

        bool isNameMatched=false;
        bool isBirthplaceMatched=false;
        bool isBirthdateMatched=false;
        String addressResult = '';
        double selfiePhotoResult=null;



        AsliResponseModel asliResponseModel = new AsliResponseModel();

        // convert to base64string


        if (!useDummyProfessionalApiResult){
          if (_professionalImage!=null) {
            var imageBytesFile = _professionalImage.readAsBytesSync(); // Convert registration image to base64
            String base64ImageFile = base64Encode(imageBytesFile);
            // COBA VERIFY BASIC
            //start calling API
            //String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_basic';
            String url='https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_profesional';
            Map bodyMap = {
              'trx_id': trx_id,
              'nik': nik,
              'name': name,
              'birthdate': birthdate,
              'birthplace': birthplace,
              'identity_photo': '',
              'selfie_photo': base64ImageFile,
            };

            asliResponseModel = await apiRequest(url, bodyMap);
            isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
            isResultValid=checkErrorBlock(asliResponseModel.errors);// Does Errors not contain message (means there is an error)
            print('Professional API');
          } else {
            //var imageBytesFile = _professionalImage.readAsBytesSync(); // Convert registration image to base64
            //String base64ImageFile = base64Encode(imageBytesFile);
            // COBA VERIFY BASIC
            //start calling API
            String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_basic';
            //String url='https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_profesional';
            Map bodyMap = {
              'trx_id': trx_id,
              'nik': nik,
              'name': name,
              'birthdate': birthdate,
              'birthplace': birthplace,
              'identity_photo': '',
              //  'selfie_photo': base64ImageFile,
            };

            asliResponseModel = await apiRequest(url, bodyMap);
            isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
            isResultValid=checkErrorBlock(asliResponseModel.errors);// Does Errors not contain message (means there is an error)
            print('Basic API');
          }

          // var imageBytesFile = _professionalImage.readAsBytesSync(); // Convert registration image to base64
          // String base64ImageFile = base64Encode(imageBytesFile);
          // // COBA VERIFY BASIC
          // //start calling API
          // //String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_basic';
          // String url='https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_profesional';
          // Map bodyMap = {
          //   'trx_id': trx_id,
          //   'nik': nik,
          //   'name': name,
          //   'birthdate': birthdate,
          //   'birthplace': birthplace,
          //   'identity_photo': '',
          //   'selfie_photo': base64ImageFile,
          // };
          // //AsliResponseModel asliResponseModel = await apiRequest(url, bodyMap);
          // asliResponseModel = await apiRequest(url, bodyMap);
          // isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
          // isResultValid=checkErrorBlock(asliResponseModel.errors);// Does Errors not contain message (means there is an error)
        } else {
          //AsliResponseModel dummyModel = new AsliResponseModel();
          asliResponseModel.timestamp= 1598328841;
          asliResponseModel.status=200;
          asliResponseModel.trx_id='ProfessionalVerification_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
          asliResponseModel.data = new AsliDataModel();
          asliResponseModel.data.name=true;
          asliResponseModel.data.birthdate=true;
          asliResponseModel.data.birthplace=true;
          asliResponseModel.data.address='*PT T*M*N *NGGR*K R*S*D*NC*S TWR. C-27 H';
          asliResponseModel.errors= new AsliErrorsModel();
          asliResponseModel.errors.identity_photo='invalid';
          asliResponseModel.data.selfie_photo=80.00;
          isStatusCodeValid=true;
          isResultValid=true;
        }

        // Interpreting API: Basic Verification
        if (isStatusCodeValid && isResultValid) {
          if (asliResponseModel.data!=null) {
            isNameMatched=asliResponseModel.data.name;
            isBirthdateMatched=asliResponseModel.data.birthdate;
            isBirthplaceMatched=asliResponseModel.data.birthplace;
            addressResult=asliResponseModel.data.address;
            selfiePhotoResult=asliResponseModel.data.selfie_photo;

            personalApiResultBool['nik']=true;
            personalApiResultMessage['nik']='NIK is registered';


//            if (isNameMatched && isBirthdateMatched==true && isBirthplaceMatched==true) {
//              isResultValid=true;
//
//              personalApiResultBool['name']=true;
//              personalApiResultBool['birthdate']=true;
//              personalApiResultBool['birthplace']=true;
//              personalApiResultBool['address']=null;
//
//              personalApiResultMessage['name']='Name belongs to the NIK owner';
//              personalApiResultMessage['birthdate']='Birthdate belongs to the same NIK owner';
//              personalApiResultMessage['birthplace']='Birthplace belongs to the same NIK owner';
//              personalApiResultMessage['address']=addressResult;
//              //result='NIK registered. Name, birthdate and birthplace belong to the same individual with the entered NIK. <br/>';
//            } else {
            if (!isNameMatched){
              //result+='Name does not belong to the same individual as Nik.  <br/>';
              personalApiResultBool['name']=false;
              personalApiResultMessage['name']='Name does not belong to the NIK owner';
            } else {
              personalApiResultBool['name']=true;
              personalApiResultMessage['name']='Name belongs to the NIK owner';
            }

            if (!isBirthdateMatched){
              //result+='Birthdate does not belong to the same individual as Nik.  <br/>';
              personalApiResultBool['birthdate']=false;
              personalApiResultMessage['birthdate']='Birthdate does not belong to the NIK owner';
            } else {
              personalApiResultBool['birthdate']=true;
              personalApiResultMessage['birthdate']='Birthdate belongs to the NIK owner';
            }

            if (!isBirthplaceMatched){
              //result+='Birthplace does not belong to the same individual as Nik.  <br/>';
              personalApiResultBool['birthplace']=false;
              personalApiResultMessage['birthplace']='Birthplace does not belong to the NIK owner';
            } else {
              personalApiResultBool['birthplace']=true;
              personalApiResultMessage['birthplace']='Birthplace belongs to the NIK owner';
            }

            //if (addressResult!='')
            personalApiResultBool['address']=null;
            personalApiResultMessage['address']=addressResult;
//            }

            debugPrint('masuk');
            if (selfiePhotoResult!=null){
              if (selfiePhotoResult>75) {
                personalApiResultBool['selfie']=true;
                personalApiResultMessage['selfie']='Selfie belong to the NIK owner ('+ selfiePhotoResult.toString() +'% match) ';
              } else if (selfiePhotoResult>0){
                personalApiResultBool['selfie']=null;
                personalApiResultMessage['selfie']='Selfie may not belong to the NIK owner ('+ selfiePhotoResult.toString() +'% match) ';
              } else if (selfiePhotoResult==0.0) {
                personalApiResultBool['selfie']=false;
                personalApiResultMessage['selfie']='Selfie does not belong to the NIK owner';
              }
            } else { // if selfiePhotoResult is null
              if (_professionalImage!=null) { // if Professional API
                personalApiResultBool['selfie']=false;
                personalApiResultMessage['selfie']='Selfie does not belong to the NIK owner';
                if (asliResponseModel.errors.selfie_photo!=null) {
                  if (asliResponseModel.errors.selfie_photo=='Invalid'){
                    personalApiResultBool['selfie']=false;
                    personalApiResultMessage['selfie']='No selfie submitted';
                  } else if (asliResponseModel.errors.selfie_photo=='no face detected'){
                    personalApiResultBool['selfie']=false;
                    personalApiResultMessage['selfie']='No face detected in the selfie';
                  }
                }
              } else { // if Basic API
                personalApiResultBool['selfie']=null;
                personalApiResultMessage['selfie']='No selfie submitted, so selfie is not checked';
              }
            }

            personalApiResultBool['mothername']=null;
            personalApiResultMessage['mothername']='This verification will be available upon request';
          } else {
            // data null = NIK is not registered
            isResultValid=false;
            result='NIK is not registered';
            personalApiResultBool['nik']=false;
            personalApiResultMessage['nik']='Nik is not registered';
          }
          if (_professionalImage!=null)
            await _professionalImage.delete();
        } else if (!isStatusCodeValid) {
          createAlertDialog(context, 'Error '+asliResponseModel.status.toString(), 'Professional/Basic API: '+asliResponseModel.error);
        }


        /*
   * 2. Negative Record Start
   */

        if (!useDummyNegativeRecordApiResult){
          String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_negative_list';
          Map bodyMap = {
            'trx_id': trx_id,
            'nik': nik,
            'name': name,
            'dob': birthdate,
            'pob': birthplace,
          };
          asliResponseModel = await apiRequest(url, bodyMap);

          isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
          isResultValid=checkErrorBlock2(asliResponseModel.errors);// Does Errors not contain message (means there is an error)
        } else {
          asliResponseModel.data.negative_record=false;
          asliResponseModel.errors.message='Data not found';
          isStatusCodeValid=true;
          isResultValid=true;
        }

        if (isStatusCodeValid && isResultValid) {
          personalApiResultBool['no_negative_record']=(asliResponseModel.errors.message=='Data not found')? true:false;
          personalApiResultMessage['no_negative_record']=(asliResponseModel.errors.message=='Data not found')? 'This person has no negative record. ': 'This person has negative record. ';
          personalApiResultMessage['messageResult']=(asliResponseModel.errors.message=='Data not found')? 'This person has no negative record. ': 'This person has negative record. ';
          messageResultController.text=personalApiResultMessage['messageResult'];
        } else if (!isStatusCodeValid) {
          createAlertDialog(context, 'Error '+asliResponseModel.status.toString(), 'Negative Record API: '+asliResponseModel.error);
        }

        /*
     * Negative Record Ends
     */

        /*
     *  3. Phone Age Start
     */

        if (!useDummyPhoneAgeApiResult){
          String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_phone_age';
          Map bodyMap = {
            'trx_id': trx_id,
            'nik': nik,
            'phone': phone,
          };
          asliResponseModel = await apiRequest(url, bodyMap);

          isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
          //isResultValid=checkErrorBlock(asliResponseModel.errors);// Does Errors not contain message (means there is an error) NO Errors for this API
        } else {
          asliResponseModel.data.result=true;
          asliResponseModel.data.age=2;
          isStatusCodeValid=true;
          isResultValid=true;
        }

        int phoneAge = asliResponseModel.data.age;
        if (isStatusCodeValid && isResultValid) {
          personalApiResultBool['phone_nik']=(asliResponseModel.data.result)? true:false;
          personalApiResultMessage['phone_nik']=(asliResponseModel.data.result)? 'Phone and NIK belong to the same person.':'Phone and NIK don\'t belong to the same person.';
          personalApiResultBool['phone_age']=null;
          if (phoneAge==null) {
            if (personalApiResultBool['phone_nik']){
              personalApiResultMessage['phone_age']='Phone is not activated';
            }
          } else {
            switch (phoneAge) {
              case 1:
                personalApiResultMessage['phone_age']='Phone is registered under 3 months';
                break;
              case 2:
                personalApiResultMessage['phone_age']='Phone is registered between 3 - 6 months';
                break;
              case 3:
                personalApiResultMessage['phone_age']='Phone is registered between 6 - 12 months';
                break;
              case 4:
                personalApiResultMessage['phone_age']='Phone is registered more than 1 year';
                break;
              default:
                personalApiResultMessage['phone_age']='Phone is not activated';
                break;
            }
          }
        } else if (!isStatusCodeValid) {
          createAlertDialog(context, 'Error '+asliResponseModel.status.toString(), 'Phone Age API: '+asliResponseModel.error);
        }
        /*
     * Phone Age ends
     */

        /*
     *  4. Phone Extra Verif Start
     */
        if (!useDummyPhoneExtraApiResult){
          String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_phone_extra';
          Map bodyMap = {
            'trx_id': trx_id,
            'nik': nik,
            'phone': phone,
          };
          asliResponseModel = await apiRequest(url, bodyMap);

          isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
          //isResultValid=checkErrorBlock(asliResponseModel.errors);// Does Errors not contain message (means there is an error) NO Errors for this API
        } else {
          asliResponseModel.data.result=true;
          asliResponseModel.data.total=2;
          isStatusCodeValid=true;
          isResultValid=true;
        }

        if (isStatusCodeValid) {
          personalApiResultBool['phone_total']=null;
          personalApiResultMessage['phone_total']='The NIK owner has '+asliResponseModel.data.total.toString()+' phone registered.';
        } else if (!isStatusCodeValid) {
          createAlertDialog(context, 'Error '+asliResponseModel.status.toString(), 'Phone Extra API: '+asliResponseModel.error);
        }

        /*
     *  Phone Extra Verif Ends
     */


        // } else { GAK PERLU SOALNYA SUDAH LANGSUNG KELUAR ERROR NYA
        // createAlertDialog(context, 'Input error', 'Input invalid. Please check again.');
      }
    } catch (e) {
      debugPrint("Error $e");
      createAlertDialog(context,'Error', e.substring(0,50));
    }
    setState(() {
      loading = false;
    });
  }

  workplaceProcess (BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      bool isStatusCodeValid=false;
      bool isResultValid=false;
      AsliResponseModel asliResponseModel = new AsliResponseModel();
      bool isNikRegistered=null;
      bool isNameMatched=null;
      bool isCompanyNameMatched=null;
      bool isCompanyPhoneMatched=null;
      //String addressResult = '';

      //resetPreSubmitErrorMessage();
      workplaceApiResultBool=new Map<String, bool>();
      workplaceApiResultMessage=new Map<String, String>();



      if (isWorkplaceTabInputValid()) {

        if (!useDummyHomeLocationApiResult){
          // Workplace Verification API
          String trx_id = 'WorkplaceVerification_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
          String nik=nikController.text.trim();
          String name = nameController.text;
          String companyName=companyNameController.text.trimRight().trimLeft();
          String companyPhone=companyPhoneController.text.trim();

          // COBA VERIFY BASIC
          //start ocr
          String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_workplace';
          Map bodyMap = {
            'trx_id': trx_id,
            'nik': nik,
            'name': name,
            'company_name': companyName,
            'company_phone': companyPhone,
          };

          asliResponseModel = await apiRequest(url, bodyMap);

          print ('workplaceVerif API passed');
          isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
          isResultValid=checkErrorBlock(asliResponseModel.errors);// Does Errors not contain message (means there is an error)
        } else {
          asliResponseModel.data = new AsliDataModel();
          asliResponseModel.data.nik=true;
          asliResponseModel.data.name=true;
          asliResponseModel.data.company=true;
          asliResponseModel.data.company_phone=true;
          asliResponseModel.data.company_name='*NF*SYS S*L*S* T*RP*D*';
          isStatusCodeValid=true;
          isResultValid=true;
        }


        if (isStatusCodeValid && isResultValid) { // 200 and empty errors
          if (asliResponseModel.data!=null) {
            isNikRegistered=asliResponseModel.data.nik;
            isNameMatched=asliResponseModel.data.name;
            isCompanyNameMatched=asliResponseModel.data.company;
            isCompanyPhoneMatched=asliResponseModel.data.company_phone;

            workplaceApiResultBool['nik']=(isNikRegistered)?true:false;
            workplaceApiResultMessage['nik']=(isNikRegistered)?'NIK is registered':'Nik is not registered';
            workplaceApiResultBool['name']=(isNameMatched)?true:false;
            workplaceApiResultMessage['name']=(isNameMatched)?'Name matches with NIK':'Name does not match with NIK';
            workplaceApiResultBool['company']=(isCompanyNameMatched)?true:false;
            workplaceApiResultMessage['company']=(isCompanyNameMatched)?'Last workplace':'Not last workplace';
            workplaceApiResultBool['company_phone']=(isCompanyPhoneMatched)?true:false;
            workplaceApiResultMessage['company_phone']=(isCompanyPhoneMatched)?'Last workplace phone number':'Not last workplace phone number';
            if (!isCompanyNameMatched && asliResponseModel.data.company_name!=null){
              workplaceApiResultBool['company_name']=null;
              workplaceApiResultMessage['company_name']='Last workplace is '+asliResponseModel.data.company_name;
              workplaceApiResultMessage['messageResult']='Last workplace is '+asliResponseModel.data.company_name;
            }
          }
        } else {
          if (!isStatusCodeValid) {
            createAlertDialog(context, 'Error '+asliResponseModel.status.toString(), asliResponseModel.error);
          }
        }

      }
    } catch (e){
      debugPrint(e);
      createAlertDialog(context, 'Error', e.substring(0, 50));
    }
    setState(() {
      loading = false;
    });
  }

  locationProcess(BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      if (isLocationTabInputValid()) {
        //resetPreSubmitErrorMessage();
        locationApiResultBool=new Map<String, bool>();
        locationApiResultMessage=new Map<String, String>();
        // 1. Home Location API
        //if (homeLatitudeController.text!='' && homeLongitudeController.text!='')
        AsliResponseModel asliResponseModel = new AsliResponseModel();
        bool isStatusCodeValid=false;
        bool isResultValid=false;

        String trx_id='HomeLocationVerification_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
        String phone=mobilePhoneController.text.trim();
        String homeLatitude=homeLatitudeController.text.trim();
        String homeLongitude=homeLongitudeController.text;
        String workLatitude=workLatitudeController.text.trim();
        String workLongitude=workLongitudeController.text.trim();

        if (!useDummyHomeLocationApiResult){
          String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_location';
          Map bodyMap = {
            'trx_id': trx_id,
            'phone': phone,
            'latitude': homeLatitude,
            'longitude': homeLongitude,
          };
          asliResponseModel = await apiRequest(url, bodyMap);

          isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
          isResultValid=checkErrorBlock3(asliResponseModel.errors);// Does Errors not contain phone, latitude, longitude (means there is an error)
        } else {
          asliResponseModel.data=new AsliDataModel();
          asliResponseModel.data.result=true;
          isStatusCodeValid=true;
          isResultValid=true;
        }

        if (isStatusCodeValid && isResultValid) {
          locationApiResultBool['home']=asliResponseModel.data.result;

          if (asliResponseModel.data.result!=null) {
            locationApiResultMessage['home']=(asliResponseModel.data.result)?'Current location is verified as Home':'Current location isn\'t verified as home';
          } else {
            locationApiResultBool['phone'] = null;
            locationApiResultMessage['phone'] ='Not registered as Telkomsel/Indosat \n or never online';
          }
        } else {
          locationApiResultMessage['messageResult']='Data format enterred is invalid or empty';
        }

        // WORK
        isStatusCodeValid=false;
        isResultValid=false;

        trx_id='WorkLocation_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());

        if (!useDummyWorkLocationApiResult){
          String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_work_location';
          Map bodyMap = {
            'trx_id': trx_id,
            'phone': phone,
            'latitude': workLatitude,
            'longitude': workLongitude,
          };
          asliResponseModel = await apiRequest(url, bodyMap);

          isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
          isResultValid=checkErrorBlock3(asliResponseModel.errors);// Does Errors not contain phone, latitude, longitude (means there is an error)
        } else {
          asliResponseModel.data=new AsliDataModel();
          asliResponseModel.data.result=true;
          isStatusCodeValid=true;
          isResultValid=true;
        }

        if (isStatusCodeValid && isResultValid) {
          locationApiResultBool['work']=asliResponseModel.data.result;

          if (asliResponseModel.data.result!=null) {
            locationApiResultMessage['work']=(asliResponseModel.data.result)?'Work location valid':'Work location is not valid';
          } else {
            locationApiResultBool['phone'] = null;
            locationApiResultMessage['phone'] ='Not registered as Telkomsel/Indosat \n or never online';
          }
        } else {
          locationApiResultMessage['messageResult']='Data format enterred is invalid or empty';
        }
      }
    } catch(e){
      debugPrint(e);
      createAlertDialog(context, 'Error', e.substring(0,50));
    }
    setState(() {
      loading = false;
    });
  }

  homeLocationProcess(BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      await _getCurrentLocation();
      if (isLocationHomeTabInputValid()) {
        //resetPreSubmitErrorMessage();
        locationApiResultBool=new Map<String, bool>();
        locationApiResultMessage=new Map<String, String>();
        // 1. Home Location API
        //if (homeLatitudeController.text!='' && homeLongitudeController.text!='')
        AsliResponseModel asliResponseModel = new AsliResponseModel();
        bool isStatusCodeValid=false;
        bool isResultValid=false;

        String trx_id='HomeLocationVerification_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
        String phone=mobilePhoneController.text.trim();
        String homeLatitude=_homeLatitude;
        String homeLongitude=_homeLongitude;
//      String homeLatitude=homeLatitudeController.text.trim();
//      String homeLongitude=homeLongitudeController.text;
//      String workLatitude=workLatitudeController.text.trim();
//      String workLongitude=workLongitudeController.text.trim();

        if (!useDummyHomeLocationApiResult){
          String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_location';
          Map bodyMap = {
            'trx_id': trx_id,
            'phone': phone,
            'latitude': homeLatitude,
            'longitude': homeLongitude,
          };
          asliResponseModel = await apiRequest(url, bodyMap);

          isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
          isResultValid=checkErrorBlock3(asliResponseModel.errors);// Does Errors not contain phone, latitude, longitude (means there is an error)
        } else {
          asliResponseModel.data=new AsliDataModel();
          asliResponseModel.data.result=true;
          isStatusCodeValid=true;
          isResultValid=true;
        }

        if (isStatusCodeValid && isResultValid) {
          locationApiResultBool['home']=asliResponseModel.data.result;

          if (asliResponseModel.data.result!=null) {
            locationApiResultMessage['home']=(asliResponseModel.data.result)?'Current location is verified as Home':'Current location isn\'t verified as home';
          } else {
            locationApiResultBool['phone'] = null;
            locationApiResultMessage['phone'] ='Not registered as Telkomsel/Indosat \n or never online';
          }
        } else {
          locationApiResultMessage['messageResult']='Data format enterred is invalid or empty';
        }
        //if (workLatitudeController.text!='' && workLongitudeController.text!='')
        //workLocationApi();
      }
    }catch(e){
      debugPrint(e);
      createAlertDialog(context, 'Error', e.substring(0,50));
    }
    setState(() {
      loading = false;
    });

  }

  taxProcess(BuildContext context) async { // NOTE: NOT FINISHED! PLEASE FIX LATER!
    // 1. Tax Extra Verif API
    // 2. Tax Company Verif API
    setState(() {
      loading = true;
    });
    try{
      if (isTaxTabInputValid()) {
        //resetPreSubmitErrorMessage();
        taxApiResultBool=new Map<String, bool>();
        taxApiResultMessage=new Map<String, String>();
//    taxApiResultBool=new Map<String, bool>();
//    taxApiResultMessage=new Map<String, String>();
//    // 1. Tax Extra Verif API
//    //if (homeLatitudeController.text!='' && homeLongitudeController.text!='')
        AsliResponseModel asliResponseModel = new AsliResponseModel();
        bool isStatusCodeValid=false;
        bool isResultValid=false;

        //String trx_id='TaxExtra_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
        String trx_id='';
        String nik=nikController.text.trim();
        String name=nameController.text;
        String birthdate=birthdateController.text;
        String birthplace=birthplaceController.text.trimRight().trimLeft();
        String npwp=npwpController.text.trim();
        String income=incomeController.text;
//

        if (_currentTaxSelected=='Personal Tax') {
          trx_id='TaxExtra_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
          if (!useDummyTaxExtraApi){
            String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_tax_extra';
            Map bodyMap = {
              'trx_id': trx_id,
              'nik': nik,
              'npwp': npwp,
              'income': income,
              'name': name,
              'birthdate': birthdate,
              'birthplace': birthplace,
            };
            asliResponseModel = await apiRequest(url, bodyMap);

            isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
            isResultValid=checkErrorBlock2(asliResponseModel.errors);//
          } else {
            asliResponseModel.data=new AsliDataModel();
            asliResponseModel.data.npwp=true;
            asliResponseModel.data.nik=true;
            asliResponseModel.data.match_result=true;
            asliResponseModel.data.name=true;
            asliResponseModel.data.birthdate=true;
            asliResponseModel.data.birthplace=true;
            asliResponseModel.data.income='AMIDST';
            isStatusCodeValid=true;
            isResultValid=true;
          }

          // Start analysing the response
          taxApiResultBool['income']=(asliResponseModel.data.income==null)?null:(asliResponseModel.data.income=='AMIDST')?true:false;
          getPriceAnalysisMessage(asliResponseModel.data.income, 'income', 'income', taxApiResultMessage);

          taxApiResultBool['name']=(asliResponseModel.data.name==null)?false:(asliResponseModel.data.name)?true:false;
          taxApiResultMessage['name']=(asliResponseModel.data.name==null)?'Name is null or has wrong format':(asliResponseModel.data.name)?'Name is as registered in NPWP':'Name is not as registered in NPWP';
          taxApiResultBool['birthdate']=(asliResponseModel.data.birthdate==null)?false:(asliResponseModel.data.birthdate)?true:false;
          taxApiResultMessage['birthdate']=(asliResponseModel.data.birthdate==null)?'Birthdate is null or has wrong format':(asliResponseModel.data.birthdate)?'Birthdate is as registered in NPWP':'Birthdate is not as registered in NPWP';
          taxApiResultBool['birthplace']=(asliResponseModel.data.birthplace==null)?false:(asliResponseModel.data.birthplace)? true:false;
          taxApiResultMessage['birthplace']=(asliResponseModel.data.birthplace==null)?'Birthplace is null or has wrong format':(asliResponseModel.data.birthplace)?'Birthplace is as registered in NPWP':'Birthplace is not as registered in NPWP';

          taxApiResultBool['nik']=(asliResponseModel.data.nik==null)?false:(asliResponseModel.data.nik)?true:false;
          taxApiResultMessage['nik']=(asliResponseModel.data.nik==null)?'NIK is null or has wrong format':(asliResponseModel.data.nik)?'NIK is registered':'NIK is not registered';
          taxApiResultBool['npwp']=(asliResponseModel.data.npwp==null)?false:(asliResponseModel.data.npwp)?true:false;
          taxApiResultMessage['npwp']=(asliResponseModel.data.npwp==null)?'NPWP is null or has wrong format':(asliResponseModel.data.npwp)?'NPWP is registered':'NPWP is not registered';

          if (asliResponseModel.data.match_result!=null){
            if (asliResponseModel.data.match_result) { // if match_result == true
              if (asliResponseModel.data.income==null) {
                taxApiResultBool['income2']=null;
                taxApiResultMessage['income2']='This person never reported their income';
              }
            } else { // if match_result == false
              if (asliResponseModel.data.nik==true && asliResponseModel.data.npwp==true) {
                taxApiResultBool['nik2']=null;
                taxApiResultMessage['nik2']='NIK and NPWP are registered before 2016 \nor NIK and NPWP do not belong to the same person';
              } // end if nik and npwp true
            }
          }
//        else { // if match_result is null
//          // commented because obsolete
//        }


//      if (isStatusCodeValid && isResultValid) {
//        //asliResponseModel.data.income
//        taxApiResultBool['npwp']=asliResponseModel.data.npwp;
//        taxApiResultMessage['npwp']=(asliResponseModel.data.npwp)?'NPWP is registered':'NPWP is not registered';
//        taxApiResultBool['nik']=asliResponseModel.data.nik;
//        taxApiResultMessage['nik']=(asliResponseModel.data.nik)?'NIK is registered':'NIK is not registered';
//        taxApiResultBool['name']=asliResponseModel.data.name;
//        taxApiResultMessage['name']=(asliResponseModel.data.name)?'Name is as registered as on NPWP':'Name is not as registered as on NPWP';
//        taxApiResultBool['birthdate']=asliResponseModel.data.birthdate;
//        taxApiResultMessage['birthdate']=(asliResponseModel.data.birthdate)?'Birthdate is as registered as on NPWP':'Birthdate is not as registered as on NPWP';
//        taxApiResultBool['birthplace']=asliResponseModel.data.birthplace;
//        taxApiResultMessage['birthplace']=(asliResponseModel.data.birthplace)?'Birthplace is as registered as on NPWP':'Birthplace is not as registered as on NPWP';
//
//        switch (asliResponseModel.data.income) {
//          case 'AMIDST':
//            taxApiResultBool['income']=true;
//            taxApiResultMessage['income']='Within the registered income range';
//            break;
//          case 'ABOVE':
//            taxApiResultBool['income']=false;
//            taxApiResultMessage['income']='Registered income is lower than this amount';
//            break;
//          case 'BELOW':
//            taxApiResultBool['income']=false;
//            taxApiResultMessage['income']='Registered income is higher than this amount';
//            break;
//          default:
//            taxApiResultBool['income']=null;
//            taxApiResultMessage['income']='Income data is not available';
//            break;
//        }
//
//      } else if (isStatusCodeValid && !isResultValid) {
//        if (asliResponseModel.errors.npwp=='invalid'){
//          taxApiResultBool['npwp']=false;
//          taxApiResultMessage['npwp']='NPWP Invalid. All data cannot be verified';
//          taxApiResultMessage['nik']='NPWP Invalid. NIK cannot be verified';
//          taxApiResultMessage['name']='NPWP Invalid. Name cannot be verified';
//          taxApiResultMessage['birthdate']='NPWP Invalid. Birthdate cannot be verified';
//          taxApiResultMessage['birthplace']='NPWP Invalid.  Birthplace cannot be verified';
//          taxApiResultMessage['income']='Income Invalid.  Birthplace cannot be verified';
//        }
//      }
        } else { // if isPersonalTax=false
          // 2. COMPANY TAX
          trx_id='TaxCompany_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
          if (!useDummyTaxCompanyApiResult){
            String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_tax_company';
            Map bodyMap = {
              'trx_id': trx_id,
              'npwp': npwp,
              'income': income,
            };
            asliResponseModel = await apiRequest(url, bodyMap);

            isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
            isResultValid=checkErrorBlock(asliResponseModel.errors);// Does Errors not contain phone, latitude, longitude (means there is an error)
          } else {
            asliResponseModel.data=new AsliDataModel();
            asliResponseModel.data.npwp=true;
            asliResponseModel.data.income='AMIDST';
            isStatusCodeValid=true;
            isResultValid=true;
          }

          if (isStatusCodeValid) {
            taxApiResultBool['npwp']=asliResponseModel.data.npwp;
            taxApiResultMessage['npwp']=(asliResponseModel.data.npwp)?'NPWP is registered':'NPWP is not registered';
//         switch (asliResponseModel.data.income) {
//          case 'AMIDST':
//            taxApiResultBool['income']=true;
//            taxApiResultMessage['income']='Within the registered income range';
//            break;
//          case 'ABOVE':
//            taxApiResultBool['income']=false;
//            taxApiResultMessage['income']='Registered income is lower than this amount';
//            break;
//          case 'BELOW':
//            taxApiResultBool['income']=false;
//            taxApiResultMessage['income']='Registered income is higher than this amount';
//            break;
//           case 'invalid':
//             taxApiResultBool['income']=false;
//             taxApiResultMessage['income']='Income input format invalid';
//             break;
//          default:
//            taxApiResultBool['income']=null;
//            taxApiResultMessage['income']='Income data is not available';
//            break;
//        }
            taxApiResultBool['income']=(asliResponseModel.data.income==null)?null:(asliResponseModel.data.income=='AMIDST')?true:false;
            //taxApiResultMessage['income']=getPriceAnalysisMessage(asliResponseModel.data.income, 'income', 'income', taxApiResultBool, taxApiResultMessage);
            getPriceAnalysisMessage(asliResponseModel.data.income, 'income', 'income', taxApiResultMessage);

          } else {
            taxApiResultMessage['messageResult']=asliResponseModel.errors.message;
          }
        } // end if isPersonalTax

      }
    } catch (e) {
      debugPrint("Error $e");
      createAlertDialog(context, 'Error', e.substring(0, 50));
    }
    setState(() {
      loading = false;
    });
  }

  propertyProcess(BuildContext context) async {
    setState(() {
      loading = true;
    });
    if (isPropertyTabInputValid()) {
      //resetPreSubmitErrorMessage();
      propertyApiResultBool=new Map<String, bool>();
      propertyApiResultMessage=new Map<String, String>();
      // 1. Home Location API
      //if (homeLatitudeController.text!='' && homeLongitudeController.text!='')
      AsliResponseModel asliResponseModel = new AsliResponseModel();
      bool isStatusCodeValid=false;
      bool isResultValid=false;

      String trx_id='Property_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
      String nop=nopController.text.trim();
      String propertyName=propertyNameController.text.trimRight().trimLeft();
      String propertySurfaceArea=propertySurfaceAreaController.text.trim();
      String propertyBuildingArea=propertyBuildingAreaController.text.trim();
      String propertyEstimation=propertyEstimationController.text;
      String nik=nikController.text.trim();
      String certificateId=certificateIdController.text.trim();
      String certificateType=_currentPropertySelected;
      String certificateName=certificateNameController.text.trimRight().trimLeft();
      String certificateDate=certificateDateController.text;

      String errorMessageText='';

      try{
        if (!useDummyPropertyApiResult){
          String url = 'https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_tax_company';
          Map bodyMap = {
            'trx_id': trx_id,
            'nop': nop,
            'property_name': propertyName,
            'property_surface_area': propertySurfaceArea,
            'property_building_area': propertyBuildingArea,
            'property_estimation': propertyEstimation,
            'nik': nik,
            'certificate_name': certificateName,
            'certificate_id': certificateId,
            'certificate_type': certificateType,
            'certificate_date':certificateDate
          };
          asliResponseModel = await apiRequest(url, bodyMap);

          isStatusCodeValid=checkStatusCode(asliResponseModel); // is status 200
          isResultValid=checkErrorBlock(asliResponseModel.errors);// Does Errors not contain phone, latitude, longitude (means there is an error)
        } else {
          asliResponseModel.data=new AsliDataModel();
          asliResponseModel.data.property_address='A** T*M*N *NGGR*K R*S*D*NC*S TWR-C 27H';
          asliResponseModel.data.property_name=true;
          asliResponseModel.data.property_building_area=true;
          asliResponseModel.data.property_surface_area=true;
          asliResponseModel.data.property_estimation='AMIDST';

          asliResponseModel.data.certificate_address='A** T*M*N *NGGR*K R*S*D*NC*S TWR-C 27H';
          asliResponseModel.data.certificate_id=true;
          asliResponseModel.data.certificate_name=true;
          asliResponseModel.data.certificate_type=true;
          asliResponseModel.data.certificate_date=true;

//        asliResponseModel.data.property_address=null;
//        asliResponseModel.data.property_name=null;
//        asliResponseModel.data.property_building_area=null;
//        asliResponseModel.data.property_surface_area=null;
//        asliResponseModel.data.property_estimation=null;

//        asliResponseModel.data.certificate_address=null;
//        asliResponseModel.data.certificate_id=null;
//        asliResponseModel.data.certificate_name=null;
//        asliResponseModel.data.certificate_type=null;
//        asliResponseModel.data.certificate_date=null;

          isStatusCodeValid=true;
          isResultValid=true;
        }

        if (isStatusCodeValid) {
          AsliDataModel asliDataModel=asliResponseModel.data;
          // Possibilities why result not valid:
          // 1. nop registered/ valid (message: "data not found") +
          // property_address,
          // property_name,
          // property_building_area,
          // property_surface_area and
          // property estimation are null
          // 2. If NIK not registered;
          // certificate_address,
          // certificate_id,
          // certificate_name,
          // certificate_type, and
          // certificate_date are null

          propertyApiResultBool['propertyAddress']=null;
          propertyApiResultBool['propertyName']=asliDataModel.property_name;
          propertyApiResultBool['propertyBuildingArea']=asliDataModel.property_building_area;
          propertyApiResultBool['propertySurfaceArea']=asliDataModel.property_surface_area;
          propertyApiResultBool['propertyEstimation']=(asliResponseModel.data.property_estimation==null)?null:(asliResponseModel.data.property_estimation=='AMIDST')?true:false;

          propertyApiResultMessage['propertyAddress']=asliDataModel.property_address;
          propertyApiResultMessage['propertyName']=(asliDataModel.property_name==null)?'Property Name is empty':(asliDataModel.property_name)?'Property name is Valid':'Property name is Not Valid';
          propertyApiResultMessage['propertyBuildingArea']=(asliDataModel.property_building_area==null)?'Building Area is empty':(asliDataModel.property_building_area)?'Building Area is Valid':'Building Area is Not Valid';
          propertyApiResultMessage['propertySurfaceArea']=(asliDataModel.property_surface_area==null)?'Surface Area is empty':(asliDataModel.property_surface_area)?'Surface Area is Valid':'Surface Area is Not Valid';
          //propertyApiResultMessage['propertyEstimation']=
          getPriceAnalysisMessage(asliDataModel.property_estimation, 'propertyEstimation', 'price', propertyApiResultMessage);
          //getPriceAnalysisMessage(asliDataModel.property_estimation, 'propertyEstimation', propertyApiResultBool, propertyApiResultMessage);

          propertyApiResultBool['certificateAddress']=null;
          propertyApiResultBool['certificateId']=asliDataModel.certificate_id;
          propertyApiResultBool['certificateName']=asliDataModel.certificate_name;
          propertyApiResultBool['certificateType']=asliDataModel.certificate_type;
          propertyApiResultBool['certificateDate']=asliDataModel.certificate_date;

          propertyApiResultMessage['certificateAddress']=asliDataModel.certificate_address;
          propertyApiResultMessage['certificateId']=(asliDataModel.certificate_id==null)?'Certificate Id is empty':(asliDataModel.certificate_id)?'Certificate Id is Valid':'Certificate Id is Not Valid';
          propertyApiResultMessage['certificateName']=(asliDataModel.certificate_name==null)?'Certificate Name is empty':(asliDataModel.certificate_name)?'Certificate Name is Valid':'Certificate Name is Not Valid';
          propertyApiResultMessage['certificateType']=(asliDataModel.certificate_type==null)?'Certificate Type is empty':(asliDataModel.certificate_type)?'Certificate Type is Valid':'Certificate Type is Not Valid';
          propertyApiResultMessage['certificateDate']=(asliDataModel.certificate_date==null)?'Certificate Date name is empty':(asliDataModel.certificate_date)?'Certificate Date is Valid':'Certificate Date is Not Valid';

          //if (!isResultValid){ // if nik &/ nop not registered/ not valid
          if (asliDataModel.property_address == null &&
              asliDataModel.property_name == null &&
              asliDataModel.property_building_area == null &&
              asliDataModel.property_surface_area == null &&
              asliDataModel.property_estimation == null) {
            errorMessageText = 'Can\'t be verified as NOP not registered';
            propertyApiResultBool['nop'] = false;
            propertyApiResultBool['propertyAddress'] = false;
            propertyApiResultBool['propertyName'] = false;
            propertyApiResultBool['propertyBuildingArea'] = false;
            propertyApiResultBool['propertySurfaceArea'] = false;
            propertyApiResultBool['propertyEstimation'] = false;

            propertyApiResultMessage['nop'] = 'NOP not registered';
            propertyApiResultMessage['propertyAddress'] = errorMessageText;
            propertyApiResultMessage['propertyName'] = errorMessageText;
            propertyApiResultMessage['propertyBuildingArea'] = errorMessageText;
            propertyApiResultMessage['propertySurfaceArea'] = errorMessageText;
            propertyApiResultMessage['propertyEstimation'] = errorMessageText;
          } else {
            propertyApiResultBool['nop'] = null;
            propertyApiResultMessage['nop'] = 'NOP is registered';
          }

          if (asliDataModel.certificate_address == null &&
              asliDataModel.certificate_id == null &&
              asliDataModel.certificate_name == null &&
              asliDataModel.certificate_type == null &&
              asliDataModel.certificate_date == null) {
            errorMessageText = 'Can\'t be verified as NIK not registered';
            propertyApiResultBool['nik'] = false;
            propertyApiResultBool['certificateAddress'] = false;
            propertyApiResultBool['certificateId'] = false;
            propertyApiResultBool['certificateName'] = false;
            propertyApiResultBool['certificateType'] = false;
            propertyApiResultBool['certificateDate'] = false;

            propertyApiResultMessage['nik'] = 'NIK not registered';
            propertyApiResultMessage['certificateAddress'] = errorMessageText;
            propertyApiResultMessage['certificateId'] = errorMessageText;
            propertyApiResultMessage['certificateName'] = errorMessageText;
            propertyApiResultMessage['certificateType'] = errorMessageText;
            propertyApiResultMessage['certificateDate'] = errorMessageText;
          } else {
            propertyApiResultBool['nik'] = null;
            propertyApiResultMessage['nik'] = 'NIK is registered';
          }
          // if result is valid, which is: nik & nop registered/ valid
//        if (asliDataModel.property_address != null &&
//            asliDataModel.property_name != null &&
//            asliDataModel.property_building_area != null &&
//            asliDataModel.property_surface_area != null &&
//            asliDataModel.property_estimation != null) {
//          propertyApiResultBool['nop'] = true;
//          propertyApiResultMessage['nop'] = 'NOP is registered';
//        }
//        if (asliDataModel.certificate_address != null &&
//            asliDataModel.certificate_id != null &&
//            asliDataModel.certificate_name != null &&
//            asliDataModel.certificate_type != null &&
//            asliDataModel.certificate_date != null) {
//          propertyApiResultBool['nik'] = true;
//          propertyApiResultMessage['nik'] = 'NIK is registered';
//        }
          //}
        } else {
          propertyApiResultMessage['messageResult']=asliResponseModel.errors.message;
        }
      } catch (e) {
        debugPrint("Error $e");
      }
    }
    setState(() {
      loading = false;
    });
  }

//  String getPriceAnalysisMessage(String result, String priceName) {
//    switch (result) {
//      case 'AMIDST':
//        taxApiResultBool['income'] = true;
//        taxApiResultMessage['income'] =
//            'Within the registered ' + priceName + ' range';
//        break;
//      case 'ABOVE':
//        taxApiResultBool['income'] = false;
//        taxApiResultMessage['income'] =
//            'Registered ' + priceName + ' is lower than this amount';
//        break;
//      case 'BELOW':
//        taxApiResultBool['income'] = false;
//        taxApiResultMessage['income'] =
//            'Registered ' + priceName + ' is higher than this amount';
//        break;
//      case 'invalid':
//        taxApiResultBool['income'] = false;
//        taxApiResultMessage['income'] = priceName + ' input format invalid';
//        break;
//      default:
//        taxApiResultBool['income'] = null;
//        taxApiResultMessage['income'] = priceName + ' data is not available';
//        break;
//    }
//  }

//  bool getPriceAnalysisBool(String result, Map<String, bool> boolMap) {
//    if (result=='AMIDST')
//      return true;
//    else if (result=='ABOVE' || result=='BELOW')
//      return false;
//    else
//      return null;
//  }

  getPriceAnalysisMessage(String result, String mapKey, String priceName, Map<String, String> stringMap) {
    if (result==null)
      stringMap[mapKey]=mapKey +' is empty';
    else{
      switch (result) {
        case 'AMIDST':
        //boolMap[priceName] = true;
          stringMap[mapKey] = 'Within the registered ' + priceName + ' range';
          break;
        case 'ABOVE':
        //boolMap[priceName] = false;
          stringMap[mapKey] ='Registered ' + priceName + ' is lower than this amount';
          break;
        case 'BELOW':
        //boolMap[priceName] = false;
          stringMap[mapKey] =
              'Registered ' + priceName + ' is higher than this amount';
          break;
        case 'invalid':
        //boolMap[priceName] = false;
          stringMap[mapKey] = priceName + ' input format invalid';
          break;
        default:
        //boolMap[priceName] = null;
          stringMap[mapKey] = priceName + ' data is not available';
          break;
      }
    }
  }

  void _getCurrentLocation() async {
    try {
      //_locationMessage = "";
      _homeLatitude="";
      _homeLongitude="";
      loc.Location location = new loc.Location();

      bool _serviceEnabled;
      loc.PermissionStatus _permissionGranted;
      loc.LocationData _locationData;

      _serviceEnabled = await location.serviceEnabled();
      if (!_serviceEnabled) {
        _serviceEnabled = await location.requestService();
        if (!_serviceEnabled) {
          print('service not enabled');
          return;
        }
      }

      _permissionGranted = await location.hasPermission();
      if (_permissionGranted == loc.PermissionStatus.denied) {
        _permissionGranted = await location.requestPermission();
        if (_permissionGranted != loc.PermissionStatus.granted) {
          return;
        }
      }

      _locationData = await location.getLocation();

      //final position = await geo.getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      final position = await geo.Geolocator() .getCurrentPosition(desiredAccuracy: geo.LocationAccuracy.high);
      print(position);

      setState(() {
        _homeLatitude= "${position.latitude}";
        _homeLongitude= "${position.longitude}";
        //_locationMessage += "${position.latitude}, ${position.longitude}";
        //_locationMessage='';
      });
    } catch (e) {
      print(e);
    }
  }

  apiRequest(String url, Map jsonMap) async {
    AsliResponseModel responseModel = AsliResponseModel();
    try {
      HttpClient httpClient = new HttpClient();
      HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
//    Map<String, String> headers = {
//      "content-type": "application/json",
//      "token": "21bc8a0b-2398-413b-8159-7b389f51e40f"
//    };
      request.headers.set('content-type', 'application/json');
      request.headers.set('token', '21bc8a0b-2398-413b-8159-7b389f51e40f');
      request.add(utf8.encode(json.encode(jsonMap)));
      HttpClientResponse response = await request.close();
      // todo - you should check the response.statusCode
      var result = new StringBuffer();
      await for (var contents in response.transform(utf8.decoder)) {
        result.write(contents);
      }

      Map<String, dynamic> myList = jsonDecode(result.toString());
      if (myList.containsKey("errors")){
        Map<dynamic, dynamic>currentErrors=myList["errors"];
        if (currentErrors.containsKey("message")){
          responseModel.data=(myList["data"]==null)?null:myList["data"];
          responseModel.errors=AsliErrorsModel();
          responseModel.errors.message=currentErrors["message"];
          responseModel.timestamp=(myList.containsKey("timestamp"))?myList["timestamp"]:null;
          responseModel.status=(myList.containsKey("status"))?myList["status"]:null;
        }
      } else {
        //OcrModel sample = OcrModel.fromJson(myList);
        responseModel = AsliResponseModel.fromJson(myList);
        print('asliresponsemodel');
      }

//
      httpClient.close();
      return responseModel;
    }
    catch(e) {
      debugPrint(e);
      responseModel.errors=AsliErrorsModel();
      responseModel.errors.message="Unexpected error";
      return responseModel;
    }
    return responseModel;
  }

  _getImage(BuildContext context, ImageSource source) async{

    this.setState(() {
      loading = true;
    });

    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    if (await tempDir.exists())
      tempDir.delete(recursive: false);

    Directory appdocdir= await getApplicationSupportDirectory();
    String test=appdocdir.path;

    if (await appdocdir.exists())
      appdocdir.delete(recursive: false);

    var picture =  await ImagePicker.pickImage(source: source);
    int appFileDirectory=picture.path.lastIndexOf('/');
    String resultDirectory=picture.path.substring(0,appFileDirectory+1); // = appdocdir+'/Pictures/'
    String resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
    //String resultPath='/storage/emulated/0/Android/data/com.smartherd.flutter_app_section2/files/Pictures/'+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';

    int photoQuality=50;
    if(picture != null) {
      try {
        var result = await FlutterImageCompress.compressAndGetFile(
          picture.absolute.path, resultPath,
          quality: photoQuality,
        );

        int pictureLength=picture.lengthSync();
        int resultLength=result.lengthSync();

        var i = 1;

        while ((resultLength < professionalMinPhotoSize || resultLength > professionalMaxPhotoSize) && photoQuality>0 && photoQuality<100) {
          if (result!=null)
            await result.delete();
          resultPath=resultDirectory+DateFormat('yyyyMMddHHmmss').format(DateTime.now())+'.jpg';
          photoQuality=(resultLength>professionalMaxPhotoSize)? photoQuality-10:photoQuality+10;
          result = await FlutterImageCompress.compressAndGetFile(
            picture.absolute.path, resultPath,
            quality: photoQuality,
          );
          resultLength=result.lengthSync();
        }

        double sizeinKb=resultLength.toDouble()/1024;
        debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');
        //print(pictureLength+resultLength);
        await picture.delete();
        this.setState(() {
          //_imageFileProfile = cropped;
          _professionalImage = result;
          loading = false;
        });
      }
      catch (e) {
        print (e);
        debugPrint("Error $e");
      }
    }else{
      this.setState(() {
        loading = false;
      });
    }
    //Navigator.of(context).pop();
  }

  bool checkStatusCode(AsliResponseModel responseModel) {
    if (responseModel.status==200)
      return true;
    else
      return false;
  }

  bool checkErrorBlock(AsliErrorsModel errorsModel) {
    if (errorsModel.message!=null)
      return false;
    else
      return true;
  }

  bool checkErrorBlock2 (AsliErrorsModel errorsModel) {
    if (errorsModel.message=='Data not found')
      return true;
    else
      return false;
  }

  bool checkErrorBlock3(AsliErrorsModel errorsModel) {
    if (errorsModel.phone==null && errorsModel.latitude==null && errorsModel.longitude==null)
      return true;
    else
      return false;
  }

  AsliResponseModel dummyBasicVerificationModel(){
    AsliResponseModel dummyModel = new AsliResponseModel();
    dummyModel.timestamp= 1598328841;
    dummyModel.status=200;
    dummyModel.trx_id='ProfessionalVerification_'+DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    dummyModel.data = new AsliDataModel();
    dummyModel.data.name=true;
    dummyModel.data.birthdate=true;
    dummyModel.data.birthplace=false;
    dummyModel.data.address='*PT T*M*N *NGGR*K R*S*D*NC*S TWR. C-27 H';
    dummyModel.errors= new AsliErrorsModel();
    dummyModel.errors.identity_photo='invalid';

    return dummyModel;
  }

  /**
   *  LOGIC ENDS
   */

  /**
   *  VALIDATION START
   */

  bool isProfessionalTabInputValid() {
    bool resultBool=false;
    String nik=nikController.text.trim();
    String name=nameController.text.trimRight().trimLeft();
    String birthplace=birthplaceController.text.trimRight().trimLeft();
    String birthdate=birthdateController.text.trim();
    // String address=addressController.text.trimRight().trimLeft();
    String mobilePhone=mobilePhoneController.text.trim();

    resultBool=intValidation(nik, 'NIK', _nikErrorMessage, 16, 16, true);
    resultBool=(resultBool)?textValidation(name, 'Name', _nameErrorMessage, false):resultBool;
    resultBool=(resultBool)?dateValidation(birthdate, 'Birthdate', _birthdateErrorMessage, false):resultBool;
    resultBool=(resultBool)?textValidation(birthplace, 'Birthplace', _birthplaceErrorMessage, false):resultBool;
    // resultBool=(resultBool)?textNumberValidation(address, 'Address', _addressErrorMessage, false):resultBool;
    resultBool=(resultBool)?intValidation(mobilePhone, 'Mobile Phone', _mobilePhoneErrorMessage, 9, 20, true):resultBool;
    // resultBool=(resultBool)?(_professionalImage!=null)?true:false:resultBool;

    _nikErrorMessage=intValidation2(nik, 'NIK', 16, 16, true);
    _nameErrorMessage=textValidation2(name, 'Name', false);
    _birthdateErrorMessage=dateValidation2(birthdate, 'Birthdate', false);
    _birthplaceErrorMessage=textValidation2(birthplace, 'Birthplace', false);
    // _addressErrorMessage=textNumberValidation2(address, 'Address', false);
    _mobilePhoneErrorMessage=intValidation2(mobilePhone, 'Mobile Phone', 9, 20, true);
    // _selfieErrorMessage=(_professionalImage==null)?'You must take selfie':'';

    return resultBool;
  }

  bool isLocationTabInputValid() {
    bool resultBool=false;
    String mobilePhone=mobilePhoneController.text.trim();
    String homeLatitude=homeLatitudeController.text.trim();
    String homeLongitude=homeLongitudeController.text.trim();
    String workLatitude=workLatitudeController.text.trim();
    String workLongitude=workLongitudeController.text.trim();

    resultBool=intValidation(mobilePhone, 'Mobile Phone', _mobilePhoneErrorMessage, 9, 20, true);
    // cek apakah bisa null
    if (homeLatitude.length!=0 && homeLongitude.length!=0) {
      resultBool=(resultBool)?doubleValidation(homeLatitude, 'Home Latitude', _homeLatitudeErrorMessage, true):resultBool;
      resultBool=(resultBool)?doubleValidation(homeLongitude, 'Home Longitude', _homeLongitudeErrorMessage, true):resultBool;
    } else if (homeLatitude.length==0 && homeLongitude.length==0) {
      resultBool=(resultBool)?doubleValidation(homeLatitude, 'Home Latitude', _homeLatitudeErrorMessage, false):resultBool;
      resultBool=(resultBool)?doubleValidation(homeLongitude, 'Home Longitude', _homeLongitudeErrorMessage, false):resultBool;
    } else if (homeLatitude.length==0) {
      resultBool=(resultBool)?doubleValidation(homeLatitude, 'Home Latitude', _homeLatitudeErrorMessage, true):resultBool;
    } else if (homeLongitude.length==0) {
      resultBool=(resultBool)?doubleValidation(homeLongitude, 'Home Longitude', _homeLongitudeErrorMessage, true):resultBool;
    }

    if (workLatitude.length!=0 && workLongitude.length!=0) {
      resultBool=(resultBool)?doubleValidation(workLatitude, 'Work Latitude', _workLatitudeErrorMessage, true):resultBool;
      resultBool=(resultBool)?doubleValidation(workLongitude, 'Work Longitude', _workLongitudeErrorMessage, true):resultBool;
    } else if (workLatitude.length==0 && workLongitude.length==0) {
      resultBool=(resultBool)?doubleValidation(workLatitude, 'Work Latitude', _workLatitudeErrorMessage, false):resultBool;
      resultBool=(resultBool)?doubleValidation(workLongitude, 'Work Longitude', _workLongitudeErrorMessage, false):resultBool;
    } else if (workLatitude.length==0) {
      resultBool=(resultBool)?doubleValidation(workLatitude, 'Work Latitude', _workLatitudeErrorMessage, true):resultBool;
    } else if (workLongitude.length==0) {
      resultBool=(resultBool)?doubleValidation(workLongitude, 'Work Longitude', _workLongitudeErrorMessage, true):resultBool;
    }

    _mobilePhoneErrorMessage=intValidation2(mobilePhone, 'Mobile Phone', 9, 20, true);
    // cek apakah bisa null
    if (homeLatitude.length!=0 && homeLongitude.length!=0) {
      _homeLatitudeErrorMessage=doubleValidation2(homeLatitude, 'Home Latitude', true);
      _homeLongitudeErrorMessage=doubleValidation2(homeLongitude, 'Home Longitude', true);
    } else if (homeLatitude.length==0 && homeLongitude.length==0) {
      _homeLatitudeErrorMessage=doubleValidation2(homeLatitude, 'Home Latitude', false);
      _homeLongitudeErrorMessage=doubleValidation2(homeLongitude, 'Home Longitude', false);
    } else if (homeLatitude.length==0) {
      _homeLatitudeErrorMessage=doubleValidation2(homeLatitude, 'Home Latitude', true);
    } else if (homeLongitude.length==0) {
      _homeLongitudeErrorMessage=doubleValidation2(homeLongitude, 'Home Longitude', true);
    }

    if (workLatitude.length!=0 && workLongitude.length!=0) {
      _workLatitudeErrorMessage=doubleValidation2(workLatitude, 'Work Latitude', true);
      _workLongitudeErrorMessage=doubleValidation2(workLongitude, 'Work Longitude', true);
    } else if (workLatitude.length==0 && workLongitude.length==0) {
      _workLatitudeErrorMessage=doubleValidation2(workLatitude, 'Work Latitude', false);
      _workLongitudeErrorMessage=doubleValidation2(workLongitude, 'Work Longitude', false);
    } else if (workLatitude.length==0) {
      _workLatitudeErrorMessage=doubleValidation2(workLatitude, 'Work Latitude', true);
    } else if (workLongitude.length==0) {
      _workLongitudeErrorMessage=doubleValidation2(workLongitude, 'Work Longitude', true);
    }

    return resultBool;
  }

  bool isLocationHomeTabInputValid() {
    if(_homeLatitude!=null && _homeLongitude!=null) {
      if (_homeLatitude.length!=0 || _homeLongitude.length!=0) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  bool isWorkplaceTabInputValid() {
    bool resultBool=false;
    String nik=nikController.text.trim();
    String name=nameController.text.trimRight().trimLeft();
    String companyName = companyNameController.text.trimRight().trimLeft();
    String companyPhone = companyPhoneController.text.trim();

    resultBool=intValidation(nik, 'NIK', _nikErrorMessage, 16, 16, true);
    resultBool=(resultBool)?textValidation(name, 'Name', _nameErrorMessage, false):resultBool;
    resultBool=(resultBool)?textValidation(companyName, 'Company Name', _companyNameErrorMessage, true):resultBool;
    resultBool=intValidation(companyPhone, 'Company Phone', _companyPhoneErrorMessage, 6, 20, true);

    _nikErrorMessage=intValidation2(nik, 'NIK', 16, 16, true);
    _nameErrorMessage=textValidation2(name, 'Name',  false);
    _companyNameErrorMessage=textValidation2(companyName, 'Company Name', true);
    _companyPhoneErrorMessage=intValidation2(companyPhone, 'Company Phone', 6, 20, true);

    return resultBool;
  }

  bool isTaxTabInputValid () {
    bool resultBool=false;
    String taxType=_currentTaxSelected;
    String npwp=npwpController.text.trim();
    String nik=nikController.text.trim();
    String name=nameController.text.trimRight().trimLeft();
    String birthplace=birthplaceController.text.trimRight().trimLeft();
    String birthdate=birthdateController.text.trim();
    String income=incomeController.text.trim();

    if (taxType=='Personal Tax' || taxType=='Company Tax'){
      resultBool=true;
    } else {
      _taxTypeErrorMessage='Tax Type has not been chosen';
      resultBool=false;
    }
    resultBool=(resultBool)?intValidation(npwp, 'NPWP', _npwpErrorMessage, 15, 15, true):resultBool;
    if (taxType=='Personal Tax') {
      resultBool=(resultBool)?intValidation(nik, 'NIK', _nikErrorMessage, 16, 16, true):resultBool;
      resultBool=(resultBool)?textValidation(name, 'Name', _nameErrorMessage, false):resultBool;
      resultBool=(resultBool)?dateValidation(birthdate, 'Birthdate', _birthdateErrorMessage, false):resultBool;
      resultBool=(resultBool)?textValidation(birthplace, 'Birthplace', _birthplaceErrorMessage, false):resultBool;
    }
    resultBool=(resultBool)?doubleValidation(income, 'Income', _incomeErrorMessage, true):resultBool;

    _npwpErrorMessage=intValidation2(npwp, 'NPWP', 15, 15, true);
    if (taxType=='Personal Tax') {
      _nikErrorMessage=intValidation2(nik, 'NIK', 16, 16, true);
      _nameErrorMessage=textValidation2(name, 'Name',  false);
      _birthdateErrorMessage=dateValidation2(birthdate, 'Birthdate', false);
      _birthplaceErrorMessage=textValidation2(birthplace, 'Birthplace', false);
    }
    _incomeErrorMessage=doubleValidation2(income, 'Income', true);

    return resultBool;
  }

  bool isPropertyTabInputValid() {
    // All parameters are Mandatory
    bool resultBool=false;

    String nop=nopController.text.trim();
    String propertyName=propertyNameController.text.trimRight().trimLeft();
    String propertySurfaceArea=propertySurfaceAreaController.text.trim();
    String propertyBuildingArea=propertyBuildingAreaController.text.trim();
    String estimation=propertyEstimationController.text.trim();

    String nik=nikController.text.trim();
    String certificateName=certificateNameController.text.trimRight().trimLeft();
    String certificateId=certificateIdController.text.trim();
    String certificateType=_currentPropertySelected;
    String certificateDate=certificateDateController.text.trim();

    if (certificateType!='HM' || certificateType!='HGB'){
      _taxTypeErrorMessage='Please choose certificate type';
      resultBool=false;
    }
    resultBool=(resultBool)?textNumberValidation(propertyName, 'Property Name', _propertyNameErrorMessage, true):resultBool;
    resultBool=(resultBool)?doubleValidation(propertySurfaceArea, 'Surface Area', _propertySurfaceAreaErrorMessage, true):resultBool;
    resultBool=(resultBool)?doubleValidation(propertyBuildingArea, 'Building Area', _propertyBuildingAreaErrorMessage, true):resultBool;
    resultBool=(resultBool)?doubleValidation(estimation, 'Estimation', _propertyEstimationErrorMessage, true):resultBool;

    resultBool=(resultBool)?intValidation(nik, 'NIK', _nikErrorMessage, 16, 16, true):resultBool;
    resultBool=(resultBool)?textValidation(certificateName, 'Certificate Name', _certificateNameErrorMessage, false):resultBool;
    resultBool=(resultBool)?intValidation(certificateId, 'Certificate Id', _certificateIdErrorMessage, 0, 100, true):resultBool;
    resultBool=(resultBool)?dateValidation(certificateDate, 'Certificate Date', _certificateDateErrorMessage, false):resultBool;

    _propertyNameErrorMessage=textNumberValidation2(propertyName, 'Property Name', true);
    _propertySurfaceAreaErrorMessage=doubleValidation2(propertySurfaceArea, 'Surface Area', true);
    _propertyBuildingAreaErrorMessage=doubleValidation2(propertyBuildingArea, 'Building Area', true);
    _propertyEstimationErrorMessage=doubleValidation2(estimation, 'Estimation', true);

    _nikErrorMessage=intValidation2(nik, 'NIK', 16, 16, true);
    _certificateNameErrorMessage=textValidation2(certificateName, 'Certificate Name', false);
    _certificateIdErrorMessage=textValidation2(certificateId, 'Certificate Id', true);
    _certificateDateErrorMessage=dateValidation2(certificateDate, 'Certificate Date', false);

    return resultBool;
  }

  bool textValidation(String fieldName, String fieldNameText, String errorMessageField, bool isMandatory) {
    if (fieldName==null ) {
      errorMessageField=isMandatory?fieldNameText+' can\'t be empty':null;
      return isMandatory? false:true;
//    } else if (!RegExp('^[a-zA-Z -]*').hasMatch(fieldName)) {
//      errorMessageField=fieldNameText+' can only contains alphabets';
//      return false;
    } else if (fieldName.length<1){
      errorMessageField=fieldNameText+' can\'t be empty';
      return false;
    }
    return true;
  }

  bool intValidation(String fieldName, String fieldNameText, String errorMessageField, int minCharNum, int maxCharNum, bool isMandatory) {
    if (fieldName==null){
      errorMessageField=isMandatory? fieldNameText+' can\'t be empty':null;
      return isMandatory? false:true;
    }
    if (fieldName.length<0) {
      errorMessageField=fieldNameText+' can\'t be empty';
      return false;
    } else if (fieldName.length<minCharNum || fieldName.length>maxCharNum) {
      errorMessageField=(fieldName.length<minCharNum)?fieldNameText+' is too short':fieldNameText+' is too long';
      return false;
    }
    if (!RegExp(r"^[0-9]*").hasMatch(fieldName)){
      errorMessageField=fieldNameText+' can only contain numbers';
      return false;
    }
    if (fieldNameText=='Mobile Phone') {
      if (fieldName.substring(0,2)!='62') {
        errorMessageField=fieldNameText+ ' must be started with 62';
        return false;
      } else {
        return true;
      }
    }

    if (fieldNameText=='Company Phone'){
      if (fieldName.substring(0,1)=='0' && fieldName.substring(0,2)!='08') {
        errorMessageField=fieldNameText+ ' must not contain area code';
        return false;
      }
      else
        return true;
    }
    return true;
  }

  bool doubleValidation(String fieldName, String fieldNameText, String errorMessageField, bool isMandatory) {
    if (fieldName==null){
      errorMessageField=isMandatory? fieldNameText+' can\'t be empty':null;
      return isMandatory? false:true;
    }
    if (fieldName.length<0) {
      errorMessageField=fieldNameText+' can\'t be empty';
      return false;
    }
//    if (!RegExp(r"/\d+\.\d*|\.?\d+/").hasMatch(fieldName)){
//      errorMessageField=fieldNameText+' can only contain numbers';
//      return false;
//    }
    return true;
  }

  bool textNumberValidation(String fieldName, String fieldNameText, String errorMessageField, bool isMandatory) {
    if (fieldName==null ) {
      errorMessageField=isMandatory?fieldNameText+' can\'t be empty':null;
      return isMandatory? false:true;
//    } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(fieldName)) {
//      errorMessageField=fieldNameText+' can only contains alphabets';
//      return false;
    } else if (fieldName.length<1){
      errorMessageField=fieldNameText+' can\'t be empty';
      return false;
    }
    return true;
  }

  bool dateValidation(String fieldName, String fieldNameText, String errorMessageField, bool isMandatory) {
    if (fieldName != null) {
      try {
        DateTime tempDate = new DateFormat("dd-MM-yyyy").parse(fieldName);
        if (Jiffy(DateTime.now()).add(years: -17).isBefore(tempDate)){
          //errorMessageField='Below 17 years old are \nnot supposed to qualify for eKTP';
          return false;
        }
        return true;
      } catch (e) {
        errorMessageField =fieldNameText + ' must be in dd-MM-yyyy format';
        return false;
      }
    } else {
      errorMessageField=isMandatory? fieldNameText + ' can\'t be empty':null;
      return isMandatory ? false : true;
    }
  }

  String textValidation2(String fieldName, String fieldNameText, bool isMandatory) {
    String errorMessageField=null;
    if (fieldName==null ) {
      errorMessageField=isMandatory?fieldNameText+' can\'t be empty':null;
      return errorMessageField;
//    } else if (!RegExp('[a-zA-Z]').hasMatch(fieldName)) {
//      errorMessageField=fieldNameText+' can only contains alphabets';
//      return errorMessageField;
    } else if (fieldName.length<1){
      errorMessageField=fieldNameText+' can\'t be empty';
      return errorMessageField;
    }
    return errorMessageField;
  }

  String intValidation2(String fieldName, String fieldNameText, int minCharNum, int maxCharNum, bool isMandatory) {
    String errorMessageField = null;
    if (fieldName==null){
      errorMessageField=isMandatory? fieldNameText+' can\'t be empty':null;
      return errorMessageField;
      //return isMandatory? false:true;
    }
    if (fieldName.length<0) {
      errorMessageField=fieldNameText+' can\'t be empty';
      return errorMessageField;
      //return false;
    } else if (fieldName.length<minCharNum || fieldName.length>maxCharNum) {
      errorMessageField=(fieldName.length<minCharNum)?fieldNameText+' is too short':fieldNameText+' is too long';
      return errorMessageField;
      //return false;
    }
    if (!RegExp(r"^[0-9]*").hasMatch(fieldName)){
      errorMessageField=fieldNameText+' can only contain numbers';
      return errorMessageField;
      //return false;
    }
    if (fieldNameText=='Mobile Phone') {
      if (fieldName.substring(0,2)!='62') {
        errorMessageField=fieldNameText+ ' must be started with 62';
        return errorMessageField;
        //return false;
      } else {
        return null;
      }
    }

    if (fieldNameText=='Company Phone'){
      if (fieldName.substring(0,1)=='0' && fieldName.substring(0,2)!='08') {
        errorMessageField=fieldNameText+ ' must not contain area code';
        //return false;
        return errorMessageField;
      }
      else
        //return true;
        return null;
    }
    return null;
  }

  String doubleValidation2(String fieldName, String fieldNameText, bool isMandatory) {
    String errorMessageField=null;
    if (fieldName==null){
      errorMessageField=isMandatory? fieldNameText+' can\'t be empty':null;
      //return isMandatory? false:true;
      return errorMessageField;
    }
    if (fieldName.length<0) {
      errorMessageField=fieldNameText+' can\'t be empty';
      return errorMessageField;
    }
//    if (!RegExp(r"/\d+\.\d*|\.?\d+/").hasMatch(fieldName)){
//      errorMessageField=fieldNameText+' can only contain numbers';
//      return errorMessageField;
//    }
    return errorMessageField;
  }

  String textNumberValidation2(String fieldName, String fieldNameText, bool isMandatory) {
    String errorMessageField=null;
    if (fieldName==null ) {
      errorMessageField=isMandatory?fieldNameText+' can\'t be empty':null;
      return errorMessageField;
//    } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(fieldName)) {
//      errorMessageField=fieldNameText+' can only contains alphabets';
//      return errorMessageField;
    } else if (fieldName.length<1){
      errorMessageField=fieldNameText+' can\'t be empty';
      return errorMessageField;
    }
    return errorMessageField;
  }

  String dateValidation2(String fieldName, String fieldNameText, bool isMandatory) {
    String errorMessageField=null;
    if (fieldName != null) {
      try {
        DateTime tempDate = new DateFormat("dd-MM-yyyy").parse(fieldName);
        if (Jiffy(DateTime.now()).add(years: -17).isBefore(tempDate)){
          errorMessageField='Below 17 years old are not supposed to qualify for eKTP';
        }
        return errorMessageField;
      } catch (e) {
        errorMessageField =fieldNameText + ' must be in dd-MM-yyyy format';
        return errorMessageField;
      }
    } else {
      errorMessageField=isMandatory? fieldNameText + ' can\'t be empty':null;
      return errorMessageField;
    }
  }


  /**
   *  VALIDATIONS END
   */



  /**
   *  UI PAGE START
   */
  Widget PersonalPageUI0(TextStyle textStyle) {
    return loading? _showCircularProgress(): PersonalPageUI(textStyle);
  }

  Widget PersonalPageUI(TextStyle textStyle) {
    return ListView(
        children: <Widget>[
          showNikInput(true),
          showErrorMessage(_nikErrorMessage),
          (personalApiResultMessage.containsKey('nik'))? showApiFieldVerification2('nik'):Container(),
          showNameInput(false),
          showErrorMessage(_nameErrorMessage),
          (personalApiResultMessage.containsKey('name'))? showApiFieldVerification2('name'):Container(),
          (personalApiResultMessage.containsKey('no_negative_record'))? showApiFieldVerification2('no_negative_record'):Container(),
          showBirthdateInput(false),
          showErrorMessage(_birthdateErrorMessage),
          (personalApiResultMessage.containsKey('birthdate'))? showApiFieldVerification2('birthdate'):Container(),
          showBirthplaceInput(false),
          showErrorMessage(_birthplaceErrorMessage),
          (personalApiResultMessage.containsKey('birthplace'))? showApiFieldVerification2('birthplace'):Container(),
          //showAddressInput(),
          showErrorMessage(_addressErrorMessage),
          (personalApiResultMessage.containsKey('address'))? showApiFieldVerification2('address'):Container(),
          showMobilePhoneInput(true),
          showErrorMessage(_mobilePhoneErrorMessage),
          (personalApiResultMessage.containsKey('phone_nik'))? showApiFieldVerification2('phone_nik'):Container(),
          (personalApiResultMessage.containsKey('phone_age'))? showApiFieldVerification2('phone_age'):Container(),
          (personalApiResultMessage.containsKey('phone_total'))? showApiFieldVerification2('phone_total'):Container(),
          //showMotherNameInput(),
          //showErrorMessage(_motherNameErrorMessage),
          (personalApiResultMessage.containsKey('mothername'))? showApiFieldVerification2('mothername'):Container(),
          // (personalApiResultMessage.containsKey('messageResult'))?showMessageResult():Container(),
          showUploadPhotoButton(),
          showErrorMessage(_selfieErrorMessage),
          (personalApiResultMessage.containsKey('selfie'))? showApiFieldVerification2('selfie'):Container(),
          showNotes('* Mandatory (Must be filled)', Colors.red),
          showButtons('personal'),
        ]);
  }

  // Nathanael code START



  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = CameraController(
      cameraDescription,
      ResolutionPreset.veryHigh,
      enableAudio: enableAudio,
    );

    // If the controller is updated then update the UI.
    controller.addListener(() {
      if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
        //createAlertDialog(this.context, 'Error','Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
    } on CameraException catch (e) {
      _showCameraException(e);
    }

    if (mounted) {
      setState(() {});
    }
  }

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  Widget LivenessPageUI0() {
    return loading? _showCircularProgress(): LivenessPageUI();
  }

  Widget LivenessPageUI(){
    return Scaffold(
      key: _scaffoldKey,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          _captureControlRowWidget1(),
          //_captureControlRowWidget000(),
          _LivenessGestureDropBox(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
              ],
            ),
          ),
        ],
      ),
    );

//    return Column(
//        children: <Widget>[
//          Expanded(
//            child: Container(
//              child: Padding(
//                padding: const EdgeInsets.all(1.0),
//                child: Center(
//                  child: _cameraPreviewWidget(),
//                ),
//              ),
//              decoration: BoxDecoration(
//                color: Colors.black,
//                border: Border.all(
//                  color: controller != null && controller.value.isRecordingVideo
//                      ? Colors.redAccent
//                      : Colors.grey,
//                  width: 3.0,
//                ),
//              ),
//            ),
//          ),
//          _captureControlRowWidget(),
//          //_toggleAudioWidget(),
//          Padding(
//            padding: const EdgeInsets.all(5.0),
//            child: Row(
//              mainAxisAlignment: MainAxisAlignment.start,
//              children: <Widget>[
//                _cameraTogglesRowWidget(),
//                //_thumbnailWidget(),
//              ],
//            ),
//          ),
//        ],
//      );
  }

  Widget _cameraTogglesRowWidget() {
    final List<Widget> toggles = <Widget>[];

    if (cameras.isEmpty) {
      return const Text('No camera found');
    } else {
      for (CameraDescription cameraDescription in cameras) {
        toggles.add(
          SizedBox(
            width: 90.0,
            child: RadioListTile<CameraDescription>(
              title: Icon(getCameraLensIcon(cameraDescription.lensDirection)),
              groupValue: controller?.description,
              value: cameraDescription,
              // onChanged: controller != null
              //     ? true
              //     : onNewCameraSelected,
              onChanged: onNewCameraSelected,
            ),
          ),
        );
      }
    }
    return Row(children: toggles);
  }

  Widget _LivenessGestureDropBox(){
    return new DropdownButton<String>(
      items: _gestureSetEnum.map((dynamic value) {
        return DropdownMenuItem<String>(
          value: value,
          child: new Text(value),
        );
      }).toList(),/**/
      value: _currentGestureSelected,
      onChanged: (value) {
        setState(() {
          _currentGestureSelected = value;
          print(_currentGestureSelected);
          switch(value){
            case 'left eye closed, mouth closed, right eye closed':
              gestureSetSelected = '0';
              break;
            case 'left eye closed, mouth closed, right eye open':
              gestureSetSelected = '1';
              break;
            case 'left eye closed, mouth open, right eye closed':
              gestureSetSelected = '2';
              break;
            case 'left eye closed, mouth open, right eye open':
              gestureSetSelected = '3';
              break;
            case 'left eye open, mouth closed, right eye closed':
              gestureSetSelected = '4';
              break;
            case 'left eye open, mouth closed, right eye open':
              gestureSetSelected = '5';
              break;
            case 'left eye open, mouth open, right eye closed':
              gestureSetSelected = '6';
              break;
            case 'left eye open, mouth open, right eye open':
              gestureSetSelected = '7';
              break;
          }
          print(gestureSetSelected);
          _onGestureSetDropDownItemSelected(value);
        });
        setState(() {
          isGestureSelected = true;
          gestureValue=_gestureSetEnum[int.parse(gestureSetSelected)];
          // switch(gestureSetSelected){
          //   case '1':
          //     gestureValue = _gestureSetEnum[0];
          //     break;
          //   case '2':
          //     gestureValue = _gestureSetEnum[1];
          //     break;
          //   case '3':
          //     gestureValue = _gestureSetEnum[2];
          //     break;
          //   case '4':
          //     gestureValue = _gestureSetEnum[3];
          //     break;
          //   case '5':
          //     gestureValue = _gestureSetEnum[4];
          //     break;
          //   case '6':
          //     gestureValue = _gestureSetEnum[5];
          //     break;
          //   case '7':
          //     gestureValue = _gestureSetEnum[6];
          //     break;
          // }
          gesture = gestureValue;
          _currentGestureSelected=gestureValue;
          //print(gestureSetSelected);
        });
      },
      isExpanded: true,
      //value: gesture,
    );
    //);
  }

  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'Tap a camera',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }
  }

  // Widget _captureControlRowWidget000() {
  //   return Row(
  //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
  //     mainAxisSize: MainAxisSize.max,
  //     children: <Widget>[
  //       IconButton(
  //         icon: const Icon(Icons.camera_alt),
  //         color: Colors.blue,
  //         onPressed: controller != null &&
  //             controller.value.isInitialized &&
  //             !controller.value.isRecordingVideo
  //             ? onTakePictureButtonPressed
  //             : null,
  //       ),
  //       // IconButton(
  //       //   icon: const Icon(Icons.videocam),
  //       //   color: Colors.blue,
  //       //   onPressed: controller != null &&
  //       //       controller.value.isInitialized &&
  //       //       !controller.value.isRecordingVideo
  //       //       ? onVideoRecordButtonPressed
  //       //       : null,
  //       // ),
  //       // IconButton(
  //       //   icon: controller != null && controller.value.isRecordingPaused
  //       //       ? Icon(Icons.play_arrow)
  //       //       : Icon(Icons.pause),
  //       //   color: Colors.blue,
  //       //   onPressed: controller != null &&
  //       //       controller.value.isInitialized &&
  //       //       controller.value.isRecordingVideo
  //       //       ? (controller != null && controller.value.isRecordingPaused
  //       //       ? onResumeButtonPressed
  //       //       : onPauseButtonPressed)
  //       //       : null,
  //       // ),
  //       // IconButton(
  //       //   icon: const Icon(Icons.stop),
  //       //   color: Colors.red,
  //       //   onPressed: controller != null &&
  //       //       controller.value.isInitialized &&
  //       //       controller.value.isRecordingVideo
  //       //       ? onStopButtonPressed
  //       //       : null,
  //       // )
  //     ],
  //   );
  // }

  Widget _captureControlRowWidget1() {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: Theme.of(this.context).primaryColorDark,
              textColor: Theme.of(this.context).primaryColorLight,
              disabledColor: Theme.of(this.context).primaryColorDark,

              child: Text(
                'Step1. Take Photos',
                textScaleFactor: 1,
              ),
              onPressed: () {
                onTakePictureButtonPressed();
//                controller != null &&
//                    controller.value.isInitialized &&
//                    !controller.value.isRecordingVideo
//                    ? onTakePictureButtonPressed
//                    : null;
//                isContinuePhoto=false;
//                warnLivenessPhotosCapture();
//                if (isContinuePhoto)

              },
            ),
          ),

          Container(width: 5.0,),

          Expanded(
            child: RaisedButton(
              color: Theme.of(this.context).primaryColorDark,
              textColor: Theme.of(this.context).primaryColorLight,
              child: Text(
                'Step 2. Check Liveness',
                textScaleFactor: 1,
              ),
              onPressed: () {
                processLiveness(this.context);
                setState(() {

                });
              },
            ),
          ),

        ],
      ),
    );
  }

  Widget _captureControlRowWidget() {
    return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.camera_alt),
            color: Colors.blue,
            onPressed: controller != null &&
                controller.value.isInitialized &&
                !controller.value.isRecordingVideo
                ? onTakePictureButtonPressed
                : null,
          )
        ]
    );
  }

//  warnLivenessPhotosCapture() {
//    //showInSnackBar('Now hold your pose. It will take about 1-2 minutes.');
//    Widget cancelButton = FlatButton(
//      child: Text("Cancel"),
//      onPressed:  () {
//        isContinuePhoto=false;
//        Navigator.of(this.context).pop();
//      },
//    );
//    Widget continueButton = FlatButton(
//      child: Text("Continue"),
//      onPressed:  () {
//        //onTakePictureButtonPressed();
//        isContinuePhoto=true;
//        Navigator.of(this.context).pop();
//
//      },
//    );

  // set up the AlertDialog
//    AlertDialog alert = AlertDialog(
//      title: Text("Confirmation"),
//      content: Text("You need to hold your pose for 1-2 minutes. Do you want to continue start taking photos?"),
//      actions: [
//        cancelButton,
//        continueButton,
//      ],
//    );
//
//    // show the dialog
//    showDialog(
//      context: this.context,
//      builder: (BuildContext context) {
//        return alert;
//      },
//    );
//  }
  void onTakePictureButtonPressed() async {
    setState(() {
      loading = true;
    });
    try{
      isGestureSelected=true;
      if(isGestureSelected) {
        //takePicture().then((String filePath) {
        takePicture().then((String result) {
          if (mounted) {
            setState(() {

            });
            if (result != null)
              //showInSnackBar('Picture captured successfully');
              createAlertDialog(this.context, 'Success','Photos captured successfully. Now click Check Liveness button.');
            else
              //showInSnackBar('Error taking pictures');
              createAlertDialog(this.context, 'Error','Error taking photos. Please redo.');
          }
        });
      }
      else{
        //showInSnackBar('Please select gesture set');
        createAlertDialog(this.context, 'Warning', 'Please select gesture set');
      }
    }catch(e){
      createAlertDialog(this.context, 'Error', e.substring(0, 50));
    }
    setState(() {
      loading = false;
    });
  }

  String timestamp() => DateTime.now().microsecond.toString();

  Future<String> takePicture() async {
    try {
      if (!controller.value.isInitialized) {
        //showInSnackBar('Error: select a camera first.');
        createAlertDialog(this.context,'Error','Error: select a camera first.');
        return null;
      }
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${extDir.path}/Pictures/Liveness';
      final String dirPathCompressed = '${extDir.path}/Pictures/LivenessCompressed';
      List<String> dirsToDelete=[dirPath, dirPathCompressed];
      livenessPhotos=new List(8);
      livenessCompressedPhotos=new List(8);

      await Directory(dirPathCompressed).createSync(recursive: true);
      await Directory(dirPath).createSync(recursive: true);
      await deleteExistingPictures(dirPath, dirPathCompressed);

      if (controller.value.isTakingPicture) {
        // A capture is already pending, do nothing.
        return null;
      }

      try {
        for (int i=1;i< livenessPhotos.length+1;i++) {
          livenessPhotos[i-1]=await takePictureWithTimer('$dirPath/$i.jpg');
        }
      } on CameraException catch (e) {
        _showCameraException(e);
        return null;
      }

      if (livenessPhotos[0]!=null && livenessPhotos[1]!=null && livenessPhotos[2]!=null && livenessPhotos[3]!= null && livenessPhotos[4]!=null && livenessPhotos[5]!=null && livenessPhotos[6]!=null && livenessPhotos[7]!= null) {
        if (livenessPhotos[0].length()!=0 && livenessPhotos[1].length()!=0 && livenessPhotos[2].length()!=0 && livenessPhotos[3]!= null && livenessPhotos[4].length()!=0 && livenessPhotos[5].length()!=0 && livenessPhotos[6].length()!=0 && livenessPhotos[7].length()!=0) {
          return 'success';
        }
      }
      return null;
    } catch (e) {
      createAlertDialog(this.context, 'Error', e.substring(0, 50));
    }
  }

  processLiveness(BuildContext context) async {
    setState(() {
      loading = true;
    });
    try {
      final Directory extDir = await getApplicationDocumentsDirectory();
      final String dirPathCompressed = '${extDir.path}/Pictures/LivenessCompressed';
      bool isResultSuccess=false;

      if (livenessPhotos[0]!=null && livenessPhotos[1]!=null && livenessPhotos[2]!=null && livenessPhotos[3]!= null && livenessPhotos[4]!=null && livenessPhotos[5]!=null && livenessPhotos[6]!=null && livenessPhotos[7]!= null) {
        if (livenessPhotos[0].length()!=0 && livenessPhotos[1].length()!=0 && livenessPhotos[2].length()!=0 && livenessPhotos[3]!= null && livenessPhotos[4].length()!=0 && livenessPhotos[5].length()!=0 && livenessPhotos[6].length()!=0 && livenessPhotos[7].length()!=0) {
          for (int i=1; i< livenessCompressedPhotos.length+1;i++) {
            livenessCompressedPhotos[i-1]=await compressPictures(livenessPhotos[i-1], dirPathCompressed, i.toString());
          }

          if (livenessCompressedPhotos[0]!=null && livenessCompressedPhotos[1]!=null && livenessCompressedPhotos[2]!=null && livenessCompressedPhotos[3]!=null && livenessCompressedPhotos[4]!=null && livenessCompressedPhotos[5]!=null && livenessCompressedPhotos[6]!=null && livenessCompressedPhotos[7]!=null) {
            if (livenessCompressedPhotos[0].length()!=0 && livenessCompressedPhotos[1].length()!=0 && livenessCompressedPhotos[2].length()!=0 && livenessCompressedPhotos[3]!= null && livenessCompressedPhotos[4].length()!=0 && livenessCompressedPhotos[5].length()!=0 && livenessCompressedPhotos[6].length()!=0 && livenessCompressedPhotos[7].length()!=0) {
              await livenessProcess(this.context);
              //isResultSuccess=true;
            }else { // one of the pictures length is 0 b after compression
              createAlertDialog(context, 'Not executed', 'Please hold selected pose and click \'Step1.\' Take Pictures button');
            }
          }else { // one of the pictures null after compression
            createAlertDialog(context, 'Not executed', 'Please hold selected pose and click \'Step1.\' Take Pictures button');
          }
        } else { // one of the pictures length is 0 b
          createAlertDialog(context, 'Not executed', 'Please hold selected pose and click \'Step1.\' Take Pictures button');
        }
      } else { // one of the pictures null
        createAlertDialog(context, 'Not executed', 'Please hold selected pose and click \'Step1.\' Take Pictures button');
      }
    }
    catch (e) {
      createAlertDialog(context, 'Error', e.substring(0, 50));
    }
    setState(() {
      loading = false;
    });
  }


  Future<String>deleteExistingPictures(String dirPath, String dirPathCompressed) async {
    try {
      for (int i=1;i<livenessPhotos.length+1;i++) {
        if (await File('$dirPath/$i.jpg').exists()) {
          await File('$dirPath/$i.jpg').delete();
        }
        if (await File('$dirPathCompressed/$i.jpg').exists()) {
          await File('$dirPathCompressed/$i.jpg').delete();
        }
      }
    } catch (e) {
      createAlertDialog(this.context, 'Error', e.substring(0, 50));
    }
  }

  Future<File> takePictureWithTimer(String filePath) async {
    await controller.takePicture(filePath);
    Future<File> result=Future.delayed(Duration(milliseconds: 800), () {
      try{
        return new File(filePath);
      } on CameraException catch (e) {
        _showCameraException(e);
        return null;
      }
    });
    return result;
  }

  Future<File> compressPictures(File picture, String resultDirectory, String compressedPhotoName) async {
    String resultPath=resultDirectory+ '/' +compressedPhotoName+'.jpg';
    int photoQuality=40;
    if(picture != null) {
      try {
        var result = await FlutterImageCompress.compressAndGetFile(
          picture.absolute.path, resultPath,
          quality: photoQuality,
        );

        int pictureLength=picture.lengthSync();
        int resultLength=result.lengthSync();

        var i = 1;

        while ((resultLength< livenessMinPhotoSize || resultLength > livenessMaxPhotoSize) && photoQuality>0 && photoQuality<100) {
          if (result!=null)
            await result.delete();
//          resultPath=resultDirectory+compressedPhotoName+'.jpg';
          photoQuality=(resultLength>livenessMaxPhotoSize)? photoQuality-10:photoQuality+10;
          result = await FlutterImageCompress.compressAndGetFile(
            picture.absolute.path, resultPath,
            quality: photoQuality,
          );
          resultLength=result.lengthSync();
        }

        double sizeinKb=resultLength.toDouble()/1024;
        debugPrint('Photo compressed size is '+sizeinKb.toString()+' kb');

        await picture.delete();
        return result;
      }
      catch (e) {
        print (e);
        debugPrint("Error $e");
      }
    } else {
      return null;
    }
  }

  // Future<String> takePicture_backup() async {
  //   if (!controller.value.isInitialized) {
  //     //showInSnackBar('Error: select a camera first.'); Maya commented this because not needed anymore
  //     return null;
  //   }
  //   final Directory extDir = await getApplicationDocumentsDirectory();
  //   final String dirPath = '${extDir.path}/Pictures/Liveness';
  //   final String dirPathCompressed = '${extDir.path}/Pictures/LivenessCompressed';
  //   List<String> dirsToDelete=[dirPath, dirPathCompressed];
  //   Directory(dirPathCompressed).createSync(recursive: true);
  //   Directory(dirPath).createSync(recursive: true);
  //   if (await File(dirPath+'/1.jpg').exists()) {
  //     await File(dirPath+'/1.jpg').delete();
  //   }
  //   if (await File(dirPath+'/2.jpg').exists()) {
  //     await File(dirPath+'/2.jpg').delete();
  //   }
  //   if (await File(dirPath+'/3.jpg').exists()) {
  //     await File(dirPath+'/3.jpg').delete();
  //   }
  //   if (await File(dirPath+'/4.jpg').exists()) {
  //     await File(dirPath+'/4.jpg').delete();
  //   }
  //   if (await File(dirPath+'/5.jpg').exists()) {
  //     await File(dirPath+'/5.jpg').delete();
  //   }
  //   if (await File(dirPath+'/6.jpg').exists()) {
  //     await File(dirPath+'/6.jpg').delete();
  //   }
  //   if (await File(dirPath+'/7.jpg').exists()) {
  //     await File(dirPath+'/7.jpg').delete();
  //   }
  //   if (await File(dirPath+'/8.jpg').exists()) {
  //     await File(dirPath+'/8.jpg').delete();
  //   }
  //   final String filePath = '$dirPath/${timestamp()}.jpg';
  //   bool isFinished = false;
  //   bool ready = false;
  //
  //   // delete directory dirpath and dirPathCompressed if exists
  //
  //
  //   if (controller.value.isTakingPicture) {
  //     // A capture is already pending, do nothing.
  //     return null;
  //   }
  //
  //   try {
  //     await controller.takePicture('$dirPath/1.jpg');
  //     Timer(Duration(milliseconds: 800), (){
  //     });
  //     await controller.takePicture('$dirPath/2.jpg');
  //     Timer(Duration(milliseconds: 800), (){
  //     });
  //     await controller.takePicture('$dirPath/3.jpg');
  //     Timer(Duration(milliseconds: 800), (){
  //     });
  //     await controller.takePicture('$dirPath/4.jpg');
  //     Timer(Duration(milliseconds: 800), (){
  //     });
  //     await controller.takePicture('$dirPath/5.jpg');
  //     Timer(Duration(milliseconds: 800), (){
  //     });
  //     await controller.takePicture('$dirPath/6.jpg');
  //     Timer(Duration(milliseconds: 800), (){
  //     });
  //     await controller.takePicture('$dirPath/7.jpg');
  //     Timer(Duration(milliseconds: 800), (){
  //     });
  //     await controller.takePicture('$dirPath/8.jpg');
  //   } on CameraException catch (e) {
  //     _showCameraException(e);
  //     return null;
  //   }
  //
  //
  //
  //   setState(() {
  //     photo1 = new File('$dirPath/1.jpg');
  //     photo2 = new File('$dirPath/2.jpg');
  //     photo3 = new File('$dirPath/3.jpg');
  //     photo4 = new File('$dirPath/4.jpg');
  //     photo5 = new File('$dirPath/5.jpg');
  //     photo6 = new File('$dirPath/6.jpg');
  //     photo7 = new File('$dirPath/7.jpg');
  //     photo8 = new File('$dirPath/8.jpg');
  //     isFinished = true;
  //   });
  //
  //   String photoLength1=photo1.length().toString();
  //   String photoLength2=photo2.length().toString();
  //   String photoLength3=photo3.length().toString();
  //   String photoLength4=photo4.length().toString();
  //   String photoLength5=photo5.length().toString();
  //   String photoLength6=photo6.length().toString();
  //   String photoLength7=photo7.length().toString();
  //   String photoLength8=photo8.length().toString();
  //
  //   print(photoLength1+''+ photoLength2+''+ photoLength3+''+ photoLength4+''+photoLength5+''+photoLength6+''+ photoLength7+''+ photoLength8);
  //
  //   if(isFinished) {
  //     PhotoCompressor().compressor1(photo1);
  //     PhotoCompressor().compressor2(photo2);
  //     PhotoCompressor().compressor3(photo3);
  //     PhotoCompressor().compressor4(photo4);
  //     PhotoCompressor().compressor5(photo5);
  //     PhotoCompressor().compressor6(photo6);
  //     PhotoCompressor().compressor7(photo7);
  //     PhotoCompressor().compressor8(photo8);
  //     ready = true;
  //   }
  //
  //   if(ready){
  //     //showInSnackBar('Photo taken successfully');
  //     setState(() {
  //       photo1Compressed = new File('$dirPathCompressed/1.jpg');
  //       photo2Compressed = new File('$dirPathCompressed/2.jpg');
  //       photo3Compressed = new File('$dirPathCompressed/3.jpg');
  //       photo4Compressed = new File('$dirPathCompressed/4.jpg');
  //       photo5Compressed = new File('$dirPathCompressed/5.jpg');
  //       photo6Compressed = new File('$dirPathCompressed/6.jpg');
  //       photo7Compressed = new File('$dirPathCompressed/7.jpg');
  //       photo8Compressed = new File('$dirPathCompressed/8.jpg');
  //     });
  //     await photo1.delete();
  //     await photo2.delete();
  //     await photo3.delete();
  //     await photo4.delete();
  //     await photo5.delete();
  //     await photo6.delete();
  //     await photo7.delete();
  //     await photo8.delete();
  //     await livenessProcess(this.context);
  //   }
  // }

  Future<bool> deleteDirectories(List<String> directoryPaths) async{
    for (var i = 0; i < directoryPaths.length; i++) {
      var currentDir = Directory(directoryPaths[i]);
      if (await currentDir.exists())
        await currentDir.delete(recursive: true);
    }
    return true;
  }

  livenessProcess(BuildContext context) async{
    String trx_id = 'Liveness_' + DateFormat('yyyyMMddHHmmss').format(DateTime.now());
    String token = '21bc8a0b-2398-413b-8159-7b389f51e40f';
    String contentType = 'application/json';
    try{
      var uri = Uri.parse('https://api.asliri.id:8443/infosyssolusiterpadu_poc/verify_liveness');
      var request = new http.MultipartRequest('POST', uri);

      request.fields['trx_id'] = trx_id;
      request.fields['gestures_set'] = gestureSetSelected;
      request.headers['token'] = token;
      request.headers['Content-Type'] = contentType;
      for (int i=0;i<livenessCompressedPhotos.length;i++) {
        request.files.add(http.MultipartFile('file', File(livenessCompressedPhotos[i].path).readAsBytes().asStream(), File(livenessCompressedPhotos[i].path).lengthSync(), filename: basename(livenessCompressedPhotos[i].path)));
      }
      print('files: '+ request.files.length.toString());

      var response = await request.send();
      var resStr = await response.stream.bytesToString();
      print(resStr);

      Map<String, dynamic> listResult = jsonDecode(resStr.toString());
      AsliGesturesSetNamesModel gestureModel = AsliGesturesSetNamesModel.fromJson(listResult);

      //TODO: response validation
      if(gestureModel.gesturesSetResults != null){
        if(gestureModel.passed = false){
          createAlertDialog(context,'Error','Your gesture photo does not match with the selected gesture set');
          //showInSnackBar('Your gesture photo does not match with the selected gesture set');
        }
        else{
          //showInSnackBar('You pass the liveness detection');
          createAlertDialog(context,'Success','Photos taken from live person and matched the gesture set');
        }
      }
      else{
        //showInSnackBar('Photo is from more than 1 person or image is not readable');
        createAlertDialog(context,'Error','Photo is taken from more than 1 person or images is not readable');
      }
    }
    catch(e){
      debugPrint('Error $e');
      createAlertDialog(context,'Failed','Liveness verification failed. Photos may not be taken from live person.');
    }
    return true;
  }

  Widget LocationPageUI0() {
    return loading? _showCircularProgress(): LocationPageUI();
  }

  Widget LocationPageUI() {
    return ListView(
      children: <Widget>[
        showMobilePhoneInput(true),
        showErrorMessage(_mobilePhoneErrorMessage),
        (locationApiResultMessage.containsKey('phone'))? showApiFieldVerification(locationApiResultBool, locationApiResultMessage,'phone'):Container(),
        showNotes('* Mandatory (Must be filled)', Colors.red),
        showHomeVerificationButton(),
        showNotes('Home Verification is checked if the mobile phone owner\nused internet data package in current location\nbetween 22PM - 3AM for the past 3 days', Colors.blue),
//        showHomeLatitudeLongitudeInput(),
//        showErrorMessage(_homeLatitudeErrorMessage),
//        showErrorMessage(_homeLongitudeErrorMessage),
        (locationApiResultMessage.containsKey('home'))? showApiFieldVerification(locationApiResultBool, locationApiResultMessage,'home'):Container(),
//        showWorkLatitudeLongitudeInput(),
//        showErrorMessage(_workLatitudeErrorMessage),
//        showErrorMessage(_workLongitudeErrorMessage),
//        (locationApiResultMessage.containsKey('work'))? showApiFieldVerification(locationApiResultBool, locationApiResultMessage,'work'):Container(),
//        showButtons('location'),
      ],
    );
  }

  Widget WorkplacePageUI0(TextStyle textStyle) {
    return loading? _showCircularProgress(): WorkplacePageUI(textStyle);
  }

  Widget WorkplacePageUI(TextStyle textStyle) {
    return ListView(
      children: <Widget>[
        showNikInput(true),
        showErrorMessage(_nikErrorMessage),
        (workplaceApiResultMessage.containsKey('nik'))? showApiFieldVerification(workplaceApiResultBool, workplaceApiResultMessage,'nik'):Container(),
        showNameInput(false),
        showErrorMessage(_nameErrorMessage),
        (workplaceApiResultMessage.containsKey('name'))? showApiFieldVerification(workplaceApiResultBool, workplaceApiResultMessage,'name'):Container(),
        showCompanyNameInput(true),
        showErrorMessage(_companyNameErrorMessage),
        (workplaceApiResultMessage.containsKey('company'))? showApiFieldVerification(workplaceApiResultBool, workplaceApiResultMessage,'company'):Container(),
        (workplaceApiResultMessage.containsKey('company_name'))? showApiFieldVerification(workplaceApiResultBool, workplaceApiResultMessage,'company_name'):Container(),
        showCompanyPhoneInput(),
        showErrorMessage(_companyPhoneErrorMessage),
        (workplaceApiResultMessage.containsKey('company_phone'))? showApiFieldVerification(workplaceApiResultBool, workplaceApiResultMessage,'company_phone'):Container(),
        (workplaceApiResultMessage.containsKey('messageResult'))?showMessageResult2(workplaceApiResultMessage):Container(),
        showNotes('* Mandatory (Must be filled)', Colors.red),
        showButtons('workplace'),
      ],
    );
  }

  Widget TaxPageUI0(TextStyle textStyle) {
    return loading? _showCircularProgress(): TaxPageUI(textStyle);
  }

  Widget TaxPageUI(TextStyle textStyle) {
    return ListView(
      children: <Widget>[
//        showNpwpTaxTypeInput(),
        //showTaxTypeInput(),
        showNpwpInput(true),
        showErrorMessage(_npwpErrorMessage),
        (taxApiResultMessage.containsKey('npwp'))? showApiFieldVerification(taxApiResultBool, taxApiResultMessage,'npwp'):Container(),
        (_currentTaxSelected=='Personal Tax')?showNikInput(true):Container(),
        (_currentTaxSelected=='Personal Tax')?showErrorMessage(_nikErrorMessage):Container(),
        (_currentTaxSelected=='Personal Tax' && taxApiResultMessage.containsKey('nik'))? showApiFieldVerification(taxApiResultBool, taxApiResultMessage,'nik'):Container(),
        (_currentTaxSelected=='Personal Tax' && taxApiResultMessage.containsKey('nik2'))? showApiFieldVerification(taxApiResultBool, taxApiResultMessage,'nik2'):Container(),
        (_currentTaxSelected=='Personal Tax')?showNameInput(false):Container(),
        (_currentTaxSelected=='Personal Tax')?showErrorMessage(_nameErrorMessage):Container(),
        (_currentTaxSelected=='Personal Tax' && taxApiResultMessage.containsKey('name')&&_currentTaxSelected=='Personal Tax')? showApiFieldVerification(taxApiResultBool, taxApiResultMessage,'name'):Container(),
        (_currentTaxSelected=='Personal Tax')?showBirthdateInput(false):Container(),
        (_currentTaxSelected=='Personal Tax')?showErrorMessage(_birthdateErrorMessage):Container(),
        (_currentTaxSelected=='Personal Tax' && taxApiResultMessage.containsKey('birthdate')&&_currentTaxSelected=='Personal Tax')? showApiFieldVerification(taxApiResultBool, taxApiResultMessage,'birthdate'):Container(),
        (_currentTaxSelected=='Personal Tax')?showBirthplaceInput(false):Container(),
        (_currentTaxSelected=='Personal Tax')?showErrorMessage(_birthplaceErrorMessage):Container(),
        (_currentTaxSelected=='Personal Tax' && taxApiResultMessage.containsKey('birthplace')&&_currentTaxSelected=='Personal Tax')? showApiFieldVerification(taxApiResultBool, taxApiResultMessage,'birthplace'):Container(),
        showIncomeInput(true),
        showErrorMessage(_incomeErrorMessage),
        (taxApiResultMessage.containsKey('income'))? showApiFieldVerification(taxApiResultBool, taxApiResultMessage,'income'):Container(),
        (_currentTaxSelected=='Personal Tax' && taxApiResultMessage.containsKey('income2')&&_currentTaxSelected=='Personal Tax')? showApiFieldVerification(taxApiResultBool, taxApiResultMessage,'income2'):Container(),
        (_currentTaxSelected=='Personal Tax' && taxApiResultMessage.containsKey('messageResult'))? showMessageResult2(taxApiResultMessage):Container(),
        showNotes('* Mandatory (Must be filled)', Colors.red),
        showButtons('tax'),
      ],
    );
  }

  Widget PropertyPageUI() {
    return ListView(
      children: <Widget>[
        showNopInput(),
        showErrorMessage(_nopErrorMessage),
        (propertyApiResultMessage.containsKey('nop'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'nop'):Container(),
        showPropertyNameInput(),
        showErrorMessage(_propertyNameErrorMessage),
        (propertyApiResultMessage.containsKey('propertyName'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'propertyName'):Container(),
        (propertyApiResultMessage.containsKey('propertyAddress'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'propertyAddress'):Container(),
        showPropertyAreaInput(),
        showErrorMessage(_propertyBuildingAreaErrorMessage),
        showErrorMessage(_propertySurfaceAreaErrorMessage),
        (propertyApiResultMessage.containsKey('propertyBuildingArea'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'propertyBuildingArea'):Container(),
        (propertyApiResultMessage.containsKey('propertySurfaceArea'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'propertySurfaceArea'):Container(),
        showPropertyEstimationInput(),
        showErrorMessage(_propertyEstimationErrorMessage),
        (propertyApiResultMessage.containsKey('propertyEstimation'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'propertyEstimation'):Container(),
        showNikInput(true),
        showErrorMessage(_nikErrorMessage),
        (propertyApiResultMessage.containsKey('nik'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'nik'):Container(),
        showCertificateNameInput(),
        showErrorMessage(_certificateNameErrorMessage),
        (propertyApiResultMessage.containsKey('certificateName'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'certificateName'):Container(),
        (propertyApiResultMessage.containsKey('certificateAddress'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'certificateAddress'):Container(),
        showCertificateIdAndTypeInput(),
        showErrorMessage(_certificateIdErrorMessage),
        showErrorMessage(_certificateTypeErrorMessage),
        (propertyApiResultMessage.containsKey('certificateId'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'certificateId'):Container(),
        (propertyApiResultMessage.containsKey('certificateType'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'certificateType'):Container(),
        showCertificateDateInput(),
        showErrorMessage(_certificateDateErrorMessage),
        (propertyApiResultMessage.containsKey('certificateDate'))? showApiFieldVerification(propertyApiResultBool, propertyApiResultMessage,'certificateDate'):Container(),
        showNotes('* Mandatory (Must be filled)', Colors.red),
        showButtons('property'),
      ],
    );
  }

  Widget CameraTestUI() {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Camera example'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.all(1.0),
                child: Center(
                  child: _cameraPreviewWidget(),
                ),
              ),
              decoration: BoxDecoration(
                color: Colors.black,
                border: Border.all(
                  color: controller != null && controller.value.isRecordingVideo
                      ? Colors.redAccent
                      : Colors.grey,
                  width: 3.0,
                ),
              ),
            ),
          ),
          _captureControlRowWidget(),
          //_toggleAudioWidget(),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                _cameraTogglesRowWidget(),
                //_thumbnailWidget(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /**
   *  UI PAGE ENDS
   */

  /**
   * UI MINOR START
   */



  Widget showNikInput(bool isMandatory) {
    String label=(isMandatory)?'NIK *':'NIK';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: nikController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.credit_card,
              color: Colors.grey,
            )),
        // onChanged: (text) {
        //   resetPreSubmitErrorMessage();
        //   resetPostSubmitErrorMessages();
        // },
        validator: (value) {
          // if (value.isEmpty) {
          //   return 'NIK can\'t be empty';
//          } else if (!RegExp(r"^[0-9]*").hasMatch(value.trim())) {
//              return 'NIK can only be numbers';
//          } else if (value.trim().length!=16) {
//            return 'NIK character amount is wrong';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showNameInput(bool isMandatory) {
    String label=(isMandatory)?'Name *':'Name';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: nameController,
        decoration: new InputDecoration(
            hintText: 'Name',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Name can\'t be empty';
//          } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
//              return 'Name can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Name can\'t be empty';
//          }
        },
      ),
    );
  }

  Widget showBirthdateInput(isMandatory) {
    String label=(isMandatory)?'Birthdate *':'Birthdate';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.datetime,
        autofocus: false,
        controller: birthdateController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )),
        onTap: () {
          showDatePicker(
            context:this.context,
            //initialDate:selectedbirthdate==null? DateTime.now():selectedbirthdate,
            initialDate:DateTime.now(),
            //firstDate: DateTime.now().add(Duration(years:16)),
            firstDate: DateTime(1900, 1, 1),
            lastDate:DateTime.now(),
            //lastDate: Jiffy(DateTime.now()).add(years: -17)
          ).then((selectedDate){
            selectedbirthdate=selectedDate;
            birthdateController.text= DateFormat('dd-MM-yyyy').format(selectedDate).toString();
            //new DateFormat.yMMMd().format(selectedDate);
                ;
          });
        },
        onChanged: (value) {
          updatebirthdate();
        },
      ),
    );
  }

  Widget showBirthplaceInput(bool isMandatory) {
    String label=(isMandatory)?'Birthplace *':'Birthplace';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: birthplaceController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.location_city,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Birthplace can\'t be empty';
//          } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
//            return 'Birthplace can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Birthplace can\'t be empty';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showAddressInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: addressController,
        decoration: new InputDecoration(
            hintText: 'Address',
            icon: new Icon(
              Icons.home,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Address can\'t be empty';
////          } else
////            if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
////            return 'Birthplace can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Address can\'t be empty';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showMobilePhoneInput(bool isMandatory) {
    String label=(isMandatory)?'Mobile Phone Number * (must start with 62)':'Mobile Phone Number (must start with 62)';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        controller: mobilePhoneController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.phone_android,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Mobile Phone can\'t be empty';
//          } else if (!RegExp(r"^[0-9]*").hasMatch(value.trim())) {
//            return 'Mobile Phone can only be numbers';
//          } else if (value.trim().length<12) {
//            return 'Mobile Phone digit amount is wrong';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showMotherNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: motherNameController,
        decoration: new InputDecoration(
            hintText: 'Mother Name',
            icon: new Icon(
              Icons.person_outline,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Mother Name can\'t be empty';
//          } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
//            return 'Mother Name can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Mother Name can\'t be empty';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showCompanyNameInput(bool isMandatory) {
    String label=(isMandatory)?'Company Name *':'Company Name';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: companyNameController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.location_city,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Company Name can\'t be empty';
//          } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
//            return 'Company Name can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Company Name can\'t be empty';
//          }
        },
      ),
    );
  }

  Widget showCompanyPhoneInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.phone,
        autofocus: false,
        controller: companyPhoneController,
        decoration: new InputDecoration(
            hintText: 'Company Phone Number (without Area Code)',
            icon: new Icon(
              Icons.phone,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isNotEmpty) {
//            if (!RegExp(r"^[0-9]*").hasMatch(value.trim())) {
//              return 'Company Phone can only be numbers';
//            }
//            if (value.trim().length < 6) {
//              return 'Company Phone digit is too short';
//            }
//          }
        },
      ),
    );
  }

//  Widget showNpwpTaxTypeInput() {
//    return Padding(
//      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
//      child: Row(children: <Widget>[
//        Expanded(
//          child: new TextFormField(
//            maxLines: 1,
//            keyboardType: TextInputType.number,
//            autofocus: false,
//            controller: npwpController,
//            decoration: new InputDecoration(
//                hintText: 'NPWP',
//                icon: new Icon(
//                  Icons.business_center,
//                  color: Colors.grey,
//                )),
//            validator: (value) {
//              if (value.isEmpty) {
//                return 'NPWP can\'t be empty';
//              } else {
//                if (!RegExp(
//                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
//                    .hasMatch(value))
//                  return 'NPWP can only be numbers';
//              }
//            },
//          ),
//        ),
//        Container(width: 5),
//        Expanded(
//            child: DropdownButton<String>(
//              items: _taxTypeEnum.map((dynamic value) {
//                return DropdownMenuItem<String>(
//                  value: value,
//                  child: new Text(value),
//                );
//              }).toList(),
//              onChanged: (value) {
//                taxApiResultBool.clear();
//                taxApiResultMessage.clear();
////                taxApiResultBool=new Map<String, bool>();
////                taxApiResultMessage=new Map<String, String>();
//                setState(() {
//                  _currentTaxSelected = value;
//                  print(_currentTaxSelected);
//                  _onPropertyDropDownItemSelected(value);
//                });
//              },
//            )),
//      ]),
//    );
//  }

  Widget showTaxTypeInput() {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
        child: DropdownButton<String>(
            items: _taxTypeEnum.map((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
            value: _currentTaxSelected,
            onChanged: (String newValueSelected) {
              _onPropertyDropDownItemSelected(newValueSelected);
            })
    );
  }

  Widget showNpwpInput(bool isMandatory) {
    String label=(isMandatory)?'NPWP *':'NPWP';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: npwpController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.business_center,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'NPWP can\'t be empty';
//          } else if (!RegExp(r"^[0-9]*").hasMatch(value.trim())) {
//            return 'NPWP can only be numbers';
//          } else if (value.trim().length!=16) {
//            return 'NPWP digit amount is wrong';
//          }
        },
      ),
    );
  }

  Widget showIncomeInput(bool isMandatory) {
    String label = (isMandatory)?'Income *':'Income';
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: incomeController,
        decoration: new InputDecoration(
            hintText: label,
            icon: new Icon(
              Icons.account_balance_wallet,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Income can\'t be empty';
//          } else if (!RegExp(r"/\d+\.\d*|\.?\d+/").hasMatch(value.trim())) {
//            return 'Income can only be numbers';
//          }
        },
      ),
    );
  }

  Widget showHomeLatitudeLongitudeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(children: <Widget>[
        Expanded(
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            controller: homeLatitudeController,
            decoration: new InputDecoration(
                hintText: 'Home Latitude',
                icon: new Icon(
                  Icons.home,
                  color: Colors.grey,
                )),
            validator: (value) {
//              if (value.isEmpty) {
//                return 'Home Latitude can\'t be empty';
//              } else {
//                if (!RegExp(r"/\d+\.\d*|\.?\d+/").hasMatch(value.trim()))
//                  return 'Home Latitude can only be numbers';
//              }
            },
          ),
        ),
        Container(width: 5),
        Expanded(
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            controller: homeLongitudeController,
            decoration: new InputDecoration(
                hintText: 'Home Longitude',
                icon: new Icon(
                  Icons.home,
                  color: Colors.grey,
                )),
            validator: (value) {
//              if (value.isEmpty) {
//                return 'Home Longitude can\'t be empty';
//              } else {
//                if (!RegExp(r"/\d+\.\d*|\.?\d+/").hasMatch(value))
//                  return 'Home Longitude can only be numbers';
//              }
            },
          ),),
      ]),
    );
  }

  Widget showWorkLatitudeLongitudeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(children: <Widget>[
        Expanded(
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            controller: workLatitudeController,
            decoration: new InputDecoration(
                hintText: 'Work Latitude',
                icon: new Icon(
                  Icons.location_city,
                  color: Colors.grey,
                )),
            validator: (value) {
//              if (value.isEmpty) {
//                return 'Work Latitude can\'t be empty';
//              } else {
//                if (!RegExp(
//                    r"/\d+\.\d*|\.?\d+/")
//                    .hasMatch(value))
//                  return 'Work Latitude can only be numbers';
//              }
            },
          ),
        ),
        Container(width: 5),
        Expanded(
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            controller: workLongitudeController,
            decoration: new InputDecoration(
                hintText: 'Work Longitude',
                icon: new Icon(
                  Icons.location_city,
                  color: Colors.grey,
                )),
            validator: (value) {
//              if (value.isEmpty) {
//                return 'Home Longitude can\'t be empty';
//              } else {
//                if (!RegExp(
//                    r"/\d+\.\d*|\.?\d+/")
//                    .hasMatch(value))
//                  return 'Home Longitude can only be numbers';
//              }
            },
          ),),
      ]),
    );
  }

//  Widget showResponseSideBySide(bool bool1, String message1, bool bool2, String message2){
//
//  }

  Widget showPropertyAreaInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(children: <Widget>[
        Expanded(
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            controller: propertySurfaceAreaController,
            decoration: new InputDecoration(
                hintText: 'Surface Area m\u00B2',
                icon: new Icon(
                  Icons.home,
                  color: Colors.grey,
                )),
            validator: (value) {
//              if (value.isEmpty) {
//                return 'Property Surface Area can\'t be empty';
//              }
//              else if (!RegExp(r"^[0-9]*").hasMatch(value.trim())) {
//                return 'Property Surface Area can only be numbers';
//              }
            },
          ),
        ),
        Container(width: 5),
        Expanded(
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            controller: propertyBuildingAreaController,
            decoration: new InputDecoration(
                hintText: 'Building Area m\u00B2',
                icon: new Icon(
                  Icons.home,
                  color: Colors.grey,
                )),
            validator: (value) {
//              if (value.isEmpty) {
//                return 'Property Building Area can\'t be empty';
//              }
//              else if (!RegExp(r"^[0-9]*").hasMatch(value.trim())) {
//                return 'Property Building Area can only be numbers';
//              }
            },
          ),),
      ]),
    );
  }

  Widget showCertificateIdAndTypeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: Row(children: <Widget>[
        Expanded(
          child: new TextFormField(
            maxLines: 1,
            keyboardType: TextInputType.number,
            autofocus: false,
            controller: certificateIdController,
            decoration: new InputDecoration(
                hintText: 'Certificate ID',
                icon: new Icon(
                  Icons.home,
                  color: Colors.grey,
                )),
            validator: (value) {
//              if (value.isEmpty) {
//                return 'Certificate ID can\'t be empty';
//              }
            },
          ),
        ),
        Container(width: 5),
        Expanded(
            child: DropdownButton<String>(
                items: _propertyTypeEnum.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                value: _currentPropertySelected,
                onChanged: (String newValueSelected) {
                  _onPropertyDropDownItemSelected(newValueSelected);
                })),
      ]),
    );
  }

  Widget showNopInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: nopController,
        decoration: new InputDecoration(
            hintText: 'NOP',
            icon: new Icon(
              Icons.credit_card,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'NOP can\'t be empty';
//          } else if (!RegExp(r"^[0-9]*").hasMatch(value.trim())) {
//            return 'NOP can only be numbers';
//          } else if (value.trim().length!=18) {
//            return 'NOP digit amount is wrong';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showPropertyNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: propertyNameController,
        decoration: new InputDecoration(
            hintText: 'Property Name',
            icon: new Icon(
              Icons.person,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Property Name can\'t be empty';
//          } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
//            return 'Property Name can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Property Name can\'t be empty';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showPropertySurfaceAreaInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: propertySurfaceAreaController,
        decoration: new InputDecoration(
            hintText: 'Property Surface Area',
            icon: new Icon(
              Icons.home,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Property Surface Area can\'t be empty';
//          }
        },
      ),
    );
  }

  Widget showPropertyBuildingAreaInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: propertyBuildingAreaController,
        decoration: new InputDecoration(
            hintText: 'Property Building Area',
            icon: new Icon(
              Icons.home,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Property Building Area can\'t be empty';
//          }
        },
      ),
    );
  }

  Widget showPropertyEstimationInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: propertyEstimationController,
        decoration: new InputDecoration(
            hintText: 'Property Price Estimation',
            icon: new Icon(
              Icons.account_balance_wallet,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Property Estimation can\'t be empty';
//          } else if(!RegExp(r"/\d+\.\d*|\.?\d+/").hasMatch(value)) {
//          return 'Property Estimation can only contains alphabets';
//          } else if (value.trim().length<1) {
//            return 'Property Estimation can\'t be empty';
//          }
        },
      ),
    );
  }

  Widget showCertificateNameInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: certificateNameController,
        decoration: new InputDecoration(
            hintText: 'Certificate Name',
            icon: new Icon(
              Icons.person_outline,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Certificate Name can\'t be empty';
//          } else if (!RegExp(r"[a-zA-Z ]*").hasMatch(value)) {
//            return 'Certificate Name can only contains alphabets';
//          } else if (value.trim().length<1){
//            return 'Certificate Name can\'t be empty';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showCertificateIdInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.number,
        autofocus: false,
        controller: certificateIdController,
        decoration: new InputDecoration(
            hintText: 'Certificate Id',
            icon: new Icon(
              Icons.description,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Certificate Id can\'t be empty';
//          }
        },
//        onSaved: (value) => _email = value.trim(),
//        onChanged: (value) {
//          debugPrint('Something changed in Title Email Field');
//          updateEmailContent();
//        },
      ),
    );
  }

  Widget showCertificateTypeInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.text,
        autofocus: false,
        controller: certificateTypeController,
        decoration: new InputDecoration(
            hintText: 'Certificate Type',
            icon: new Icon(
              Icons.assignment,
              color: Colors.grey,
            )),
        validator: (value) {
//          if (value.isEmpty) {
//            return 'Certificate Type can\'t be empty';
////          } else {
//////            if (value.substring(value.length-14, value.length)!='@myinfosys.net') {
//////              return 'Must input IST email';
//////            }
////            if (!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value))
////              return 'Certificate Type can only be alphabets';
//          }
        },
      ),
    );
  }

  Widget showCertificateDateInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.datetime,
        autofocus: false,
        controller: certificateDateController,
        decoration: new InputDecoration(
            hintText: 'Certificate Date',
            icon: new Icon(
              Icons.calendar_today,
              color: Colors.grey,
            )),
        onTap: () {
          showDatePicker(
            context:this.context,
            initialDate:selectedcertificatedate==null? DateTime.now():selectedcertificatedate,
            firstDate: DateTime(1900),
            lastDate:DateTime.now(),
          ).then((selectedDate){
            selectedcertificatedate=selectedDate;
            certificateDateController.text= DateFormat('dd-MM-yyyy').format(selectedDate).toString();
            //new DateFormat.yMMMd().format(selectedDate);
                ;
          });
        },
        onChanged: (value) {
          debugPrint('Something changed in Certificate Date Text Field');
          //updatebirthdate();
        },
      ),
    );
  }

  Widget showUploadPhotoButton(){
    return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: RaisedButton(
          color: Colors.orange,
          textColor: Colors.white,
          child: Text(
            'Upload Selfie',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            _getImage(this.context, ImageSource.camera);
//        setState(() {
//          debugPrint("Photo button clicked");
//
//        });
          },
        )
    );
  }

  Widget showHomeVerificationButton(){
    return Padding(
        padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
        child: RaisedButton(
          color: Theme.of(this.context).primaryColorDark,
          textColor: Theme.of(this.context).primaryColorLight,
          child: Text(
            'Verify Current Location as Home',
            textScaleFactor: 1.5,
          ),
          onPressed: () {
            homeLocationProcess(this.context);
//        setState(() {
//          debugPrint("Photo button clicked");
//
//        });
          },
        )
    );
  }

  Widget showButtons(String tabName) {
    return Padding(
      padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: RaisedButton(
              color: Theme.of(this.context).primaryColorDark,
              textColor: Theme.of(this.context).primaryColorLight,
              child: Text(
                'Submit',
                textScaleFactor: 1.5,
              ),
              onPressed: () {
                setState(() {
                  debugPrint("Submit button clicked");
                  //_save();
                  if (tabName=='personal')
                    personalProcess(this.context);
                  else if (tabName=='liveness'){
                    livenessProcess(this.context);
//                  } else if (tabName=='location'){
//                    //locationProcess(context);
//                    locationHomeProcess(context);
                  } else if (tabName=='workplace'){
                    workplaceProcess(this.context);
                  } else if (tabName=='tax'){
                    taxProcess(this.context);
                  } else if (tabName=='property'){
                    propertyProcess(this.context);
                  }
                });
              },
            ),
          ),

          Container(width: 5.0,),

          Expanded(
            child: RaisedButton(
                color: Theme.of(this.context).primaryColorDark,
                textColor: Theme.of(this.context).primaryColorLight,
                child: Text(
                  'Reset',
                  textScaleFactor: 1.5,
                ),
                onPressed: () => resetProcess(this.context)
              // onPressed: resetField()
              //onPressed: resetForm
            ),
          ),

        ],
      ),
    );
  }

  Widget showMessageResult2(Map<String, String> currentResultMessageMap) {
    messageResultController.text=currentResultMessageMap['mesageResult'];
    if (messageResultController.text!= null && messageResultController.text!='')
    {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new TextFormField(
          minLines: 1,
          maxLines: 10,
          enabled:false,
          keyboardType: null,
          autofocus: false,
          controller: messageResultController,
          decoration: new InputDecoration(
            //hintText: 'NIK',
              icon: new Icon(
                Icons.assignment,
                color: Colors.grey,
              )),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showMessageResult() {
    messageResultController.text=personalApiResultMessage['mesageResult'];
    if (messageResultController.text!= null && messageResultController.text!='')
    {
      return Padding(
        padding: const EdgeInsets.fromLTRB(0.0, 5.0, 0.0, 0.0),
        child: new TextFormField(
          minLines: 1,
          maxLines: 10,
          enabled:false,
          keyboardType: null,
          autofocus: false,
          controller: messageResultController,
          decoration: new InputDecoration(
            //hintText: 'NIK',
              icon: new Icon(
                Icons.assignment,
                color: Colors.grey,
              )),
        ),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }

  }

  Widget showErrorMessage(String errorToDisplay) {
    if (errorToDisplay!=null) {
      if (errorToDisplay.length > 0) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 5.0, 0.0, 0.0),
            child: new Text(
              errorToDisplay,
              style: TextStyle(
                  fontSize: 13.0,
                  color: Colors.red,
                  height: 1.0,
                  fontWeight: FontWeight.bold),
            ));
      } else { // if errorMessage.length=0
        return new Container(
          height: 0.0,
        );
      }
    } else { // is errorMessage is null
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showNotes(String notes, Color color) {
    if (notes!=null) {
      if (notes.length > 0) {
        return Padding(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 0.0, 0.0),
            child: new Text(
              notes,
              style: TextStyle(
                  fontSize: 13.0,
                  color: color,
                  height: 1.0,
                  fontWeight: FontWeight.bold),
            ));
      } else { // if errorMessage.length=0
        return new Container(
          height: 0.0,
        );
      }
    } else { // is errorMessage is null
      return new Container(
        height: 0.0,
      );
    }
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

  Widget showMessage(BuildContext context) {

    Widget okButton = FlatButton(
      child: Text("Close"),
      onPressed: () {Navigator.of(context).pop(); },
    );

    return AlertDialog(title: Text('Liveness Verification Steps'),
      content:
      Container(
          width:300,
          height:410,
          decoration: BoxDecoration(
              image:DecorationImage(
                  fit:BoxFit.fill,
                  //image:NetworkImage('https://ml7k0yxbfti1.i.optimole.com/ksZOHHk-8dvf3uL_/w:180/h:180/q:auto/https://www.plushplush.sg/wp-content/uploads/2020/08/Mochi-Mochi-Peach-Cat-Daily-Life-.png')
                  image:NetworkImage('https://i.ibb.co/L652k77/Liveness-How-Tos2.jpg')
              )
          )
      ),  actions: [
        okButton,
      ],);
    // return Row(children:<Widget>[
    //   Container(child:Container(
    //     width: 50.0,
    //     height: 50.0,
    // return Dialog(
    //   child: Container(
    //       width:200,
    //       height:200,
    //       decoration: BoxDecoration(
    //           image:DecorationImage(
    //               fit:BoxFit.fill,
    //               image:NetworkImage('https://ml7k0yxbfti1.i.optimole.com/ksZOHHk-8dvf3uL_/w:180/h:180/q:auto/https://www.plushplush.sg/wp-content/uploads/2020/08/Mochi-Mochi-Peach-Cat-Daily-Life-.png')
    //           )
    //       )
    //   ),
    // );
  }


  void _onGestureSetDropDownItemSelected(String newValueSelected){
    setState(() {
      this._currentGestureSelected = newValueSelected;
    });
  }

  void _onPropertyDropDownItemSelected(String newValueSelected) {
    setState(() {
      // assign the current item selected into the new value selected by the user
      this._currentPropertySelected = newValueSelected;
    });
  }

  void _onTaxDropDownItemSelected(String newValueSelected) {
    setState(() {
      // assign the current item selected into the new value selected by the user
      this._currentTaxSelected = newValueSelected;
    });
  }
  // Widget _determineBlankOrNot() {
  //   return loading? _showCircularProgress(): _determineFormToShow();
  // }
  Widget _showCircularProgress() {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  void resetForm() {
    // _currentPropertySelected = _propertyTypeEnum[0];
    // _currentTaxSelected=_taxTypeEnum[0];

    nikController.text='';
    nameController.text='';
    birthdateController.text='';
    birthplaceController.text='';
    addressController.text='';
    mobilePhoneController.text='';
    motherNameController.text='';
    messageResultController.text='';
    companyNameController.text='';
    companyPhoneController.text='';
    homeLatitudeController.text='';
    homeLongitudeController.text='';
    workLatitudeController.text='';
    workLongitudeController.text='';

    npwpController.text='';
    incomeController.text='';

    nopController.text='';
    propertyNameController.text='';
    propertySurfaceAreaController.text='';
    propertyBuildingAreaController.text='';
    propertyEstimationController.text='';
    certificateNameController.text='';
    certificateIdController.text='';
    certificateTypeController.text='';
    certificateDateController.text='';

    _currentPropertySelected = _propertyTypeEnum[1];
    _currentTaxSelected=_taxTypeEnum[1];
    _currentGestureSelected=_gestureSetEnum[0];

    imgPath=null;
    selectedbirthdate=null;
    selectedcertificatedate=null;

    _professionalImage=null;
    resetPreSubmitErrorMessage();
    resetPostSubmitErrorMessages();
  }

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }



  // Widget _determineFormToShow() {
  //   return _isRegisterLoginOption? _showOptionForm(): _showForm();
  // }

  /**
   * UI MINOR ENDS
   */

// Update the title of Note object
  void updateTitle(){
    //note.title = titleController.text;
  }

  /**
   * OTHERS
   */

  void updateNik() {

  }

  // Update the title of Note object
  void updatebirthdate(){
    //note.title = titleController.text;
    birthdateController.text= (selectedbirthdate==null? '':selectedbirthdate.toString());
  }

// Update the description of Note object
  void updateDescription() {
    //note.description = descriptionController.text;
  }
}




