import 'package:flutter/material.dart';
import 'package:sy_nav/data/buildings/building.dart';
import 'package:sy_nav/features/navigation/screens/buildings/building_section.dart';
import 'package:sy_nav/utils/constants/k_sizes.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BuildingsScreen(); // Navigate to BuildingsScreen
    // return const Placeholder(); // Placeholder for future content
  }
}

class BuildingsScreen extends StatelessWidget {
  final List<Building> buildings = [
    Building('Main Hall', 'hostel'), // Building: Main Hall
    Building('Beit Trust', 'hostel'), // Building: Beit Trust
    Building('Kenyata', 'hostel'), // Building: Kenyata
    Building('Chirunga', 'hostel'), // Building: Chirunga
    Building('Kanjeza', 'hostel'), // Building: Kanjeza
    Building('Chikowi', 'room'), // Building: Chikowi
    Building('Wadonda', 'room'), // Building: Wadonda
    Building('Library Wing', 'room'), // Building: Library Wing
    Building(
        'Performing Arts Center', 'room'), // Building: Performing Arts Center
    Building('Athletic Complex', 'room'), // Building: Athletic Complex
    Building('Sports Complex', 'room'), // Building: Sports Complex
    Building('Cartographics lab', 'room'), // Building: Cartographics lab
    Building('Lab X', 'room'), // Building: Lab X
  ];

  BuildingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(
          horizontal: KSizes.defaultSpace), // Padding for the list view
      children: [
        BuildingSection(
          sectionTitle: 'Rooms', // Section title for rooms
          buildings: buildings
              .where((b) => b.type == 'room')
              .toList(), // Filter buildings by type 'room'
          tag: 'Rooms', // Tag for rooms section
        ),
        BuildingSection(
          sectionTitle: 'Hostels', // Section title for hostels
          buildings: buildings
              .where((b) => b.type == 'hostel')
              .toList(), // Filter buildings by type 'hostel'
          tag: 'Hostels', // Tag for hostels section
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
