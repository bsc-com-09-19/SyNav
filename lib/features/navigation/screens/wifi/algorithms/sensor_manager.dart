// sensor_manager.dart
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_algorithms.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';

class SensorManager {
  static const MethodChannel _sensorChannel =
      MethodChannel('com.example.sy_nav/sensors');

  WifiController wifiController = Get.find<WifiController>();
  HomeController homeController = Get.find<HomeController>();

  SensorManager() {
    _sensorChannel.setMethodCallHandler(_sensorHandler);
  }

  final List<double> _accelerometerValues = [0, 0, 0];
  final List<double> _gyroscopeValues = [0, 0, 0];

  Future<void> _sensorHandler(MethodCall call) async {
    if (call.method == "sensorData") {
      final Map<String, dynamic> sensorData =
          Map<String, dynamic>.from(call.arguments);

      //updating the sensor values
      if (sensorData['type'] == 'accelerometer') {
        _accelerometerValues.setAll(0, List<double>.from(sensorData['values']));
        // wifiController.accelerometerValues.value = _accelerometerValues;
      } else if (sensorData['type'] == 'gyroscope') {
        _gyroscopeValues.setAll(0, List<double>.from(sensorData['values']));
        // wifiController.gyroscopeValues.value = _gyroscopeValues;
      }
    }

    // Call the location update method
    _updateLocation();
  }

  void _updateLocation() {
    // Estimate the new location based on the sensor data and WiFi data
    final location = WifiAlgorithms.getEstimatedLocation(
        wifiController.wifiList.value,
        sensorManager: this);
    homeController.updateLocation(location);
  }

  List<double> get accelerometerValues =>
      List.unmodifiable(_accelerometerValues);
  List<double> get gyroscopeValues => List.unmodifiable(_gyroscopeValues);
}
