import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/list_tiles/menu_tile.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/screens/inventory/widgets/inv_dialog.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CInventoryDetailsScreen1 extends StatelessWidget {
  const CInventoryDetailsScreen1({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    AddUpdateItemDialog dialog = AddUpdateItemDialog();

    final invController = Get.put(CInventoryController());

    final invList = invController.inventoryItems;

    final invItem =
        invList.firstWhere((item) => item.productId == Get.arguments);

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
                    backIconAction: () {
                      Navigator.pop(context, true);
                      Get.back();
                    },
                    showBackArrow: true,
                    backIconColor: CColors.white,
                  ),

                  // product profile card
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.brown[300],
                      child: Text(
                        invItem.name[0].toUpperCase(),
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                              color: CColors.white,
                            ),
                      ),
                    ),
                    title: Text(
                      invItem.name,
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: CColors.grey,
                          ),
                    ),
                    subtitle: Text(
                      invItem.date,
                      style: Theme.of(context).textTheme.headlineSmall!.apply(
                            color: CColors.white,
                            fontSizeFactor: 0.6,
                          ),
                    ),
                    trailing: IconButton(
                      onPressed: () {
                        invController.itemExists.value = true;
                        showDialog(
                          context: context,
                          useRootNavigator: false,
                          builder: (BuildContext context) => dialog.buildDialog(
                            context,
                            CInventoryModel(
                              invItem.userId,
                              invItem.userEmail,
                              invItem.userName,
                              invItem.pCode,
                              invItem.name,
                              invItem.quantity,
                              invItem.buyingPrice,
                              invItem.unitSellingPrice,
                              invItem.date,
                            ),
                            invController.itemExists.value ? false : true,
                          ),
                        );
                        //setState(() {});
                      },
                      icon: const Icon(
                        Iconsax.edit,
                        color: CColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnSections / 2,
                  ),
                ],
              ),
            ),

            // -- body --
            Obx(
              () => Padding(
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
                      title: invItem.productId.toString(),
                      subTitle: 'product/item id',
                      onTap: () {},
                    ),

                    CMenuTile(
                      icon: Iconsax.barcode,
                      title: invItem.pCode,
                      subTitle: 'sku/code',
                      onTap: () {},
                    ),
                    CMenuTile(
                      icon: Iconsax.shopping_cart,
                      title: '${(invItem.quantity)}',
                      subTitle: 'Qty/units available',
                      onTap: () {},
                    ),

                    CMenuTile(
                      icon: Iconsax.bitcoin_card,
                      //title: '',
                      title: 'Ksh. ${(invItem.buyingPrice)}',
                      subTitle: 'buying price',
                      onTap: () {
                        //Get.to(() => const UserAddressesScreen());
                      },
                    ),

                    CMenuTile(
                      icon: Iconsax.card_pos,
                      //title: '',
                      title: 'Ksh. ${(invItem.unitSellingPrice)}',
                      subTitle: 'unit selling price',
                      onTap: () {
                        //Get.to(() => const OrdersScreen());
                      },
                    ),
                    CMenuTile(
                      icon: Iconsax.calendar,
                      title: 'comming soon',
                      subTitle: 'last modified',
                      onTap: () {},
                    ),
                    CMenuTile(
                      icon: Iconsax.card_tick,
                      title: 'coming soon',
                      subTitle: 'total sales',
                      onTap: () {},
                    ),
                    CMenuTile(
                      icon: Iconsax.notification,
                      title: 'notifications',
                      subTitle: 'customize notification messages',
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
            ),
          ],
        ),
      ),
    );
  }
}
