class WifiConstants {
  // Define path loss model parameters
  static const referenceSignalStrength =
      -30.0; // Reference signal strength at reference distance (in dBm)
  static const referenceDistance = 1.0; // Reference distance (in meters)
  static const pathLossExponent = 3.5; // Path loss exponent

  // Define path loss model parameters for different RSSI ranges
  static const referenceSignalStrengths = [
    -30.0, // For high RSSI (close to the access point)
    -50.0, // For mid RSSI
    -60.0, // For low RSSI (far from the access point)
  ];

  static const pathLossExponents = [
    2.0, // For high RSSI
    6.0, // For mid RSSI
    14.0, // For low RSSI
  ];
}
