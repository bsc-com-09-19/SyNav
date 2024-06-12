// import 'dart:async';
// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:sensors_plus/sensors_plus.dart';
// import 'package:sy_nav/features/navigation/screens/wifi/algorithms/position_kalman_filter.dart';
// import 'package:sy_nav/features/navigation/screens/wifi/algorithms/trilateration.dart';
// import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_scanner.dart';

// /// LocationTracker is the main widget that tracks and displays the user's location.
// class LocationTracker extends StatefulWidget {
//   const LocationTracker({super.key});

//   @override
//   _LocationTrackerState createState() => _LocationTrackerState();
// }

// class _LocationTrackerState extends State<LocationTracker> {
//   final WiFiScanner wifiScanner = WiFiScanner();
//   final PositionKalmanFilter kalmanFilterX = PositionKalmanFilter(0.0001, 0.1);
//   final PositionKalmanFilter kalmanFilterY = PositionKalmanFilter(0.0001, 0.1);

//   double userX = 0;
//   double userY = 0;

//   double velocityX = 0;
//   double velocityY = 0;
//   double accelerationX = 0;
//   double accelerationY = 0;

//   double orientation = 0; // Orientation angle

//   List<WiFiAccessPoint> accessPoints = [
//     WiFiAccessPoint(bssid: '00:11:22:33:44:55', x: 0.0, y: 0.0),
//     WiFiAccessPoint(bssid: '66:77:88:99:AA:BB', x: 10.0, y: 0.0),
//     WiFiAccessPoint(bssid: 'CC:DD:EE:FF:00:11', x: 5.0, y: 8.66),
//   ];

//   @override
//   void initState() {
//     super.initState();

//     // Schedule periodic Wi-Fi scans
//     Timer.periodic(const Duration(seconds: 5), (timer) async {
//       List<WiFiNetwork> networks = await wifiScanner.scanForWiFi();
//       Map<String, double> position = trilaterate(networks, accessPoints);
//       updatePosition(position['x']!, position['y']!);
//     });

//     // Listen to accelerometer updates
//     accelerometerEventStream().listen((AccelerometerEvent event) {
//       accelerationX = event.x;
//       accelerationY = event.y;
//     });

// // Listen to gyroscope updates
//     gyroscopeEventStream().listen((GyroscopeEvent event) {
//       orientation += event.z * (1 / 60); // Assuming 60 Hz update rate
//     });

//     // Update position based on sensor data periodically
//     Timer.periodic(const Duration(milliseconds: 100), (timer) {
//       updatePositionWithSensors();
//     });
//   }

//   /// Updates the position estimate using sensor data.
//   void updatePositionWithSensors() {
//     // Calculate velocity using the accelerometer data
//     velocityX += accelerationX * 0.1; // 0.1 seconds interval
//     velocityY += accelerationY * 0.1;

//     // Calculate the displacement
//     double deltaX = velocityX * 0.1;
//     double deltaY = velocityY * 0.1;

//     // Adjust the displacement based on the current orientation
//     double adjustedDeltaX =
//         deltaX * cos(orientation) - deltaY * sin(orientation);
//     double adjustedDeltaY =
//         deltaX * sin(orientation) + deltaY * cos(orientation);

//     // Update the user's position
//     setState(() {
//       userX += adjustedDeltaX;
//       userY += adjustedDeltaY;

//       // Update Kalman filter
//       userX = kalmanFilterX.filter(userX);
//       userY = kalmanFilterY.filter(userY);
//     });
//   }

//   /// Updates the position estimate using Wi-Fi trilateration data.
//   void updatePosition(double x, double y) {
//     setState(() {
//       userX = kalmanFilterX.filter(x);
//       userY = kalmanFilterY.filter(y);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return buildUserLocationCard(userX, userY);
//   }

//   Widget buildUserLocationCard(double userX, double userY) {
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Text(
//           'User Position: ($userX, $userY)',
//           style: const TextStyle(fontSize: 16.0),
//         ),
//       ),
//     );
//   }
// }
