import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/features/navigation/screens/home/controllers/home_controller.dart';
import 'package:sy_nav/utils/constants/k_sizes.dart';

class KSearchBar extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback? onMenuTap;
  final void Function(String value)? onSearchTap;
  final String hintText;
  final VoidCallback? onButtonTap; // New callback for button tap

  const KSearchBar({
    Key? key,
    required this.controller,
    required this.hintText,
    this.onMenuTap,
    this.onSearchTap,
    this.onButtonTap, // Initialize the callback
  }) : super(key: key);

  @override
  _KSearchBarState createState() => _KSearchBarState();
}

class _KSearchBarState extends State<KSearchBar> {
  bool isButtonTapped = false;

  @override
  Widget build(BuildContext context) {
    final homeController = Get.find<HomeController>();

    return Padding(
      padding: const EdgeInsets.all(KSizes.defaultSpace),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(KSizes.borderRadiusLg),
          border: Border.all(
            color: const Color.fromARGB(255, 23, 1, 119),
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
                  controller: widget.controller,
                  style: const TextStyle(fontSize: 18.0),
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    border: InputBorder.none,
                    suffixIcon: GestureDetector(
                      onTapDown: (_) {
                        setState(() {
                          isButtonTapped = true;
                        });
                        // Call the callback when button is tapped
                        widget.onButtonTap?.call();
                      },
                      onTapUp: (_) {
                        setState(() {
                          isButtonTapped = false;
                        });
                        if (widget.onSearchTap != null) {
                          widget.onSearchTap!(widget.controller.value.text);
                        }
                      },
                      onTapCancel: () {
                        setState(() {
                          isButtonTapped = false;
                        });
                      },
                      child: AnimatedContainer(
                        duration: const Duration(seconds: 3),
                        decoration: BoxDecoration(
                          color: isButtonTapped
                              ? Colors.green
                              : const Color.fromARGB(97, 23, 18, 152),
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          ),
                        ),
                        padding: const EdgeInsets.all(8.0),
                        child: const Icon(
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
