import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/icon_buttons/trailing_icon_btn.dart';
import 'package:c_ri/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:c_ri/features/store/controllers/inventory_controller.dart';
import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/features/store/screens/inventory/widgets/add_update_inventory_item_dialog.dart';
import 'package:c_ri/features/store/screens/inventory_details/inventory_details.dart';
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
    invController.fetchInventoryItems();

    return Scaffold(
      /// -- app bar --
      appBar: CAppBar(
        showBackArrow: true,
        backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
        title: Text(
          'inventory',
          style: Theme.of(context).textTheme.headlineSmall!.apply(
                fontSizeFactor: 0.7,
              ),
        ),
        actions: [
          // -- search button
          CTrailingIconBtn(
            iconColor: CColors.white,
            iconData: Iconsax.search_favorite,
            onPressed: () {},
          ),
        ],
      ),

      /// -- body --
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Obx(() {
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
                    String pName = invController.inventoryItems[index].name;
                    invController.deleteInventoryItem(
                        invController.inventoryItems[index]);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("$pName deleted"),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 1.0,
                    child: ListTile(
                      title: Text(
                        invController.inventoryItems[index].name,
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
                        children: [
                          Text(
                            invController.inventoryItems[index].date,
                            style:
                                Theme.of(context).textTheme.labelSmall!.apply(
                                      color: CColors.grey,
                                      fontStyle: FontStyle.italic,
                                    ),
                          ),
                        ],
                      ),
                      onTap: () {
                        Get.to(() => CInventoryDetailsScreen(
                              inventoryItem:
                                  invController.inventoryItems[index],
                            ));
                      },
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.delete,
                          color: Color.fromARGB(255, 153, 113, 98),
                        ),
                        onPressed: () {},
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
          // update current page
          invController.currentScreen.value = "invListScreen";
          //print(invController.currentScreen.value);

          showDialog(
            context: context,
            builder: (BuildContext context) => dialog.buildDialog(
              context,
              CInventoryModel(0, '', '', 0, 0, 0, ''),
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
