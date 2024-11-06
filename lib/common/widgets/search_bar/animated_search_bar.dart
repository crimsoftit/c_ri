import 'package:c_ri/common/widgets/search_bar/expanded_search_field.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CAnimatedSearchBar extends StatelessWidget {
  const CAnimatedSearchBar({
    super.key,
    required this.hintTxt,
    this.boxColor,
    required this.controller,
  });

  final String hintTxt;
  final Color? boxColor;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(CSearchBarController());
    final salesController = Get.put(CSalesController());
    final invController = Get.put(CInventoryController());

    return Obx(
      () {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // width: searchController.showSearchField.value
          //     ? CHelperFunctions.screenWidth()
          //     : 50.0,
          width: hintTxt == 'inventory'
              ? searchController.invShowSearchField.value
                  ? double.maxFinite
                  : 40.0
              : searchController.salesShowSearchField.value
                  ? double.maxFinite
                  : 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: hintTxt == 'inventory'
                ? searchController.invShowSearchField.value
                    ? BorderRadius.circular(5.0)
                    : BorderRadius.circular(20.0)
                : searchController.salesShowSearchField.value
                    ? BorderRadius.circular(5.0)
                    : BorderRadius.circular(20.0),
            color: boxColor,
            boxShadow: kElevationToShadow[2],
          ),
          child: hintTxt == 'inventory'
              ? searchController.invShowSearchField.value
                  ? CExpandedSearchField(
                      hintTxt: hintTxt,
                      txtColor: CColors.rBrown,
                      controller: controller,
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
                          searchController.onSearchIconTap(hintTxt);
                          invController.fetchInventoryItems();
                          salesController.fetchTransactions();
                        },
                        child: const Icon(
                          Iconsax.search_normal,
                          color: CColors.white,
                          size: CSizes.iconMd,
                        ),
                      ),
                    )
              : searchController.salesShowSearchField.value
                  ? CExpandedSearchField(
                      hintTxt: hintTxt,
                      txtColor: CColors.rBrown,
                      controller: controller,
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
                          searchController.onSearchIconTap(hintTxt);
                          invController.fetchInventoryItems();
                          salesController.fetchTransactions();
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
