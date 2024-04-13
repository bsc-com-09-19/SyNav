import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/bindings/home_binding.dart';
// import 'package:sy_nav/features/navigation/screens/bookmarks/bookmarks.dart';
import 'package:sy_nav/features/navigation/screens/home/home.dart';
import 'package:sy_nav/features/navigation/screens/navigation/navigationScreen.dart';
import 'package:sy_nav/features/navigation/screens/nofications/notifications_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/wifi_screen.dart';
import 'package:sy_nav/utils/themes/theme.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(SyNavApp());
}

class SyNavApp extends StatelessWidget {
  SyNavApp({super.key});
  final List<GetPage> appRoutes = [
    GetPage(
      name: '/', // Home screen as the initial route
      page: () => const Home(),
    ),
    GetPage(
      name: '/explore',
      page: () => const Home(),
    ),
    GetPage(
      name: '/bookmarks',
      page: () => WifiScreen(),
    ),
    GetPage(
      name: '/navigate',
      page: () => BuildingsScreen(),
    ),
    GetPage(
      name: "/notifications",
      page: () => const NotificationsScreen(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SyNav",
      home: const Home(),
      theme: KTheme.lightTheme,
      darkTheme: KTheme.darkTheme,
      initialBinding: HomeBinding(),
      getPages: appRoutes,
    );
  }
}
