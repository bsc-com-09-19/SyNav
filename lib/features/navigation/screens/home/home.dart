import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/common/widgets/drawer/drawer_manager.dart';
import 'package:sy_nav/common/widgets/drawer/k_drawer.dart';
import 'package:sy_nav/common/widgets/k_search_bar.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeController>();

    return Scaffold(
      //every scaffold has to use this key
      key: DrawerManager.drawerKey,
      // appBar: AppBar(title: const Text("SyNav")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              KSearchBar(
                controller: controller.textEditingController.value,
                hintText: "Enter here",
              ),
              const SizedBox(
                height: kTextTabBarHeight,
              ),
              const Text("University of Malawi Campus Navigation",
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),

      drawer: const KDrawer(),
    );
  }

  void handleMic() {
    //TODO
  }
}
