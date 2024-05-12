import 'dart:math';
import 'package:get/get.dart';
import 'package:sy_nav/features/navigation/screens/wifi/model/wifi_network.dart';
import 'package:sy_nav/utils/constants/wifi_constants.dart';
import 'package:sy_nav/utils/dummy/dummy.dart';

class WifiAlgorithms {
  // Function to estimate distance based on signal strength using path loss model
  static double estimateDistance(double signalStrength) {
    return WifiConstants.referenceDistance *
        pow(
            10,
            ((WifiConstants.referenceSignalStrength - signalStrength) /
                (10 * WifiConstants.pathLossExponent)));
  }

  /// Estimates the user's location based on a list of scanned WiFi access points.

  /// This function takes a list of WiFi access points in a specific format as input
  /// and returns an estimated location as a Point object. The format of the WiFi
  /// access point list is expected to be comma-separated strings with the following structure:
  ///
  /// BSSID#level#SSID
  ///
  /// - BSSID: The unique identifier of the access point (e.g., "ce:eb:bd:58:9b:01").
  /// - level: The received signal strength indication (RSSI) of the access point (integer value).
  /// - SSID: The name of the WiFi network (optional, not used for location estimation).
  ///
  /// This function throws an exception if the provided list is empty or the first element
  /// indicates a failure.
  static Point<double> getEstimatedLocation(List<String> wifiList) {
    if (wifiList.isEmpty || wifiList[0].startsWith("Failed")) {
      throw Exception("Please provide a valid list");
    }

    /// Generate a list of APs with their locations
    // Map BSSID to AccessPoint object (assuming BSSID is unique)
    final accessPointMap = {for (var ap in Dummy.accessPoints) ap.bssid: ap};

    // Filter access points based on BSSIDs in wifiList
    final filteredBssids =
        wifiList.map((wifiEntry) => wifiEntry.split("#")[0]).toList();
    final accessPointList = Dummy.accessPoints
        .where((ap) => filteredBssids.contains(ap.bssid))
        .toList();

    // Create a map containing only valid access points and their estimated distances
    final locationMap = Map<String, double>.fromIterable(wifiList,
        key: (wifi) => wifi.split("#")[0], // Use BSSID from split string
        value: (wifi) {
          final bssid = wifi.split("#")[0];
          final accessPoint = accessPointMap[bssid];
          if (accessPoint != null) {
            final level = double.parse(wifi.split("#")[1]); // Parse level
            return estimateDistance(
                level); // Calculate distance using your function
          } else {
            // Handle case where access point not found (optional: return default value)
            return 0.0;
          }
        });

    // Extract distances from locationMap (assuming keys are BSSIDs)
    final distancesList = locationMap.values.toList();

    // Call the trilateration function with filtered access points and distances
    var trilaterationWithWeights2 = trilaterationWithWeights(
        accessPointList, distancesList, 0.7, 0.7, 0.7);
    return trilaterationWithWeights2;


  }

  static Point<double> dynamicWeightedTrilateration(
      List<AccessPoint> apList, List<double> distances) {
    if (apList.length < 3 && apList.length == distances.length) {
      throw Exception(
          "Number of access points is supposed to be 3 and has to be of same size with the distances array!!!");
    }
    // Constants (you can adjust these based on your scenario)
    const double weight2_4GHz = 0.7; // Weight for 2.4 GHz band
    const double weight5GHz = 0.3; // Weight for 5 GHz band

    // Calculate weighted average of AP coordinates
    double totalX = 0;
    double totalY = 0;
    double totalWeight = 0;

    for (int i = 0; i < apList.length; i++) {
      // final weight = apList[i].frequency == '5GHz' ? weight5GHz : weight2_4GHz;
      final weight = weight5GHz;
      totalX += distances[i] * weight * apList[i].longitude;
      totalY += distances[i] * weight * apList[i].latitude;
      totalWeight += weight;
    }

    final estimatedX = totalX / totalWeight;
    final estimatedY = totalY / totalWeight;

    return Point(estimatedX.toPrecision(2), estimatedY.toPrecision(2));
  }

  static Point<double> trilaterationWithWeights(List<AccessPoint> apList,
      List<double> distances, double weight1, double weight2, double weight3) {
    if (apList.length < 3 || apList.length != distances.length) {
      throw Exception(
          "Number of access points must be 3 and match the number of distances!");
    }

    // Check for negative distances
    for (final distance in distances) {
      if (distance < 0) {
        throw Exception("Distance cannot be negative!");
      }
    }

    // Adjust coordinates based on first access point (similar to offset calculation)
    final offsetX = apList[0].longitude;
    final offsetY = apList[0].latitude;
    final adjustedPoints = List<Point<double>>.generate(
        apList.length,
        (index) => Point(apList[index].longitude - offsetX,
            apList[index].latitude - offsetY));

    // Extract weighted coordinates
    final weightedX1 = distances[0] * weight1 * adjustedPoints[0].x;
    final weightedY1 = distances[0] * weight1 * adjustedPoints[0].y;
    final weightedX2 = distances[1] * weight2 * adjustedPoints[1].x;
    final weightedY2 = distances[1] * weight2 * adjustedPoints[1].y;
    final weightedX3 = distances[2] * weight3 * adjustedPoints[2].x;
    final weightedY3 = distances[2] * weight3 * adjustedPoints[2].y;

    // Solve for x and y using the circle equations with weights
    final a =
        (weightedX2 - weightedX1) / (adjustedPoints[1].x - adjustedPoints[0].x);
    final b = weightedY2 - a * adjustedPoints[1].y;
    final c =
        (weightedX3 - weightedX1) / (adjustedPoints[2].x - adjustedPoints[0].x);
    final d = weightedY3 - c * adjustedPoints[2].y;

    final determinant = a * c - 1;

    // Check for non-intersecting circles (invalid scenario)
    if (determinant.abs() < 1e-6) {
      throw Exception("Circles do not intersect (invalid configuration)");
    }

    final x = (c * weightedX1 - a * weightedX3 + d * b - a * d) / determinant;
    final y = (a * weightedY3 - c * weightedY1 + b * c - a * b) / determinant;

    // Translate back to original coordinate space
    return Point(x + offsetX, y + offsetY);
  }
}
