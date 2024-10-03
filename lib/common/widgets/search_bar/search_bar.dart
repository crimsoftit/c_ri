import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CAnimatedSearchBar extends StatelessWidget {
  const CAnimatedSearchBar({
    super.key,
    required this.hintTxt,
  });

  final String hintTxt;

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(CSearchBarController());

    return Obx(
      () {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: searchController.showSearchField.value
              ? CHelperFunctions.screenWidth()
              : 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25.0),
            color: CColors.white,
            boxShadow: kElevationToShadow[2],
          ),
          child: searchController.showSearchField.value
              ? Row(
                  children: [
                    Expanded(
                      child: TextField(
                        onSubmitted: (value) {
                          searchController.onSearchBtnPressed();
                        },
                        style: const TextStyle(
                          color: CColors.rBrown,
                        ),
                        decoration: InputDecoration(
                          hintText: 'search $hintTxt',
                          hintStyle: const TextStyle(
                            color: CColors.rBrown,
                          ),
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        searchController.onCloseIconTap();
                      },
                      child: const Icon(
                        Icons.close,
                        color: CColors.rBrown,
                        size: CSizes.iconMd,
                      ),
                    ),
                  ],
                )
              : InkWell(
                  onTap: () {
                    searchController.onCloseIconTap();
                  },
                  child: const Icon(
                    Iconsax.search_favorite,
                    color: CColors.rBrown,
                    size: CSizes.iconMd,
                  ),
                ),
        );
      },
    );
  }
}
