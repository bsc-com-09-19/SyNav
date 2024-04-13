import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sy_nav/features/navigation/screens/wifi/model/wifi_network.dart';

class WifiNetworkService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addWifiNetwork(WifiNetwork wifiNetwork) async {
    await _firestore
        .collection('wifiNetworks')
        .doc(wifiNetwork.bssid)
        .set(wifiNetwork.toJson());
  }

  Future<List<WifiNetwork>> retrieveWifiNetworks() async {
    QuerySnapshot querySnapshot =
        await _firestore.collection('wifiNetworks').get();
    return querySnapshot.docs
        .map((doc) => WifiNetwork.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<List<WifiNetwork>> getFilteredAndStoredWifiNetworks(
      List<String> filteredBssids) async {
    List<WifiNetwork> storedWifiNetworks = await retrieveWifiNetworks();
    return storedWifiNetworks
        .where((wifi) => filteredBssids.contains(wifi.bssid))
        .toList();
  }
}
