import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sy_nav/common/widgets/k_height.dart';
import 'package:sy_nav/data/buildings/building.dart';
import 'package:sy_nav/utils/constants/colors.dart';
import 'package:sy_nav/utils/constants/k_sizes.dart';
import 'package:sy_nav/utils/helpers/helper_functions.dart';

///Displays the available building in the map of context
class BuildingSectionController extends GetxController {
  final RxBool showAll = false.obs;

  void toggleShowAll() {
    showAll.toggle();
    update();
  }
}


class BuildingSection extends StatelessWidget {
  final String sectionTitle;
  final List<Building> buildings;

  /// This will ensure that the section uses a unique controller for the show all toggler
  final String tag;

  const BuildingSection({
    Key? key,
    required this.sectionTitle,
    required this.buildings,
    required this.tag,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<BuildingSectionController>(
      init: BuildingSectionController(),
      tag: tag,
      builder: (controller) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const KHeight(height: KSizes.spaceBtwSections),
          _buildHeader(context, controller),
          const Divider(),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 2000),
            child: Center(
              child: Wrap(
                children: controller.showAll.value
                    ? buildings
                        .map((building) => _buildBuildingCard(building))
                        .toList()
                    : buildings
                        .sublist(0, 4)
                        .map((building) => _buildBuildingCard(building))
                        .toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, BuildingSectionController controller) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(sectionTitle, style: Get.textTheme.headlineSmall),
        TextButton(
          onPressed: controller.toggleShowAll,
          child: Text(controller.showAll.value ? 'View Less' : 'View All'),
        ),
      ],
    );
  }

  Widget _buildBuildingCard(Building building) {
    return GestureDetector(
      onTap: () {
        // TODO: Implement navigation or actions for building details
      },
      child: Padding(
        padding: const EdgeInsets.all(KSizes.spaceSmall),
        child: Container(
          padding: const EdgeInsets.all(KSizes.spaceBtwSections),
          height: 75,
          width: (KHelpers.screenWidth() / 3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(KSizes.borderRadiusMd),
            color: AppColors.primaryColor.withOpacity(0.7),
          ),
          child: Center(
            child: Text(
              building.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
