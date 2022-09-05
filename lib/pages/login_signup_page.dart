import 'dart:convert';
import 'dart:io';

import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_apns/apns.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/RDNAProvider/RDNABridge.dart';
import 'package:simple_app/model/faceVerifModel.dart';
import 'package:simple_app/model/user_profile.dart';
import 'package:simple_app/services/authentication.dart';
import 'package:simple_app/utils/database_helper.dart';
import 'package:simple_app/views/home2.dart';
import 'package:sqflite/sqflite.dart';

class LoginSignupPage extends StatefulWidget {
  LoginSignupPage({this.auth, this.loginCallback, this.currentMode});

  final BaseAuth? auth;
  final VoidCallback? loginCallback;
  String? currentMode;

  // to save locally
  //final UserProfile userProfile;

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  final _formKey = new GlobalKey<FormState>();

  String? _email;
  String? _password;
  String? _errorMessage;

  late bool _isLoginForm;
  late bool _isLoading;

  late bool _isRegisterLoginOption;

  final connector = createPushConnector();

  // to save locally
  DatabaseHelper helper = DatabaseHelper();
  UserProfile userProfile =
      new UserProfile('', '', '', '', '', ''); // Step 1. Masukin userProfile
  TextEditingController emailController =
      TextEditingController(); // Step 2. assign controller ke email dan password
  TextEditingController passwordController = TextEditingController();
  List<UserProfile>? userProfileList;

  // Face Recog Login
  File? _imageFileProfile;

  File? _imageFile; // foto selfie waktu registration
  var _reference = FirebaseStorage.instance.ref().child('myimage_login.jpg');
  bool _isPhotoUploaded = false;

  //bool _isFaceRecogLoginInProcess = false;
  late File imageFileProfile2;

  // Firestore
  String? firestoreId;
  final firestoreDb = FirebaseFirestore.instance;
  String? firestoreName;

  // Load semua firestore
  Future<List<QuerySnapshot>>? allFirestoreSnapshots;
  late List<UserProfile> listFirestoreUsers;

  // isFormEmpty
  bool? isAllFieldInTheFormFilled;
  String? title;

