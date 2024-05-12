// features/navigation/bindings/home_binding.dart (or similar location)

import 'package:get/get.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<WifiController>(WifiController());
    Get.put<HomeController>(HomeController());
  }
}
