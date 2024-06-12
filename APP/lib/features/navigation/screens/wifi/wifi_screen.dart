import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/common/widgets/access_point_dialog.dart';
import 'package:sy_nav/features/navigation/screens/wifi/controllers/wifi_controller.dart';
import 'package:sy_nav/features/navigation/screens/wifi/model/wifi_network.dart';
import 'package:sy_nav/features/navigation/screens/wifi/services/wifi_network_service.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_algorithms.dart';

class WifiScreen extends StatelessWidget {
  WifiScreen({Key? key}) : super(key: key);

  final wifiController = Get.find<WifiController>();

  @override
  Widget build(BuildContext context) {
    int itemCount = wifiController.wifiList.length;

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Obx(() => ListView.builder(
            itemCount: wifiController.wifiList.length,
            itemBuilder: (context, index) {
              if (wifiController.wifiList.isEmpty ||
                  (index == 0 &&
                      wifiController.wifiList[0].startsWith("Failed"))) {
                print(
                    "Index: $index value is ${wifiController.wifiList[index]}");
                return kCenter();
              }

              List<String> wifiDetails =
                  wifiController.wifiList[index].split('#');
              print(
                  "Number: ${itemCount}, ${wifiDetails[0]}, ${wifiDetails[1]}");

              String macAddress = wifiDetails[0];
              double rssi = double.parse(wifiDetails[1]);
              double distance =
                  WifiAlgorithms.estimateDistance(rssi).toPrecision(2);
              return GestureDetector(
                onTap: () {
                  // Show the dialog box when ListTile is tapped
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AddAccessPointDialog(
                        macAddress: macAddress,
                      ); // Display the dialog box
                    },
                  );
                },
                child: ListTile(
                  title: Text(wifiController.wifiList[index]),
                  subtitle: Text("RSSI: $rssi, Distance is:  $distance"),
                ),
              );
            },
          )),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     actions: [
    //       IconButton(
    //           onPressed: () => wifiController.getWifiList(),
    //           icon: const Icon(Icons.refresh))
    //     ],
    //     title: const Text('Available Wi-Fi Networks'),
    //   ),
    //   body: Obx(() => ListView.builder(
    //         itemCount: wifiController.wifiList.length,
    //         itemBuilder: (context, index) {
    //           if (wifiController.wifiList.isEmpty ||
    //               (index == 0 &&
    //                   wifiController.wifiList[0].startsWith("Failed"))) {
    //             print(
    //                 "Index: $index value is ${wifiController.wifiList[index]}");
    //             return kCenter();
    //           }

    //           List<String> wifiDetails =
    //               wifiController.wifiList[index].split('#');
    //           print(
    //               "Number: ${itemCount}, ${wifiDetails[0]}, ${wifiDetails[1]}");

    //           String macAddress = wifiDetails[0];
    //           double rssi = double.parse(wifiDetails[1]);
    //           String ssid = wifiDetails[2];
    //           double distance =
    //               WifiAlgorithms.estimateDistance(rssi).toPrecision(2);
    //           return GestureDetector(
    //             onTap: () {
    //               // Show the dialog box when ListTile is tapped
    //               showDialog(
    //                 context: context,
    //                 builder: (BuildContext context) {
    //                   return AddAccessPointDialog(
    //                     macAddress: macAddress,
    //                   ); // Display the dialog box
    //                 },
    //               );
    //             },
    //             child: ListTile(
    //               title: Text(wifiController.wifiList[index]),
    //               subtitle: Text("RSSI: $rssi, Distance is:  $distance"),
    //             ),
    //           );
    //         },
    //       )),
    // );
  }

  Widget kCenter() {
    return const Center(
      child: Text("No wifi available"),
    );
  }

  void saveWifi() async {
    AccessPoint newAccessPoint = AccessPoint(
      bssid: '00:0a:95:9d:68:16',
      latitude: 37.422,
      longitude: -122.084,
      frequency: '2.4 GHz',
    );
    await WifiNetworkService.addWifiNetwork(newAccessPoint);
  }
}
