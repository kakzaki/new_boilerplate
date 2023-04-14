import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

const boxSetting = 'Setting';
const keyLanguage = 'language';

class Setting with ChangeNotifier {
  int language = 1;

  var box = Hive.box(boxSetting);

  void init() async {
    box = await Hive.openBox(boxSetting);
    language = box.get(keyLanguage) ?? 1;
  }

  void setLanguage({required int val}) async {
    language = val;
    box.put(keyLanguage, language);
    notifyListeners();
  }

  Locale getLanguage() {
    switch (language) {
      case 1:
        return const Locale('id', 'ID');
      default:
        return const Locale('en', 'EN');
    }
  }
}
