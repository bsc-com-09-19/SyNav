// import 'package:get/get.dart';
// import 'package:flutter/services.dart';

// class WifiController extends GetxController {
//   // Creating a MethodChannel linked to the specified channel name.
//   static const platform = MethodChannel('com.example.wifi/wifi');

//   // RxList to hold the Wi-Fi networks (SSID and RSSI).
//   var wifiList = <String>[].obs;

//   // Asynchronous method to fetch the Wi-Fi list via the MethodChannel.
//   Future<void> getWifiList() async {
//     try {
//       // Invoke the 'getWifiList' method on the native side and cast the result to List<String>.
//       final List<dynamic> result = await platform.invokeMethod('getWifiList');
//       wifiList.value = result.cast<String>();
//     } on PlatformException catch (e) {
//       // Handle the case where the platform method does not succeed.
//       wifiList.value = ["Failed to get Wi-Fi list: '${e.message}'"];
//     }
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     getWifiList();
//   }
// }


import 'package:get/get.dart';
import 'package:flutter/services.dart';

class WifiController extends GetxController {
  var wifiList = <String>[].obs;
  static const platform = MethodChannel('com.example.sy_nav/wifi');

  @override
  void onInit() {
    super.onInit();
    getWifiList();
  }

  Future<void> getWifiList() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getWifiList');
      wifiList.value = result.cast<String>();
    } on PlatformException catch (e) {
      wifiList.value = ["Failed to get Wi-Fi list: '${e.message}'"];
    }
  }
}
