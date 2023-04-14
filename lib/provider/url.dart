import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:otobee/provider/rest_api.dart';
import 'package:provider/provider.dart';

const keyBaseURL = 'baseURL';

class URL with ChangeNotifier {
  String? baseURL;

  var box = Hive.box(boxRestApi);

  void init() async {
    box = await Hive.openBox(boxRestApi);
    baseURL = box.get(keyBaseURL);
  }

  getUrl() => baseURL;

  void setUrl(String url) async {
    baseURL = url;
    notifyListeners();
    box.put(keyBaseURL, url);
  }
}

//GET URL UTAMA
Future fetchURL(BuildContext context) async {
  final url = Provider.of<URL>(context, listen: false);
  final Response response =
      await Dio().get('https://doransukses.github.io/urlmaster/index.json');
  var data = response.data['urljeteconnect'];
  if (data != null) {
    url.setUrl("$data");
  }
  return data;
}
