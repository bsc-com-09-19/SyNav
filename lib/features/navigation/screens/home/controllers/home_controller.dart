import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';
import 'package:sy_nav/utils/constants/k_strings.dart';

class HomeController extends GetxController {
  var textEditingController = TextEditingController().obs;
  // ignore: prefer_const_constructors
  var location = Point<double>(0, 0).obs;
  var title = KStrings.homeTitle.obs;
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
}
