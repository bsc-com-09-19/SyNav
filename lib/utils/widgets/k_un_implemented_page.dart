import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/utils/widgets/k_un_implemented_widget.dart';

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
      body: KUnImplementedWidget(pageName: pageName),
    );
  }
}

