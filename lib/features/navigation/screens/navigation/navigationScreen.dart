import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/data/buildings/building.dart';
import 'package:sy_nav/features/navigation/screens/buildings/building_section.dart';
import 'package:sy_nav/utils/constants/colors.dart';
import 'package:sy_nav/utils/constants/k_sizes.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // return const BuildingsScreen();
    return const Placeholder();
  }
}

class BuildingsScreen extends StatelessWidget {
  final List<Building> buildings = [
    Building('Main Hall', 'hostel'),
    Building('International House', 'hostel'),
    Building('Lakeside Residence', 'hostel'),
    Building('North Quad', 'hostel'),
    Building('The Hub', 'hostel'),
    Building('Engineering Building', 'room'),
    Building('Science Center', 'room'),
    Building('Library Wing', 'room'),
    Building('Performing Arts Center', 'room'),
    Building('Athletic Complex', 'room'),
    Building('Health Center', 'room'),
    Building('Administration Building', 'room'),
    Building('Faculty Apartments', 'room'),
  ];

  BuildingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: Get.back,
          icon: const Icon(Icons.arrow_back, color: AppColors.primaryColor),
        ),
        title: const Text('Buildings'),
        centerTitle: true,
      ),
      body: ListView(
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
      ),
    );
  }
}