  // Check if form is valid before perform login or signup
  bool validateAndSave() {
    final form = _formKey.currentState!;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  // Perform login or signup
  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (isUserCheckValid()) {
      if (validateAndSave()) {
        String userId = "";
        //userProfile.date = DateFormat.yMMMd().format(DateTime.now());
        userProfile.date = DateFormat('yyyyMMddHHmmss').format(DateTime.now());
        //int resultDelete;
        //int resultInsert;
        try {
          if (_isLoginForm) {
            userId = await widget.auth!.signIn(_email, _password) ?? '';
            print('Signed in: $userId');
          } else {
            // Registration Process
            userId = await widget.auth!.signUp(_email, _password) ??
                ''; // 1. illegible registration: auth ok, get userId
            // sign out user from auth (if you dont do this step, the user is auto signed in when opening the app next time)
            await widget.auth!.signOut();
            //await widget.auth.signOut();
            uploadImage(userId); // 2. Upload photo
            var imageBytesFile = _imageFile!
                .readAsBytesSync(); // 3. Convert registration image to base64 (to be saved locally later)
            String base64ImageFile = base64Encode(imageBytesFile);
            userProfile.uid = userId;
            var parts = userProfile.userEmail.split('@');
            userProfile.userDisplayName = parts[0].trim().replaceAll('.', ' ');
            userProfile.selfieString = base64ImageFile;
            // 4. save in UserCRUD Firestore DB
            createFirestoreData(
                userProfile.uid,
                userProfile.userDisplayName,
                userProfile.userEmail,
                userProfile.userPassword,
                userProfile.date);
//            // 4. b. sign out user from auth
//            await widget.auth.signOut();
            // 5. save locally
            Future<Database> dbFuture = helper.initializeDatabase();
            dbFuture.then((database) {
              Future<List<UserProfile>> userProfileListFuture =
                  helper.getUserProfileList();
              userProfileListFuture.then((userProfileList) {
                Future<int> resultDeleteAll = helper.deleteAllUserProfile();
                Future<int> resultInsert2 =
                    helper.insertUserProfile(userProfile);
                if (resultInsert2 != 0) {
                  // success
                  _showAlertDialog('Success!', 'Registration successful!');
                  toggleFormModeRegisterLoginOption();
                } else {
                  _showAlertDialog('Failed', 'Registration failed!');
                }
              });
            });
// 6. save the selfie picture to local
            // copy the file to a new path
            Directory systemTempDir = Directory.systemTemp;
            Future<File> newImage =
                _imageFile!.copy('${systemTempDir.path}/$userId.jpg');

            // 6. add listAllUsers
            listFirestoreUsers.add(userProfile);

            // 7. delete 1st user if users>5
            if (listFirestoreUsers.length > 5) {
              String? uidToDelete = listFirestoreUsers
                  .elementAt(0)
                  .uid; //Directory systemTempDir = Directory.systemTemp;

              // 7.a. delete 1st (earliest) user auth
              await deleteFirstAuthUser(listFirestoreUsers.elementAt(0));

              // 7.b. delete from  firestore cloud
              QuerySnapshot? querySnapshot =
                  await FirebaseFirestore.instance.collection("UserCRUD").get();
              await FirebaseFirestore.instance
                  .collection("UserCRUD")
                  .doc(uidToDelete)
                  .delete();

              // 7.c. delete local image
              File photoToDelete =
                  File('${systemTempDir.path}/$uidToDelete.jpg');

              // 7.d. delete from local
              listFirestoreUsers.removeAt(0);

              // 7.e. delete user's picture
              deleteImage(uidToDelete);
            }

            print('Signed up user: $userId');
          }
          setState(() {
            _isLoading = false;
          });

          if (userId.length > 0 && _isLoginForm) {
            widget.loginCallback!();
          }
        } catch (e) {
          print('Error: $e');
          setState(() {
            _isLoading = false;
            _errorMessage = e.toString();
            //_showAlertDialog('Failed!', e.message);
            //_formKey.currentState.reset();
          });
        }
      }
    }
    setState(() {
      _isLoading = false;
      //_showAlertDialog('Failed!', e.message);
      //_formKey.currentState.reset();
    });
    //_email='';
    //_password='';
  }

  @override
  Future<void> deleteFirstAuthUser(UserProfile userToDelete) async {
    await widget.auth!.signOut();
    String? uidToDelete = await widget.auth!
        .signIn(userToDelete.userEmail, userToDelete.userPassword);
    var user = await widget.auth?.getCurrentUser();
    user!.delete().then((_) {
      print("Succesfull user deleted");
    }).catchError((error) {
      print("user can't be delete" + error.toString());
    });
    return null;
  }

  // #####
  // Face Recog Login
  // #####

  Future getImage() async {
    if (_isRegisterLoginOption) {
      // kalau halaman depan
      //_getThingsOnStartup(); // TODO MAYA: Mestinya load semua foto
      faceRecognitionLogin();
    } else {
      // kalau registration mau upload image
      File? registerSelfieimage;
      //Future<bool> faceMatchFound=Future<bool>.value(false);
      bool faceMatchFound1 = false;
      final picked =
          await (ImagePicker()).pickImage(source: ImageSource.camera);
      registerSelfieimage = File(picked!.path);
      final cropped = await (ImageCropper()).cropImage(
          sourcePath: registerSelfieimage.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 80,
          maxWidth: 300,
          maxHeight: 400,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Colors.blueAccent,
              toolbarTitle: "Adjust Like Passport Photo",
              statusBarColor: Colors.blue,
              backgroundColor: Colors.white,
            ),
          ]);

