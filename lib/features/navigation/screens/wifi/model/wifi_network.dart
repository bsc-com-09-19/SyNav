class WifiNetwork {
  final String bssid;
  final double latitude;
  final double longitude;

  WifiNetwork({required this.bssid, required this.latitude, required this.longitude});

  // Convert a WifiNetwork object into a Map for Firebase.
  Map<String, dynamic> toJson() {
    return {
      'bssid': bssid,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  // Create a WifiNetwork object from a Map (Firebase snapshot).
  factory WifiNetwork.fromJson(Map<String, dynamic> json) {
    return WifiNetwork(
      bssid: json['bssid'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }
}
