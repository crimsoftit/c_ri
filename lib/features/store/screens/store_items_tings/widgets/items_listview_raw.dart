import 'package:c_ri/common/widgets/layouts/c_expansion_tile.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/screens/search/widgets/no_results_screen.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CItemsListViewRaw extends StatelessWidget {
  const CItemsListViewRaw({
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

        if (invController.foundInventoryItems.isEmpty &&
            space == 'inventory' &&
            searchController.showSearchField.value) {
          return const NoSearchResultsScreen();
        }

        if (invController.inventoryItems.isEmpty && space == 'inventory') {
          return const Center(
            child: NoDataScreen(
              lottieImage: CImages.noDataLottie,
              txt: 'No data found!',
            ),
          );
        }

        if (searchController.txtSearchField.text.isNotEmpty &&
            salesController.foundSales.isEmpty &&
            space == 'sales') {
          return const NoSearchResultsScreen();
        }

        if (!searchController.showSearchField.value &&
            salesController.sales.isEmpty &&
            space == 'sales') {
          return const Center(
            child: NoDataScreen(
              lottieImage: CImages.noDataLottie,
              txt: 'No data found!',
            ),
          );
        }

        if (!searchController.showSearchField.value &&
            salesController.refunds.isEmpty &&
            space == 'refunds') {
          return const Center(
            child: NoDataScreen(
              lottieImage: CImages.noDataLottie,
              txt: 'No data found!',
            ),
          );
        }

        /// -- compute ListView.builder's itemCount --
        var itemsCount = 0;
        switch (space) {
          case "sales":
            itemsCount = salesController.foundSales.isNotEmpty
                ? salesController.foundSales.length
                : salesController.sales.length;
            break;
          case "refunds":
            itemsCount = salesController.refunds.length;
          default:
            itemsCount = 0;
            CPopupSnackBar.errorSnackBar(
              title: 'invalid tab space',
            );
        }

        return SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: SizedBox(
            height: CHelperFunctions.screenHeight() * 0.62,
            child: ListView.builder(
              padding: const EdgeInsets.all(2.0),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              // itemCount:
              //     space == 'inventory' && searchController.showSearchField.value
              //         ? invController.foundInventoryItems.length
              //         : space == 'inventory' &&
              //                 invController.foundInventoryItems.isEmpty
              //             ? invController.inventoryItems.length
              //             : space == 'sales' &&
              //                     salesController.foundSales.isNotEmpty
              //                 ? salesController.foundSales.length
              //                 : salesController.sales.length,
              itemCount: itemsCount,
              itemBuilder: (context, index) {
                var id = space == 'inventory' &&
                        invController.foundInventoryItems.isNotEmpty
                    ? '#${invController.foundInventoryItems[index].productId}'
                    : space == 'inventory' &&
                            invController.foundInventoryItems.isEmpty
                        ? '#${invController.inventoryItems[index].productId}'
                        : space == 'sales' &&
                                salesController.foundSales.isNotEmpty
                            ? 'receip#: ${salesController.foundSales[index].txnId}'
                            : 'receipt#: ${salesController.sales[index].txnId}';

                var pName = space == 'inventory' &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].name
                    : space == 'inventory' &&
                            invController.foundInventoryItems.isEmpty
                        ? '#${invController.inventoryItems[index].name}'
                        : space == 'sales' &&
                                salesController.foundSales.isNotEmpty
                            ? salesController.foundSales[index].productName
                            : salesController.sales[index].productName;

                var amount = space == 'inventory' &&
                        invController.foundInventoryItems.isNotEmpty
                    ? 'bp: $userCurrencyCode.${invController.foundInventoryItems[index].buyingPrice}'
                    : space == 'inventory' &&
                            invController.foundInventoryItems.isEmpty
                        ? 'bp: $userCurrencyCode.${invController.inventoryItems[index].buyingPrice}'
                        : space == 'sales' &&
                                salesController.foundSales.isNotEmpty
                            ? 't.Amount: $userCurrencyCode.${salesController.foundSales[index].totalAmount}'
                            : 't.Amount: $userCurrencyCode.${salesController.sales[index].totalAmount}';

                var qty = space == 'inventory' &&
                        invController.foundInventoryItems.isNotEmpty
                    ? '(${invController.foundInventoryItems[index].quantity} stocked)'
                    : space == 'inventory' &&
                            invController.foundInventoryItems.isEmpty
                        ? '(${invController.inventoryItems[index].quantity} stocked)'
                        : space == 'sales' &&
                                salesController.foundSales.isNotEmpty
                            ? 'qty: ${salesController.foundSales[index].quantity}'
                            : 'qty: ${salesController.sales[index].quantity}';

                var usp = space == 'inventory' &&
                        invController.foundInventoryItems.isNotEmpty
                    ? 'usp: $userCurrencyCode.${invController.foundInventoryItems[index].unitSellingPrice}'
                    : space == 'inventory' &&
                            invController.foundInventoryItems.isEmpty
                        ? 'usp: $userCurrencyCode.${invController.inventoryItems[index].unitSellingPrice}'
                        : space == 'sales' &&
                                salesController.foundSales.isNotEmpty
                            ? 'usp: ${salesController.foundSales[index].unitSellingPrice}'
                            : 'usp: ${salesController.sales[index].unitSellingPrice}';

                var date = space == 'inventory' &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].date
                    : space == 'inventory' &&
                            invController.foundInventoryItems.isEmpty
                        ? invController.inventoryItems[index].date
                        : space == 'sales' &&
                                salesController.foundSales.isNotEmpty
                            ? salesController.foundSales[index].date
                            : salesController.sales[index].date;

                return Card(
                  color: isDarkTheme
                      ? CColors.rBrown.withValues(alpha: 0.3)
                      : CColors.lightGrey,
                  elevation: 0.3,
                  child: CExpansionTile(
                    avatarTxt: space == 'inventory' &&
                            invController.foundInventoryItems.isNotEmpty
                        ? invController.foundInventoryItems[index].name[0]
                            .toUpperCase()
                        : space == 'inventory' &&
                                invController.foundInventoryItems.isEmpty
                            ? invController.inventoryItems[index].name[0]
                                .toUpperCase()
                            : space == 'sales' &&
                                    salesController.foundSales.isNotEmpty
                                ? salesController
                                    .foundSales[index].productName[0]
                                    .toUpperCase()
                                : salesController.sales[index].productName[0]
                                    .toUpperCase(),
                    titleTxt: pName,
                    subTitleTxt1Item1: '$amount ',
                    subTitleTxt1Item2: qty,
                    subTitleTxt2Item1: usp,
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
                          arguments: invController
                                  .foundInventoryItems.isNotEmpty
                              ? invController
                                  .foundInventoryItems[index].productId
                              : invController.inventoryItems[index].productId,
                        );
                      }
                      if (space == 'sales') {
                        Get.toNamed(
                          '/sales/txn_details',
                          arguments: salesController.foundSales.isNotEmpty
                              ? salesController.foundSales[index].soldItemId
                              : salesController.sales[index].soldItemId,
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
            ),
          ),
        );
      },
    );
  }
}
