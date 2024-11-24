import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hit_moments/app/datasource/local/storage.dart';
import 'package:hit_moments/app/providers/user_provider.dart';
import 'package:hit_moments/app/routes/app_routes.dart';
import 'package:lottie/lottie.dart';
class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 4), () {
      _checkLogin();
    });
    super.initState();
  }
  void _checkLogin() async{
    if(getToken().isNotEmpty){
      Navigator.pushReplacementNamed(
          context,
          AppRoutes.MY_HOME,
      );
      UserProvider().getMe();
    }
    else{
      Navigator.pushReplacementNamed(context, AppRoutes.AUTHENTICATION);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Image.asset('assets/images/rotating_splash.gif', width: 200.w, height: 200.h),

        ),
      ),
    );
  }
}
