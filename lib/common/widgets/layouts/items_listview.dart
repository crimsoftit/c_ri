import 'package:c_ri/common/widgets/layouts/c_expansion_tile.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/screens/search/widgets/no_results_screen.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
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
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final invController = Get.put(CInventoryController());
    final salesController = Get.put(CTxnsController());
    final searchController = Get.put(CSearchBarController());
    final userController = Get.put(CUserController());

    final userCurrencyCode =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);

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

        if (searchController.txtSearchField.text.isNotEmpty &&
            salesController.foundSales.isEmpty &&
            space == 'sales') {
          return const NoSearchResultsScreen();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(2.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: space == 'inventory'
              ? invController.foundInventoryItems.length
              : salesController.foundSales.length,
          itemBuilder: (context, index) {
            var id = space == 'inventory'
                ? '#${invController.foundInventoryItems[index].productId}'
                : 'txn id: #${salesController.foundSales[index].txnId}';

            // var pCode = space == 'inventory'
            //     ? invController.foundInventoryItems[index].pCode
            //     : salesController.foundTxns[index].productCode;

            var amount = space == 'inventory'
                ? 'bp: $userCurrencyCode.${invController.foundInventoryItems[index].buyingPrice}'
                : 't.Amount: $userCurrencyCode.${salesController.foundSales[index].totalAmount}';

            var qty = space == 'inventory'
                ? '(${invController.foundInventoryItems[index].quantity} stocked)'
                : 'qty: ${salesController.foundSales[index].quantity}';

            var date = space == 'inventory'
                ? invController.foundInventoryItems[index].date
                : salesController.foundSales[index].date;

            return Card(
              color: isDarkTheme
                  ? CColors.rBrown.withValues(alpha: 0.3)
                  : CColors.lightGrey,
              elevation: 0.3,
              child: CExpansionTile(
                avatarTxt: space == 'inventory'
                    ? invController.foundInventoryItems[index].name[0]
                        .toUpperCase()
                    : salesController.foundSales[index].productName[0]
                        .toUpperCase(),
                titleTxt: space == 'inventory'
                    ? invController.foundInventoryItems[index].name
                        .toUpperCase()
                    : salesController.foundSales[index].productName
                        .toUpperCase(),
                subTitleTxt1Item1: '$amount ',
                subTitleTxt1Item2: qty,
                subTitleTxt2Item1: space == 'inventory'
                    ? 'usp: $userCurrencyCode.${invController.foundInventoryItems[index].unitSellingPrice}'
                    : 'payment method: ${salesController.foundSales[index].paymentMethod}',
                subTitleTxt2Item2: '',
                subTitleTxt3Item1: date,
                subTitleTxt3Item2: id,
                btn1Txt: 'info',
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
                      arguments: salesController.foundSales[index].txnId,
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