      registerSelfieimage = File(cropped!.path);
      if (cropped != null) {
        faceMatchFound1 = await checkIfSelfieRegistered(registerSelfieimage);
        if (faceMatchFound1 == true) {
          _showAlertDialog('Face Already Registered!',
              'Same person cannot have two account! Please go to login page to login');
          registerSelfieimage = null;
        } else {
          _imageFile = registerSelfieimage;
          _showAlertDialog('Success!', 'Selfie upload successful!');
        }
      } else {
        _showAlertDialog(
            'Photo upload cancelled', 'Your photo has not been saved');
      }
      _errorMessage = '';

      setState(() {
        _imageFile = registerSelfieimage;
      });
    }
  }

  Future<bool> checkIfSelfieRegistered(File? image1) async {
    setState(() {
      _isLoading = true;
    });
    //Future<bool> faceMatchFound = Future<bool>.value(false);
    bool faceMatchFound1 = false;
    // 1. get number of registered users
    int registeredUsersAmount = listFirestoreUsers.length;
    if (registeredUsersAmount > 0) {
      //int registeredUsersAmount = listFirestoreUsers.length;
      // 2. Loop through all the users in the cloud
      for (int i = 0; i < registeredUsersAmount; i++) {
        //if (faceMatchFound==Future<bool>.value(false)){
        debugPrint('LOOP $i : FACE MATCH FOUND $faceMatchFound1');
        if (!faceMatchFound1) {
          // 2a. Download the image of user[i]
//          StorageReference referenceTemp = FirebaseStorage.instance.ref().child(listFirestoreUsers.elementAt(i).uid+'.jpg');
//          String downloadAddressTemp=await referenceTemp.getDownloadURL();
//          Response downloadDataTemp = await get(downloadAddressTemp);
//          Directory systemTempDir = Directory.systemTemp;
//          File currentDownloadedUserImage = File('${systemTempDir.path}/tmp1.jpg'); // image file dari user[i]
//          if (currentDownloadedUserImafge.existsSync()) {
//            await currentDownloadedUserImage.delete();
//          }
//          await currentDownloadedUserImage.create();
//          StorageFileDownloadTask task = referenceTemp.writeToFile(currentDownloadedUserImage);
          //debugPrint('TASK: '+task.toString());
          String? currentUserUid = listFirestoreUsers.elementAt(i).uid;
          Directory systemTempDir = Directory.systemTemp;
          File currentUserImage =
              File('${systemTempDir.path}/$currentUserUid.jpg');

          // 2b. compare current selfie with the user[i]
          faceMatchFound1 = await compareTwoImages(image1!, currentUserImage);
        }
      }
    }
    setState(() {
      _isLoading = false;
    });
    //return faceMatchFound;
    return faceMatchFound1;
  }

  Future<bool> compareTwoImages(File image1, File image2) async {
    //String dialog = "";
    //debugPrint('--- COMPARE TWO IMAGES START ---');
    try {
      var streamIdCard =
          http.ByteStream(DelegatingStream.typed(image1.openRead()));
      var lengthIdCard = await image1.length();
      var streamProfile =
          http.ByteStream(DelegatingStream.typed(image2.openRead()));
      var lengthProfile = await image2.length();
      var uri = Uri.parse("http://demo.faceid.asia/api/faceid/v2/verify");
      var request = http.MultipartRequest("POST", uri);

      request.fields['apiKey'] = "9TCM5oQ72DlXJK0ukbP6Aa0TM2KKKxlT";
      request.files.add(http.MultipartFile(
          "imageIdCard", streamIdCard, lengthIdCard,
          filename: path.basename(image1.path)));
      request.files.add(http.MultipartFile(
          "imageBest", streamProfile, lengthProfile,
          filename: path.basename(image2.path)));

      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      Map<String, dynamic> listResult = jsonDecode(respStr.toString());
      FaceVerifModel faceVerifResult = FaceVerifModel.fromJson(listResult);

      if (faceVerifResult != null || faceVerifResult.resultIdcard != null) {
//        dialog = "confidence: " +
//            faceVerifResult.resultIdcard.confidence.toString();

        if (faceVerifResult.resultIdcard!.confidence! > 75) {
          //dialog = "Login Successful";
          //return Future<bool>.value(true);
          return true;
          //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          //dialog = "Login Fail";
          //return Future<bool>.value(false);
          return false;
        }
      } else {
        //dialog = "Unexpected Error";
//        return Future<bool>.value(false);
        return false;
      }
    } catch (e) {
      //dialog = "ERROR NO FACE DETECTED";
      debugPrint("Error $e");
      //return Future<bool>.value(false);
      return false; // TODO MAYA: ini mestinya keluarin error message
    }
//    setState(() {
//      _isLoading = false;
//    });
    //createAlertDialog(context, dialog);
  }

