import 'dart:convert';

class AccessPoint {
  final String bssid;
  final double latitude;
  final double longitude;
  final String frequency;

  AccessPoint(
      {required this.frequency,
      required this.bssid,
      required this.latitude,
      required this.longitude});

  // Convert a AccessPoint object into a Map for Firebase.
  Map<String, dynamic> toJson() {
    return {
      'bssid': bssid,
      'latitude': latitude,
      'longitude': longitude,
      'frequency': frequency,
    };
  }

  // Create a AccessPoint object from a Map (Firebase snapshot).
  factory AccessPoint.fromJson(Map<String, dynamic> json) {
    return AccessPoint(
      bssid: json['bssid'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      frequency: json['frequency'],
    );
  }

  static List<AccessPoint> decodeJsonList(String jsonList) {
    List<dynamic> decodedList = json.decode(jsonList);
    return decodedList.map((e) => AccessPoint.fromJson(e)).toList();
  }

  static String encodeJsonList(List<AccessPoint> accessPoints) {
    List<Map<String, dynamic>> jsonList =
        accessPoints.map((e) => e.toJson()).toList();
    return json.encode(jsonList);
  }
}
