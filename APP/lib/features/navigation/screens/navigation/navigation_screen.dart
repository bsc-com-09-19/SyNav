import 'package:flutter/material.dart';
import 'package:sy_nav/data/buildings/building.dart';
import 'package:sy_nav/features/navigation/screens/buildings/building_section.dart';
import 'package:sy_nav/utils/constants/k_sizes.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BuildingsScreen();
    // return const Placeholder();
  }
}

class BuildingsScreen extends StatelessWidget {
  final List<Building> buildings = [
    Building('Main Hall', 'hostel'),
    Building('Beit Trust', 'hostel'),
    Building('Kenyata', 'hostel'),
    Building('Chirunga', 'hostel'),
    Building('Kanjeza', 'hostel'),
    Building('Chikowi', 'room'),
    Building('Wadonda', 'room'),
    Building('Library Wing', 'room'),
    Building('Performing Arts Center', 'room'),
    Building('Athletic Complex', 'room'),
    Building('Sports Complex', 'room'),
    Building('Cartographics lab', 'room'),
    Building('Lab X', 'room'),
  ];

  BuildingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: KSizes.defaultSpace),
      children: [
        BuildingSection(
          sectionTitle: 'Rooms',
          buildings: buildings.where((b) => b.type == 'room').toList(),
          tag: 'Rooms',
        ),
        BuildingSection(
          sectionTitle: 'Hostels',
          buildings: buildings.where((b) => b.type == 'hostel').toList(),
          tag: 'Hostels',
        ),
      ],
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     leading: IconButton(
    //       onPressed: Get.back,
    //       icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
    //     ),
    //     title: const Text('Buildings'),
    //     centerTitle: true,
    //   ),
    //   body: ListView(
    //     padding: const EdgeInsets.symmetric(horizontal: KSizes.defaultSpace),
    //     children: [
    //       BuildingSection(
    //         sectionTitle: 'Rooms',
    //         buildings: buildings.where((b) => b.type == 'room').toList(),
    //         tag: 'Rooms',
    //       ),
    //       BuildingSection(
    //         sectionTitle: 'Hostels',
    //         buildings: buildings.where((b) => b.type == 'hostel').toList(),
    //         tag: 'Hostels',
    //       ),
    //     ],
    //   ),
    // );
  }
}
