import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// WiFiNetwork represents a Wi-Fi network with its SSID, BSSID, and RSSI.
class WiFiNetwork {
  final String ssid;
  final String bssid;
  final int rssi;

  WiFiNetwork({required this.ssid, required this.bssid, required this.rssi});

  /// Creates a WiFiNetwork instance from a map.
  factory WiFiNetwork.fromMap(Map<String, dynamic> map) {
    return WiFiNetwork(
      ssid: map['ssid'],
      bssid: map['bssid'],
      rssi: map['rssi'],
    );
  }
}

/// WiFiScanner provides functionality to scan for Wi-Fi networks.
class WiFiScanner {
  static const platform = MethodChannel('com.example.wifi_scanner');

  /// Scans for available Wi-Fi networks and returns a list of WiFiNetwork instances.
  Future<List<WiFiNetwork>> scanForWiFi() async {
    try {
      final List networks = await platform.invokeMethod('scanForWiFi');
      return networks.map((network) => WiFiNetwork.fromMap(network)).toList();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to scan for Wi-Fi: '${e.message}'.");
      }
      return [];
    }
  }
}
