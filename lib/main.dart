import 'dart:math';

import 'package:alan_voice/alan_voice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sy_nav/bindings/home_binding.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/home/home.dart';
import 'package:sy_nav/features/navigation/screens/navigation/navigationScreen.dart';
import 'package:sy_nav/features/navigation/screens/nofications/notifications_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/wifi_screen.dart';
import 'package:sy_nav/firebase_options.dart';
import 'package:sy_nav/utils/helpers/wifi_algorithms.dart';
import 'package:sy_nav/utils/themes/theme.dart';
import 'dart:async';

import 'package:sy_nav/utils/widgets/k_snack_bar.dart';

// Declare a global key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

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

void _initAlan() async {
  AlanVoice.addButton(
    "3e8015e10c102cb7e6efd807edc44b782e956eca572e1d8b807a3e2338fdd0dc/stage",
    buttonAlign:
        AlanVoice.BUTTON_ALIGN_LEFT // Prevents Alan button from aligning
    // draggable: false, // Uncomment this line if the Alan SDK provides such an option
  );
  AlanVoice.callbacks.add((command) => _handleCommand(command.data));
  // Enable the wake word
  AlanVoice.setWakewordEnabled(true);

  // Check if the wake word is enabled
  var enabled = await AlanVoice.getWakewordEnabled();
  print('Wake word enabled: $enabled');
}

void _handleCommand(Map<String, dynamic> commandData) async {
  HomeController homeController = Get.find<HomeController>();
  WifiController wifiController = Get.find<WifiController>();
  String command = commandData['command'];

  // Access the context using the global key
  BuildContext? context = navigatorKey.currentContext;

  switch (command) {
    case 'Home':
      homeController.currentIndex.value = 0;
      _playText("You're in the Explore screen");
      break;
    case 'Bookmarks':
      homeController.currentIndex.value = 1;
      homeController.appBarTitle.value = "Bookmarks";
      _playText("You're in the Bookmarks screen");
      break;
    case 'Navigate':
      homeController.appBarTitle.value = "Buildings";
      homeController.currentIndex.value = 2;
      _playText("You're in the Navigate screen");
      break;
    case 'Notifications':
      homeController.appBarTitle.value = "Notifications";
      homeController.currentIndex.value = 3;
      _playText("You're in the notifications screen");
      break;
    case 'Explore':
      _playText("You're in the Explore screen");
      break;
    case 'Location':
      if (wifiController.wifiList.length < 3) {
        _playText("You don't have enough registered access points around you");
        showErrorSnackBAr(context!,
            "You don't have enough registered access points around you (${wifiController.wifiList.length} APs)");
      } else {
        List<String> wifiList = await wifiController.getTrilaterationWifi();
        Point<double> estimatedLocation =
            WifiAlgorithms.getEstimatedLocation(wifiList);
        homeController.location.value = estimatedLocation;
        _playText("Your location is $estimatedLocation");
      }
      break;
    default:
      _playText(
          "You can tell me to: go to Bookmarks, Home, Notifications, Navigate, or Explore");
      break;
  }

  // Wait for 10 seconds before closing the connection
  Timer(const Duration(seconds: 10), () {
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
      navigatorKey: navigatorKey, // Set the global key
      home: Stack(
        children: [
          const Home(),
          Positioned(
            bottom: 20,
            right: 20,
            child: AlanVoiceButton(),
          ),
        ],
      ),
      theme: KTheme.lightTheme,
      darkTheme: KTheme.darkTheme,
      initialBinding: HomeBinding(),
      getPages: appRoutes,
    );
  }
}

class AlanVoiceButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // This is where you would integrate the actual Alan button if necessary
    // Since the Alan button is automatically managed by the Alan SDK, this is a placeholder
    return SizedBox.shrink();
  }
}
