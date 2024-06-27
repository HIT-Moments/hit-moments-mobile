import 'package:flutter/material.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/example/example_view.dart';
import 'package:hit_moments/app/views/my_friend/myfriend_view.dart';
import 'package:hit_moments/app/views/splash/splash_view.dart';

abstract class AppPages {
  AppPages._();
  static Map<String, Widget Function(dynamic)> routes = {
    AppRoutes.SPASH: (context) => const SplashView(),
    AppRoutes.EXAMPLE: (context) => const ExampleView(),
    AppRoutes.MYFRIENDVIEW: (context) => MyFriendView(),
  };
}
