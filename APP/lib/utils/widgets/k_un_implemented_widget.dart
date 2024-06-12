import 'package:flutter/material.dart';

class KUnImplementedWidget extends StatelessWidget {
  const KUnImplementedWidget({
    super.key,
    required this.pageName,
  });

  final String pageName;

  @override
  Widget build(BuildContext context) {
    return Center(
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
    );
  }
}
