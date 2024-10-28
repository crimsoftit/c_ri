import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CExpandedSearchField extends StatelessWidget {
  const CExpandedSearchField({
    super.key,
    required this.hintTxt,
    required this.txtColor,
    required this.controller,
  });

  final String hintTxt;
  final Color txtColor;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(CSearchBarController());

    final invController = Get.put(CInventoryController());
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              bottom: 12.0,
            ),
            child: TextFormField(
              controller: controller,
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
                //color: CColors.rBrown.withOpacity(0.6),
                color: txtColor,
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
    );
  }
}