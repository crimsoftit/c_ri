import 'package:c_ri/common/widgets/layouts/c_expansion_tile.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/screens/search/widgets/no_results_screen.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CItemsListView extends StatelessWidget {
  const CItemsListView({
    super.key,
    required this.space,
  });

  final String space;

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final salesController = Get.put(CSalesController());

    final searchController = Get.put(CSearchBarController());

    return Obx(
      () {
        // run loader --
        if (invController.isLoading.value || salesController.isLoading.value) {
          return const CVerticalProductShimmer(
            itemCount: 7,
          );
        }

        if (invController.foundInventoryItems.isEmpty && space == 'inventory') {
          return const NoSearchResultsScreen();
        }

        if (searchController.txtSalesSearch.text.isNotEmpty &&
            salesController.foundTxns.isEmpty &&
            space == 'sales') {
          return const NoSearchResultsScreen();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(2.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: space == 'inventory'
              ? invController.foundInventoryItems.length
              : salesController.foundTxns.length,
          itemBuilder: (context, index) {
            var id = space == 'inventory'
                ? '#${invController.foundInventoryItems[index].productId}'
                : 'txn id: #${salesController.foundTxns[index].saleId}';

            // var pCode = space == 'inventory'
            //     ? invController.foundInventoryItems[index].pCode
            //     : salesController.foundTxns[index].productCode;

            var amount = space == 'inventory'
                ? 'bp: Ksh.${invController.foundInventoryItems[index].buyingPrice}'
                : 't.Amount: Ksh.${salesController.foundTxns[index].totalAmount}';

            var qty = space == 'inventory'
                ? '(${invController.foundInventoryItems[index].quantity} stocked)'
                : 'qty: ${salesController.foundTxns[index].quantity}';

            var date = space == 'inventory'
                ? invController.foundInventoryItems[index].date
                : salesController.foundTxns[index].date;

            return Card(
              color: CColors.white,
              elevation: 0.3,
              child: CExpansionTile(
                avatarTxt: space == 'inventory'
                    ? invController.foundInventoryItems[index].name[0]
                        .toUpperCase()
                    : salesController.foundTxns[index].productName[0]
                        .toUpperCase(),
                titleTxt: space == 'inventory'
                    ? '${invController.foundInventoryItems[index].name.toUpperCase()}($id)'
                    : '${salesController.foundTxns[index].productName.toUpperCase()} ($id)',
                subTitleTxt1Item1: '$amount ',
                subTitleTxt1Item2: qty,
                subTitleTxt2Item1: space == 'inventory'
                    ? 'usp: ${invController.foundInventoryItems[index].unitSellingPrice}'
                    : 'payment method: ${salesController.foundTxns[index].paymentMethod}',
                subTitleTxt2Item2: '',
                subTitleTxt3Item1: date,
                subTitleTxt3Item2: id,
                btn2Txt: space == 'inventory' ? 'sell' : 'update',
                btn2Icon: space == 'inventory'
                    ? const Icon(
                        Iconsax.card_pos,
                        color: CColors.rBrown,
                        size: CSizes.iconSm,
                      )
                    : const Icon(
                        Iconsax.edit,
                        color: CColors.rBrown,
                        size: CSizes.iconSm,
                      ),
                btn1NavAction: () {
                  if (space == 'inventory') {
                    Get.toNamed(
                      '/inventory/item_details/',
                      arguments:
                          invController.foundInventoryItems[index].productId,
                    );
                  }
                  if (space == 'sales') {
                    Get.toNamed(
                      '/sales/txn_details',
                      arguments: salesController.foundTxns[index].saleId,
                    );
                  }
                },
                btn2NavAction: space == 'inventory'
                    ? () {
                        salesController.onSellItemBtnAction(
                            invController.foundInventoryItems[index]);
                      }
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}
