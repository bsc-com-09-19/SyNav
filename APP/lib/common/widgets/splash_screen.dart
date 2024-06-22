import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sy_nav/features/navigation/screens/home/home.dart';
import 'package:sy_nav/utils/constants/colors.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen>  createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Home()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "SYNAV",
              style: TextStyle(
                color: Color.fromARGB(255, 248, 190, 1),
                fontSize: 50,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "navigate with ease",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 16),
            Icon(
              Icons.accessibility_new_outlined,
              color: Color.fromARGB(255, 248, 190, 1),
              size: 48,
            ),
          ],
        ),
      ),
    );
  }
}
