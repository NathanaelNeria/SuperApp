// import 'package:rdna_client/rdna_client.dart'; TODO:(wandy) uncomment when solved
// import 'package:rdna_client/rdna_struct.dart';

class RDNABridge {
//   static RDNABridge? instance;
//   String? userName;
//   late BuildContext context;
//   RdnaClient rdna = new RdnaClient();
//   final EventEmitter eventEmitter = new EventEmitter();
//   final log = getLogger("RDNABridge");
//   RDNASession? RdnaSession = RDNASession();
//
// //Singleton object creation
//   static RDNABridge? getInstance(context) {
//     if (instance == null) {
//       instance = new RDNABridge();
//     }
//     return instance;
//   }
//
// //Callbacks registration frm constructor
//   RDNABridge() {
//     this.registerSdkCalback();
//   }
//
// //Method to set a build context
//   setContext(context) {
//     this.context = context;
//   }
//
// //Method to register all the RDNA callbacks
//   registerSdkCalback() {
//     rdna.on(RdnaClient.EVENT_ON_INITIALIZED, onInitialized);
//     rdna.on(RdnaClient.EVENT_ON_INITIALIZED_ERROR, onInitializedError);
//     rdna.on(RdnaClient.EVENT_GET_USER, getUser);
//     rdna.on(RdnaClient.EVENT_GET_ACTIVATION_CODE, getActivationCode);
//     rdna.on(RdnaClient.EVENT_GET_PASSWORD, getPassword);
//     rdna.on(RdnaClient.EVENT_ADD_NEW_DEVICE_OPTION, addNewDeviceOptions);
//     rdna.on(RdnaClient.EVENT_GET_ACCESS_CODE, getAccessCode);
//
//     rdna.on(RdnaClient.EVENT_ON_GET_NOTIFICATION, onGetNotifications);
//     rdna.on(RdnaClient.EVENT_ON_UPDATE_NOTIFICATION, onUpdateNotification);
//     rdna.on(RdnaClient.EVENT_ON_GET_REGISTERED_DEVICE_DETAILS,
//         onGetRegistredDeviceDetails);
//     rdna.on(RdnaClient.EVENT_ON_UPDATE_DEVICE_DETAILS, onUpdateDeviceDetails);
//     rdna.on(RdnaClient.EVENT_ON_HTTP_RESPONSE, onHttpResponse);
//     rdna.on(RdnaClient.EVENT_ON_USER_LOGGED_IN, onUserLoggedIn);
//     rdna.on(RdnaClient.EVENT_ON_USER_CONSENT_THREATS, onUserConsentThreats);
//     rdna.on(RdnaClient.EVENT_ON_TERMINATE_WITH_THREATS, onTerminateWithThreats);
//     rdna.on(RdnaClient.EVENT_ON_USER_LOG_OFF, onUserLoggedOff);
//     rdna.on(RdnaClient.EVENT_ON_CREDENTIALS_AVAILABLE_FOR_UPDATE,
//         onCredentialsAvailableForUpdate);
//     rdna.on(RdnaClient.EVENT_ON_UPDATE_CREDENTIAL_RESPONSE,
//         onUpdateCredentialResponse);
//     rdna.on(RdnaClient.EVENT_ON_GET_NOTIFICATION_HISTORY,
//         onGetNotificationsHistory);
//
//     rdna.on(RdnaClient.EVENT_ON_SELECT_SECRET_QUESTION_ANSWER,
//         onSelectSecretQuestionAnswer);
//     rdna.on(RdnaClient.EVENT_GET_SECRET_ANSWER, getSecretAnswer);
//     rdna.on(
//         RdnaClient.EVENT_ON_HANDLE_CUSTOM_CHALLENGE, onHandleCustomChallenge);
//     rdna.on(RdnaClient.EVENT_GET_DEVICE_NAME, getDeviceName);
//      rdna.on(RdnaClient.EVENT_GET_LOGIN_ID, getLoginID);
//     rdna.on(
//         RdnaClient.EVENT_ON_LOGIN_ID_UPDATE_STATUS, onLoginIdUpdateStatus);
//     rdna.on(
//         RdnaClient.EVENT_ON_FORGOT_LOGIN_ID_STATUS, onForgotLoginIDStatus);
//     rdna.on(RdnaClient.EVENT_ON_SESSION_TIMEOUT, onSessionTimeout);
//   }
//
//   //RDNA Initialize Call
//   initializeAPI(String agentInfo, String host, int port) async {
//     log.log(Level.debug, "initializeAPI", null, null);
//     RDNASyncResponse resp = await rdna.initialize(
//         agentInfo,
//         host,
//         port,
//         'AES/256/CFB/PKCS7Padding',
//         'com.uniken.rdna',
//         null,
//         null,
//         RDNALoggingLevel.RDNA_NO_LOGS);
//     checkSyncError(resp.error);
//   }
//
//   //RDNA Reset authentication call
//   resetAuthenticationAPI() {
//     log.log(Level.debug, "resetAuthenticationAPI", null, null);
//     rdna.resetAuthState();
//   }
//
//   //RDNA set user Call
//   setUserAPI(String userId) async {
//     log.log(Level.debug, "setUserAPI userId - " + userId, null, null);
//     RDNASyncResponse resp = await rdna.setUser(userId);
//     checkSyncError(resp.error);
//     setLocalData('userId', userId);
//   }
//
//   //RDNA set activation
//   setActivationAPI(String activationCode) async {
//     log.log(Level.debug, "setActivationAPI activationCode - " + activationCode,
//         null, null);
//     RDNASyncResponse resp = await rdna.setActivationCode(activationCode);
//     checkSyncError(resp.error);
//   }
//
//   //RDNA set access code
//   setAccessCodeAPI(String accessCode) async {
//     log.log(
//         Level.debug, "setAccessCodeAPI accessCode - " + accessCode, null, null);
//     RDNASyncResponse resp = await rdna.setAccessCode(accessCode);
//     checkSyncError(resp.error);
//   }
//
//   //RDNA set password
//   setPasswordAPI(String password, RDNAChallengeOpMode mode) async {
//     log.log(
//         Level.debug, "setPasswordAPI mode - " + mode.toString(), null, null);
//     late RDNASyncResponse resp;
//     switch (mode.index) {
//       case 0:
//         resp = await rdna.setPassword(
//             password, RDNAChallengeOpMode.RDNA_CHALLENGE_OP_VERIFY);
//         break;
//       case 1:
//         resp = await rdna.setPassword(
//             password, RDNAChallengeOpMode.RDNA_CHALLENGE_OP_SET);
//         break;
//       case 2:
//         // resp = await rdna.updatePassword(currentPassword, newPassword, mode) pranav
//         break;
//       default:
//         log.log(
//             Level.debug,
//             "(default case) setPasswordAPI mode - " + mode.toString(),
//             null,
//             null);
//     }
//     checkSyncError(resp.error);
//   }
//
//   //RDNA get notification call
//   getNotificationAPI() async {
//     log.log(Level.debug, "getNotificationAPI", null, null);
//     RDNASyncResponse resp = await rdna.getNotifications(0, '', 1, "", "");
//     checkSyncError(resp.error);
//     // print(resp);
//   }
//
//   //RDNA get notification history call
//   getNotificationHistoryAPI() async {
//     log.log(Level.debug, "getNotificationHistoryAPI", null, null);
//     RDNASyncResponse resp =
//         await rdna.getNotificationHistory(10, '', 1, '', '', '', '', '', '');
//     checkSyncError(resp.error);
//   }
//
//   //RDNA update notification call
//   updateNotificationAPI(String notificationID, String action) async {
//     log.log(
//         Level.debug,
//         "updateNotificationAPI - notificationID - " +
//             notificationID +
//             "- action -" +
//             action,
//         null,
//         null);
//     RDNASyncResponse resp =
//         await rdna.updateNotification(notificationID, action);
//     checkSyncError(resp.error);
//   }
//
//   void setDeviceToken(String deviceToken) async {
//     RDNASyncResponse res = await rdna.setDeviceToken(deviceToken);
//     log.log(Level.debug,"setDeviceToken--->" + json.encode(res.toJson()),null,null);
//   }
//
//   //RDNA get connected devices call
//   getConnectedDevicesAPI(String userid) async {
//     log.log(
//         Level.debug, "getConnectedDevicesAPI - userid - " + userid, null, null);
//     RDNASyncResponse resp = await rdna.getRegisteredDeviceDetails(userid);
//     checkSyncError(resp.error);
//   }
//
//   //RDNA update device details call
//   updateDeviceDetailsAPI(String userid, String devicesJson) async {
//     log.log(
//         Level.debug,
//         "updateDeviceDetailsAPI - userid - " +
//             userid +
//             "- updatedDeviceDetails -" +
//             devicesJson,
//         null,
//         null);
//     RDNASyncResponse resp = await rdna.updateDeviceDetails(userid, devicesJson);
//     checkSyncError(resp.error);
//   }
//
//   //RDNA logout user call
//   logOutUserAPI(String userid) async {
//     log.log(Level.debug, "logOutUserAPI - userid - " + userid, null, null);
//     RDNASyncResponse resp = await rdna.logOff(userid);
//     checkSyncError(resp.error);
//   }
//
//   //RDNA open http connection call
//   openHttpConnectionAPI(RDNAHttpMethods httpMethod, String url, Map<String,dynamic> headers, String body) async {
//     log.log(
//         Level.debug,
//         "openHttpConnectionAPI - httpMethod - " +
//             httpMethod.toString() +
//             "- url -" +
//             url +
//             "- headers -" +
//             headers.toString() +
//             "- body -" +
//             body,
//         null,
//         null);
//         RDNAHTTPRequest request = new RDNAHTTPRequest();
//         request.method =httpMethod;
//         request.body = body;
//         request.url = url;
//         request.headers = headers;
//     RDNASyncResponse resp =
//         await rdna.openHttpConnection( request);
//     checkSyncError(resp.error);
//   }
//
//   //RDNA get all challenges call
//   getAllChallengesAPI(String userid) async {
//     log.log(Level.debug, " getAllChallengesAPI:  " + userid, null, null);
//     RDNASyncResponse resp = await rdna.getAllChallenges(userid);
//     return resp;
//   }
//
//   //RDNA initiate update call
//   initiateUpdateAPI(String updateCrediential) async {
//     log.log(Level.debug, " initiateUpdateAPI " + updateCrediential, null, null);
//     RDNASyncResponse resp =
//         await rdna.initiateUpdateFlowForCredential(updateCrediential);
//     return resp;
//   }
//
//   //====================================> RDNA Callback Events <=======================================
//
//   //RDNA get user callback
//   getUser(RDNAGetUser res) {
//     RdnaSession = res.challengeResponse!.session;
//     log.log(Level.debug, "getUser - " + getEncodedValue(res), null, null);
//     setLocalData('userId', res.recentLoggedInUser);
//     var errorcode = res.error!.shortErrorCode;
//     var errorText = res.error!.errorString! +
//         "(Long error code: " +
//         res.error!.longErrorCode.toString() +
//         ")";
//     var cResErrorcode = res.challengeResponse!.status!.statusCode;
//     if (errorcode == 0) {
//       if (cResErrorcode == 100) {
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => VerifyUsername(res)));
//       } else {
//         showAlertMessageDialog(
//             this.context,
//             res.challengeResponse!.status!.statusMessage,
//             (value) => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => VerifyUsername(res))));
//       }
//     } else
//       showAlertMessageDialog(
//           this.context,
//           errorText,
//           (value) => Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(
//                   builder: (BuildContext context) => VerifyUsername(res))));
//   }
//
//   //RDNA onSessionTimeout callback
//   onSessionTimeout(String response) {
//     log.log(Level.debug, "response--->" + response, null, null);
//     // rdnaSessionInfo.sessionType = 0;
//     showAlertMessageDialog(
//         this.context,
//         response,
//             (value) => Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => HomeScreen())));
//   }
//
//   //RDNA onInitializedError callback
//   onInitializedError(RDNAInitializeError res) {
//     RdnaSession!.sessionType = 0;
//     log.log(Level.debug, "onInitializedError - " + getEncodedValue(res), null,
//         null);
//     showAlertMessageDialog(this.context, res.errorString, null);
//   }
//
//   //RDNA onInitialized callback
//   onInitialized(RDNAInitialized res) {
//     log.log(Level.debug, "onInitialized - " + getEncodedValue(res), null, null);
//   }
//
//   //RDNA onUserConsentThreats callback
//   onUserConsentThreats(List<RDNAThreat> threatList) async {
//     log.log(Level.debug,
//         "onUserConsentThreats - " + getEncodedValue(threatList), null, null);
//
//     for (int i = 0; i < threatList.length; i++) {
//       threatList[i].shouldProceedWithThreats = true;
//     }
//     RDNASyncResponse resp = await rdna.takeActionOnThreats(threatList);
//     checkSyncError(resp.error);
//   }
//
//   //RDNA onTerminateWithThreats callback
//   onTerminateWithThreats(List<RDNAThreat> threatList) {
//     log.log(Level.debug,
//         "onTerminateWithThreats - " + getEncodedValue(threatList), null, null);
//   }
//
//   //RDNA performVerifyAuthCall
//   performVerifyAuthCall(shouldPerform) async {
//     log.log(
//         Level.debug,
//         "performVerifyAuthCall - " + getEncodedValue(shouldPerform),
//         null,
//         null);
//     RDNASyncResponse resp = await rdna.performVerifyAuth(shouldPerform);
//     // print(resp);
//     return resp;
//   }
//
//   //RDNA addNewDeviceOptions callback
//   addNewDeviceOptions(RDNAAddNewDeviceOptions res) {
//     log.log(Level.debug, "addNewDeviceOptions - " + getEncodedValue(res), null,
//         null);
//     Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//             builder: (BuildContext context) => VerifyAuthentication(res)));
//   }
//
//   //RDNA getActivationCode callback
//   getActivationCode(RDNAActivationCode res) {
//     log.log(
//         Level.debug, "getActivationCode - " + getEncodedValue(res), null, null);
//     var errorcode = res.error!.shortErrorCode;
//     var errorText = res.error!.errorString! +
//         "(Long error code: " +
//         res.error!.longErrorCode.toString() +
//         ")";
//
//     var attemptsCount = res.attemptsLeft;
//     var verificationKey = res.verificationKey;
//     var challengeResErrorcode = res.challengeResponse!.status!.statusCode;
//     if (errorcode == 0) {
//       if (challengeResErrorcode == 100) {
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => ActivationCode(
//                     attemptsCount: attemptsCount,
//                     verificationKey: verificationKey)));
//       } else {
//         showAlertMessageDialog(
//             this.context,
//             res.challengeResponse!.status!.statusMessage,
//             (value) => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => ActivationCode(
//                         attemptsCount: attemptsCount,
//                         verificationKey: verificationKey))));
//       }
//     } else {
//       showAlertMessageDialog(
//           this.context, res.challengeResponse!.status!.statusMessage, null);
//     }
//   }
//
//   //RDNA onUserLoggedIn callback
//   onUserLoggedIn(RDNAUserLoggedIn res) {
//     RdnaSession = res.challengeResponse!.session;
//     log.log(
//         Level.debug, "onUserLoggedIn - " + getEncodedValue(res), null, null);
//     userName = res.userId;
//     Navigator.pushReplacement(context,
//         MaterialPageRoute(builder: (BuildContext context) => Dashboard()));
//   }
//
//   //RDNA getPassword callback
//   getPassword(RDNAGetPassword res) {
//     RdnaSession = res.challengeResponse!.session;
//     log.log(Level.debug, "getPassword - " + getEncodedValue(res), null, null);
//     var errorcode = res.error!.shortErrorCode;
//     RDNAChallengeOpMode challengeMode = RDNAChallengeOpMode.values[res.challengeMode!];
//     var attemptsCount = res.attemptsLeft;
//     userName = res.userId;
//     var challengeResErrorcode = res.challengeResponse!.status!.statusCode;
//     if (errorcode == 0) {
//       if (challengeResErrorcode == 100) {
//         switch (challengeMode.index) {
//           case 0:
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => VerifyLoginPassword(
//                         challengeMode: challengeMode,
//                         attemptsCount: attemptsCount)));
//             break;
//           case 1:
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) =>
//                         VerifyPassword(challengeMode: challengeMode)));
//             break;
//           case 2:
//             log.log(Level.debug, "getPassword Case 2:", null, null);
//             Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) =>
//                         UpdatePassword(challengeMode, null)));
//             break;
//
//           default:
//             log.log(Level.debug, "getPassword default:", null, null);
//         }
//       } else {
//         showAlertMessageDialog(
//             this.context,
//             res.challengeResponse!.status!.statusMessage,
//             (value) =>
//                 // Get.to(VerifyLoginPassword(challengeMode: challengeMode)));
//                 Navigator.pushReplacement(
//                     context,
//                     MaterialPageRoute(
//                         builder: (BuildContext context) => VerifyLoginPassword(
//                             challengeMode: challengeMode))));
//       }
//     } else
//       showAlertMessageDialog(
//           this.context, res.challengeResponse!.status!.statusMessage, null);
//   }
//
//   //RDNA getAccessCode callback
//   getAccessCode(RDNAGetAccessCode res) {
//     log.log(Level.debug, "getAccessCode - " + getEncodedValue(res), null, null);
//     var errorcode = res.error!.shortErrorCode;
//     var attemptsCount = res.attemptsLeft;
//     var verificationKey = res.verificationKey;
//     var challengeResErrorcode = res.challengeResponse!.status!.statusCode;
//     userName = res.userId;
//     if (errorcode == 0) {
//       if (challengeResErrorcode == 100) {
//         Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(
//                 builder: (BuildContext context) => AccessCode(
//                     attemptsCount: attemptsCount,
//                     verificationKey: verificationKey)));
//       } else {
//         showAlertMessageDialog(
//             this.context,
//             res.challengeResponse!.status!.statusMessage,
//             (value) => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => AccessCode(
//                         attemptsCount: attemptsCount,
//                         verificationKey: verificationKey))));
//       }
//     } else
//       showAlertMessageDialog(
//           this.context, res.challengeResponse!.status!.statusMessage, null);
//   }
//
//   //RDNA onGetNotification callback
//   onGetNotifications(RDNAStatusGetNotifications res) {
//     log.log(Level.debug, "onGetNotifications - " + getEncodedValue(res), null,
//         null);
//     eventEmitter.emit('notifications', null, res);
//   }
//
//   //RDNA oGetNotificationHistory callback
//   onGetNotificationsHistory(RDNAStatusGetNotificationHistory res) {
//     log.log(Level.debug, "onGetNotificationsHistory - " + getEncodedValue(res),
//         null, null);
//     eventEmitter.emit('notificationHistory', null, res);
//   }
//
//   //RDNA onUpdateNotofication callback
//   onUpdateNotification(res) {
//     log.log(Level.debug, "onUpdateNotification - " + getEncodedValue(res), null,
//         null);
//     getNotificationAPI();
//   }
//
//   //RDNA onGetRegistredDeviceDetails callback
//   onGetRegistredDeviceDetails(RDNAStatusGetRegisteredDeviceDetails res) {
//     log.log(Level.debug,
//         "onGetRegistredDeviceDetails - " + getEncodedValue(res), null, null);
//     eventEmitter.emit('connectedDevices', null, res);
//   }
//
//   //RDNA onUpdateDeviceDetails callback
//   onUpdateDeviceDetails(RDNAStatusUpdateDeviceDetails res) {
//     log.log(Level.debug, "onUpdateDeviceDetails - " + getEncodedValue(res),
//         null, null);
//     eventEmitter.emit('onUpdateDeviceDetails', null, res);
//   }
//
//   //RDNA onHttpResponse callback
//   onHttpResponse(RDNAHTTPStatus res) {
//     log.log(
//         Level.debug, "onHttpResponse - " + getEncodedValue(res), null, null);
//     if(res.error!.shortErrorCode == 0)    {
//     if (res.httpResponse!.statusCode == 200) {
//       eventEmitter.emit('onHttpSuccess', null, res);
//     }}else{
//       checkSyncError(res.error);
//     }
//   }
//
//   //RDNA onUserLoggedOff callback
//   onUserLoggedOff(RDNAUserLogOff res) {
//     RdnaSession = res.challengeResponse!.session;
//     log.log(
//         Level.debug, "onUserLoggedOff - " + getEncodedValue(res), null, null);
//     checkSyncError(res.error);
//   }
//
//   onCredentialsAvailableForUpdate(RDNACredentialsAvailableForUpdate res) {
//     log.log(
//         Level.debug,
//         "onCredentialsAvailableForUpdate - " + getEncodedValue(res),
//         null,
//         null);
//     var success = checkSyncError(res.error);
//     if (success)
//       eventEmitter.emit('creadientialsAvailable', null, res.options![0]);
//   }
//
//   onUpdateCredentialResponse(RDNAUpdateCredentialResponse res) {
//     log.log(Level.debug, "onUpdateCredentialResponse - " + getEncodedValue(res),
//         null, null);
//     var success = checkSyncError(res.error);
//
//   }
//
//     void getSecretAnswer(RDNAGetSecretAnswer res) async {
//       log.log(Level.debug,"getSecretAnswer--->" + json.encode(res.toJson()),null,null);
//
//     if (res.error!.shortErrorCode == 0 &&
//         res.challengeResponse!.status!.statusCode == 100) {
//       List<RDNASecretQuestionAndAnswer> questionList = <RDNASecretQuestionAndAnswer>[];
//       res.secretQuestionAnswer!.secretAnswer = 'answer';
//       questionList.add(res.secretQuestionAnswer!);
//       RDNASyncResponse syncResponse = await rdna.setSecretQuestionAnswer(
//           questionList, RDNAChallengeOpMode.RDNA_CHALLENGE_OP_VERIFY);
//     } else if (res.challengeResponse!.status!.statusCode != 100) {
//           showAlertMessageDialog(
//             this.context,
//             res.challengeResponse!.status!.statusMessage,
//             (value) => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => this.resetAuthenticationAPI() )));
//     } else {
//      checkSyncError(res.error);
//     }
//   }
//
//   Future<void> onSelectSecretQuestionAnswer(
//       RDNASelectSecretQuestionAnswer res) async {
//
//       log.log(Level.debug,"onSelectSecretQuestionAnswer--->" + json.encode(res.toJson()),null,null);
//
//
//     if (res.error!.shortErrorCode == 0 &&
//         res.challengeResponse!.status!.statusCode == 100) {
//       List<RDNASecretQuestionAndAnswer> questionList =<RDNASecretQuestionAndAnswer>[];
//       List<String> questionGroup = res.questionsToSet![0];
//       questionList.add(RDNASecretQuestionAndAnswer(questionGroup[0], 'answer'));
//
//       RDNASyncResponse syncResponse = await rdna.setSecretQuestionAnswer(
//           questionList, RDNAChallengeOpMode.RDNA_CHALLENGE_OP_SET);
//
//     } else if (res.challengeResponse!.status!.statusCode != 100) {
//        showAlertMessageDialog(
//             this.context,
//             res.challengeResponse!.status!.statusMessage,
//             (value) => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => this.resetAuthenticationAPI() )));
//     } else {
//       checkSyncError(res.error);
//     }
//   }
//
//   onHandleCustomChallenge(RDNAHandleCustomChallenge res) async {
//    log.log(Level.debug,"onHandleCustomChallenge--->" + json.encode(res.toJson()),null,null);
//     if (res.error!.shortErrorCode == 0 &&
//         res.status!.statusCode == 100) {
//       Map<String, dynamic> chlngJsonObj = json.decode(res.challenge!);
//       chlngJsonObj['chlng_resp'][0]['response'] = '12345';
//       String jsonChallengeString = json.encode(chlngJsonObj);
//
//       RDNASyncResponse syncResponse =
//           await rdna.setCustomChallengeResponse(jsonChallengeString);
//
//     } else if (res.status!.statusCode != 100) {
//       showAlertMessageDialog(
//             this.context,
//             res.status!.statusMessage,
//             (value) => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: (BuildContext context) => this.resetAuthenticationAPI() )));
//     } else {
//        checkSyncError(res.error);
//     }
//   }
//
//   void getDeviceName(RDNAGetDeviceName response) async {
//     log.log(Level.debug,"getDeviceName--->" + json.encode(response.toJson()),null,null);
//      log.log(Level.debug,
//         "Auto generated DeviceName--->" + response.autoGeneratedDeviceName!,null,null);
//     RDNASyncResponse res =
//         await rdna.setDeviceName(response.autoGeneratedDeviceName!);
//      log.log(Level.debug,"setDeviceName--->" + json.encode(res.toJson()),null,null);
//   }
//
//    void getLoginID(String response) async {
//     RDNASyncResponse res = await rdna.addAlternateLoginId('1234');
//     log.log(Level.debug,"addAlternateLoginId--->" + json.encode(res.toJson()),null,null);
//   }
//
//   void onLoginIdUpdateStatus(RDNALoginIdUpdateStatus res) {
//     log.log(Level.debug,"onLoginIdUpdateStatus--->" + json.encode(res.toJson()),null,null);
//     if (res.error!.shortErrorCode == 0 &&
//         res.status!.statusCode == 100) {
//     } else if (res.status!.statusCode != 100) {
//       showAlertMessageDialog(
//             this.context,
//             res.status!.statusMessage,
//             (value) => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: ((BuildContext context) =>null) as Widget Function(BuildContext) )));
//     } else {
//        checkSyncError(res.error);
//     }
//   }
//
//   void onForgotLoginIDStatus(RDNAForgotLoginIdStatus res) {
//   log.log(Level.debug,"onForgotLoginIDStatus--->" + json.encode(res.toJson()),null,null);
//     if (res.error!.shortErrorCode == 0 &&
//         res.status!.statusCode == 100) {
//     } else if (res.status!.statusCode != 100) {
//       showAlertMessageDialog(
//             this.context,
//             res.status!.statusMessage,
//             (value) => Navigator.pushReplacement(
//                 context,
//                 MaterialPageRoute(
//                     builder: ((BuildContext context) => null) as Widget Function(BuildContext) )));
//     } else {
//        checkSyncError(res.error);
//     }
//   }
//
//   ////====================================> Methods <====================================
//
//   //Method to check sync response error
//   bool checkSyncError(error) {
//     var retVal = false;
//     if (error.shortErrorCode != 0) {
//       showAlertMessageDialog(this.context, error.errorString, null);
//     } else {
//       log.log(Level.debug, "checkSyncError error code is 0", null, null);
//       retVal = true;
//     }
//     return retVal;
//   }
//
//   //Method to call fallbackNewDeviceActivationFlow
//   fallBackNewDeviceCall() {
//     rdna.fallbackNewDeviceActivationFlow().then((result) {
//       checkSyncError(result.error);
//       return (result);
//     });
//   }
//
//   //Method to show alert message
//   void showAlertMessageDialog(BuildContext context, message, func) {
//     showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//               title: Text("Error!", style: TextStyle(fontSize: 20)),
//               content: Text(message, style: Theme.of(context).textTheme.bodyText2),
//               actions: <Widget>[
//                 TextButton(
//                   child: Text('Ok'),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     if (func != null) func(true);
//                     showLoadingController(false);
//                   },
//                 ),
//               ],
//             ));
//   }
//
//   //Method to emit events
//   void on(String event, Function handler) {
//     EventCallback eventcallback = (event, cont) {
//       handler(event.eventData);
//     };
//     eventEmitter.on(event, null, eventcallback);
//   }
//
//   //Method to check internet connectivity
//   Future<bool> check() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.mobile) {
//       return true;
//     } else if (connectivityResult == ConnectivityResult.wifi) {
//       return true;
//     }
//     return false;
//   }
//
//   //Method to check internet Connection
//   dynamic checkInternet(context) {
//     check().then((intenet) {
//       if (intenet) {
//         fetchPrefrence(true, context);
//       } else {
//         fetchPrefrence(false, context);
//       }
//     });
//   }
//
//   //Method to fetch internet connection preference
//   fetchPrefrence(bool isNetworkPresent, context) {
//     if (isNetworkPresent) {
//       showAlertMessageDialog(this.context, "internet is connected", null);
//     } else {
//       showAlertMessageDialog(this.context, "internet is not connected", null);
//     }
//   }
//
//   //Method to set data in localstorage
//   setLocalData(key, userId) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.setString(key, userId);
//   }
//
//   //Method to get data from localstorage
//   getLocalData(key) async {
//     final prefs = await SharedPreferences.getInstance();
//     String? userid = prefs.getString(key);
//     return userid;
//   }
//
//   //Method to clear the localstorage data
//   clearLocalData(key) async {
//     final prefs = await SharedPreferences.getInstance();
//     prefs.remove(key);
//   }
//
//   //Method to handle the hardware back button click event
//   Future<bool> onBackPressed(shouldExit) async {
//     log.log(Level.debug, "Back button pressed.", null, null);
//     if (shouldExit) {
//       exit(0);
//     } else {
//       log.log(Level.debug, "Back button pressed. Performing resetAuth()", null,
//           null);
//       this.resetAuthenticationAPI();
//       return false;
//     }
//   }
//
//   //Method to show loader
//   showLoadingController(shouldShow) {
//     Positioned(child: ShowCase(false));
//   }
//
//   //Method to show loader
//   showLoader() {
//     return Padding(
//       padding: EdgeInsets.fromLTRB(20, 50, 20, 0),
//       child: SpinKitWave(color: Colors.blueAccent),
//     );
//   }
}
