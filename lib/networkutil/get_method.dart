import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:provider/provider.dart';
import '../dbhelper/dbhelper.dart';
import '../model/user.dart';
import '../provider/rest_api.dart';
import '../provider/url.dart';

Future<Map?> getHTTP(
    {required String url, String? token, bool? log = false}) async {
  Dio dio = Dio();
  late Response response;
  Map? data;
  if (log == true) {
    if (kDebugMode == true) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
      ));
    }
  }
  Options options = Options(
    responseType: ResponseType.json,
  );
  if (token != null) {
    options.headers = {"token": token};
  }
  response = await dio.get(url, options: options);
  data = await response.data;
  return data;
}

Future fetchProfile(BuildContext context) async {
  final rest = Provider.of<RestApi>(context, listen: false);
  var baseURL = Provider.of<URL>(context, listen: false).baseURL;
  User user = await fetchUserFromDatabase();
  Map? data;
  data = await getHTTP(url: "${baseURL}api/pelanggan", token: user.apitoken);
  if (data != null) {
    if (data['data'] != null) {
      rest.setProfile(data['data']);
    }
  }
  return data;
}
