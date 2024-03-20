import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/bindings/home_binding.dart';
import 'package:sy_nav/features/navigation/screens/home/home.dart';

void main() {
  runApp(const SyNavApp());
}

class SyNavApp extends StatelessWidget {
  const SyNavApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "SyNav",
      home: const Home(),
      initialBinding: HomeBinding(),
    );
  }
}
