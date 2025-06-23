import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/appbar/tab_bar.dart';
import 'package:c_ri/common/widgets/products/cart/positioned_cart_counter_widget.dart';
import 'package:c_ri/common/widgets/search_bar/animated_search_bar.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/controllers/checkout_controller.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/screens/store_items_tings/checkout/widgets/checkout_scan_fab.dart';
import 'package:c_ri/features/store/screens/store_items_tings/inventory/widgets/inv_dialog.dart';
import 'package:c_ri/features/store/screens/store_items_tings/widgets/inv_gridview_screen.dart';
import 'package:c_ri/features/store/screens/store_items_tings/widgets/items_listview.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CStoreScreen extends StatelessWidget {
  const CStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CCheckoutController());
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final txnsController = Get.put(CTxnsController());

    txnsController.fetchTxns();
    AddUpdateItemDialog dialog = AddUpdateItemDialog();

    invController.fetchUserInventoryItems();

    final searchController = Get.put(CSearchBarController());
    return DefaultTabController(
      length: 3,
      child: Obx(
        () => Scaffold(
          backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
          appBar: CAppBar(
            leadingWidget: searchController.showSearchField.value
                ? null
                : Padding(
                    padding: const EdgeInsets.only(top: 5.0, left: 10.0),
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.menu,
                          size: 25.0,
                          color: CColors.rBrown,
                        ),
                        Expanded(
                          child: searchController.showSearchField.value
                              ? CAnimatedSearchBar(
                                  hintTxt: 'inventory, transactions',
                                  boxColor:
                                      searchController.showSearchField.value
                                          ? CColors.white
                                          : Colors.transparent,
                                  controller: searchController.txtSearchField,
                                )
                              : Container(),
                        ),
                      ],
                    ),
                  ),
            horizontalPadding: 1.0,
            showBackArrow: false,
            backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
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
          ),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrollable) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  pinned: true,
                  floating: false,
                  backgroundColor: CColors.transparent,
                  expandedHeight: 50.0,
                  flexibleSpace: Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      right: 10.0,
                    ),
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Container(
                          // padding: const EdgeInsets.only(left: 2.0),
                          padding: EdgeInsets.zero,
                          child: Text(
                            'Store',
                            style:
                                Theme.of(context).textTheme.labelLarge!.apply(
                                      color: CNetworkManager
                                              .instance.hasConnection.value
                                          ? CColors.rBrown
                                          : CColors.darkGrey,
                                      fontSizeFactor: 2.5,
                                      fontWeightDelta: -7,
                                    ),
                          ),
                        ),
                        SizedBox(
                          height: 1.0,
                        ),
                      ],
                    ),
                  ),

                  /// -- tabs --
                  bottom: const CTabBar(
                    tabs: [
                      Tab(
                        child: Text('inventory'),
                      ),
                      Tab(
                        child: Text('sales'),
                      ),
                      Tab(
                        child: Text('refunds'),
                      ),
                    ],
                  ),

                  // TabBar(
                  //   indicatorColor: CColors.rBrown,
                  //   isScrollable: true,
                  //   labelColor: CColors.rBrown,
                  //   tabs: [

                  //   ],
                  // ),
                ),
              ];
            },
            body: const TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                /// -- inventory list items --
                CInvGridviewScreen(
                  mainAxisExtent: 176.0,
                ),

                /// -- transactions list view --
                CItemsListView(
                  space: 'sales',
                ),

                CItemsListView(
                  space: 'refunds',
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
                              backgroundColor:
                                  CNetworkManager.instance.hasConnection.value
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
                    //elevation: 0, // -- removes shadow
                    onPressed: () {
                      invController.resetInvFields();
                      showDialog(
                        context: context,
                        useRootNavigator: false,
                        builder: (BuildContext context) => dialog.buildDialog(
                          context,
                          CInventoryModel('', '', '', '', '', 0, 0, 0, 0, 0.0,
                              0.0, 0.0, 0, '', '', '', '', 0, ''),
                          true,
                        ),
                      );
                    },
                    backgroundColor:
                        CNetworkManager.instance.hasConnection.value
                            ? Colors.brown
                            : CColors.black,
                    //backgroundColor: CColors.transparent,
                    foregroundColor: CColors.white,
                    heroTag: 'add',
                    child: Icon(
                      // Iconsax.scan_barcode,
                      Iconsax.add,
                    ),
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnSections / 8,
                  ),
                  CCheckoutScanFAB(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
