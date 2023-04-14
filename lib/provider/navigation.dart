import 'package:flutter/material.dart';

class Navigation with ChangeNotifier {
  int navigation = 1;

  int get currentNavigation => navigation;

  void setNavigation({required int val}) {
    navigation = val;
    notifyListeners();
  }
}
