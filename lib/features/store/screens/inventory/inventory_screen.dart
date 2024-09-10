import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/icon_buttons/trailing_icon_btn.dart';
import 'package:c_ri/common/widgets/shimmers/horizontal_products_shimmer.dart';
import 'package:c_ri/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/screens/inventory/widgets/add_update_inventory_item_dialog.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
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

    return Scaffold(
      /// -- app bar --
      appBar: CAppBar(
        showBackArrow: false,
        backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
        title: Text(
          'inventory items',
          style: Theme.of(context).textTheme.headlineSmall!.apply(
                fontSizeFactor: 0.85,
              ),
        ),
        actions: [
          // -- search button
          CTrailingIconBtn(
            iconColor: isDarkTheme ? CColors.white : CColors.rBrown,
            iconData: Iconsax.search_favorite,
            onPressed: () {},
          ),
        ],
        backIconAction: () {
          // Navigator.pop(context, true);
          // Get.back();
        },
      ),

      /// -- body --
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Obx(() {
            // run loader --
            if (invController.isLoading.value) {
              return const CHorizontalProductShimmer(itemCount: 4);
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

            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: (invController.inventoryItems.isNotEmpty)
                  ? invController.inventoryItems.length
                  : 0,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: Key(invController.inventoryItems[index].pCode),
                  onDismissed: (direction) {
                    // -- confirm before deleting --
                    invController.deleteInventoryWarningPopup(
                        invController.inventoryItems[index]);
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 1.0,
                    child: ListTile(
                      title: Text(
                        '${invController.inventoryItems[index].name} (${invController.inventoryItems[index].date})',
                        style: Theme.of(context).textTheme.labelMedium!.apply(
                              color: CColors.rBrown,
                            ),
                      ),
                      leading: CircleAvatar(
                        backgroundColor: Colors.brown[300],
                        child: Text(
                          invController.inventoryItems[index].name[0]
                              .toUpperCase(),
                          style: Theme.of(context).textTheme.labelLarge!.apply(
                                color: CColors.white,
                              ),
                        ),
                      ),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                "qty: ${invController.inventoryItems[index].quantity}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .apply(
                                      color: CColors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                              Text(
                                " BP: Ksh.${invController.inventoryItems[index].buyingPrice}",
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall!
                                    .apply(
                                      color: CColors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      onTap: () {
                        Get.toNamed(
                          '/inventory/item_details/',
                          arguments: invController.inventoryItems[index].pCode,
                        );
                      },
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          // color: Color.fromARGB(255, 153, 113, 98),
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // -- confirm before deleting --
                          invController.deleteInventoryWarningPopup(
                              invController.inventoryItems[index]);
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //print(invController.currentScreen.value);

          showDialog(
            context: context,
            useRootNavigator: false,
            builder: (BuildContext context) => dialog.buildDialog(
              context,
              CInventoryModel('', '', 0, 0, 0, ''),
              true,
            ),
          );
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
