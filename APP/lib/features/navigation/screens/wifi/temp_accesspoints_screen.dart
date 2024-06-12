import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/common/storage/local_storage_service.dart';
import 'package:sy_nav/features/navigation/screens/wifi/model/wifi_network.dart';
import 'package:sy_nav/features/navigation/screens/wifi/services/wifi_network_service.dart';

/// A screen to display a list of access points.
class AccessPointsScreen extends StatelessWidget {
  final WifiNetworkService _firebaseService = WifiNetworkService();
  final LocalStorageService _localStorageService = LocalStorageService();
  final RxList<AccessPoint> _accessPoints = <AccessPoint>[].obs;

  AccessPointsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    _loadAccessPoints();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Access Points'),
      ),
      body: Obx(
        () => _accessPoints.isEmpty
            ? const Center(child: Text("No Wifi Available"),)
            : ListView.builder(
                itemCount: _accessPoints.length,
                itemBuilder: (context, index) {
                  final accessPoint = _accessPoints[index];
                  return ListTile(
                    title: Text(accessPoint.bssid),
                    subtitle: Text(
                        'Latitude: ${accessPoint.latitude}, Longitude: ${accessPoint.longitude}'),
                  );
                },
              ),
      ),
    );
  }

  /// Loads access points data from local storage and Firebase.
  void _loadAccessPoints() async {
    final localAccessPoints = await _localStorageService.getAccessPoints();
    _accessPoints.value = localAccessPoints;

    _firebaseService.listenToAccessPoints().listen((accessPoints) {
      _accessPoints.value = accessPoints;
      _localStorageService.saveAccessPoints(accessPoints);
    });
  }
}
