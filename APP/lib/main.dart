import 'dart:async'; 
import 'dart:math'; 
import 'package:flutter/foundation.dart'; 
import 'package:flutter/material.dart'; 
import 'package:get/get.dart'; 
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart'; 
import 'package:alan_voice/alan_voice.dart'; 
import 'package:sy_nav/bindings/home_binding.dart'; 
import 'package:sy_nav/common/widgets/splash_screen.dart'; 
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart'; 
import 'package:sy_nav/features/navigation/screens/home/home.dart'; 
import 'package:sy_nav/features/navigation/screens/navigation/navigation_screen.dart'; 
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart'; 
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/sensor_manager.dart'; 
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_algorithms.dart'; 
import 'package:sy_nav/firebase_options.dart'; 
import 'package:sy_nav/utils/alan/alanutils.dart'; 
import 'package:sy_nav/utils/themes/theme.dart'; 
import 'package:sy_nav/utils/widgets/k_snack_bar.dart'; 
import 'features/navigation/screens/nofications/notifications_screen.dart'; 

final GlobalKey<NavigatorState> navigatorKey =
    GlobalKey<NavigatorState>(); // Define a global key for navigation

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensure Flutter binding is initialized

  /// Initializing the firebase
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions
          .currentPlatform); // Initialize Firebase with default options

  /// Enables local caching
  FirebaseDatabase.instance
      .setPersistenceEnabled(true); // Enable persistence for Firebase database

  runApp(SyNavApp()); // Run the SyNavApp

  await _initAlan(); // Initialize Alan voice assistant
  _initWifi(); // Initialize WiFi
}

// Function to initialize Alan voice assistant
Future<void> _initAlan() async {
  AlanVoice.addButton(
    "3e8015e10c102cb7e6efd807edc44b782e956eca572e1d8b807a3e2338fdd0dc/stage",
    buttonAlign: AlanVoice.BUTTON_ALIGN_LEFT,
  ); // Add Alan button with specified ID and alignment
  AlanVoice.callbacks.add((command) =>
      _handleCommand(command.data)); // Add command callback handler

  // Enable the wake word
  AlanVoice.setWakewordEnabled(true); // Enable wake word for Alan

  // Check if the wake word is enabled
  var enabled =
      await AlanVoice.getWakewordEnabled(); // Get wake word enabled status
  if (kDebugMode) {
    print(
        'Wake word enabled: $enabled'); // Print wake word status in debug mode
  }

  AlanVoice.activate(); // Activate Alan
  AlanVoiceUtils.playText(
      "Welcome to SyNav app, I am your voice assistant!"); // Play welcome text
}

// Function to initialize WiFi
void _initWifi() async {
  final wifiController = Get.put<WifiController>(
      WifiController()); // Create and put WiFi controller
  final homeController = Get.put<HomeController>(
      HomeController()); // Create and put Home controller

  final sensorManager = SensorManager(
      wifiController: wifiController,
      homeController: homeController); // Create sensor manager with controllers

  await wifiController.getWifiList(); // Get initial WiFi list

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    // Periodic timer to update WiFi list and location
    await wifiController.getWifiList(); // Get updated WiFi list
    List<String> wifiList =
        wifiController.getTrilaterationWifi(); // Get trilateration WiFi list

    if (wifiList.isNotEmpty) {
      // If WiFi list is not empty, update location
      homeController.updateLocation(WifiAlgorithms.getEstimatedLocation(
          wifiList,
          sensorManager:
              sensorManager)); // Update location using WiFi algorithms
      if (kDebugMode) {
        print(wifiController.getLocationName(
            homeController.location.value.x,
            homeController
                .location.value.y)); // Print location name in debug mode
      }
    } else {
      if (kDebugMode) {
        print("WiFi is empty"); // Print message if WiFi list is empty
      }
    }
  });
}

