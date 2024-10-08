import 'package:c_ri/features/store/controllers/inv_controller.dart';
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
  });

  final String hintTxt;
  final Color? boxColor;

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(CSearchBarController());

    final invController = Get.put(CInventoryController());

    return Obx(
      () {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // width: searchController.showSearchField.value
          //     ? CHelperFunctions.screenWidth()
          //     : 50.0,
          width:
              searchController.showSearchField.value ? double.maxFinite : 40.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: searchController.showSearchField.value
                ? BorderRadius.circular(5.0)
                : BorderRadius.circular(20.0),
            color: boxColor,
            boxShadow: kElevationToShadow[2],
          ),
          child: searchController.showSearchField.value
              ? Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 16.0,
                          bottom: 10.0,
                        ),
                        child: TextFormField(
                          controller: searchController.txtSearchField,
                          autofocus: true,
                          onChanged: (value) {
                            if (hintTxt == 'inventory') {
                              invController.onSearchInventory(value);
                            }
                          },
                          onFieldSubmitted: (value) {
                            //searchController.onSearchBtnPressed();
                            if (hintTxt == 'inventory') {
                              invController.onSearchInventory(value);
                            }
                          },
                          style: TextStyle(
                            color: CColors.rBrown.withOpacity(0.6),
                            //color: CColors.grey,
                            fontSize: 10.0,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(
                                top: 7,
                              ),
                              child: Icon(
                                Iconsax.search_favorite,
                                color: CColors.rBrown.withOpacity(0.6),
                                size: CSizes.iconSm,
                              ),
                            ),
                            hintText: 'search $hintTxt',
                            hintStyle: TextStyle(
                              color: CColors.rBrown.withOpacity(0.6),
                            ),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                    Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(0),
                          topRight: Radius.circular(32),
                          bottomLeft: Radius.circular(0),
                          bottomRight: Radius.circular(32),
                        ),
                        onTap: () {
                          searchController.onCloseIconTap();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Icon(
                            Icons.close,
                            color: CColors.rBrown.withOpacity(0.6),
                            size: CSizes.iconSm,
                          ),
                        ),
                      ),
                    ),
                  ],
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
                      searchController.onCloseIconTap();
                    },
                    child: const Icon(
                      Iconsax.search_favorite,
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
