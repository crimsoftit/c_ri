import 'package:c_ri/api/sheets/store_sheets_api.dart';
import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/search_bar/animated_search_bar.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/screens/inventory/widgets/inv_dialog.dart';
import 'package:c_ri/features/store/screens/search/widgets/no_results_screen.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class InventoryScreen extends StatelessWidget {
  const InventoryScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    AddUpdateItemDialog dialog = AddUpdateItemDialog();

    final invController = Get.put(CInventoryController());

    final userController = Get.put(CUserController());

    final searchController = Get.put(CSearchBarController());

    final txnsController = Get.put(CTxnsController());

    final currency =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);

    return Scaffold(
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
                        leadingWidget: searchController.invShowSearchField.value
                            ? null
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 10.0),
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
                                    IconButton(
                                      onPressed: () {
                                        invController.runInvScanner();
                                        showDialog(
                                          context: context,
                                          useRootNavigator: false,
                                          builder: (BuildContext context) =>
                                              dialog.buildDialog(
                                            context,
                                            CInventoryModel('', '', '', '', '',
                                                0, 0, 0, '', 0, ''),
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
                                    invController.unSyncedAppends.isEmpty &&
                                            invController
                                                .unSyncedUpdates.isEmpty
                                        ? const Icon(
                                            Iconsax.cloud_add,
                                          )
                                        : IconButton(
                                            onPressed: () async {
                                              invController.fetchInvDels();
                                              invController.syncInvDels();
                                              // -- check internet connectivity
                                              final isConnected =
                                                  await CNetworkManager.instance
                                                      .isConnected();

                                              if (isConnected) {
                                                /// -- initialize spreadsheets --
                                                await StoreSheetsApi
                                                    .initSpreadSheets();
                                                await invController
                                                    .addUnsyncedInvToCloud();
                                                await invController
                                                    .syncInvUpdates();
                                              } else {
                                                CPopupSnackBar.warningSnackBar(
                                                  title:
                                                      'cloud sync requires internet',
                                                  message:
                                                      'an internet connection is required for cloud sync...',
                                                );
                                              }
                                            },
                                            icon: const Icon(
                                              Iconsax.cloud_cross,
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
                          hintTxt: 'inventory',
                          boxColor: searchController.invShowSearchField.value
                              ? CColors.white
                              : Colors.transparent,
                          controller: searchController.txtInvSearchField,
                        ),
                        backIconAction: () {
                          //invController.addUnsyncedInvToCloud();
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
            Obx(
              () {
                // run loader --
                if (invController.isLoading.value) {
                  return const CVerticalProductShimmer(
                    itemCount: 4,
                  );
                }

                invController.fetchInventoryItems();

                if (searchController.txtInvSearchField.text.isNotEmpty &&
                    invController.foundInventoryItems.isEmpty) {
                  return const NoSearchResultsScreen();
                }

                // -- no data widget --
                if (invController.inventoryItems.isEmpty) {
                  return const Center(
                    child: NoDataScreen(
                      lottieImage: CImages.noDataLottie,
                      txt: 'No data found!',
                    ),
                  );
                }

                return SizedBox(
                  height: CHelperFunctions.screenHeight() * 0.7,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(2.0),
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    itemCount:
                        searchController.txtInvSearchField.text.isNotEmpty
                            ? invController.foundInventoryItems.length
                            : (invController.inventoryItems.isNotEmpty)
                                ? invController.inventoryItems.length
                                : 0,
                    itemBuilder: (context, index) {
                      return Dismissible(
                        key: Key(searchController
                                .txtInvSearchField.text.isNotEmpty
                            ? invController.foundInventoryItems[index].productId
                                .toString()
                            : invController.inventoryItems[index].productId
                                .toString()),
                        onDismissed: (direction) {
                          // -- confirm before deleting --
                          invController.deleteInventoryWarningPopup(
                              searchController.txtInvSearchField.text.isNotEmpty
                                  ? invController.foundInventoryItems[index]
                                  : invController.inventoryItems[index]);
                        },
                        child: Card(
                          //color: Colors.white,
                          // color: isDarkTheme
                          //     ? CColors.white
                          //     : CColors.white.withOpacity(0.8),
                          color: CColors.white,
                          elevation: 0.3,
                          child: ListTile(
                            horizontalTitleGap: 10,
                            contentPadding: const EdgeInsets.all(10.0),
                            titleAlignment: ListTileTitleAlignment.center,
                            //minLeadingWidth: 30.0,
                            leading: CircleAvatar(
                              backgroundColor: Colors.brown[300],
                              radius: 16,
                              child: Text(
                                searchController
                                        .txtInvSearchField.text.isNotEmpty
                                    ? invController
                                        .foundInventoryItems[index].name[0]
                                    : invController
                                        .inventoryItems[index].name[0]
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
                              searchController.txtInvSearchField.text.isNotEmpty
                                  ? invController
                                      .foundInventoryItems[index].name
                                      .toUpperCase()
                                  : '${invController.inventoryItems[index].name.toUpperCase()} (#${invController.inventoryItems[index].productId})',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .apply(
                                    color: CColors.rBrown,
                                  ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),

                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                const SizedBox(
                                  height: CSizes.spaceBtnInputFields / 4,
                                ),
                                SizedBox(
                                  //width: CHelperFunctions.screenWidth() * 0.92,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        "code: ${searchController.txtInvSearchField.text.isNotEmpty ? invController.foundInventoryItems[index].pCode : invController.inventoryItems[index].pCode} ",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .apply(
                                              color: CColors.rBrown
                                                  .withOpacity(0.7),
                                            ),
                                      ),

                                      Text(
                                        "Bp: $currency.${searchController.txtInvSearchField.text.isNotEmpty ? invController.foundInventoryItems[index].buyingPrice : invController.inventoryItems[index].buyingPrice}",
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelSmall!
                                            .apply(
                                              color: CColors.rBrown
                                                  .withOpacity(0.7),
                                            ),
                                      ),
                                      // Text(
                                    ],
                                  ),
                                ),
                                Text(
                                  "USP: $currency.${searchController.txtInvSearchField.text.isNotEmpty ? invController.foundInventoryItems[index].unitSellingPrice : invController.inventoryItems[index].unitSellingPrice}  added by: ${searchController.txtInvSearchField.text.isNotEmpty ? invController.foundInventoryItems[index].userName.split(" ").elementAt(0) : invController.inventoryItems[index].userName.split(" ").elementAt(0)}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(
                                        color: CColors.rBrown.withOpacity(0.7),
                                        //fontStyle: FontStyle.italic,
                                      ),
                                ),
                                Text(
                                  "qty: ${searchController.txtInvSearchField.text.isNotEmpty ? invController.foundInventoryItems[index].quantity : invController.inventoryItems[index].quantity}  modified: ${searchController.txtInvSearchField.text.isNotEmpty ? invController.foundInventoryItems[index].date : invController.inventoryItems[index].date}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(
                                        color: CColors.rBrown.withOpacity(0.7),
                                        //fontStyle: FontStyle.italic,
                                      ),
                                ),
                                Text(
                                  "isSynced: ${searchController.txtInvSearchField.text.isNotEmpty ? invController.foundInventoryItems[index].isSynced : invController.inventoryItems[index].isSynced} syncAction: ${searchController.txtInvSearchField.text.isNotEmpty ? invController.foundInventoryItems[index].syncAction : invController.inventoryItems[index].syncAction}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(
                                        color: CColors.rBrown.withOpacity(0.7),
                                        //fontStyle: FontStyle.italic,
                                      ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      child: TextButton.icon(
                                        label: Text(
                                          'info',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .apply(
                                                color: CColors.rBrown,
                                              ),
                                        ),
                                        icon: const Icon(
                                          Iconsax.information,
                                          color: CColors.rBrown,
                                          size: CSizes.iconSm,
                                        ),
                                        onPressed: () {
                                          Get.toNamed(
                                            '/inventory/item_details/',
                                            arguments: searchController
                                                    .txtInvSearchField
                                                    .text
                                                    .isNotEmpty
                                                ? invController
                                                    .foundInventoryItems[index]
                                                    .productId
                                                : invController
                                                    .inventoryItems[index]
                                                    .productId,
                                          );
                                        },
                                      ),
                                    ),
                                    const SizedBox(
                                      width: CSizes.spaceBtnInputFields,
                                    ),
                                    SizedBox(
                                      child: TextButton.icon(
                                        label: Text(
                                          'sell',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .apply(
                                                color: CColors.rBrown,
                                              ),
                                        ),
                                        icon: const Icon(
                                          Iconsax.card_pos,
                                          color: CColors.rBrown,
                                          size: CSizes.iconSm,
                                        ),
                                        onPressed: () {
                                          txnsController.onSellItemBtnAction(
                                              searchController.txtInvSearchField
                                                      .text.isNotEmpty
                                                  ? invController
                                                          .foundInventoryItems[
                                                      index]
                                                  : invController
                                                      .inventoryItems[index]);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            onTap: () {
                              Get.toNamed(
                                '/inventory/item_details/',
                                arguments: searchController
                                        .txtInvSearchField.text.isNotEmpty
                                    ? invController
                                        .foundInventoryItems[index].productId
                                    : invController
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
                                // -- confirm before deleting --

                                invController.deleteInventoryWarningPopup(
                                    searchController
                                            .txtInvSearchField.text.isNotEmpty
                                        ? invController
                                            .foundInventoryItems[index]
                                        : invController.inventoryItems[index]);
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
            // const SizedBox(
            //   height: CSizes.spaceBtnSections * 2,
            // ),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          invController.runInvScanner();
          showDialog(
            context: context,
            useRootNavigator: false,
            builder: (BuildContext context) => dialog.buildDialog(
              context,
              CInventoryModel('', '', '', '', '', 0, 0, 0, '', 0, ''),
              true,
            ),
          );
        },
        label: const Text('add item'),
        backgroundColor: Colors.brown,
        foregroundColor: Colors.white,
        icon: const Icon(
          Iconsax.additem,
        ),
      ),
    );
  }
}
