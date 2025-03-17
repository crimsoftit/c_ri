import 'package:c_ri/features/personalization/screens/profile/profile.dart';
import 'package:c_ri/features/personalization/screens/settings/user_settings.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/screens/home/home.dart';
import 'package:c_ri/features/store/screens/inventory/inventory_screen.dart';
import 'package:c_ri/features/store/screens/txns/sales_screen.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final invController = Get.put(CInventoryController());
    final navController = Get.put(NavMenuController());
    final isDark = CHelperFunctions.isDarkMode(context);

    Get.put(CCartController());
    Get.put(CInventoryController());

    invController.onInit();
    invController.fetchTopSellers();
    cartController.fetchCartItems();

    GlobalKey navBarGlobalKey = GlobalKey(debugLabel: 'bottomAppBar');

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          key: navBarGlobalKey,
          height: 80.0,
          elevation: 0,
          selectedIndex: navController.selectedIndex.value,
          onDestinationSelected: (index) {
            navController.selectedIndex.value = index;
          },
          backgroundColor: isDark
              ? CNetworkManager.instance.hasConnection.value
                  ? CColors.rBrown
                  : CColors.black
              : CNetworkManager.instance.hasConnection.value
                  ? CColors.rBrown.withValues(alpha: 0.1)
                  : CColors.black.withValues(alpha: 0.1),
          indicatorColor: isDark
              ? CColors.white.withValues(alpha: 0.3)
              : CNetworkManager.instance.hasConnection.value
                  ? CColors.rBrown.withValues(alpha: 0.3)
                  : CColors.black.withValues(alpha: 0.3),
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'home',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.card_tick),
              label: 'inventory',
            ),
            // NavigationDestination(
            //   icon: Icon(Iconsax.wallet_check),
            //   label: 'checkout',
            // ),
            NavigationDestination(
              icon: Icon(Iconsax.empty_wallet_time),
              label: 'sales',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.setting),
              label: 'account',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.user),
              label: 'profile',
            ),
          ],
        ),
      ),
      body: Obx(
        () {
          return navController.screens[navController.selectedIndex.value];
        },
      ),
    );
  }
}

class NavMenuController extends GetxController {
  static NavMenuController get instance => Get.find();

  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const CInventoryScreen(),
    //const CCheckoutScreen(),
    const TxnsScreen(),
    const SettingsScreen(),
    const ProfileScreen(),
  ];
}
