import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
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
    final salesController = Get.put(CTxnsController());

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
                // if (hintTxt == 'inventory') {
                //   invController.onSearchInventory(value);
                // } else if (hintTxt == 'inventory, transactions') {
                //   invController.onSearchInventory(value);
                //   salesController.onSearchSalesAction(value);
                // }
                invController.searchInventory(value);
                salesController.searchSales(value);
              },
              onFieldSubmitted: (value) {
                //searchController.onSearchBtnPressed();
                // if (hintTxt == 'inventory') {
                //   invController.searchInventory(value);
                // } else if (hintTxt == 'inventory, transactions') {
                //   invController.searchInventory(value);
                //   salesController.onSearchSalesAction(value);
                // }
                invController.searchInventory(value);
                salesController.searchSales(value);
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
                    color: CColors.rBrown.withValues(alpha: 0.6),
                    size: CSizes.iconSm,
                  ),
                ),
                hintText: 'search $hintTxt',
                hintStyle: TextStyle(
                  color: CColors.rBrown.withValues(alpha: 0.6),
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
              searchController.toggleSearchFieldVisibility();
              invController.fetchUserInventoryItems();
              salesController.fetchSoldItems();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.close,
                color: CColors.rBrown.withValues(alpha: 0.6),
                size: CSizes.iconSm,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
