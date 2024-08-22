import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/list_tiles/menu_tile.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
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
                  const SizedBox(
                    height: CSizes.spaceBtnSections / 2,
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
                      onPressed: () {},
                      icon: const Icon(
                        Iconsax.edit,
                        color: CColors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnSections,
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
                    title: 'account settings',
                    btnTitle: '',
                    editFontSize: false,
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnItems,
                  ),
                  CMenuTile(
                    icon: Iconsax.safe_home,
                    title: 'my addresses',
                    subTitle: 'set shopping delivery address',
                    onTap: () {
                      //Get.to(() => const UserAddressesScreen());
                    },
                  ),
                  CMenuTile(
                    icon: Iconsax.shopping_cart,
                    title: 'my cart',
                    subTitle: 'add, remove products, and proceed to checkout',
                    onTap: () {},
                  ),
                  CMenuTile(
                    icon: Iconsax.bag_tick,
                    title: 'my orders',
                    subTitle: 'in-progress and completed orders',
                    onTap: () {
                      //Get.to(() => const OrdersScreen());
                    },
                  ),
                  CMenuTile(
                    icon: Iconsax.bank,
                    title: 'bank account',
                    subTitle: 'withdraw balance to a registered bank account',
                    onTap: () {},
                  ),
                  CMenuTile(
                    icon: Iconsax.discount_shape,
                    title: 'my coupons',
                    subTitle: 'list of all the discounted coupons',
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
