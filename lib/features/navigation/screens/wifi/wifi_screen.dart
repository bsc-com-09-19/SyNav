// import "package:flutter/material.dart";
// import 'dart:async';
// import 'package:flutter/services.dart';

// class WifiScreen extends StatefulWidget {
//   const WifiScreen({super.key});

//   @override
//   State<WifiScreen> createState() => _WifiScreenState();
// }

// class _WifiScreenState extends State<WifiScreen> {
//   // Creating a MethodChannel linked to the specified channel name.
//   static const platform = MethodChannel('com.example.wifi/wifi');

//   // List to hold the Wi-Fi networks (SSID and RSSI).
//   List<String> _wifiList = [];

//   // Asynchronous method to fetch the Wi-Fi list via the MethodChannel.
//   Future<void> _getWifiList() async {
//     List<String> wifiList;
//     try {
//       // Invoke the 'getWifiList' method on the native side and cast the result to List<String>.
//       final List<dynamic> result = await platform.invokeMethod('getWifiList');
//       wifiList = result.cast<String>();
//     } on PlatformException catch (e) {
//       // Handle the case where the platform method does not succeed.
//       wifiList = ["Failed to get Wi-Fi list: '${e.message}'"];
//     }

//     print(wifiList.length);

//     // Update the state with the new Wi-Fi list.
//     setState(() {
//       _wifiList = wifiList;
//     });
//   }

//   @override
//   void initState() {
//     super.initState();
//     _getWifiList();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           actions: [
//             IconButton(onPressed: _getWifiList, icon: const Icon(Icons.refresh))
//           ],
//           title: const Text('Available Wi-Fi Networks'),
//         ),
//         body: ListView.builder(
//           itemCount: _wifiList.length,
//           itemBuilder: (context, index) {
//             return ListTile(
//               title: Text(_wifiList[index]),
//             );
//           },
//         ),
//       ),
//     );
//   }
// }

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
