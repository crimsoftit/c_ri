import 'package:c_ri/common/widgets/loaders/animated_loader.dart';
import 'package:c_ri/common/widgets/products/product_cards/product_card_vertical.dart';
import 'package:c_ri/common/widgets/shimmers/shimmer_effects.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/controllers/sync_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/screens/search/widgets/no_results_screen.dart';
import 'package:c_ri/features/store/screens/store_items_tings/inventory/widgets/inv_dialog.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CInvGridviewScreen extends StatelessWidget {
  const CInvGridviewScreen({
    super.key,
    this.mainAxisExtent = 160.0,
  });

  final double? mainAxisExtent;

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final searchController = Get.put(CSearchBarController());
    final syncController = Get.put(CSyncController());
    final txnsController = Get.put(CTxnsController());

    AddUpdateItemDialog dialog = AddUpdateItemDialog();

    return Obx(
      () {
        /// -- empty data widget --
        final noDataWidget = CAnimatedLoaderWidget(
          actionBtnWidth: 180.0,
          actionBtnText: 'let\'s fill it!',
          animation: CImages.noDataLottie,
          lottieAssetWidth: CHelperFunctions.screenWidth() * 0.42,
          onActionBtnPressed: () {
            showDialog(
              context: context,
              useRootNavigator: false,
              builder: (BuildContext context) => dialog.buildDialog(
                context,
                CInventoryModel('', '', '', '', '', 0, 0, 0, 0, 0.0, 0.0, 0.0,
                    0, '', '', '', 0, ''),
                true,
              ),
            );
          },
          showActionBtn: true,
          text: 'whoops! store is EMPTY!',
        );

        // run loader --
        if (invController.isLoading.value) {
          return const CVerticalProductShimmer(
            itemCount: 7,
          );
        }

        if (invController.foundInventoryItems.isEmpty &&
            searchController.showSearchField.value &&
            !invController.isLoading.value) {
          return const NoSearchResultsScreen();
        }

        if (invController.inventoryItems.isEmpty &&
            !searchController.showSearchField.value &&
            invController.foundInventoryItems.isEmpty &&
            !invController.isLoading.value) {
          return noDataWidget;

          // const Center(
          //   child: NoDataScreen(
          //     lottieImage: CImages.noDataLottie,
          //     txt: 'No data found!',
          //   ),
          // );
        }

        return ListView(
          padding: const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
          ),
          shrinkWrap: true,
          children: [
            SizedBox(
              width: invController.syncIsLoading.value ||
                      txnsController.txnsSyncIsLoading.value
                  ? 40.0
                  : 150.0,
              child: invController.syncIsLoading.value ||
                      txnsController.txnsSyncIsLoading.value
                  ? const CShimmerEffect(
                      width: 40.0,
                      height: 40.0,
                      radius: 40.0,
                    )
                  : invController.unSyncedAppends.isEmpty &&
                          invController.unSyncedUpdates.isEmpty
                      ? null
                      : TextButton.icon(
                          icon: const Icon(
                            Iconsax.cloud_change,
                            size: CSizes.iconSm,
                            color: CColors.white,
                          ),
                          label: Text(
                            'sync to cloud',
                            style:
                                Theme.of(context).textTheme.labelMedium!.apply(
                                      color: CColors.white,
                                    ),
                          ),
                          style: ElevatedButton.styleFrom(
                            elevation: 0.2,
                            foregroundColor:
                                CColors.white, // foreground (text) color
                            backgroundColor: isDarkTheme
                                ? CColors.rBrown.withValues(alpha: 0.25)
                                : CColors.transparent, // background color
                          ),
                          onPressed: () async {
                            // -- check internet connectivity --
                            final internetIsConnected =
                                await CNetworkManager.instance.isConnected();

                            if (internetIsConnected) {
                              syncController.processSync();
                            } else {
                              CPopupSnackBar.customToast(
                                message:
                                    'internet connection required for cloud sync!',
                                forInternetConnectivityStatus: true,
                              );
                            }
                          },
                        ),
            ),
            GridView.builder(
              itemCount: searchController.showSearchField.value
                  ? invController.foundInventoryItems.length
                  : invController.inventoryItems.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: CSizes.gridViewSpacing / 12,
                crossAxisSpacing: CSizes.gridViewSpacing / 12,
                mainAxisExtent: mainAxisExtent,
              ),
              itemBuilder: (context, index) {
                var avatarTxt = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].name[0]
                        .toUpperCase()
                    : invController.inventoryItems[index].name[0].toUpperCase();

                var bp = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].buyingPrice
                    : invController.inventoryItems[index].buyingPrice;

                var date = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].date
                    : invController.inventoryItems[index].date;

                var lowStockNotifierLimit = searchController
                            .showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController
                        .foundInventoryItems[index].lowStockNotifierLimit
                    : invController.inventoryItems[index].lowStockNotifierLimit;

                var productId = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].productId
                    : invController.inventoryItems[index].productId;

                var pName = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].name
                    : invController.inventoryItems[index].name;

                var qtyAvailable = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].quantity
                    : invController.inventoryItems[index].quantity;

                var qtyRefunded = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].qtyRefunded
                    : invController.inventoryItems[index].qtyRefunded;

                var qtySold = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].qtySold
                    : invController.inventoryItems[index].qtySold;

                var sku = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].pCode
                    : invController.inventoryItems[index].pCode;

                var usp = searchController.showSearchField.value &&
                        invController.foundInventoryItems.isNotEmpty
                    ? invController.foundInventoryItems[index].unitSellingPrice
                    : invController.inventoryItems[index].unitSellingPrice;

                return CProductCardVertical(
                  date: date,
                  bp: bp.toString(),
                  deleteAction: () {
                    CInventoryModel itemId;
                    if (invController.foundInventoryItems.isNotEmpty) {
                      itemId = invController.foundInventoryItems[index];
                    } else {
                      itemId = invController.inventoryItems[index];
                    }
                    invController.deleteInventoryWarningPopup(itemId);
                  },
                  itemAvatar: avatarTxt,
                  itemName: pName,
                  lowStockNotifierLimit: lowStockNotifierLimit,
                  onTapAction: () {
                    Get.toNamed(
                      '/inventory/item_details/',
                      arguments: invController.inventoryItems[index].productId,
                    );
                  },
                  pCode: sku,
                  pId: productId!,
                  qtyAvailable: qtyAvailable.toString(),
                  qtyRefunded: qtyRefunded.toString(),
                  qtySold: qtySold.toString(),
                  usp: usp.toString(),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
