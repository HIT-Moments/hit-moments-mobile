// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/core/constants/color_constants.dart';
import 'package:hit_moments/app/core/constants/text_style_constants.dart';

class ThemeConfig {
  static ThemeData get lightTheme => ThemeData.light().copyWith(
    extensions: [
      ColorConstants.colorThemeLightExt,
      TextStyleConstant.textStyleLightExt,
    ],
    scaffoldBackgroundColor: ColorConstants.primaryLight10,
    appBarTheme: const AppBarTheme(),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 57.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      displayMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 45.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      displaySmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 36.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      headlineLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 32.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 28.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      headlineSmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 24.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      titleLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 22.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      titleMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 16.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      titleSmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 14.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 14.sp, // Changed to .sp
          fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 12.sp, // Changed to .sp
          fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 11.sp, // Changed to .sp
          fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 16.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      labelMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 14.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      labelSmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralLight120,
          fontSize: 12.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
    ),
  );

  static ThemeData get darkTheme => ThemeData.dark().copyWith(
    extensions: [
      ColorConstants.colorThemeDarkExt,
      TextStyleConstant.textStyleDarkExt,
    ],
    scaffoldBackgroundColor: ColorConstants.primaryDark10,
    appBarTheme: const AppBarTheme(),
    textTheme: TextTheme(
      displayLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 57.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      displayMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 45.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      displaySmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 36.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      headlineLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 32.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      headlineMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 28.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      headlineSmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 24.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      titleLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 22.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      titleMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 16.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      titleSmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 14.sp, // Changed to .sp
          fontWeight: FontWeight.w700),
      bodyLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 14.sp, // Changed to .sp
          fontWeight: FontWeight.w400),
      bodyMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 12.sp, // Changed to .sp
          fontWeight: FontWeight.w400),
      bodySmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 11.sp, // Changed to .sp
          fontWeight: FontWeight.w400),
      labelLarge: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 16.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      labelMedium: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 14.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
      labelSmall: TextStyle(
          fontFamily: 'Dongle',
          color: ColorConstants.neutralDark120,
          fontSize: 12.sp, // Changed to .sp
          fontWeight: FontWeight.w300),
    ),
  );
}
