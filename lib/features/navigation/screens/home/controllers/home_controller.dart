import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';

class HomeController extends GetxController {
  var textEditingController = TextEditingController().obs;

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


