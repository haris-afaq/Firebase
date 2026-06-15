import 'package:firebase_practice/constants/app_colors.dart';
import 'package:firebase_practice/services/splash_screen_services.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  SplashScreenServices splashScreenServices = SplashScreenServices();
  @override
  void initState() {
    // TODO: implement initState
    splashScreenServices.isLogin(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.whiteColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment:  CrossAxisAlignment.center,
          children: [
           Image(
            height: 150,
            image: AssetImage("assets/images/firebase_logo.png")),
            // SizedBox(height: 10,),
            // CircularProgressIndicator(color: AppColors.firebaseOrangeColor, strokeCap: StrokeCap.butt,strokeWidth: 3,)
          ],
        ),
      ),
    );
  }
}