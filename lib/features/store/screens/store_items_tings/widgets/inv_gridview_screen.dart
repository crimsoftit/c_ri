import 'package:c_ri/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CInvGridviewScreen extends StatelessWidget {
  const CInvGridviewScreen({
    super.key,
    this.mainAxisExtent = 218,
  });

  final double? mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());

    return SizedBox(
      height: CHelperFunctions.screenHeight() * 0.52,
      child: GridView.builder(
        itemCount: invController.inventoryItems.length,
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        physics: const AlwaysScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: CSizes.gridViewSpacing / 12,
          crossAxisSpacing: CSizes.gridViewSpacing / 12,
          mainAxisExtent: mainAxisExtent,
        ),
        itemBuilder: (context, index) {
          var pName = invController.foundInventoryItems.isNotEmpty
              ? invController.foundInventoryItems[index].name
              : invController.inventoryItems[index].name;
          return CProductCardVertical(
            itemName: pName,
          );
        },
      ),
    );
  }
}
