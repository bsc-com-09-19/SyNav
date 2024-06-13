// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:sy_nav/bindings/home_binding.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/home/home.dart';
import 'package:sy_nav/features/navigation/screens/navigation/navigationScreen.dart';
// import 'package:sy_nav/features/navigation/screens/notifications/notifications_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/wifi_screen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/sensor_manager.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_algorithms.dart';
import 'package:sy_nav/firebase_options.dart';
import 'package:sy_nav/utils/constants/colors.dart';
import 'package:sy_nav/utils/themes/theme.dart';
import 'package:sy_nav/utils/widgets/k_snack_bar.dart';
import 'package:sy_nav/firebase_options.dart';
import 'features/navigation/screens/nofications/notifications_screen.dart';

// Declare a global key
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initializing the firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  /// Enables local caching
  FirebaseDatabase.instance.setPersistenceEnabled(true);

  runApp(SyNavApp());

  await _initAlan();
  _initWifi();
}

Future<void> _initAlan() async {
  AlanVoice.addButton(
    "3e8015e10c102cb7e6efd807edc44b782e956eca572e1d8b807a3e2338fdd0dc/stage",
    buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
    // draggable: false,
  );
  AlanVoice.callbacks.add((command) => _handleCommand(command.data));

  // Enable the wake word
  // ignore: await_only_futures
  AlanVoice.setWakewordEnabled(true);

  // Check if the wake word is enabled
  var enabled = await AlanVoice.getWakewordEnabled();
  if (kDebugMode) {
    print('Wake word enabled: $enabled');
  }

  // Ensure the connection is open before speaking
  AlanVoice.activate();
  _voiceOut();
}

void _voiceOut() {
  _playText("Welcome to SyNav app, I am your voice assistant!");
}

void _initWifi() async {
  final wifiController = Get.put<WifiController>(WifiController());
  final homeController = Get.put<HomeController>(HomeController());

  final sensorManager = SensorManager(
      wifiController: wifiController, homeController: homeController);

  await wifiController.getWifiList();
  //TODO

  Timer.periodic(const Duration(milliseconds: 3000), (timer) async {
    await wifiController.getWifiList();
    List<String> wifiList = wifiController.getTrilaterationWifi();

    if (wifiList.isNotEmpty) {
      homeController.location.value = WifiAlgorithms.getEstimatedLocation(
          wifiList,
          sensorManager: sensorManager);
      if (kDebugMode) {
        print(wifiController.getLocationName(
          homeController.location.value.x, homeController.location.value.y));
      }
    } else {
      if (kDebugMode) {
        print("WiFi is empty");
      }
    }
  });
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
      _playText("You are in the Explore screen");
      break;
    case 'Bookmarks':
      homeController.currentIndex.value = 1;
      homeController.appBarTitle.value = "Bookmarks";
      _playText("You are in the Bookmarks screen");
      break;
    case 'Navigate':
      homeController.appBarTitle.value = "Buildings";
      homeController.currentIndex.value = 2;
      _playText("You are in the Navigate screen");
      break;
    case 'Notifications':
      homeController.appBarTitle.value = "Notifications";
      homeController.currentIndex.value = 3;
      _playText("You are in the Notifications screen");
      break;
    case 'Explore':
      _playText("You are in the Explore screen");
      break;
    case 'Location':
      if (wifiController.wifiList.length < 3) {
        _playText(
            "You don't have enough registered access points around you but your previous location was ${homeController.location.value}");
        showErrorSnackBAr(context!,
            "You don't have enough registered access points around you (${wifiController.wifiList.length} APs)");
      } else {
        List<String> wifiList = await wifiController.getTrilaterationWifi();
        Point<double> estimatedLocation = homeController.location.value;
        homeController.location.value = estimatedLocation;
        _playText("Your location is $estimatedLocation");
      }
      break;
    default:
      _playText(
          "You can tell me to: go to Bookmarks, Home, Notifications, Navigate, or Explore");
      break;
  }

  // Wait for 3 seconds before closing the connection
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

  /// Routes for navigation through the app
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
      name: "/history",
      page: () => const NotificationsScreen(),
    )
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SyNav",
      navigatorKey: navigatorKey, // Set the global key
      home: const SplashScreen(),
      theme: KTheme.lightTheme,
      darkTheme: KTheme.darkTheme,
      initialBinding: HomeBinding(),
      getPages: appRoutes,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()),
      );
      _initAlan();
      _initWifi();
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.primaryColor, // Set the background color to blue
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            Text(
              "SYNAV",
              style: TextStyle(
                color: Color.fromARGB(255, 248, 190, 1),
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "navigate with ease",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Icon(
              Icons.accessibility_new_outlined,
              color: Color.fromARGB(255, 248, 190, 1),
              size: 48,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _initAlan() async {
    AlanVoice.addButton(
      "3e8015e10c102cb7e6efd807edc44b782e956eca572e1d8b807a3e2338fdd0dc/stage",
      buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
      // draggable: false,
    );
    AlanVoice.callbacks.add((command) => _handleCommand(command.data));

    // Enable the wake word
    // ignore: await_only_futures
    AlanVoice.setWakewordEnabled(true);

    // Check if the wake word is enabled
    var enabled = await AlanVoice.getWakewordEnabled();
    if (kDebugMode) {
      print('Wake word enabled: $enabled');
    }

    // Ensure the connection is open before speaking
    AlanVoice.activate();
    _voiceOut();
  }

  void _voiceOut() {
    _playText("Welcome to SyNav app, I am your voice assistant!");
  }

  void _initWifi() async {
    final wifiController = Get.put<WifiController>(WifiController());
    final homeController = Get.put<HomeController>(HomeController());

    final sensorManager = SensorManager(
        wifiController: wifiController, homeController: homeController);

    await wifiController.getWifiList();

    Timer.periodic(const Duration(milliseconds: 6000), (timer) async {
      await wifiController.getWifiList();
      List<String> wifiList = wifiController.getTrilaterationWifi();

      if (wifiList.isNotEmpty) {
        homeController.location.value = WifiAlgorithms.getEstimatedLocation(
            wifiList,
            sensorManager: sensorManager);
      } else {
        print("WiFi is empty");
      }
    });
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
        _playText("You are in the Explore screen");
        break;
      case 'Bookmarks':
        homeController.currentIndex.value = 1;
        homeController.appBarTitle.value = "Bookmarks";
        _playText("You are in the Bookmarks screen");
        break;
      case 'Navigate':
        homeController.appBarTitle.value = "Buildings";
        homeController.currentIndex.value = 2;
        _playText("You are in the Navigate screen");
        break;
      case 'Notifications':
        homeController.appBarTitle.value = "Notifications";
        homeController.currentIndex.value = 3;
        _playText("You are in the Notifications screen");
        break;
      case 'Explore':
        _playText("You are in the Explore screen");
        break;
      case 'Location':
        if (wifiController.wifiList.length < 3) {
          _playText(
              "You don't have enough registered access points around you but your previous location was ${homeController.location.value}");
          showErrorSnackBAr(context!,
              "You don't have enough registered access points around you (${wifiController.wifiList.length} APs)");
        } else {
          List<String> wifiList = await wifiController.getTrilaterationWifi();
          Point<double> estimatedLocation = homeController.location.value;
          homeController.location.value = estimatedLocation;
          _playText("Your location is $estimatedLocation");
        }
        break;
      default:
        _playText(
            "You can tell me to: go to Bookmarks, Home, Notifications, Navigate, or Explore");
        break;
    }

    // Wait for 3 seconds before closing the connection
    Timer(const Duration(seconds: 15), () {
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
}
