
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
