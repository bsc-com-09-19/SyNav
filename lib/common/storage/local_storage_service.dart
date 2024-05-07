import 'package:shared_preferences/shared_preferences.dart';
import 'package:sy_nav/features/navigation/screens/wifi/model/wifi_network.dart';

/// A service class to handle local storage operations for access points.
class LocalStorageService {
  /// The key used to store access points data in shared preferences.
  static const String keyAccessPoints = 'access_points';

  /// Retrieves the list of access points from local storage.
  ///
  /// Returns a Future that resolves to a List<AccessPoint>.
  Future<List<AccessPoint>> getAccessPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? accessPointsJson = prefs.getString(keyAccessPoints);
    if (accessPointsJson != null) {
      return AccessPoint.decodeJsonList(accessPointsJson);
    } else {
      // If no access points are stored, return an empty list.
      return [];
    }
  }

  /// Saves the list of access points to local storage.
  ///
  /// [accessPoints] The list of access points to be saved.
  ///
  /// Returns a Future that completes when the access points are saved.
  Future<void> saveAccessPoints(List<AccessPoint> accessPoints) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String accessPointsJson = AccessPoint.encodeJsonList(accessPoints);
    await prefs.setString(keyAccessPoints, accessPointsJson);
  }
}