// Function to handle commands from Alan voice assistant
void _handleCommand(Map<String, dynamic> commandData) async {
  HomeController homeController =
      Get.find<HomeController>(); // Find Home controller
  WifiController wifiController =
      Get.find<WifiController>(); // Find WiFi controller
  String command = commandData['command']; // Get command from data

  BuildContext? context =
      navigatorKey.currentContext; // Get current context from navigator key

  switch (command) {
    case 'Home':
      homeController.currentIndex.value = 0; // Set current index to home
      AlanVoiceUtils.playText(
          "You are in the Home screen"); // Play text for home screen
      break;
    // case 'Bookmarks':
    //   homeController.currentIndex.value = 1;
    //   homeController.appBarTitle.value = "Bookmarks";
    //   AlanVoiceUtils.playText("You are in the Bookmarks screen");
    //   break;
    case 'room A':
      AlanVoiceUtils.playText(
          "Searching for room A"); // Play text for searching room A
      var locationCell = wifiController.grid.value
          .findCellByName("Room A"); // Find cell by name
      if (locationCell != null) {
        var distance = -1.0; // Initialize distance
        var currentLocation = wifiController.grid.value.findCellByCoordinates(
            homeController.location.value.x,
            homeController.location.value.y); // Find current location cell
        if (currentLocation != null) {
          distance = wifiController.grid.value.calculateDistance(
              currentLocation, locationCell); // Calculate distance to room A
        }
        AlanVoiceUtils.playText(
            "room A is available ${(distance == -1) ? "" : " and the distance is $distance meters from your location"}"); // Play text with distance
      } else {
        AlanVoiceUtils.playText(
            "room A is not available"); // Play text if room A is not available
      }
      break;
    case 'room X':
      AlanVoiceUtils.playText(
          "Searching for room X"); // Play text for searching room X
      var locationCell = wifiController.grid.value
          .findCellByName("Room X"); // Find cell by name
      if (locationCell != null) {
        AlanVoiceUtils.playText(
            "Room X is available"); // Play text if room X is available
      } else {
        AlanVoiceUtils.playText(
            "Room X is not available"); // Play text if room X is not available
      }
      break;
    case 'room Y':
      AlanVoiceUtils.playText(
          "Searching for room Y"); // Play text for searching room Y
      var locationCell = wifiController.grid.value
          .findCellByName("Room Y"); // Find cell by name
      if (locationCell != null) {
        AlanVoiceUtils.playText(
            "Room Y is available"); // Play text if room Y is available
      } else {
        AlanVoiceUtils.playText(
            "Room Y is not available"); // Play text if room Y is not available
      }
      break;
    case 'Navigate':
      homeController.appBarTitle.value =
          "Buildings"; // Set app bar title to Buildings
      homeController.currentIndex.value = 1; // Set current index to navigate
      AlanVoiceUtils.playText(
          "You are in the Navigate screen"); // Play text for navigate screen
      break;
    case 'History':
      homeController.appBarTitle.value =
          "History"; // Set app bar title to History
      homeController.currentIndex.value = 2; // Set current index to history
      AlanVoiceUtils.playText(
          "You are in the History screen"); // Play text for history screen
      break;
    // case 'Explore':
    //   AlanVoiceUtils.playText("You are in the Explore screen");
    //   break;
    case 'Location':
      if (wifiController.wifiList.length < 3) {
        AlanVoiceUtils.playText(
            "You don't have enough registered access points around you but your previous location was ${homeController.location.value}"); // Play text if not enough APs
        showErrorSnackBAr(context!,
            "You don't have enough registered access points around you (${wifiController.wifiList.length} APs)"); // Show error snackbar
      } else {
        Point<double> estimatedLocation =
            homeController.location.value; // Get estimated location
        homeController.location.value = estimatedLocation; // Update location
        // Convert the location to a string and use Alan to announce it
        String locationString =
            "Your location is: ${homeController.location.value.x}, ${homeController.location.value.y}"; // Convert location to string
        AlanVoiceUtils.playText(locationString); // Play text for location
        AlanVoiceUtils.playText(locationString); // Play text again
      }
      break;
    default:
      AlanVoiceUtils.playText(
          "You can tell me to: go to Bookmarks, Home, Notifications, Navigate, or Explore"); // Play default text for unknown command
      break;
  }

  Timer(const Duration(seconds: 10), () {
    _closeAlanConnection(); // Close Alan connection after 10 seconds
  });

  AlanVoiceUtils.playText(
      "Welcome to SyNav app, I am your voice assistant!"); // Play welcome text again
}

// Function to close Alan voice connection
void _closeAlanConnection() {
  AlanVoice.deactivate(); // Deactivate Alan
}

// Main app class
class SyNavApp extends StatelessWidget {
  SyNavApp({super.key}); // Constructor with key

  final List<GetPage> appRoutes = [
    GetPage(
      name: '/',
      page: () => const Home(), // Define home page route
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
      page: () => BuildingsScreen(), // Define navigate page route
    ),
    GetPage(
      name: "/history",
      page: () => const NotificationsScreen(), // Define history page route
    )
  ];

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false, // Disable debug banner
      title: "SyNav", // Set app title
      navigatorKey: navigatorKey, // Set navigator key
      home: const SplashScreen(), // Set home screen
      theme: KTheme.lightTheme, // Set light theme
      darkTheme: KTheme.darkTheme, // Set dark theme
      initialBinding: HomeBinding(), // Set initial binding
      getPages: appRoutes, // Set app routes
    );
  }
}
