import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/list_tiles/menu_tile.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/controllers/inventory_controller.dart';
import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/features/store/screens/inventory/widgets/add_update_inventory_item_dialog.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CInventoryDetailsScreen extends StatelessWidget {
  const CInventoryDetailsScreen({
    super.key,
    required this.inventoryItem,
  });

  final CInventoryModel inventoryItem;

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

    AddUpdateItemDialog dialog = AddUpdateItemDialog();

    final invController = Get.put(CInventoryController());
    invController.fetchItemByCode(inventoryItem.pCode);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // -- header --
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  // app bar
                  CAppBar(
                    title: Text(
                      'product details',
                      style: Theme.of(context).textTheme.headlineSmall!.apply(
                            color: CColors.white,
                          ),
                    ),
                  ),

                  // product profile card
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown[300],
                      child: Text(
                        inventoryItem.name[0].toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                              color: CColors.white,
                            ),
                      ),
                    ),
                    title: Text(
                      inventoryItem.name,
                      //invDetails[0].name,
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: CColors.grey,
                          ),
                    ),
                    subtitle: Text(
                      inventoryItem.date,
                      style: Theme.of(context).textTheme.headlineSmall!.apply(
                            color: CColors.white,
                            fontSizeFactor: 0.6,
                          ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        // update current page
                        invController.currentScreen.value = "invDetailsScreen";
                        //print(invController.currentScreen.value);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => dialog.buildDialog(
                            context,
                            CInventoryModel(
                              inventoryItem.id,
                              inventoryItem.pCode,
                              inventoryItem.name,
                              inventoryItem.quantity,
                              //invController.itemQty.value,
                              inventoryItem.buyingPrice,
                              inventoryItem.unitSellingPrice,
                              inventoryItem.date,
                            ),
                            false,
                          ),
                        );
                      },
                      icon: const Icon(
                        Iconsax.edit,
                        color: CColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnSections / 4,
                  ),
                ],
              ),
            ),

            // -- body --
            Padding(
              padding: const EdgeInsets.all(CSizes.defaultSpace),
              child: Column(
                children: [
                  // --- account settings
                  const CSectionHeading(
                    showActionBtn: false,
                    title: 'details',
                    btnTitle: '',
                    editFontSize: false,
                  ),

                  CMenuTile(
                    icon: Iconsax.barcode,
                    title: inventoryItem.pCode,
                    subTitle: 'sku/code',
                    onTap: () {},
                  ),
                  CMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: '${(inventoryItem.quantity)}',
                    subTitle: 'Qty/units available',
                    onTap: () {},
                  ),

                  CMenuTile(
                    icon: Iconsax.bitcoin_card,
                    title: 'Ksh. ${(inventoryItem.buyingPrice)}',
                    subTitle: 'buying price',
                    onTap: () {
                      //Get.to(() => const UserAddressesScreen());
                    },
                  ),

                  CMenuTile(
                    icon: Iconsax.card_pos,
                    title: 'Ksh. ${(inventoryItem.unitSellingPrice)}',
                    subTitle: 'unit selling price',
                    onTap: () {
                      //Get.to(() => const OrdersScreen());
                    },
                  ),
                  CMenuTile(
                    icon: Iconsax.calendar,
                    title: inventoryItem.date,
                    subTitle: 'last modified',
                    onTap: () {},
                  ),
                  CMenuTile(
                    icon: Iconsax.card_tick,
                    title: '',
                    subTitle: 'total sales',
                    onTap: () {},
                  ),
                  CMenuTile(
                    icon: Iconsax.notification,
                    title: 'notifications',
                    subTitle: 'customize notification messages',
                    onTap: () {},
                  ),
                  CMenuTile(
                    icon: Iconsax.security_card,
                    title: 'account privacy',
                    subTitle: 'manage data usage and connected accounts',
                    onTap: () {},
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnSections,
                  ),

                  // -- app settings
                  const CSectionHeading(
                    showActionBtn: false,
                    title: 'app settings',
                    btnTitle: '',
                    editFontSize: false,
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnItems,
                  ),
                  CMenuTile(
                    icon: Iconsax.document_upload,
                    title: 'upload data',
                    subTitle: 'upload data to your cloud firebase',
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.arrow_right),
                    ),
                    onTap: () {},
                  ),
                  CMenuTile(
                    icon: Iconsax.location,
                    title: 'geolocation',
                    subTitle: 'set recommendation based on location',
                    trailing: Switch(
                      value: true,
                      activeColor: CColors.rBrown,
                      onChanged: (value) {},
                    ),
                  ),
                  CMenuTile(
                    icon: Iconsax.security_user,
                    title: 'safe mode',
                    subTitle: 'search result is safe for people of all ages',
                    trailing: Switch(
                      value: false,
                      activeColor: CColors.rBrown,
                      onChanged: (value) {},
                    ),
                  ),
                  CMenuTile(
                    icon: Iconsax.security_user,
                    title: 'HD image quality',
                    subTitle: 'set image quality to be seen',
                    trailing: Switch(
                      value: false,
                      activeColor: CColors.rBrown,
                      onChanged: (value) {},
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: CSizes.spaceBtnItems,
                  ),

                  const Center(
                    child: Row(
                      children: [
                        Icon(
                          Iconsax.logout,
                          size: 28.0,
                          color: CColors.primaryBrown,
                        ),
                        SizedBox(
                          width: CSizes.spaceBtnInputFields,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
