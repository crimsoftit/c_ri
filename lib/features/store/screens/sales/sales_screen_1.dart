import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/layouts/c_expansion_tile.dart';
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

class SalesScreen1 extends StatelessWidget {
  const SalesScreen1({super.key});

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
                          child: CExpansionTile(
                            avatarTxt: salesController
                                .transactions[index].productName[0]
                                .toUpperCase(),
                            titleTxt: salesController
                                .transactions[index].productName
                                .toUpperCase(),
                            subTitleTxt1Item1:
                                salesController.transactions[index].productCode,
                            subTitleTxt1Item2:
                                '${salesController.transactions[index].totalAmount}',
                            subTitleTxt2Item1: salesController
                                .transactions[index].paymentMethod,
                            subTitleTxt2Item2:
                                '${salesController.transactions[index].quantity}',
                            subTitleTxt3Item1:
                                salesController.transactions[index].date,
                            subTitleTxt3Item2:
                                '${salesController.transactions[index].saleId}',
                            btn1NavAction: () {
                              Get.toNamed(
                                '/sales/txn_details',
                                arguments:
                                    salesController.transactions[index].saleId,
                              );
                            },
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
