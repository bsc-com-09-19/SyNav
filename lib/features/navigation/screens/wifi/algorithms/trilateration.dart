import 'dart:math';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/wifi_scanner.dart';
import 'package:vector_math/vector_math.dart' as vec;

/// WiFiAccessPoint represents a Wi-Fi access point with a known location.
class WiFiAccessPoint {
  final String bssid;
  final double x;
  final double y;

  WiFiAccessPoint({required this.bssid, required this.x, required this.y});
}



/// Converts RSSI to distance.
double rssiToDistance(int rssi) {
  const int A = -50; // RSSI at 1 meter distance
  const double n = 2.0; // Path-loss exponent
  return pow(10, (A - rssi) / (10 * n)) as double;
}

/// Performs trilateration to estimate the user's position based on Wi-Fi networks and access points.
Map<String, double> trilaterate(
    List<WiFiNetwork> networks, List<WiFiAccessPoint> accessPoints) {
  List<Map<String, double>> positions = [];
  List<double> distances = [];

  




  // for (var network in networks) {
  //   WiFiAccessPoint? ap = accessPoints
  //       .firstWhere((ap) => ap.bssid == network.bssid, orElse: () => null);
  //   if (ap != null) {
  //     positions.add({'x': ap.x, 'y': ap.y});
  //     distances.add(rssiToDistance(network.rssi));
  //   }
  // }

  if (positions.length < 3) {
    throw Exception(
        "At least 3 valid access points are required for trilateration");
  }

  int N = positions.length;
  List<double> A = [];
  List<double> B = [];
  List<double> W = [];

  for (int i = 0; i < N; i++) {
    double x = positions[i]['x']!;
    double y = positions[i]['y']!;
    double r = distances[i];

    for (int j = i + 1; j < N; j++) {
      double x2 = positions[j]['x']!;
      double y2 = positions[j]['y']!;
      double r2 = distances[j];

      A.add(2 * (x2 - x));
      A.add(2 * (y2 - y));
      B.add(pow(r, 2) -
          pow(r2, 2) -
          pow(x, 2) +
          pow(x2, 2) -
          pow(y, 2) +
          pow(y2, 2) as double);

      // Compute weight as the inverse of the distance difference (optional)
      double weight = 1.0 / (r + r2);
      W.add(weight);
      W.add(weight);
    }
  }

  // Solve for position using least squares
  var AtW = vec.Matrix2(
    A[0] * W[0],
    A[A.length ~/ 2] * W[0],
    A[A.length ~/ 2] * W[1],
    A[A.length - 1] * W[1],
  );

  var BVector = vec.Vector2(B[0] * W[0], B[1] * W[1]);

  var X = AtW.transposed() * AtW.invert() * (AtW.transposed() * BVector);

  return {'x': X.x, 'y': X.y};
}
