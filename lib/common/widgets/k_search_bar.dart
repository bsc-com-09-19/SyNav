import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/utils/constants/k_sizes.dart';

class KSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback? onMenuTap;

  final String hintText;
  const KSearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    this.onMenuTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //dependency injection for the home controller
    final homeController = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.all(KSizes.defaultSpace),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(KSizes.borderRadiusLg),
          border: Border.all(
            color: Color.fromARGB(255, 23, 1, 119),
            width: 1.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                height: 50.0,
                padding: const EdgeInsets.all(5),
                child: TextField(
                  controller: controller,
                  style: TextStyle(fontSize: 18.0),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: "Where do you want to go",
                    semanticCounterText: hintText,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                    suffixIcon: Container(
                      decoration: BoxDecoration(
                        color: Color.fromARGB(97, 23, 18, 152),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        ),
                      ),
                      child: IconButton(
                        onPressed: () {
                          // Add your search logic here
                        },
                        icon: Icon(
                          Icons.location_searching,
                          color: Colors.white,
                        ),
                      ),
                    ),
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
