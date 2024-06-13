import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';
import 'package:sy_nav/features/navigation/screens/map/grid_map.dart';
import 'package:sy_nav/features/navigation/screens/wifi/algorithms/sensor_manager.dart';
import 'package:sy_nav/utils/constants/k_strings.dart';

class HomeController extends GetxController {
  var textEditingController = TextEditingController().obs;
  // ignore: prefer_const_constructors
  var location = Point<double>(0, 0).obs;
  var gridMap = Grid(
      rows: 10, cols: 10, cellSize: 0.8, startLatitude: 10, startLongitude: 10);
  var appBarTitle = KStrings.homeTitle.obs;
  var appBarSuffixActions = <Widget>[].obs;

  var iconButton =
      IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)).obs;

  var currentIndex = 0.obs;

  void clearValue() {
    textEditingController.value.dispose();
  }

  void handleSearch() {
    //TODO : logic for searching
  }

  // Opens the drawer
  void handleOpenDrawer() {
    DrawerManager.openDrawer();
  }

  void updateLocation(Point<double> location) {
    this.location.value = location;
  }
}