//  Future _getThingsOnStartup() async {
//    String downloadAddress=await _reference.getDownloadURL();
//    Response downloadData = await get(downloadAddress);
//    Directory systemTempDir = Directory.systemTemp;
//    imageFileProfile2 = File('${systemTempDir.path}/tmp.jpg');
//    if (imageFileProfile2.existsSync()) {
//      await imageFileProfile2.delete();
//    }
//    await imageFileProfile2.create();
//    StorageFileDownloadTask task = _reference.writeToFile(imageFileProfile2);
//  }

  // ###
  // #  FACE RECOGNITION LOGIN
  // #
  // # 1. Get picture
  // # 2. Compare images
  // #    if false sampai akhir loop, error message not registered pls register
  // #    if true: nomer 3
  // # 3. Log that person in
  // # 4. Direct them to Home
  // #
  // ###
  faceRecognitionLogin() async {
    setState(() {
      //_isFaceRecogLoginInProcess = true;
      _isLoading = true;
    });
    // 1. Get picture
    var picture = await (ImagePicker()).pickImage(source: ImageSource.camera);
    File? loginFaceFile;
    if (picture != null) {
      final cropped = await (ImageCropper()).cropImage(
          sourcePath: picture.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 80,
          maxWidth: 300,
          maxHeight: 400,
          compressFormat: ImageCompressFormat.jpg,
          uiSettings: [
            AndroidUiSettings(
              toolbarColor: Colors.blueAccent,
              toolbarTitle: "Adjust Like Passport Photo",
              statusBarColor: Colors.blue,
              backgroundColor: Colors.white,
            ),
          ]);
      setState(() {
        _imageFile = File(cropped!.path);
        //_isFaceRecogLoginInProcess = false;
        loginFaceFile = File(cropped.path);
        //._isLoading=false;
      });
    } else {
      setState(() {
        //_isFaceRecogLoginInProcess = false;
        _isLoading = false;
      });
    }

    // 2. Compare login face vs all users
    bool faceMatchFound1 = false;
    UserProfile? firestoreUserProfile;
    File currentFirestoreUserFile;
    for (int i = 0; i < listFirestoreUsers.length; i++) {
      if (!faceMatchFound1) {
        String? currentUserUid = listFirestoreUsers.elementAt(i).uid;
        Directory systemTempDir = Directory.systemTemp;
        File currentUserImage =
            File('${systemTempDir.path}/$currentUserUid.jpg');

        // 2b. compare current selfie with the user[i]
        faceMatchFound1 =
            await compareTwoImages(loginFaceFile!, currentUserImage);
        firestoreUserProfile =
            (faceMatchFound1) ? listFirestoreUsers.elementAt(i) : null;
      }
    }

    // comparingImages(context); // di atas itu gantiin ini

    // 3. If faceMatchFound true -> log in this user, if not alert error not found pls register
    switch (faceMatchFound1) {
      case true:
        String? tempUserId = await widget.auth!.signIn(
            firestoreUserProfile!.userEmail, firestoreUserProfile.userPassword);
        print('Signed in: $tempUserId');
        widget.loginCallback!();
        break;
      case false:
        (loginFaceFile == null)
            ? print('')
            : _showAlertDialog("User not found!", "Please register first");
        break;
    }

    setState(() {
      _isLoading = false;
    });
  }

  comparingImages(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });

    String dialog = "";
    final imageBytes = _imageFile!.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    try {
      var streamIdCard =
          http.ByteStream(DelegatingStream.typed(_imageFile!.openRead()));
      var lengthIdCard = await _imageFile!.length();
      var streamProfile =
          http.ByteStream(DelegatingStream.typed(imageFileProfile2.openRead()));
      var lengthProfile = await imageFileProfile2.length();
      var uri = Uri.parse("http://demo.faceid.asia/api/faceid/v2/verify");
      var request = http.MultipartRequest("POST", uri);

      request.fields['apiKey'] = "9TCM5oQ72DlXJK0ukbP6Aa0TM2KKKxlT";
      request.files.add(http.MultipartFile(
          "imageIdCard", streamIdCard, lengthIdCard,
          filename: path.basename(_imageFile!.path)));
      request.files.add(http.MultipartFile(
          "imageBest", streamProfile, lengthProfile,
          filename: path.basename(imageFileProfile2.path)));

      var response = await request.send();
      var respStr = await response.stream.bytesToString();

      Map<String, dynamic> listResult = jsonDecode(respStr.toString());
      FaceVerifModel faceVerifResult = FaceVerifModel.fromJson(listResult);

      if (faceVerifResult != null || faceVerifResult.resultIdcard != null) {
        dialog = "confidence: " +
            faceVerifResult.resultIdcard!.confidence.toString();

        if (faceVerifResult.resultIdcard!.confidence! > 75) {
          dialog = "Login Successful";
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Home()));
        } else {
          dialog = "Login Fail";
        }
      } else {
        dialog = "Unexpected Error";
      }
    } catch (e) {
      dialog = "ERROR NO FACE DETECTED";
      debugPrint("Error $e");
    }
    setState(() {
      _isLoading = false;
    });
    createAlertDialog(context, dialog);
  }

  Future uploadImage(String? uid) async {
    _reference = FirebaseStorage.instance.ref().child('$uid.jpg');
    final uploadTask = _reference.putFile(_imageFile!);
    final taskSnapshot =
        await uploadTask; // so when the upload task is complete we can have a snapshot [Maya note]
    setState(() {
      _isPhotoUploaded = true;
    });
  }

  Future deleteImage(String? uid) async {
    _reference = FirebaseStorage.instance.ref().child('$uid.jpg');
    _reference.delete();
//    StorageUploadTask uploadTask = _reference.putFile(_imageFile);
//    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;// so when the upload task is complete we can have a snapshot [Maya note]
//    setState(() {
//      _isPhotoUploaded = true;
//    });
  }

