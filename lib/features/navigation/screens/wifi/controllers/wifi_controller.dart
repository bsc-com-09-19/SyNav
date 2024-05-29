import 'package:get/get.dart';
import 'package:flutter/services.dart';

class WifiController extends GetxController {
  var wifiList = <String>[].obs;
  static const platform = MethodChannel('com.example.sy_nav/wifi');

  @override
  void onInit() {
    super.onInit();
    getWifiList();
    // Listen for updates when the app starts
    listenForWifiUpdates();
  }

  Future<void> getWifiList() async {
    try {
      final List<dynamic> result = await platform.invokeMethod('getWifiList');
      wifiList.value = result.cast<String>();
    } on PlatformException catch (e) {
      wifiList.value = ["Failed to get Wi-Fi list: '${e.message}'"];
    }
  }

  void listenForWifiUpdates() {
    platform.setMethodCallHandler((call) async {
      if (call.method == 'updateWifiList') {
        final List<dynamic> result = call.arguments;
        wifiList.value = result.cast<String>();
      }
    });
  }

  ///GEts the first 5 access points from the available APs to be used for trilateration. 
  ///Only works if the number of available of APs is atleast 3. 
  ///if the number of APs is less than 5, either 3 or 4 it will still return thos
  List<String> getTrilaterationWifi() {
    if (wifiList.isNotEmpty && wifiList.length >= 3) {
      return wifiList.take(5).toList();
    } else {
      return [];
    }
  }
}
