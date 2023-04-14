import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const boxRestApi = 'RestApi';
const keyProfile = 'profile';

class RestApi with ChangeNotifier {
  Map? profile;

  var box = Hive.box(boxRestApi);

  void init() async {
    box = await Hive.openBox(boxRestApi);
    profile = box.get(keyProfile);
  }

  getProfile() => profile;



  void setProfile(Map? val) async {
    profile = val;
    notifyListeners();
    box.put(keyProfile, val);
  }
}
