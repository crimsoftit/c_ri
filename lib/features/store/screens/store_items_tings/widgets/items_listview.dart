import 'package:c_ri/common/widgets/layouts/c_expansion_tile.dart';
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
        // if (invController.isLoading.value || salesController.isLoading.value) {
        //   return const CVerticalProductShimmer(
        //     itemCount: 7,
        //   );
        // }

        if (searchController.txtSearchField.text.isNotEmpty &&
            salesController.foundSales.isEmpty &&
            space == 'sales' &&
            !salesController.isLoading.value) {
          return const NoSearchResultsScreen();
        }

        if (searchController.txtSearchField.text.isNotEmpty &&
            salesController.foundRefunds.isEmpty &&
            space == 'refunds') {
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
            itemsCount = salesController.foundRefunds.isNotEmpty
                ? salesController.foundRefunds.length
                : salesController.refunds.length;
          default:
            itemsCount = 0;
            CPopupSnackBar.errorSnackBar(
              title: 'invalid tab space',
            );
        }

        return ListView(
          shrinkWrap: true,
          children: [
            // SizedBox(
            //   child: salesController.isLoading.value ||
            //           salesController.txnsSyncIsLoading.value
            //       ? const CShimmerEffect(
            //           width: 40.0,
            //           height: 40.0,
            //           radius: 40.0,
            //         )
            //       : salesController.unsyncedTxnAppends.isEmpty &&
            //               salesController.unsyncedTxnUpdates.isEmpty
            //           ? null
            //           : TextButton.icon(
            //               icon: const Icon(
            //                 Iconsax.cloud_change,
            //                 size: CSizes.iconSm,
            //                 color: CColors.white,
            //               ),
            //               label: Text(
            //                 'sync to cloud',
            //                 style:
            //                     Theme.of(context).textTheme.labelMedium!.apply(
            //                           color: CColors.white,
            //                         ),
            //               ),
            //               style: ElevatedButton.styleFrom(
            //                 elevation: 0.2,
            //                 foregroundColor:
            //                     CColors.white, // foreground (text) color
            //                 backgroundColor: isDarkTheme
            //                     ? CColors.rBrown.withValues(
            //                         alpha: 0.25,
            //                       )
            //                     : CColors.rBrown, // background color
            //               ),
            //               onPressed: () async {
            //                 // -- check internet connectivity --
            //                 final internetIsConnected =
            //                     await CNetworkManager.instance.isConnected();
            //                 if (internetIsConnected) {
            //                   await salesController.addSalesDataToCloud();
            //                   await salesController.addSalesDataToCloud();
            //                 } else {
            //                   CPopupSnackBar.customToast(
            //                     message:
            //                         'internet connection required for cloud sync!',
            //                     forInternetConnectivityStatus: true,
            //                   );
            //                 }
            //               },
            //             ),
            // ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.all(2.0),
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: itemsCount,
              itemBuilder: (context, index) {
                var avatarTxt = '';
                var itemProductId = 0;
                var itemName = '';
                var qtyRefunded = 0;
                var qtySold = 0;
                var txnAmount = 0.0;
                var txnDate = '';
                var unitSellingPrice = 0.0;

                switch (space) {
                  case "refunds":
                    avatarTxt = salesController.foundRefunds.isNotEmpty
                        ? salesController.foundRefunds[index].productName[0]
                            .toUpperCase()
                        : salesController.refunds[index].productName[0]
                            .toUpperCase();
                    itemProductId = salesController.foundRefunds.isNotEmpty
                        ? salesController.foundRefunds[index].productId
                        : salesController.refunds[index].productId;

                    itemName = salesController.foundRefunds.isNotEmpty
                        ? salesController.foundRefunds[index].productName
                        : salesController.refunds[index].productName;

                    qtyRefunded = salesController.foundRefunds.isNotEmpty
                        ? salesController.foundRefunds[index].qtyRefunded
                        : salesController.refunds[index].qtyRefunded;

                    qtySold = salesController.foundRefunds.isNotEmpty
                        ? salesController.foundRefunds[index].quantity
                        : salesController.refunds[index].quantity;

                    txnAmount = salesController.foundRefunds.isNotEmpty
                        ? salesController.foundRefunds[index].totalAmount
                        : salesController.refunds[index].totalAmount;

                    txnDate = salesController.foundRefunds.isNotEmpty
                        ? salesController.foundRefunds[index].date
                        : salesController.refunds[index].date;

                    unitSellingPrice = salesController.foundRefunds.isNotEmpty
                        ? salesController.foundRefunds[index].unitSellingPrice
                        : salesController.refunds[index].unitSellingPrice;
                    break;
                  case "sales":
                    avatarTxt = salesController.foundSales.isNotEmpty
                        ? salesController.foundSales[index].productName[0]
                            .toUpperCase()
                        : salesController.sales[index].productName[0]
                            .toUpperCase();

                    itemProductId = salesController.foundSales.isNotEmpty
                        ? salesController.foundSales[index].productId
                        : salesController.sales[index].productId;

                    itemName = salesController.foundSales.isNotEmpty
                        ? salesController.foundSales[index].productName
                        : salesController.sales[index].productName;

                    qtyRefunded = salesController.foundSales.isNotEmpty
                        ? salesController.foundSales[index].qtyRefunded
                        : salesController.sales[index].qtyRefunded;

                    qtySold = salesController.foundSales.isNotEmpty
                        ? salesController.foundSales[index].quantity
                        : salesController.sales[index].quantity;

                    txnAmount = salesController.foundSales.isNotEmpty
                        ? salesController.foundSales[index].totalAmount
                        : salesController.sales[index].totalAmount;

                    txnDate = salesController.foundSales.isNotEmpty
                        ? salesController.foundSales[index].date
                        : salesController.sales[index].date;

                    unitSellingPrice = salesController.foundSales.isNotEmpty
                        ? salesController.foundSales[index].unitSellingPrice
                        : salesController.sales[index].unitSellingPrice;
                  default:
                    avatarTxt = '';
                    itemsCount = 0;
                    itemName = '';
                    qtyRefunded = 0;
                    qtySold = 0;
                    txnAmount = 0.0;
                    txnDate = '';
                    unitSellingPrice = 0.0;
                    CPopupSnackBar.errorSnackBar(
                      title: 'invalid tab space',
                    );
                }

                return Column(
                  children: [
                    Card(
                      color: isDarkTheme
                          ? CColors.rBrown.withValues(alpha: 0.3)
                          : CColors.lightGrey,
                      elevation: 0.3,
                      child: CExpansionTile(
                        avatarTxt: avatarTxt,
                        includeRefundBtn: space == 'sales' ? true : false,
                        titleTxt: itemName.toUpperCase(),
                        subTitleTxt1Item1:
                            't.Amount: $userCurrencyCode.$txnAmount ',
                        subTitleTxt1Item2:
                            '($qtySold sold, $qtyRefunded refunded)',
                        subTitleTxt2Item1:
                            'usp: $userCurrencyCode.$unitSellingPrice',
                        subTitleTxt2Item2: '',
                        subTitleTxt3Item1: txnDate,
                        subTitleTxt3Item2: 'product id: $itemProductId',
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
                                  invController.foundInventoryItems.isNotEmpty
                                      ? invController
                                          .foundInventoryItems[index].productId
                                      : invController
                                          .inventoryItems[index].productId,
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
                        refundBtnAction: () {
                          salesController.refundItemActionModal(
                              context,
                              salesController.foundSales.isNotEmpty
                                  ? salesController.foundSales[index]
                                  : salesController.sales[index]);
                        },
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}
