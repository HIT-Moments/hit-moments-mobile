import 'package:flutter/material.dart';
import 'package:hit_moments/app/core/config/theme_config.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';

class ThemeProvider extends ChangeNotifier {
  //final is
  ThemeData themeData = getIsDarkMode()!=true?ThemeConfig.lightTheme:ThemeConfig.darkTheme;
  themData(){
    return themeData;
  }
  void setThemeData(ThemeData themeData) {
    this.themeData = themeData;
    notifyListeners();
  }
}
