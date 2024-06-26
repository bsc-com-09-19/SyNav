import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/utils/constants/colors.dart';

///Displays the booksmarks made by the user
class BookMarksScreen extends StatelessWidget {
  const BookMarksScreen({super.key});

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
        title: const Text("Bookmarks"),
        centerTitle: true,
      ),
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(),
          child: Column(
            children: [],
          ),
        ),
      ),
    );
  }
}
