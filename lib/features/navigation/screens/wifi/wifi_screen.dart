import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';

class WifiScreen extends StatelessWidget {
  WifiScreen({Key? key}) : super(key: key);

  final WifiController wifiController = Get.put(WifiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () => wifiController.getWifiList(),
              icon: const Icon(Icons.refresh))
        ],
        title: const Text('Available Wi-Fi Networks'),
      ),
      body: Obx(() => ListView.builder(
            itemCount: wifiController.wifiList.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(wifiController.wifiList[index]),
              );
            },
          )),
    );
  }
}
