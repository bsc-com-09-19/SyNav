import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:alan_voice/alan_voice.dart';
import 'package:get_storage/get_storage.dart';
import 'package:sy_nav/bindings/home_binding.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/home/home.dart';
import 'package:sy_nav/features/navigation/screens/navigation/navigationScreen.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/sensor_manager.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_algorithms.dart';
import 'package:sy_nav/firebase_options.dart';
import 'package:sy_nav/utils/alan/alanutils.dart';
import 'package:sy_nav/utils/constants/colors.dart';
import 'package:sy_nav/utils/themes/theme.dart';
import 'package:sy_nav/utils/widgets/k_snack_bar.dart';

import 'features/navigation/screens/nofications/notifications_screen.dart';

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
  );
  AlanVoice.callbacks.add((command) => _handleCommand(command.data));

  // Enable the wake word
  AlanVoice.setWakewordEnabled(true);

  // Check if the wake word is enabled
  var enabled = await AlanVoice.getWakewordEnabled();
  if (kDebugMode) {
    print('Wake word enabled: $enabled');
  }

  AlanVoice.activate();
  AlanVoiceUtils.playText("Welcome to SyNav app, I am your voice assistant!");
}

void _initWifi() async {
  final wifiController = Get.put<WifiController>(WifiController());
  final homeController = Get.put<HomeController>(HomeController());

  final sensorManager = SensorManager(
      wifiController: wifiController, homeController: homeController);

  await wifiController.getWifiList();

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    await wifiController.getWifiList();
    List<String> wifiList = wifiController.getTrilaterationWifi();

    if (wifiList.isNotEmpty) {
      homeController.updateLocation(WifiAlgorithms.getEstimatedLocation(
          wifiList,
          sensorManager: sensorManager));
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

  BuildContext? context = navigatorKey.currentContext;

  switch (command) {
    case 'Home':
      homeController.currentIndex.value = 0;
      AlanVoiceUtils.playText("You are in the Home screen");
      break;
    // case 'Bookmarks':
    //   homeController.currentIndex.value = 1;
    //   homeController.appBarTitle.value = "Bookmarks";
    //   AlanVoiceUtils.playText("You are in the Bookmarks screen");
    //   break;
    case 'room A':
      AlanVoiceUtils.playText("Searching for room A");
      var locationCell = wifiController.grid.value.findCellByName("Room A");
      if (locationCell != null) {
        var distance = -1.0;
        var currentLocation = wifiController.grid.value.findCellByCoordinates(
            homeController.location.value.x, homeController.location.value.y);
        if (currentLocation != null) {
          distance = wifiController.grid.value
              .calculateDistance(currentLocation, locationCell);
        }
        AlanVoiceUtils.playText(
            "room A is available ${(distance == -1) ? "" : " and the distance is $distance meters from your location"}");
      } else {
        AlanVoiceUtils.playText("room A is not available");
      }
      break;
    case 'room X':
      AlanVoiceUtils.playText("Searching for room X");
      var locationCell = wifiController.grid.value.findCellByName("Room X");
      if (locationCell != null) {
        AlanVoiceUtils.playText("Room X is available");
      } else {
        AlanVoiceUtils.playText("Room X is not available");
      }
      break;
    case 'room Y':
      AlanVoiceUtils.playText("Searching for room Y");
      var locationCell = wifiController.grid.value.findCellByName("Room Y");
      if (locationCell != null) {
        AlanVoiceUtils.playText("Room Y is available");
      } else {
        AlanVoiceUtils.playText("Room Y is not available");
      }
      break;
    case 'Navigate':
      homeController.appBarTitle.value = "Buildings";
      homeController.currentIndex.value = 1;
      AlanVoiceUtils.playText("You are in the Navigate screen");
      break;
    case 'History':
      homeController.appBarTitle.value = "History";
      homeController.currentIndex.value = 2;
      AlanVoiceUtils.playText("You are in the History screen");
      break;
    // case 'Explore':
    //   AlanVoiceUtils.playText("You are in the Explore screen");
    //   break;
    case 'Location':
      if (wifiController.wifiList.length < 3) {
        AlanVoiceUtils.playText(
            "You don't have enough registered access points around you but your previous location was ${homeController.location.value}");
        showErrorSnackBAr(context!,
            "You don't have enough registered access points around you (${wifiController.wifiList.length} APs)");
      } else {
        List<String> wifiList = await wifiController.getTrilaterationWifi();
        Point<double> estimatedLocation = homeController.location.value;
        homeController.location.value = estimatedLocation;
        // Convert the location to a string and use Alan to announce it
        String locationString =
            "Your location is: ${homeController.location.value.x}, ${homeController.location.value.y}";
        AlanVoiceUtils.playText(locationString);
        AlanVoiceUtils.playText(locationString);
      }
      break;
    default:
      AlanVoiceUtils.playText(
          "You can tell me to: go to Bookmarks, Home, Notifications, Navigate, or Explore");
      break;
  }

  Timer(const Duration(seconds: 10), () {
    _closeAlanConnection();
  });

  AlanVoiceUtils.playText("Welcome to SyNav app, I am your voice assistant!");
}

void _closeAlanConnection() {
  AlanVoice.deactivate();
}

class SyNavApp extends StatelessWidget {
  SyNavApp({super.key});

  final List<GetPage> appRoutes = [
    GetPage(
      name: '/',
      page: () => const Home(),
    ),
    // GetPage(
    //   name: '/explore',
    //   page: () => const Home(),
    // ),
    // GetPage(
    //   name: '/bookmarks',
    //   page: () => WifiScreen(),
    // ),
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
      navigatorKey: navigatorKey,
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
}
