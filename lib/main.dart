import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smart_pace/src/features/authentication/auth_repository/auth_repository.dart';

import 'firebase_options.dart';
import 'src/features/screens/home/drop_down_menu/controllers/account_controller.dart';
import 'src/features/screens/home/drop_down_menu/controllers/menu_controller.dart';
import 'src/features/screens/home/drop_down_menu/controllers/settings_controller.dart';
import 'src/features/screens/welcome_screen/welcome_screen.dart';
import 'src/routing/routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize controllers
  Get.put(AuthRepository());
  Get.put(DmenuController());
  Get.put(SettingsController());
  Get.put(AccountController());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartPace',
    
      themeMode: ThemeMode.system,
      
      // Define routes
      initialRoute: AppRoutes.welcome,
      getPages: AppPages.routes,
      
      // Fallback route
      unknownRoute: GetPage(
        name: '/notfound',
        page: () => WelcomeScreen(),
      ),
      
      home: WelcomeScreen(),
    );
  }
}