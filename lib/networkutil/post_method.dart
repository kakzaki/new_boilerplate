// ignore_for_file: prefer_typing_uninitialized_variables
// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:headup_loading/headup_loading.dart';
import '../util/random_string.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../dbHelper/dbHelper.dart';
import '../home_screen.dart';
import '../model/user.dart';
import '../provider/rest_api.dart';
import '../provider/url.dart';
import '../widget/dialog.dart';
import 'get_method.dart';

var dbHelper = DBHelper();

Future postLogin(BuildContext context,
    {int tipe = 0,
    String? email,
    String? password,
    String? phone,
    String? phonecode,
    String? token,
    String? sendWA,
    bool resendcode = false}) async {
  HeadUpLoading.show(context);
  var dbHelper = DBHelper();
  var baseURL = Provider.of<URL>(context, listen: false).baseURL;
  OSDeviceState? status = await OneSignal().getDeviceState();
  String? onesignalUserId = status?.userId;
  String? deviceId = await PlatformDeviceId.getDeviceId;
  String endPoint = "api/login";
  Dio dio = Dio();
  Map<String, dynamic> maps = {};
  switch (tipe) {
    case 0: //phone
      String signature = await SmsAutoFill().getAppSignature;
      maps["phone"] = phone;
      maps["phonecode"] = phonecode;
      maps["signature"] = signature;
      break;
    case 1: //email
      maps["email"] = email;
      maps["password"] = password;
      break;
    case 2: //google
      maps["token"] = token;
      endPoint = "api/login/google";
      break;
    case 3: //facebook
      maps["token"] = token;
      endPoint = "api/login/facebook";
      break;
  }

  if (onesignalUserId != null) {
    maps["player_id"] = onesignalUserId;
  }
  if (deviceId != null) {
    maps["device_id"] = deviceId;
  }
  maps["send_wa"] = sendWA;

  FormData formData = FormData.fromMap(maps);
  if (kDebugMode) {
    dio.interceptors
        .add(PrettyDioLogger(requestHeader: true, requestBody: true));
  }
  final Response response = await dio.post("$baseURL$endPoint",
      data: formData,
      options: Options(
        responseType: ResponseType.json,
      ));
  var data;
  data = response.data;
  if (data['status'] == true ||
      data['result'] == true ||
      data['success'] == true ||
      data['code'] == 200) {
    var profile = data['data']['pelanggan'];
    if (resendcode == true) {
      HeadUpLoading.hide();
      return data;
    } else {
      HeadUpLoading.hide();
      switch (tipe) {
        case 0: //phone
          // Navigator.pushReplacement(
          //     context,
          //     PageTransition(
          //         type: PageTransitionType.leftToRight,
          //         child: VerifikasiSMS(
          //           kodenomor: phonecode,
          //           nomorhp: phone,
          //           result: data,
          //         )));
          break;
        case 1: //email
          dbHelper.saveUser(User(
              "${profile['id']}",
              "${profile['name'] ?? ""}",
              password,
              "${profile['email'] ?? ""}",
              "${profile['phone'] ?? ""}",
              "${profile['api_token']}"));
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
          break;
        case 2: //google
          await _googleSignIn.signOut();
          HeadUpLoading.hide();
          dbHelper.saveUser(User(
              "${profile['id']}",
              "${profile['name']}",
              "${profile['api_token']}",
              "${profile['email']}",
              "${profile['phone']}",
              "${profile['api_token']}"));
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
          break;
        case 3: //facebook
          HeadUpLoading.hide();
          dbHelper.saveUser(User(
              "${profile['id']}",
              "${profile['name']}",
              "${profile['api_token']}",
              "${profile['email']}",
              "${profile['phone']}",
              "${profile['api_token']}"));
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
          break;
        default: //selain phone
          dbHelper.saveUser(User(
              "${profile['id']}",
              "${profile['name'] ?? ""}",
              password,
              "${profile['email'] ?? ""}",
              "${profile['phone'] ?? ""}",
              "${profile['api_token']}"));
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
          break;
      }
    }
  } else {
    HeadUpLoading.hide();
    dialogWarning(context, data);
  }
}

GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: <String>[
    'email',
  ],
);

Future loginGoogle(BuildContext context, {required isRegister}) async {
  var profile;
  _googleSignIn.signIn().then((result) {
    result?.authentication.then((googleKey) async {
      debugPrint("token google ${googleKey.accessToken}");
      if (isRegister == true) {
        profile = await postRegister(context,
            tipe: 2, token: "${googleKey.accessToken}");
      } else {
        profile = await postLogin(context,
            tipe: 2, token: "${googleKey.accessToken}");
      }
    }).catchError((err) {
      debugPrint('inner error');
    });
  }).catchError((err) {
    debugPrint('error occured');
  });
  return profile;
}

