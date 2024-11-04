import 'package:c_ri/common/widgets/appbar/other_screens_app_bar.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:c_ri/features/store/screens/search/widgets/c_typeahead_field.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SalesScreen2 extends StatelessWidget {
  const SalesScreen2({super.key});
  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final salesController = Get.put(CSalesController());

    invController.fetchInventoryItems();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            OtherScreensAppBar(
              showScanner: true,
              title: 'transactions',
              trailingIconLeftPadding: CHelperFunctions.screenWidth() * 0.2,
              showBackActionIcon: false,
              showTrailingIcon: true,
            ),

            /// -- typeahead search field --
            const Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: CTypeAheadSearchField(),
            ),

            /// -- display complete transactions
            Obx(
              () {
                salesController.fetchTransactions();

                if (salesController.transactions.isEmpty) {
                  // run loader --
                  if (salesController.isLoading.value) {
                    return const CVerticalProductShimmer(
                      itemCount: 6,
                    );
                  } else {
                    return const Center(
                      child: NoDataScreen(
                        lottieImage: CImages.noDataLottie,
                        txt: 'No data found!',
                      ),
                    );
                  }
                }

                return SizedBox(
                  height: CHelperFunctions.screenHeight() * 0.7,
                  child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount: salesController.transactions.length,
                    itemBuilder: (context, index) {
                      return Card(
                        color: CColors.lightGrey,
                        elevation: 0.3,
                        child: ListTile(
                          horizontalTitleGap: 10,
                          contentPadding: const EdgeInsets.all(
                            10.0,
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.brown[300],
                            radius: 16.0,
                            child: Text(
                              salesController.transactions[index].productName[0]
                                  .toUpperCase(),
                              style:
                                  Theme.of(context).textTheme.labelLarge!.apply(
                                        color: CColors.white,
                                      ),
                            ),
                          ),
                          title: Text(
                            '${salesController.transactions[index].productName.toUpperCase()} (txn id: #${salesController.transactions[index].saleId})',
                            style:
                                Theme.of(context).textTheme.labelMedium!.apply(
                                      color: CColors.rBrown,
                                      //fontSizeFactor: 1.2,
                                      //fontWeightDelta: 2,
                                    ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'pCode: ${salesController.transactions[index].productCode} t.Amount: Ksh.${salesController.transactions[index].totalAmount}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .apply(
                                      color: CColors.rBrown.withOpacity(0.8),
                                      //fontStyle: FontStyle.italic,
                                    ),
                              ),
                              Text(
                                'payment method: ${salesController.transactions[index].paymentMethod} qty: ${salesController.transactions[index].quantity} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .apply(
                                      color: CColors.rBrown.withOpacity(0.8),
                                      //fontStyle: FontStyle.italic,
                                    ),
                              ),
                              Text(
                                'modified: ${salesController.transactions[index].date}',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .apply(
                                      color: CColors.rBrown.withOpacity(0.7),
                                      //fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),

      /// -- floating action button to scan item for sale --
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          salesController.scanItemForSale();

          if (salesController.itemExists.value) {
            Get.toNamed(
              '/sales/sell_item/',
            );
          }
          CPopupSnackBar.customToast(
              message: salesController.sellItemScanResults.value);
        },
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        child: const Icon(
          Iconsax.additem,
        ),
      ),
    );
  }
}
