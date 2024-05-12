import 'package:alan_voice/alan_voice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/bindings/home_binding.dart';
// import 'package:sy_nav/features/navigation/screens/bookmarks/bookmarks.dart';
import 'package:sy_nav/features/navigation/screens/home/home.dart';
import 'package:sy_nav/features/navigation/screens/navigation/navigationScreen.dart';
import 'package:sy_nav/features/navigation/screens/nofications/notifications_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/wifi_screen.dart';
import 'package:sy_nav/firebase_options.dart';
import 'package:sy_nav/utils/themes/theme.dart';
import 'dart:async';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Initializing the firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  ///Enables local caching
  FirebaseDatabase.instance.setPersistenceEnabled(true);
  runApp(SyNavApp());
  _initAlan();
  _initWifi();
}

void _initWifi() async {
  final wifiController = Get.put<WifiController>(WifiController());
  await wifiController.getWifiList();
}

void _initAlan() {
  AlanVoice.addButton(
    "3e8015e10c102cb7e6efd807edc44b782e956eca572e1d8b807a3e2338fdd0dc/stage",
    buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
  );
  AlanVoice.callbacks.add((command) => _handleCommand(command.data));
}

void _handleCommand(Map<String, dynamic> commandData) {
  String command = commandData['command'];
  switch (command) {
    case 'Home':
      Get.toNamed('/');
      _playText("Your in the Explore screen");
      break;
    case 'Bookmarks':
      Get.toNamed('/bookmarks');
      _playText("Your in the Bookmarks screen");
      break;
    case 'Navigate':
      Get.toNamed('/navigate');
      _playText("Your in the Navigate screen");
      break;
    case 'Notifications':
      Get.toNamed('/notifications');
      _playText("Your in the notifications screen");
      break;
    case 'Explore':
      Get.toNamed('/explore');
      _playText("Your in the Explore screen");
      break;
    default:
      _playText(
          "you can tell me to: go to Bookmarks, Home, Notifications, Navigate, or Explore");
      break;
  }

  // Wait for 3 seconds before closing the connection
  Timer(Duration(seconds: 6), () {
    _closeAlanConnection();
  });

  // Ask if the user needs something else
  _playText("Do you need something else?");
}

// Play text via Alan Voice
void _playText(String text) {
  AlanVoice.playText(text);
}

// Close Alan connection
void _closeAlanConnection() {
  AlanVoice.deactivate();
}

class SyNavApp extends StatelessWidget {
  SyNavApp({super.key});

  ///Routes for navigation through the app
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
