import 'package:flutter/material.dart';
import 'package:flutter_application_22/Theme/darktheme.dart';
import 'package:flutter_application_22/Theme/lighttheme.dart';

class Themeprovider extends ChangeNotifier {
  ThemeData _activetheme = lighttheme;
  ThemeData get activethemename => _activetheme;
  bool get isdarkmode => _activetheme == darktheme;
  set themedata(ThemeData themedata) {
    _activetheme = themedata; //give the name of parameter
    notifyListeners();
  }

  void toggletheme() {
    if (_activetheme == lighttheme) {
      _activetheme = darktheme;
    } else {
      _activetheme = lighttheme;
    }
    notifyListeners();
  }
}
