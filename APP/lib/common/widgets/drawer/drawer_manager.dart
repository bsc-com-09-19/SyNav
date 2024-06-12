import 'package:flutter/material.dart';

class DrawerManager {
  // this key will be used when accessing the state of the scaffold.
  // is static so that it can be accessed anywhere
  static final GlobalKey<ScaffoldState> drawerKey = GlobalKey();

  static void openDrawer() {
    drawerKey.currentState?.openDrawer();
  }
}
