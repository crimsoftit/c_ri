import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/search_bar/animated_search_bar.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/common/widgets/tab_views/store_items_tabs.dart';
import 'package:c_ri/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final searchController = Get.put(CSearchBarController());
    final invController = Get.put(CInventoryController());
    final salesController = Get.put(CSalesController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        /// -- body --
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              CPrimaryHeaderContainer(
                child: Column(
                  children: [
                    /// -- app bar --
                    Obx(
                      () {
                        invController.fetchInventoryItems();
                        return CAppBar(
                          leadingWidget: searchController
                                  .salesShowSearchField.value
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'transactions',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge!
                                            .apply(
                                              color: CColors.white,
                                            ),
                                      ),
                                      const SizedBox(
                                        width: CSizes.spaceBtnSections,
                                      ),

                                      /// -- scan item for sale --
                                      IconButton(
                                        onPressed: () {
                                          invController.fetchInventoryItems();
                                          salesController.scanItemForSale();
                                        },
                                        icon: const Icon(
                                          Iconsax.scan,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          horizontalPadding: 1.0,
                          showBackArrow: false,
                          backIconColor:
                              isDarkTheme ? CColors.white : CColors.rBrown,
                          title: CAnimatedSearchBar(
                            hintTxt: 'inventory, transactions',
                            boxColor:
                                searchController.salesShowSearchField.value
                                    ? CColors.white
                                    : Colors.transparent,
                            controller: searchController.txtSalesSearch,
                          ),
                          backIconAction: () {
                            // Navigator.pop(context, true);
                            // Get.back();
                          },
                        );
                      },
                    ),

                    const SizedBox(
                      height: CSizes.spaceBtnSections,
                    ),
                  ],
                ),
              ),

              /// -- tab bars for inventory & transactions lists --
              Obx(
                () {
                  if (searchController.salesShowSearchField.value) {
                    //invController.fetchInventoryItems();
                    return const CStoreItemsTabs(
                      tab1Title: 'inventory',
                      tab2Title: 'transactions',
                    );
                  }

                  // run loader --
                  if (salesController.isLoading.value ||
                      invController.isLoading.value) {
                    return const CVerticalProductShimmer(
                      itemCount: 7,
                    );
                  }

                  salesController.fetchTransactions();

                  // -- no data widget --
                  if (invController.inventoryItems.isEmpty ||
                      salesController.transactions.isEmpty) {
                    return const Center(
                      child: NoDataScreen(
                        lottieImage: CImages.noDataLottie,
                        txt: 'No data found!',
                      ),
                    );
                  }

                  return SizedBox(
                    height: CHelperFunctions.screenHeight() * 0.72,
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
                              5.0,
                            ),
                            leading: CircleAvatar(
                              backgroundColor: Colors.brown[300],
                              radius: 16.0,
                              child: Text(
                                salesController
                                    .transactions[index].productName[0]
                                    .toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .labelLarge!
                                    .apply(
                                      color: CColors.white,
                                    ),
                              ),
                            ),
                            title: Text(
                              '${salesController.transactions[index].productName.toUpperCase()} (txn id: #${salesController.transactions[index].saleId})',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(
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
            invController.fetchInventoryItems();
            salesController.scanItemForSale();
          },
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          child: const Icon(
            Iconsax.additem,
          ),
        ),
      ),
    );
  }
}
