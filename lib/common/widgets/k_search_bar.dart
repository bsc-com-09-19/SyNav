import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';

class KSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onSuffixTap;
  final VoidCallback? onMenuTap;

  final String hintText;
  const KSearchBar(
      {super.key,
      required this.controller,
      this.onSuffixTap,
      required this.hintText,
      this.onMenuTap});

  @override
  Widget build(BuildContext context) {
    //dependency injection for the home controller
    final homeController = Get.find<HomeController>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.0),
          border: Border.all(
            color: Colors.grey,
            width: 1.0,
          )),
      child: Row(
        children: [
          IconButton(
            onPressed: homeController.handleOpenDrawer,
            icon: const Icon(Icons.menu),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: InputDecoration(
                // labelText: hintText,
                hintText: hintText,
                semanticCounterText: "Type your location here",
                border: InputBorder.none,
              ),
            ),
          ),
          IconButton(onPressed: () => {}, icon: const Icon(Icons.mic))
        ],
      ),
    );
  }
}
