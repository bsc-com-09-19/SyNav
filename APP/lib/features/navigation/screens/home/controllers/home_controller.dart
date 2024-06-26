import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';
import 'package:sy_nav/utils/constants/k_strings.dart';

class HomeController extends GetxController {
  var textEditingController = TextEditingController().obs;
  // ignore: prefer_const_constructors
  var location = Point<double>(0, 0).obs;

  var appBarTitle = KStrings.homeTitle.obs;
  var appBarSuffixActions = <Widget>[].obs;

  var iconButton =
      IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)).obs;

  var currentIndex = 0.obs;

  get fromCellName => null;

  get toCellName => null;

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
    // var modifiedLocation = Point(
    //     ((location.x > 10.1) ? location.x % 10.0 : location.x),
    //     ((location.y > 10.1) ? location.y % 19.0 : location.y));
    // this.location.value = modifiedLocation;
  }
}
