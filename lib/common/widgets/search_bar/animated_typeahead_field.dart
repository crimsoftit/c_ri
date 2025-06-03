import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/screens/search/widgets/c_typeahead_field.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CAnimatedTypeaheadField extends StatelessWidget {
  const CAnimatedTypeaheadField({
    super.key,
    this.boxColor,
  });

  final Color? boxColor;

  @override
  Widget build(BuildContext context) {
    final searchBarController = Get.put(CSearchBarController());
    final invController = Get.put(CInventoryController());

    final screenWidth = CHelperFunctions.screenWidth();

    return Obx(
      () {
        return AnimatedContainer(
          padding: const EdgeInsets.all(CSizes.defaultSpace / 4),
          duration: const Duration(milliseconds: 200),
          width: searchBarController.showAnimatedTypeAheadField.value
              ? screenWidth * .93
              : 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: searchBarController.showAnimatedTypeAheadField.value
                ? BorderRadius.circular(5.0)
                : BorderRadius.circular(20.0),
            color: boxColor,
            //boxShadow: kElevationToShadow[2],
          ),
          child: searchBarController.showAnimatedTypeAheadField.value
              ? SizedBox(
                  child: CRoundedContainer(
                    width: screenWidth * .88,
                    showBorder: false,
                    borderRadius: 5.0,
                    child: const CTypeAheadSearchField(),
                  ),
                )
              : Material(
                  type: MaterialType.transparency,
                  child: InkWell(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0),
                      topRight: Radius.circular(32),
                      bottomLeft: Radius.circular(0),
                      bottomRight: Radius.circular(32),
                    ),
                    onTap: () {
                      searchBarController.onTypeAheadSearchIconTap();
                      invController.fetchUserInventoryItems();
                    },
                    child: const Icon(
                      Iconsax.search_normal,
                      color: CColors.white,
                      size: CSizes.iconMd,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