Future loginFacebook(BuildContext context, {required isRegister}) async {
  var profile;
  final LoginResult result = await FacebookAuth.instance
      .login(loginBehavior: LoginBehavior.katanaOnly);
  switch (result.status) {
    case LoginStatus.success:
      final AccessToken? accessToken = result.accessToken;
      debugPrint("token fb ${accessToken?.token}");
      if (isRegister == true) {
        profile = await postRegister(context,
            tipe: 3, token: "${accessToken?.token}");
      } else {
        profile =
            await postLogin(context, tipe: 3, token: "${accessToken?.token}");
      }
      break;
    case LoginStatus.cancelled:
      debugPrint('Login cancelled by the user.');
      break;
    case LoginStatus.failed:
      debugPrint('Something went wrong with the login process.\n'
          'Here\'s the error Facebook gave us: ${result.message}');
      break;
    case LoginStatus.operationInProgress:
      debugPrint('operationInProgress.');
      break;
  }
  return profile;
}

Future postRegister(BuildContext context,
    {int tipe = 0,
    String? email,
    String? name,
    String? password,
    String? passwordkonfirm,
    String? phone,
    String? phonecode,
    String? token,
    bool resendcode = false}) async {
  HeadUpLoading.show(context);
  var baseURL = Provider.of<URL>(context, listen: false).baseURL;
  OSDeviceState? status = await OneSignal().getDeviceState();
  String? onesignalUserId = status?.userId;
  String? deviceId = await PlatformDeviceId.getDeviceId;

  String endPoint = "api/register";
  Dio dio = Dio();
  Map<String, dynamic> maps = {};
  switch (tipe) {
    case 0: //phone
      String signature = await SmsAutoFill().getAppSignature;
      maps["phone"] = phone;
      maps["phonecode"] = phonecode;
      maps["signature"] = signature;
      break;
    case 1: //email
      maps["phone"] = phone;
      maps["phonecode"] = phonecode;
      maps["name"] = name;
      maps["email"] = email;
      maps["password"] = password;
      maps["email"] = email;
      break;
    case 2: //google
      maps["token"] = token;
      endPoint =
          "api/register/google?X-API-KEY=doran_data&random=${RandomString.create()}";
      break;
    case 3: //facebook
      maps["token"] = token;
      endPoint =
          "api/register/facebook?X-API-KEY=doran_data&random=${RandomString.create()}";
      break;
  }

  if (onesignalUserId != null) {
    maps["player_id"] = onesignalUserId;
  }
  if (deviceId != null) {
    maps["device_id"] = deviceId;
  }
  FormData formData = FormData.fromMap(maps);
  dio.interceptors
      .add(PrettyDioLogger(requestHeader: false, requestBody: true));
  // try {
  final Response response = await dio.post("$baseURL$endPoint",
      data: formData,
      options: Options(
        responseType: ResponseType.json,
        // contentType:Headers.jsonContentType ,
        // method: "POST"
      ));
  var data = response.data;
  if (data['status'] == true ||
      data['result'] == true ||
      data['success'] == true ||
      data['code'] == 200) {
    if (resendcode == true) {
      HeadUpLoading.hide();
      return data;
    } else {
      var profile = data['data']['pelanggan'] ?? {};
      switch (tipe) {
        case 0: //phone
          HeadUpLoading.hide();
          // Navigator.pushReplacement(
          //     context,
          //     PageTransition(
          //         type: PageTransitionType.leftToRight,
          //         child: VerifikasiSMS(
          //           kodenomor: phonecode,
          //           nomorhp: phone,
          //           result: data,
          //           register: true,
          //         )));
          break;
        case 1: //email
          HeadUpLoading.hide();
          dialogWarning(context, data, close: true).then((value) {
            if (value == true) {
              Navigator.pop(context);
            }
          });
          break;
        case 2: //google
          await _googleSignIn.signOut();
          HeadUpLoading.hide();
          dbHelper.saveUser(User(
              "${profile['id']}",
              "${profile['name']}",
              "${profile['api_token']}",
              "${profile['email']}",
              "${profile['phone']}",
              "${profile['api_token']}"));
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );

          break;
        case 3: //facebook
          HeadUpLoading.hide();
          dbHelper.saveUser(User(
              "${profile['id']}",
              "${profile['name']}",
              "${profile['api_token']}",
              "${profile['email']}",
              "${profile['phone']}",
              "${profile['api_token']}"));
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
            (Route<dynamic> route) => false,
          );
          break;
        default: //selain
          HeadUpLoading.hide();
          dialogWarning(context, data, close: true).then((value) {
            if (value == true) {
              Navigator.of(context).pop(true);
            }
          });
          break;
      }
    }
  } else {
    HeadUpLoading.hide();
    dialogWarning(context, data);
  }
  // } on DioError catch (e) {
  //   HeadUpLoading.hide();
  //   dialogwarning(context, e.response!.data);
  // }
}

