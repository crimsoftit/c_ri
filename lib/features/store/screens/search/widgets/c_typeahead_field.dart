import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CTypeAheadSearchField extends StatelessWidget {
  const CTypeAheadSearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final searchController = Get.put(CSearchBarController());
    final salesController = Get.put(CSalesController());

    return TypeAheadField<CInventoryModel>(
      builder: (context, controller, focusNode) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: false,
          style: const TextStyle(
            color: CColors.white,
          ),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: 'search inventory, sold items',
            //hintText: 'search inventory, sold items',
          ),
        );
      },
      suggestionsCallback: (pattern) {
        //invController.fetchInventoryItems();

        var matches = invController.inventoryItems;

        return matches
            .where((item) =>
                item.name.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (context, suggestion) {
        //invController.fetchInventoryItems();
        // return ListTile(
        //   title: Text(suggestion.name),
        //   onTap: () {},
        // );
        return ExpansionTile(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
          backgroundColor: CColors.white,
          collapsedBackgroundColor: CColors.rBrown.withOpacity(0.08),
          expandedCrossAxisAlignment: CrossAxisAlignment.start,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${suggestion.name} (#${suggestion.productId})',
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.fade,
                maxLines: 1,
              ),
              Text(
                'code: ${suggestion.pCode}   usp: Ksh.${suggestion.unitSellingPrice}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              Text(
                'in stock: ${suggestion.quantity}   bp: Ksh.${suggestion.buyingPrice}',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
          children: [
            Column(
              children: [
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Get.toNamed(
                          '/inventory/item_details/',
                          arguments: suggestion.productId,
                        );
                      },
                      label: Text(
                        'info',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      icon: const Icon(
                        Iconsax.information,
                        size: CSizes.iconSm,
                        color: CColors.rBrown,
                      ),
                    ),
                    SizedBox(
                      width: CHelperFunctions.screenWidth() * 0.5,
                    ),
                    TextButton.icon(
                      onPressed: () {
                        salesController.onSellItemBtnAction(suggestion);
                      },
                      label: Text(
                        'sell',
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      icon: const Icon(
                        Iconsax.card_pos,
                        size: CSizes.iconSm,
                        color: CColors.rBrown,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
      onSelected: (suggestion) {
        // Handle when a suggestion is selected.
        searchController.txtTypeAheadFieldController.text = suggestion.name;

        //print('Selected item: ${suggestion.name}');
      },
    );
  }
}
