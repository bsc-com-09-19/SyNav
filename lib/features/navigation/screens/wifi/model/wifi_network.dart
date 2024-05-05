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
}
