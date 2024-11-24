import 'package:flutter/material.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:hit_moments/app/views/auth/auth_view.dart';
import 'package:hit_moments/app/views/auth/login/login_view.dart';
import 'package:hit_moments/app/views/auth/register/register_view.dart';
import 'package:hit_moments/app/views/auth/register/verify_email_view.dart';
import 'package:hit_moments/app/views/example/example_view.dart';
import 'package:hit_moments/app/views/example/home_view.dart';
import 'package:hit_moments/app/views/onboarding/onboarding_view.dart';
import 'package:hit_moments/app/views/profile/personalPageView.dart';
import 'package:hit_moments/app/views/splash/splash_view.dart';

import '../views/conversation/conversation_view.dart';
import '../views/list_my_friend/list_my_friend_view.dart';

abstract class AppPages {
  AppPages._();
  static Map<String, Widget Function(dynamic)> routes = {
    AppRoutes.SPASH: (context) => const SplashView(),
     AppRoutes.EXAMPLE: (context) => const ExampleView(),
    AppRoutes.AUTHENTICATION: (context) => const AuthView(),
    AppRoutes.SIGNUP: (context) => const RegisterView(),
    AppRoutes.LOGIN: (context) => const LoginView(),
    AppRoutes.VERIFYEMAIL: (context) => const VerifyEmailView(),
    AppRoutes.LIST_MY_FRIEND: (context) => const ListMyFriendView(),
    AppRoutes.MY_CONVERSATION : (context) => const ConversationView(),
    AppRoutes.MY_PROFILE : (context) => const PersonalPageScreen(),
    AppRoutes.MY_HOME : (context) => const HomeView(),
    AppRoutes.ONBOARDING : (context) => const Onboarding(),
  };
}
