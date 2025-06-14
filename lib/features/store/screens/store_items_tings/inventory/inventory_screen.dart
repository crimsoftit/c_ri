import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/products/cart/add_to_cart_btn.dart';
import 'package:c_ri/common/widgets/products/cart/positioned_cart_counter_widget.dart';
import 'package:c_ri/common/widgets/products/circle_avatar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/search_bar/animated_search_bar.dart';
import 'package:c_ri/common/widgets/shimmers/shimmer_effects.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/common/widgets/tab_views/store_items_tabs.dart';
import 'package:c_ri/common/widgets/txt_widgets/product_title_txt.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/controllers/checkout_controller.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/controllers/sync_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
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

class CInventoryScreen extends StatelessWidget {
  const CInventoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CCheckoutController());
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final searchController = Get.put(CSearchBarController());
    final syncController = Get.put(CSyncController());
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());

    AddUpdateItemDialog dialog = AddUpdateItemDialog();

    invController.fetchUserInventoryItems();

    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;

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
                          leadingWidget: searchController.showSearchField.value
                              ? null
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      top: 8.0, left: 10.0),
                                  child: Row(
                                    children: [
                                      Text(
                                        'inventory',
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
                                          invController.runInvScanner();
                                          showDialog(
                                            context: context,
                                            useRootNavigator: false,
                                            builder: (BuildContext context) =>
                                                dialog.buildDialog(
                                              context,
                                              CInventoryModel(
                                                  '',
                                                  '',
                                                  '',
                                                  '',
                                                  '',
                                                  0,
                                                  0,
                                                  0,
                                                  0,
                                                  0.0,
                                                  0.0,
                                                  0.0,
                                                  0,
                                                  '',
                                                  '',
                                                  '',
                                                  0,
                                                  ''),
                                              true,
                                            ),
                                          );
                                        },
                                        icon: const Icon(
                                          Iconsax.scan,
                                        ),
                                      ),
                                      const SizedBox(
                                        width: CSizes.spaceBtnSections / 4,
                                      ),

                                      invController.syncIsLoading.value
                                          ? const CShimmerEffect(
                                              width: 40.0,
                                              height: 40.0,
                                              radius: 40.0,
                                            )
                                          : invController.unSyncedAppends
                                                      .isEmpty &&
                                                  invController
                                                      .unSyncedUpdates.isEmpty
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
                                                      syncController
                                                          .processSync();
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
                            boxColor: searchController.showSearchField.value
                                ? CColors.white
                                : Colors.transparent,
                            controller: searchController.txtSearchField,
                          ),
                          backIconAction: () {
                            // Navigator.pop(context, true);
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
                  if (searchController.showSearchField.value) {
                    //invController.fetchInventoryItems();
                    return const CStoreItemsTabs(
                      tab1Title: 'inventory',
                      tab2Title: 'sold items',
                      tab3Title: 'refunds',
                    );
                  }

                  // run loader --
                  final cartController = Get.put(CCartController());
                  if (txnsController.isLoading.value ||
                      invController.isLoading.value ||
                      invController.syncIsLoading.value) {
                    return const CVerticalProductShimmer(
                      itemCount: 7,
                    );
                  }

                  if (invController.inventoryItems.isEmpty) {
                    invController.fetchUserInventoryItems();
                    if (invController.inventoryItems.isEmpty &&
                        !invController.isLoading.value &&
                        !invController.syncIsLoading.value &&
                        !cartController.cartItemsLoading.value) {
                      return const Center(
                        child: NoDataScreen(
                          lottieImage: CImages.noDataLottie,
                          txt: 'No data found!',
                        ),
                      );
                    }
                  }

                  if (invController.inventoryItems.isEmpty) {
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
                      padding: EdgeInsets.all(
                        2.0,
                      ),
                      shrinkWrap: true,
                      scrollDirection: Axis.vertical,
                      itemCount: invController.inventoryItems.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(invController.inventoryItems[index].productId
                              .toString()),
                          onDismissed: (direction) {
                            invController.deleteInventoryWarningPopup(
                                invController.inventoryItems[index]);
                          },
                          child: Card(
                            color: CColors.lightGrey,
                            elevation: 0.3,
                            child: ListTile(
                              horizontalTitleGap: 10,
                              contentPadding: const EdgeInsets.all(
                                5.0,
                              ),
                              leading: CCircleAvatar(
                                avatarInitial:
                                    invController.inventoryItems[index].name[0],
                                bgColor: invController
                                            .inventoryItems[index].quantity <
                                        5
                                    ? Colors.red
                                    : CColors.rBrown,
                              ),
                              title: CProductTitleText(
                                title: invController.inventoryItems[index].name
                                    .toUpperCase(),
                                smallSize: false,
                                txtColor: invController
                                            .inventoryItems[index].quantity ==
                                        0
                                    ? Colors.red
                                    : invController.inventoryItems[index]
                                                .quantity <=
                                            5
                                        ? Colors.amber
                                        : CColors.rBrown,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'code: ${invController.inventoryItems[index].pCode} usp: ${userController.user.value.currencyCode}.${invController.inventoryItems[index].unitSellingPrice}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .apply(
                                          color: invController
                                                      .inventoryItems[index]
                                                      .quantity <=
                                                  5
                                              ? Colors.red
                                              : CColors.rBrown
                                                  .withValues(alpha: 0.8),
                                          //fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                  CProductTitleText(
                                    title: invController
                                        .inventoryItems[index].date,
                                    smallSize: true,
                                    txtColor: invController
                                                .inventoryItems[index]
                                                .quantity <=
                                            5
                                        ? Colors.red
                                        : isConnectedToInternet
                                            ? CColors.rBrown
                                            : CColors.black,
                                  ),
                                  Text(
                                    'isSynced:${invController.inventoryItems[index].isSynced} syncAction:${invController.inventoryItems[index].syncAction}',
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
                                    'qty sold:${invController.inventoryItems[index].qtySold} (in stock:${invController.inventoryItems[index].quantity})',
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
                                    'total refunds:${invController.inventoryItems[index].qtyRefunded * invController.inventoryItems[index].unitSellingPrice} (refunded items:${invController.inventoryItems[index].qtyRefunded} )',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall!
                                        .apply(
                                          color: CColors.rBrown
                                              .withValues(alpha: 0.7),
                                          //fontStyle: FontStyle.italic,
                                        ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (invController
                                              .inventoryItems[index].quantity >=
                                          1)
                                        CAddToCartBtn(
                                          pId: invController
                                              .inventoryItems[index].productId!,
                                        ),
                                      if (invController
                                              .inventoryItems[index].quantity >=
                                          1)
                                        SizedBox(
                                          width: 5.0,
                                        ),
                                      SizedBox(
                                        width: 5.0,
                                      ),
                                      TextButton.icon(
                                        iconAlignment: IconAlignment.start,
                                        label: Text(
                                          'update',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .apply(
                                                color: CColors.rBrown,
                                              ),
                                        ),
                                        style: TextButton.styleFrom(
                                          padding: EdgeInsets.zero,
                                          minimumSize: Size(
                                            30,
                                            20,
                                          ),
                                          alignment: Alignment.centerLeft,
                                        ),
                                        icon: const Icon(
                                          Iconsax.edit,
                                          color: CColors.rBrown,
                                          size: CSizes.iconSm,
                                        ),
                                        onPressed: () {
                                          invController.itemExists.value = true;
                                          showDialog(
                                            context: context,
                                            useRootNavigator: true,
                                            builder: (BuildContext context) {
                                              invController
                                                      .currentItemId.value =
                                                  invController
                                                      .inventoryItems[index]
                                                      .productId!;
                                              return dialog.buildDialog(
                                                context,
                                                CInventoryModel.withID(
                                                  invController
                                                      .currentItemId.value,
                                                  userController.user.value.id,
                                                  userController
                                                      .user.value.email,
                                                  userController
                                                      .user.value.fullName,
                                                  invController
                                                      .inventoryItems[index]
                                                      .pCode,
                                                  invController
                                                      .inventoryItems[index]
                                                      .name,
                                                  invController
                                                      .inventoryItems[index]
                                                      .markedAsFavorite,
                                                  invController
                                                      .inventoryItems[index]
                                                      .quantity,
                                                  invController
                                                      .inventoryItems[index]
                                                      .qtySold,
                                                  invController
                                                      .inventoryItems[index]
                                                      .qtyRefunded,
                                                  invController
                                                      .inventoryItems[index]
                                                      .buyingPrice,
                                                  invController
                                                      .inventoryItems[index]
                                                      .unitBp,
                                                  invController
                                                      .inventoryItems[index]
                                                      .unitSellingPrice,
                                                  invController
                                                      .inventoryItems[index]
                                                      .lowStockNotifierLimit,
                                                  invController
                                                      .inventoryItems[index]
                                                      .supplierName,
                                                  invController
                                                      .inventoryItems[index]
                                                      .supplierContacts,
                                                  invController
                                                      .inventoryItems[index]
                                                      .date,
                                                  invController
                                                      .inventoryItems[index]
                                                      .isSynced,
                                                  invController
                                                      .inventoryItems[index]
                                                      .syncAction,
                                                ),
                                                false,
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              onTap: () {
                                Get.toNamed(
                                  '/inventory/item_details/',
                                  arguments: invController
                                      .inventoryItems[index].productId,
                                );
                              },
                              trailing: IconButton(
                                iconSize: 20.0,
                                icon: const Icon(
                                  Icons.delete,
                                  // color: Color.fromARGB(255, 153, 113, 98),
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  invController.deleteInventoryWarningPopup(
                                      invController.inventoryItems[index]);
                                },
                              ),
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
        floatingActionButton: Obx(
          () {
            final cartController = Get.put(CCartController());
            return Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                cartController.countOfCartItems.value >= 1
                    ? Stack(
                        alignment: Alignment.centerRight,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              checkoutController.handleNavToCheckout();
                            },
                            backgroundColor: isConnectedToInternet
                                ? Colors.brown
                                : CColors.black,
                            foregroundColor: Colors.white,
                            heroTag: 'checkout',
                            child: const Icon(
                              Iconsax.wallet_check,
                            ),
                          ),
                          CPositionedCartCounterWidget(
                            counterBgColor: CColors.white,
                            counterTxtColor: CColors.rBrown,
                            rightPosition: 10.0,
                            topPosition: 8.0,
                          ),
                        ],
                      )
                    : SizedBox(),
                const SizedBox(
                  height: CSizes.spaceBtnSections / 8,
                ),
                FloatingActionButton(
                  onPressed: () {
                    invController.runInvScanner();
                    showDialog(
                      context: context,
                      useRootNavigator: false,
                      builder: (BuildContext context) => dialog.buildDialog(
                        context,
                        CInventoryModel('', '', '', '', '', 0, 0, 0, 0, 0.0,
                            0.0, 0.0, 0, '', '', '', 0, ''),
                        true,
                      ),
                    );
                  },
                  backgroundColor:
                      isConnectedToInternet ? Colors.brown : CColors.black,
                  foregroundColor: Colors.white,
                  heroTag: 'scan',
                  child: const Icon(
                    // Iconsax.scan_barcode,
                    Iconsax.scan,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
