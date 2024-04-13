import 'package:flutter/material.dart';
import 'package:get/get.dart';

class KUnImplementedPage extends StatelessWidget {
  final String pageName;
  const KUnImplementedPage({super.key, required this.pageName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading:
            IconButton(onPressed: Get.back, icon: const Icon(Icons.arrow_back)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$pageName page to be implemented soon",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              "Contact the developer",
              style: Theme.of(context).textTheme.bodySmall,
            )
          ],
        ),
      ),
    );
  }
}
