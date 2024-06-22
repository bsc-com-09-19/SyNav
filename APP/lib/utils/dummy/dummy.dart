import 'package:sy_nav/features/navigation/screens/wifi/model/wifi_network.dart';

class Dummy {
  static final accessPoints = [
    // node 1
    AccessPoint(
      bssid: "de:ba:ef:7d:57:a5",
      latitude: 0.0,
      longitude: 8.0,
      frequency: "2.4 GHz", // Or any other frequency value
    ),
    // node 2
    AccessPoint(
      bssid: "de:ba:ef:b8:80:e5",
      latitude: 0.0,
      longitude: 0.0,
      frequency: "2.4 GHz",
    ),
    // node 3
    AccessPoint(
      bssid: "ce:eb:bd:58:9b:01",
      latitude: 7.0,
      longitude: 6.0,
      frequency: "2.4 GHz", // Or any other frequency value
    ),
    // node 5
    AccessPoint(
      bssid: "de:ba:ef:b8:69:d7",
      latitude: 6.0,
      longitude: 5.0,
      frequency: "5 GHz",
    ),
    // node 6
    AccessPoint(
      bssid: "ce:eb:bd:57:d2:2f",
      latitude: 6.0,
      longitude: 0.5,
      frequency: "2.4 GHz",
    ),
    // Isulu mifi
    AccessPoint(
      bssid: "98:a9:42:3b:29:57",
      latitude: 12.7,
      longitude: 1,
      frequency: "2.4 GHz",
    ),

    // LAB -MYPC
    AccessPoint(
      bssid: "de:ba:ef:98:0f:fb",
      latitude: 4.0,
      longitude: 0.0,
      frequency: "2.4 GHz",
    ),
    // LAB -BRIE FAINDANI - PC
    AccessPoint(
      bssid: "de:ba:ef:b8:80:3b",
      latitude: 4.0,
      longitude: 0.0,
      frequency: "2.4 GHz",
    ),
    // LAB -Bester - PC
    AccessPoint(
      bssid: "de:ba:ef:a2:3c:df",
      latitude: 6.0,
      longitude: 0.0,
      frequency: "2.4 GHz",
    ),
    // LAB -3rd from bester - PC
    AccessPoint(
      bssid: "de:ba:ef:98:11:73",
      latitude: 6.0,
      longitude: 2.0,
      frequency: "2.4 GHz",
    ),

    // NETGEAR
    AccessPoint(
      bssid: "78:d2:94:9a:b1:53",
      longitude: 4.2,
      latitude: 9,
      frequency: "2.4 GHz",
    ),

    // tnm dlink
    AccessPoint(
      bssid: "3c:fa:d3:96:99:63",
      longitude: 1.5,
      latitude: 2.0,
      frequency: "2.4 GHz",
    ),

    // mami chide
    AccessPoint(
      bssid: "98:a9:42:57:71:f0",
      longitude: 9.6,
      latitude: 1.2,
      frequency: "2.4 GHz",
    ),
    // ce74
    AccessPoint(
      bssid: "98:a9:42:85:ce:74",
      longitude: 12.7,
      latitude: 15.3,
      frequency: "2.4 GHz",
    ),
    // ced5
    AccessPoint(
      bssid: "98:a9:42:85:cc:d5",
      longitude: 1,
      latitude: 1,
      frequency: "2.4 GHz",
    ),
    // ce5f
    AccessPoint(
      bssid: "98:a9:42:85:ce:5f",
      longitude: 1,
      latitude: 15.3,
      frequency: "2.4 GHz",
    ),
  ];
}
//98:a9:42:85:ce:74  ce74
//98:a9:42:85:cc:d5  ced5
//98:a9:42:85:ce:5f  ce5f

// "3c:fa:d3:96:99:63#-50#dlink_DWR-930M_1963"// 78:d2:94:9a:b1:53 netgear
// "de:ba:ef:98:11:73#-42#com1"
// "de:ba:ef:a2:3c:df#-31#sure"
// "de:ba:ef:b8:80:3b#-46#grant"
// "98:a9:42:3b:29:57#-22#Mr Isu"
// "de:ba:ef:98:0f:fb#-31#midpoint"

// "ce:eb:bd:58:9b:01 Node 3"
//"ce:eb:bd:57:d2:2f node 6"
// "ce:eb:bd:7e:27:39 Node 2"
// "de:ba:ef:7d:57:a5 Node 1"
// "de:ba:ef:b8:69:d7 Node 5"