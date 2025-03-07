import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/search_bar/animated_search_bar.dart';
import 'package:c_ri/common/widgets/shimmers/shimmer_effects.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/common/widgets/tab_views/store_items_tabs.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TxnsScreen extends StatelessWidget {
  const TxnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final searchController = Get.put(CSearchBarController());
    //final syncController = Get.put(CSyncController());
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());

    Get.put(CInventoryController());
    txnsController.fetchTransactions();

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
                                        'sales',
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
                                          txnsController.scanItemForSale();
                                        },
                                        icon: const Icon(
                                          Iconsax.scan,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: CSizes.spaceBtnSections / 4,
                                      ),

                                      /// -- track unsynced txns --
                                      // txnsController.isLoading.value ||
                                      //         invController.isLoading.value
                                      txnsController.syncIsLoading.value ||
                                              invController.isLoading.value ||
                                              txnsController.syncIsLoading.value
                                          ? const CShimmerEffect(
                                              width: 40.0,
                                              height: 40.0,
                                              radius: 40.0,
                                            )
                                          : txnsController
                                                  .unsyncedTxnAppends.isEmpty
                                              ? const Icon(
                                                  Iconsax.cloud_add,
                                                )
                                              : IconButton(
                                                  onPressed: () async {
                                                    // -- check internet connectivity --
                                                    final internetIsConnected =
                                                        await CNetworkManager
                                                            .instance
                                                            .isConnected();
                                                    if (internetIsConnected) {
                                                      await txnsController
                                                          .addSalesToCloud()
                                                          .then((result) {
                                                        txnsController
                                                            .syncIsLoading
                                                            .value = false;
                                                        txnsController.isLoading
                                                            .value = false;
                                                      });
                                                    } else {
                                                      CPopupSnackBar
                                                          .customToast(
                                                        message:
                                                            'internet connection required for cloud sync!',
                                                        forInternetConnectivityStatus:
                                                            true,
                                                      );
                                                    }
                                                  },
                                                  icon: const Icon(
                                                    Iconsax.cloud_change,
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
                  if (txnsController.isLoading.value ||
                      invController.isLoading.value ||
                      txnsController.syncIsLoading.value) {
                    return const CVerticalProductShimmer(
                      itemCount: 7,
                    );
                  }

                  // -- no data widget --
                  if (invController.inventoryItems.isEmpty ||
                      txnsController.transactions.isEmpty) {
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
                      itemCount: txnsController.transactions.length,
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
                                txnsController
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
                              '${txnsController.transactions[index].productName.toUpperCase()} ',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(
                                    color: CColors.rBrown,
                                    //fontSizeFactor: 1.2,
                                    //fontWeightDelta: 2,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'soldItemId: ${txnsController.transactions[index].soldItemId}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .apply(
                                        color: CColors.rBrown,
                                        //fontStyle: FontStyle.italic,
                                      ),
                                ),
                                Text(
                                  'pCode: ${txnsController.transactions[index].productCode} t.Amount: ${userController.user.value.currencyCode}.${txnsController.transactions[index].totalAmount}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .apply(
                                        color: CColors.rBrown
                                            .withValues(alpha: 0.8),
                                        //fontStyle: FontStyle.italic,
                                      ),
                                ),
                                Text(
                                  'payment method: ${txnsController.transactions[index].paymentMethod} qty: ${txnsController.transactions[index].quantity} ',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelMedium!
                                      .apply(
                                        color: CColors.rBrown
                                            .withValues(alpha: 0.8),
                                        //fontStyle: FontStyle.italic,
                                      ),
                                ),
                                Text(
                                  'modified: ${txnsController.transactions[index].date} (txn id: #${txnsController.transactions[index].txnId})',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(
                                        color: CColors.rBrown
                                            .withValues(alpha: 0.7),
                                        //fontStyle: FontStyle.italic,
                                      ),
                                ),
                                Text(
                                  'isSynced:${txnsController.transactions[index].isSynced} syncAction:${txnsController.transactions[index].syncAction}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(
                                        color: CColors.rBrown
                                            .withValues(alpha: 0.7),
                                        //fontStyle: FontStyle.italic,
                                      ),
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.toNamed(
                                '/sales/txn_details',
                                arguments:
                                    txnsController.transactions[index].txnId,
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
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.brown,
          foregroundColor: Colors.white,
          icon: const Icon(
            Iconsax.additem,
          ),
          label: const Text(
            'transact',
          ),
          onPressed: () {
            invController.fetchInventoryItems();
            txnsController.scanItemForSale();
          },
        ),
      ),
    );
  }
}
