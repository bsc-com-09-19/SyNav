import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color if needed
      body: Center(
        child: Image.asset(
          'assets/logo.png', // Replace with your splash screen image
          width: 200,
          height: 200,
        ),
      ),
    );
  }
}
