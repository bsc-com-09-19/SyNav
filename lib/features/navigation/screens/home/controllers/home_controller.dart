import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';

class HomeController extends GetxController {
  final GlobalKey<ScaffoldState> scaffoldKey =
      GlobalKey(); //global key for the scaffold

  // Opens the drawer
  void openDrawer() {
    print("open drawer launched");
    scaffoldKey.currentState?.openDrawer();
  }
}

class TextInputFieldController extends GetxController {
  TextEditingController textEditingController = TextEditingController();

  void clearValue() {
    textEditingController.dispose();
  }

  void handleSearch() {
    //TODO : logic for searching
  }
}
