import 'package:get/get.dart';
import 'package:smart_pace/src/features/screens/welcome_screen/welcome_screen.dart';

import '../../features/screens/home/drop_down_menu/screens/about_screen.dart';
import '../../features/screens/home/drop_down_menu/screens/accounts_screen.dart';
import '../../features/screens/home/drop_down_menu/screens/help_screen.dart';
import '../../features/screens/home/drop_down_menu/screens/notification_settings_screen.dart';
import '../../features/screens/home/drop_down_menu/screens/privacy_settings_screen.dart';
import '../../features/screens/home/drop_down_menu/screens/settings_screen.dart';
import '../navigation/navigation.dart';

class AppRoutes {
  static const String welcome = '/welcome';
  static const String home = '/home';
  static const String settings = '/settings';
  static const String account = '/account';
  static const String help = '/help';
  static const String about = '/about';
  static const String privacySettings = '/privacy-settings';
  static const String notificationSettings = '/notification-settings';
  static const String editProfile = '/edit-profile';
  static const String studyReminders = '/study-reminders';
  static const String dataStorage = '/data-storage';
}

class AppPages {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.welcome,
      page: () => WelcomeScreen(),
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => MainNavigation(),
    ),
    GetPage(
      name: AppRoutes.settings,
      page: () => SettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.account,
      page: () => AccountScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.help,
      page: () => HelpScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.about,
      page: () => AboutScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.privacySettings,
      page: () => PrivacySettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.notificationSettings,
      page: () => NotificationSettingsScreen(),
      transition: Transition.rightToLeft,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}