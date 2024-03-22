import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/utils/constants/colors.dart';

class BuildingsScreen extends StatelessWidget {
  const BuildingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: Get.back,
            icon: const Icon(
              Icons.arrow_back,
              color: AppColors.primaryColor,
            )),
        title: const Text("Buildings"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search),
            color: AppColors.primaryColor,
          )
        ],
      ),
    );
  }
}
