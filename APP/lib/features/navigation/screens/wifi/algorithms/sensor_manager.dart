// sensor_manager.dart
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_algorithms.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';

class SensorManager {
  static const MethodChannel _sensorChannel =
      MethodChannel('com.example.sy_nav/sensors');

  final WifiController wifiController;
  final HomeController homeController;

  SensorManager({required this.wifiController, required this.homeController}) {
    //ensures that the method executed once the object has been constructed
    _sensorChannel.setMethodCallHandler(_sensorHandler);
  }

  final List<double> _accelerometerValues = [0, 0, 0];
  final List<double> _gyroscopeValues = [0, 0, 0];
  final List<double> _previousAccelerometerValues = [0, 0, 0];
  final List<double> _previousGyroscopeValues = [0, 0, 0];

  Future<void> _sensorHandler(MethodCall call) async {
    if (call.method == "sensorData") {
      final Map<String, dynamic> sensorData =
          Map<String, dynamic>.from(call.arguments);

      //updating the sensor values
      if (sensorData['type'] == 'accelerometer') {
        _previousAccelerometerValues.setAll(0, _accelerometerValues);
        _accelerometerValues.setAll(0, List<double>.from(sensorData['values']));
        // wifiController.accelerometerValues.value = _accelerometerValues;
      } else if (sensorData['type'] == 'gyroscope') {
        _previousGyroscopeValues.setAll(0, _gyroscopeValues);
        _gyroscopeValues.setAll(0, List<double>.from(sensorData['values']));
        // wifiController.gyroscopeValues.value = _gyroscopeValues;
      }
    }

    // Call the location update method
    // _updateLocation();
  }

  ///Updates the user's location based on sensor data and WI-FI trilateration
  void _updateLocation() {
    var lastKnownLocation = homeController.location.value;

    //use filtered sensor data for calculate the movement made by the based on the accelerometer
    var estimatedMovement = _estimateMovement(
        _accelerometerValues,
        _previousAccelerometerValues,
        _gyroscopeValues,
        _previousGyroscopeValues);

    var updatedLocation = Point(lastKnownLocation.x + estimatedMovement.x,
        lastKnownLocation.y + estimatedMovement.y);

    // // Estimate the new location based on the sensor data and WiFi data
    // final location = WifiAlgorithms.getEstimatedLocation(
    //     wifiController.getTrilaterationWifi(),
    //     sensorManager: this);
    // homeController.updateLocation(location);

    if (_shouldTriggerWifiUpdate()) {
      var wifiLocation = WifiAlgorithms.getEstimatedLocation(
          wifiController.getTrilaterationWifi(), sensorManager: this);
      homeController.updateLocation(wifiLocation);
    } else {
      homeController.updateLocation(updatedLocation);
    }
  }

  /// Estimates the movement based on accelerometer and gyroscope data.
  Point _estimateMovement(List<double> accelCurrent, List<double> accelPrev,
      List<double> gyroCurrent, List<double> gyroPrev) {
    // accelerometerValues = [ax, ay, az]
    // gyroscopeValues = [gx, gy, gz]
    // Basic dead reckoning estimation

    double deltaTime = 0.6; // Example time difference in seconds

    double dx = (accelCurrent[0] - accelPrev[0]) * deltaTime * deltaTime * 0.5;
    double dy = (accelCurrent[1] - accelPrev[1]) * deltaTime * deltaTime * 0.5;

    double directionChange = gyroCurrent[2] - gyroPrev[2];

    double movedX = dx * cos(directionChange);
    double movedY = dy * sin(directionChange);

    return Point(movedX, movedY);
  }

  bool _shouldTriggerWifiUpdate() {
    const double accelerometerThreshold = 1.0;
    const double gyroscopeThreshold = 0.1;

    return _isSignificantMovement(_accelerometerValues,
            _previousAccelerometerValues, accelerometerThreshold) ||
        _isSignificantMovement(
            _gyroscopeValues, _previousGyroscopeValues, gyroscopeThreshold);
  }

  bool _isSignificantMovement(
      List<double> newValues, List<double> oldValues, double threshold) {
    for (int i = 0; i < newValues.length; i++) {
      if ((newValues[i] - oldValues[i]).abs() > threshold) {
        return true;
      }
    }
    return false;
  }

  List<double> get accelerometerValues =>
      List.unmodifiable(_accelerometerValues);
  List<double> get gyroscopeValues => List.unmodifiable(_gyroscopeValues);
}
