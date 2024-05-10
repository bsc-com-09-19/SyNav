import 'package:sy_nav/features/navigation/screens/wifi/model/wifi_network.dart';

class Dummy {
  final accessPoints = [
    // node 1
    AccessPoint(
      bssid: "de:ba:ef:7d:57:a5",
      latitude: 0.0,
      longitude: 10.0,
      frequency: "5 GHz", // Or any other frequency value
    ),
    // node 2
    AccessPoint(
      bssid: "ce:eb:bd:7e:27:39",
      latitude: 0.0,
      longitude: 0.0,
      frequency: "2.4 GHz",
    ),
    // node 3
    AccessPoint(
      bssid: "ce:eb:bd:58:9b:01",
      latitude: 12.0,
      longitude: 10.0,
      frequency: "2.4 GHz", // Or any other frequency value
    ),
    // node 5
    AccessPoint(
      bssid: "de:ba:ef:b8:69:d7",
      latitude: 10.0,
      longitude: 10.0,
      frequency: "5 GHz",
    ),
    // node 6
    AccessPoint(
      bssid: "ce:eb:bd:57:d2:2f",
      latitude: 10.0,
      longitude: 0.0,
      frequency: "2.4 GHz",
    ),
  ];
}

// "ce:eb:bd:58:9b:01 Node 3"
//"ce:eb:bd:57:d2:2f node 6"
// "ce:eb:bd:7e:27:39 Node 2"
// "de:ba:ef:7d:57:a5 Node 1"
// "de:ba:ef:b8:69:d7 Node 5"