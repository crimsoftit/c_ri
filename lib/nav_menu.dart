import 'package:c_ri/features/personalization/screens/profile/profile.dart';
import 'package:c_ri/features/personalization/screens/settings/user_settings.dart';
import 'package:c_ri/features/store/screens/home/home.dart';
import 'package:c_ri/features/store/screens/inventory/inventory_screen.dart';
import 'package:c_ri/features/store/screens/sales/sales_screen.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class NavMenu extends StatelessWidget {
  const NavMenu({super.key});

  @override
  Widget build(BuildContext context) {
    final navController = Get.put(NavMenuController());
    final isDark = CHelperFunctions.isDarkMode(context);

    return Scaffold(
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80.0,
          elevation: 0,
          selectedIndex: navController.selectedIndex.value,
          onDestinationSelected: (index) {
            navController.selectedIndex.value = index;
          },
          backgroundColor:
              isDark ? CColors.rBrown : CColors.rBrown.withOpacity(0.1),
          indicatorColor: isDark
              ? CColors.white.withOpacity(0.3)
              : CColors.rBrown.withOpacity(0.3),
          destinations: const [
            NavigationDestination(
              icon: Icon(Iconsax.home),
              label: 'home',
            ),
            NavigationDestination(
              icon: Icon(Iconsax.card_tick),
              label: 'inventory',
            ),
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
            // NavigationDestination(
            //   icon: Icon(Iconsax.warning_2),
            //   label: 'error',
            // ),
          ],
        ),
      ),
      body: Obx(() => navController.screens[navController.selectedIndex.value]),
    );
  }
}

class NavMenuController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const HomeScreen(),
    const InventoryScreen(),
    const SalesScreen(),
    const SettingsScreen(),
    const ProfileScreen(),

    // const DataErrorScreen(
    //   lottieImage: CImages.errorDataLottie,
    //   txt: 'error',
    // ),
  ];
}