Future postCheckOTP(BuildContext context,
    {String? phone, String? phonecode, String? kodeotp}) async {
  HeadUpLoading.show(context);
  var baseURL = Provider.of<URL>(context, listen: false).baseURL;
  String endPoint = "api/auth/otp/verify";
  Dio dio = Dio();
  Map<String, dynamic> maps = {};
  maps["phone"] = phone;
  maps["phonecode"] = phonecode;
  maps["otp"] = kodeotp;
  FormData formData = FormData.fromMap(maps);
  if (kDebugMode) {
    dio.interceptors
        .add(PrettyDioLogger(requestHeader: true, requestBody: true));
  }
  var data;
  // try {
  Response response = await dio.post("$baseURL$endPoint",
      data: formData,
      options: Options(
        responseType: ResponseType.json,
      ));
  data = await response.data;
  // } on DioError catch (e) {
  //   HeadUpLoading.hide();
  //   return dialogwarning(context, e.response!.data);
  // }
  return data;
}

Future postAktivationOTP(BuildContext context,
    {String? phone, String? phonecode, String? kodeotp}) async {
  HeadUpLoading.show(context);
  var baseURL = Provider.of<URL>(context, listen: false).baseURL;
  // var baseURL = Provider.of<URL>(context,listen: false).getUrl();
  String endPoint = "api/activation/otp";
  Dio dio = Dio();
  Map<String, dynamic> maps = {};
  maps["phone"] = phone;
  maps["phonecode"] = phonecode;
  maps["otp_code"] = kodeotp;
  FormData formData = FormData.fromMap(maps);
  if (kDebugMode) {
    dio.interceptors
        .add(PrettyDioLogger(requestHeader: true, requestBody: true));
  }
  Response response = await dio.post("$baseURL$endPoint",
      data: formData,
      options: Options(
        responseType: ResponseType.json,
      ));
  return response.data;
}

Future postEditProfile(BuildContext context,
    {String? email,
    String? name,
    String? password,
    String? phone,
    String? height,
    String? weight,
    String? token,
    String? id,
    bool? fromLogin,
    String? workoutGoal,
    String? gender,
    String? dateOfBirth,
    String? stravaToken,
    String? stravaRefreshToken,
    String? stravaExpired,
    File? avatar}) async {
  // var baseURL = Provider.of<URL>(context, listen: false).getUrl();
  HeadUpLoading.show(context);
  var baseURL = Provider.of<URL>(context, listen: false).baseURL;
  final rest = Provider.of<RestApi>(context, listen: false);
  var data;

  if (token == null) {
    User user = await fetchUserFromDatabase();
    id = user.iduser;
    token = user.apitoken;
  }
  Dio dio = Dio();
  Map<String, dynamic> maps = {};
  maps["_method"] = "PUT";
  if (email != "") {
    maps["email"] = email!.trim();
  }
  if (name != "") {
    maps["name"] = name;
  }
  if (password != "" && password != null) {
    maps["password"] = password;
  }
  if (phone != "") {
    maps["phone"] = phone;
  }
  if (height != "") {
    maps["height"] = height;
  }
  if (weight != "") {
    maps["weight"] = weight;
  }
  if (workoutGoal != "") {
    maps["workoout_goal"] = workoutGoal;
  }
  if (gender != "") {
    if (gender == "Male" || gender == "Pria") {
      maps['gender'] = "L";
    } else {
      maps['gender'] = "P";
    }
  }
  if (stravaToken != "") {
    maps['strava_token'] = stravaToken;
    maps['strava_refresh_token'] = stravaRefreshToken;
    maps['strava_expired'] = stravaExpired;
  }
  if (dateOfBirth != "") {
    maps["birthday"] = dateOfBirth;
  }
  if (avatar != null) {
    maps["avatar"] = await MultipartFile.fromFile(avatar.path);
  }
  FormData formData = FormData.fromMap(maps);
  dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true));

  // try {
  Response response = await dio.post("${baseURL}api/pelanggan/$id",
      data: formData,
      options: Options(
        headers: {"token": token},
        //  method: 'PUT',
        responseType: ResponseType.json,
      ));
  data = await response.data;
  debugPrint("dataUser $data");
  if (data?['result'] == true || data['status'] == true) {
    HeadUpLoading.hide();
    if (fromLogin == true) {
      Map? profile = data['data'];
      if (profile != null) {
        rest.setProfile(profile);
        dbHelper.saveUser(User(
            "${profile['id']}",
            "${profile['name']}",
            "${profile['api_token']}",
            "${profile['email']}",
            "${profile['phone']}",
            "${profile['api_token']}"));
        Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
          (Route<dynamic> route) => false,
        );
      }
    } else {
      fetchProfile(context).then((data) {
        log("fetchProfile success");
        rest.setProfile(data['data']);
        HeadUpLoading.hide();
        dialogWarning(context, data, close: true).then((value) {
          if (value == true) {
            Navigator.of(context).pop();
          }
        });
      }, onError: (e) {
        log(e);
      });
    }
  } else {
    HeadUpLoading.hide();
    dialogWarning(context, data);
  }
  return data;
}
