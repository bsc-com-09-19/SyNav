// // fusion_algorithm.dart
// import 'dart:math';

// import 'package:sy_nav/features/navigation/screens/wifi/algorithms/position_kalman_filter.dart';
// import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_algorithms.dart';
// import 'package:sy_nav/features/navigation/screens/wifi/model/sensor_data.dart';

// class FusionAlgorithm {
//   final SensorData sensorData = SensorData();
//   final KalmanFilter kalmanFilterX = KalmanFilter();
//   final KalmanFilter kalmanFilterY = KalmanFilter();

//   Point<double> fuseData(List<String> wifiList) {
//     final estimatedLocation = WifiAlgorithms.getEstimatedLocation(wifiList);
//     final acceleration = sensorData.getAcceleration();
//     final gyroscope = sensorData.getGyroscope();

//     // simple integration of accelerometer data to estimate position change
//     // and gyroscope data to correct the direction.

//     // Kalman filter update with sensor data
//     final newX = kalmanFilterX.filter(estimatedLocation.x + 0.01 * acceleration[0]);
//     final newY = kalmanFilterY.filter(estimatedLocation.y + 0.01 * acceleration[1]);

//     return Point(newX, newY);
//   }
// }
