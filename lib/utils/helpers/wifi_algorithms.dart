import 'dart:math';
import 'package:sy_nav/features/navigation/screens/wifi/model/wifi_network.dart';
import 'package:sy_nav/utils/constants/wifi_constants.dart';

class WifiAlgorithms {
  // Function to estimate distance based on signal strength using path loss model
  static double estimateDistance(double signalStrength) {
    return WifiConstants.referenceDistance *
        pow(
            10,
            ((WifiConstants.referenceSignalStrength - signalStrength) /
                (10 * WifiConstants.pathLossExponent)));
  }

  ///Gets the scanned and filtered wifi list
  static Point<double> getEstimatedLocation(List<String> wifiList) {
    if (wifiList.isEmpty || wifiList[0].startsWith("Failed")) {
      throw Exception("Please provide a valid list");
    }

    ///generate a list of APs with their locations 
    

    return Point(3, 1);
  }

  Point<double> dynamicWeightedTrilateration(
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
      final weight = apList[i].frequency == '5GHz' ? weight5GHz : weight2_4GHz;
      totalX += distances[i] * weight * apList[i].longitude;
      totalY += distances[i] * weight * apList[i].latitude;
      totalWeight += weight;
    }

    final estimatedX = totalX / totalWeight;
    final estimatedY = totalY / totalWeight;

    return Point(estimatedX, estimatedY);
  }
}