//  void resetPhotoProperties() {
//    _isPhotoUploaded=false;
//    _imageFile=null;
//  }

  // ###
  // Firestore
  // ###
  void createFirestoreData(String? uid, String displayName, String userEmail,
      String userPassword, String registerDate) async {
    //if (_formKey.currentState.validate()) {

    //DocumentReference ref = await firestoreDb.collection('UserCRUD').add({'uid': '$uid', 'displayName': '$displayName', 'userEmail': '$userEmail', 'userPassword': '$userPassword', 'registerDate': '$registerDate'});
    await firestoreDb.collection('UserCRUD').doc(uid).set({
      'uid': '$uid',
      'displayName': '$displayName',
      'userEmail': '$userEmail',
      'userPassword': '$userPassword',
      'registerDate': '$registerDate'
    });
    setState(() => firestoreId = uid);
    //print(ref.documentID);
    //await firestoreDb.collection('UserCRUD').document(uid).setData({'uid': '$uid', 'displayName': '$displayName', 'userEmail': '$userEmail', 'userPassword': '$userPassword', 'registerDate': '$registerDate'});
    //_formKey.currentState.save();
    //}
  }

  // Update the title of userProfile object
  void updateEmailContent() {
    userProfile.userEmail = emailController.text;
    _email = emailController.text;
  }

  // Update the title of userProfile object
  void updatePasswordContent() {
    userProfile.userPassword = passwordController.text;
    _password = passwordController.text;
  }

  bool isUserCheckValid() {
    if (_email == null) {
      _errorMessage = 'Email can\'t be empty';
      return false;
    }
    if (_email == '') {
      _errorMessage = 'Email can\'t be empty';
      return false;
    }

    if (!RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email!)) {
      _errorMessage = 'Email format invalid';
      return false;
    }

    if (_password == null) {
      _errorMessage = 'Password can\'t be empty';
      return false;
    }
    if (_password == '') {
      _errorMessage = 'Password can\'t be empty';
      return false;
    }

    if (_password!.length < 6) {
      _errorMessage = 'Password can\'t be less than 6 characters';
      return false;
    }

    if (!_isLoginForm) {
      if (_imageFile == null) {
        _errorMessage = 'Please upload Selfie!';
        return false;
      }

      // check if email already registered
      for (int i = 0; i < listFirestoreUsers.length; i++) {
        if (_email == listFirestoreUsers.elementAt(i).userEmail) {
          _errorMessage = 'Email has been registered';
          return false;
        }
      }
    }

    // MAYA: COMMENT THIS ON 20200806
    // check if email already registered
