import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/utils/constants/k_sizes.dart';

class KSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onMenuTap;

  final String hintText;
  const KSearchBar(
      {super.key,
      required this.controller,
      required this.hintText,
      this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    //dependency injection for the home controller
    final homeController = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.all(KSizes.defaultSpace),
      child: Container(
        // padding: const EdgeInsets.symmetric(horizontal: KSizes.spaceBtwItems),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(KSizes.borderRadiusMd),
            border: Border.all(
              color: Colors.grey,
              width: 1.0,
            )),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // IconButton(
            //   onPressed: homeController.handleOpenDrawer,
            //   icon: const Icon(Icons.menu),
            // ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 10),
                child: TextField(
                  controller: controller,
                  decoration: InputDecoration(
                    // labelText: hintText,
                    hintText: "Where do you want to go",
                    semanticCounterText: hintText,
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
