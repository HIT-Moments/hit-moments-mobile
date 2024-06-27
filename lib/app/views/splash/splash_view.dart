import 'package:flutter/material.dart';
import 'package:hit_moments/app/routes/app_routes.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 2), () {
    //   Navigator.popAndPushNamed(context, AppRoutes.EXAMPLE);
    // });
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.popAndPushNamed(context, AppRoutes.MYFRIENDVIEW);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
