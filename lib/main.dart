import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/splash/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      defaultTransition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
    );
  }
}