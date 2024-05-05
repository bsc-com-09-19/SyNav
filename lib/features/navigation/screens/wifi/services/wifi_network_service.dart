import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sy_nav/features/navigation/screens/wifi/model/wifi_network.dart';

class WifiNetworkService {

  static Future<void> addWifiNetwork(AccessPoint wifiNetwork) async {
    await firestore()
        .collection('wifiNetworks')
        .doc(wifiNetwork.bssid)
        .set(wifiNetwork.toJson());
  }

  Future<List<AccessPoint>> retrieveWifiNetworks() async {
    QuerySnapshot querySnapshot =
        await firestore().collection('wifiNetworks').get();
    return querySnapshot.docs
        .map((doc) => AccessPoint.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<AccessPoint>> getFilteredAndStoredWifiNetworks(
      List<String> filteredBssids) async {
    List<AccessPoint> storedWifiNetworks = await retrieveWifiNetworks();
    return storedWifiNetworks
        .where((wifi) => filteredBssids.contains(wifi.bssid))
        .toList();
  }
   static FirebaseFirestore firestore() {
    return FirebaseFirestore.instance;
  }
}