//    for (int i=0; i<listFirestoreUsers.length; i++) {
//      if (_email==listFirestoreUsers.elementAt(i).userEmail) {
//        _errorMessage='Email has been registered';
//        return false;
//      }
//    }

    return true;
  }

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    //_isLoginForm = true;
    downloadAllFirestore();
    switch (widget.currentMode) {
      case 'Login Email':
        _isLoginForm = true;
        _isRegisterLoginOption = false;
        title = 'Login with Email';
        break;
      case 'Register':
        _isLoginForm = false;
        _isRegisterLoginOption = false;
        title = 'Registration';
        break;
      case 'Register Login Option':
        _isLoginForm = false;
        _isRegisterLoginOption = true;
        _imageFile == null;
        title = 'IST Demo';
        break;
      default:
        _isLoginForm = false;
        _isRegisterLoginOption = true;
        break;
    }
    super.initState();

    connector.configure(
      onLaunch: (data) => onPush('onLaunch', data as Map<String, dynamic>),
      onResume: (data) => onPush('onResume', data as Map<String, dynamic>),
      onMessage: (data) => onPush('onMessage', data as Map<String, dynamic>),
      onBackgroundMessage: _onBackgroundMessage,
    );
    connector.token.addListener(() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('Token_id', connector.token.value!);
      RDNABridge.getInstance(null)!.setDeviceToken(connector.token.value!);
      print('Token ${connector.token.value}');
    });
    connector.requestNotificationPermissions();
    print("init");
  }

  Future downloadAllFirestore() async {
    setState(() {
      _isLoading = true;
    });
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("UserCRUD").get();
    UserProfile tempUserProfile;
    listFirestoreUsers = [];
    for (int i = 0; i < querySnapshot.docs.length; i++) {
      var a = querySnapshot.docs[i];
      final tempMap = a.data() as Map<String, dynamic>;
      String tempUid = a.id;
      String? tempUserEmail = tempMap['userEmail'];
      String? tempUserPassword = tempMap['userPassword'];
      String? tempDisplayName = tempMap['displayName'];
      String? tempRegisterDate = tempMap['registerDate'];
      //print(a.documentID);
      tempUserProfile = new UserProfile.withId(i, tempUid, tempDisplayName,
          tempUserEmail, tempUserPassword, tempRegisterDate);

      // download the user's photo
      // 2. Download the image of user[i]
      final referenceTemp =
          FirebaseStorage.instance.ref().child(tempUid + '.jpg');
      String downloadAddressTemp = await referenceTemp.getDownloadURL();
      Response downloadDataTemp = await get(downloadAddressTemp as Uri);
      Directory systemTempDir = Directory.systemTemp;
      File currentDownloadedUserImage =
          File('${systemTempDir.path}/$tempUid.jpg'); // image file dari user[i]
      if (currentDownloadedUserImage.existsSync()) {
        await currentDownloadedUserImage.delete();
      }
      await currentDownloadedUserImage.create();
      final task = referenceTemp.writeToFile(currentDownloadedUserImage);

      listFirestoreUsers.add(tempUserProfile);
    }
    listFirestoreUsers.sort((a, b) => a.date.compareTo(b.date));

    setState(() {
      _isLoading = false;
    });
  }

  void resetForm() {
    _formKey.currentState!.reset();
    _errorMessage = "";
  }

  void toggleFormMode() {
    resetForm();
    setState(() {
      _isLoginForm = !_isLoginForm;
    });
  }

  void toggleFormModeEmailLogin() {
    _imageFile = null;
    _email = null;
    _password = null;
    setState(() {
      _isLoginForm = true;
      _isRegisterLoginOption = false;
      widget.currentMode = 'Login Email';
    });
  }

  toggleFormModeRegisterLoginOption() {
    emailController.text = '';
    passwordController.text = '';
    _errorMessage = '';
    _imageFile = null;
    _email = null;
    _password = null;
    setState(() {
      _isLoginForm = false;
      _isRegisterLoginOption = true;
      widget.currentMode = 'Register Login Option';
    });
  }

  void toggleFormModeRegister() {
    _imageFile = null;
    _email = null;
    _password = null;
    emailController.text = '';
    passwordController.text = '';
    setState(() {
      _isLoginForm = false;
      _isRegisterLoginOption = false;
      widget.currentMode = 'Register';
    });
  }

  @override
  Widget build(BuildContext context) {
    //emailController.text='';
    //passwordController.text='';
    return new WillPopScope(
        onWillPop: _onWillPop,
        child: new Scaffold(
            appBar: new AppBar(
              title: new Text('IST Demo'),
            ),
            body: Stack(
              children: <Widget>[
                _determineBlankOrNot(),
                //_isRegisterLoginOption? _showOptionForm(): _showForm(),
                //_showCircularProgress(),
              ],
            )));
  }

  Widget _determineBlankOrNot() {
    return _isLoading ? _showCircularProgress() : _determineFormToShow();
  }

  Widget _determineFormToShow() {
    return _isRegisterLoginOption ? _showOptionForm() : _showForm();
  }

  Future<bool> _onWillPop() async {
    return (await (showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text((_isRegisterLoginOption)
                ? 'Do you want to exit IST Demo?'
                : 'Do you want to leave this page?'),
            actions: <Widget>[
              new TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: new Text('No'),
              ),
              new TextButton(
                onPressed: () {
                  if (widget.currentMode == 'Register Login Option') {
                    Navigator.of(context).pop(true);
                  } else {
                    //Navigator.of(context).pop(true);
                    widget.currentMode = 'Register Login Option';
                    _isRegisterLoginOption = true;
                    toggleFormModeRegisterLoginOption();
                    Navigator.of(context).pop(false);
                  }
                },
                child: new Text('Yes'),
              ),
            ],
          ),
        ))) ??
        false;
  }

  Widget _showCircularProgress() {
    if (_isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

//  void _showVerifyEmailSentDialog() {
//    showDialog(
//      context: context,
//      builder: (BuildContext context) {
//        // return object of type Dialog
//        return AlertDialog(
//          title: new Text("Verify your account"),
//          content:
//              new Text("Link to verify account has been sent to your email"),
//          actions: <Widget>[
//            new TextButton(onPressed: onPressed, child: child)(
//              child: new Text("Dismiss"),
//              onPressed: () {
//                toggleFormMode();
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

  Widget _showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: _formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              _isLoginForm ? Container() : showUploadSelfieButton(),
              _isLoginForm ? Container() : showSelfieUploadedInfo(),
              showPrimaryButton(),
              //showSecondaryButton(),
              showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showSelfieUploadedInfo() {
    if (_imageFile != null) {
      return new Padding(
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
          child: new Center(
              child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const <Widget>[
              Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 24.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text(
                'Your selfie successfully uploaded',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.green,
                    height: 1.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          )));
    } else {
      return new Padding(
          padding: EdgeInsets.fromLTRB(15.0, 5.0, 0.0, 0.0),
          child: new Center(
              child: Row(
            //mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const <Widget>[
              Icon(
                Icons.info,
                color: Colors.lightBlue,
                size: 20.0,
                semanticLabel: 'Text to announce in accessibility modes',
              ),
              Text(
                ' Must upload unregistered pass photo',
                style: TextStyle(
                    fontSize: 14.0,
                    color: Colors.lightBlue,
                    height: 1.0,
                    fontWeight: FontWeight.bold),
              )
            ],
          )));
    }
  }

  Widget _showOptionForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showLogo(),
//              showEmailInput(),
//              showPasswordInput(),
              showLoginWithFaceRecognitionButton(),
              showLoginWithEmailButton(),
              showRegistrationButton(),
              //showErrorMessage(),
            ],
          ),
        ));
  }

  Widget showLoginWithFaceRecognitionButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 70.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.blue,
            ),
            child: new Text('Login with Face Recognition',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed: getImage,
          ),
        ));
  }

  Widget showUploadSelfieButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.blue,
            ),
            child: new Text('Login with Face Recognition',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            //onPressed: () { navigateToPage('Login Face');}
            onPressed: getImage,
          ),
        ));
  }

  Widget showLoginWithEmailButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 45.0, 10.0, 25.0),
        child: SizedBox(
          height: 40.0,
          child: new ElevatedButton(
              style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0),
                ),
                backgroundColor: Colors.blue,
              ),
              child: new Text('Login with Email',
                  style: new TextStyle(fontSize: 20.0, color: Colors.white)),
              //onPressed: () { navigateToPage('Login Email');},
              onPressed: () {
                widget.currentMode = 'Login Email';
                _isRegisterLoginOption = false;
                toggleFormModeEmailLogin();
              }),
        ));
  }

  Widget showRegistrationButton() {
    return new TextButton(
      child: new Text('Sign up',
          style: new TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.w300,
            decoration: TextDecoration.underline,
          )),
      //onPressed: () { navigateToPage('Register');},
      onPressed: toggleFormModeRegister,
    );
  }

  Widget showErrorMessage() {
    if (_errorMessage!.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage!,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 70.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('images/logoist.jpg'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 100.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        controller: emailController,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Email can\'t be empty';
          } else {
//            if (value.substring(value.length-14, value.length)!='@myinfosys.net') {
//              return 'Must input IST email';
//            }
            if (!RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value)) return 'Email format invalid';
          }
          return null;
        },
        onSaved: (value) => _email = value!.trim(),
        onChanged: (value) {
          debugPrint('Something changed in Title Email Field');
          updateEmailContent();
        },
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        controller: passwordController,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Password can\'t be empty';
          }
          if (value.length < 6) {
            return 'Password must be 6 characters or more';
          } else {
            null;
          }
          return null;
        },
        onSaved: (value) => _password = value!.trim(),
        onChanged: (value) {
          debugPrint('Something changed in Password Field');
          updatePasswordContent();
        },
      ),
    );
  }

  Widget showSecondaryButton() {
    return new TextButton(
        child: new Text(
            _isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(10.0, 15.0, 10.0, 20.0),
        child: SizedBox(
          height: 40.0,
          child: new ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0),
              ),
              backgroundColor: Colors.blue,
            ),
            child: new Text(_isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: validateAndSubmit,
          ),
        ));
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  createAlertDialog(BuildContext context, String message) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(title: Text(message));
        });
  }
}

Future<dynamic> onPush(String name, Map<String, dynamic> data) {
  //storage.append('$name: $data');
  RDNABridge rdnaBridge = RDNABridge.getInstance(null)!;
  if (rdnaBridge.RdnaSession!.sessionType == 1) {
    rdnaBridge.getNotificationAPI();
  }
  return Future.value();
}

Future<dynamic> _onBackgroundMessage(RemoteMessage data) =>
    onPush('onBackgroundMessage', data.data);
