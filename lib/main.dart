import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/authentication/auth_repository/auth_repository.dart';
import 'package:smart_pace/src/features/authentication/presentation/binding/AuthBinding.dart';

import 'firebase_options.dart';
import 'src/features/screens/welcome_screen/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // inject for once
  Get.put(AuthRepository());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialBinding: AuthBinding(), // ✅Initialize controllers here
      home: WelcomeScreen(),
    );
  }
}