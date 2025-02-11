import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/loaders/animated_loader.dart';
import 'package:c_ri/common/widgets/success_screen/success_screen.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';

import 'package:c_ri/features/store/screens/checkout/widgets/payment_methods/payment_method_section.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/billing_amount_section.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/cart_items.dart';
import 'package:c_ri/features/store/screens/search/search_results.dart';
import 'package:c_ri/nav_menu.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCheckoutScreen extends StatelessWidget {
  const CCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final navController = Get.put(NavMenuController());
    final userController = Get.put(CUserController());

    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final currencySymbol =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CNetworkManager.instance.hasConnection.value
            ? CColors.primaryBrown
            : CColors.black,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Get.back();
          },
        ),
        title: Text(
          'checkout...',
          style: Theme.of(context).textTheme.bodyLarge!.apply(
                color: CColors.white,
              ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(
                () {
                  return const CSearchResultsScreen();
                },
              );
            },
            icon: const Icon(
              Iconsax.search_normal,
              color: CColors.white,
              size: CSizes.iconMd,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Obx(
          () {
            /// -- empty data widget --
            final noDataWidget = Center(
              child: CAnimatedLoaderWidget(
                showActionBtn: true,
                text: 'whoops! cart is EMPTY!',
                actionBtnText: 'let\'s fill it',
                animation: CImages.emptyCartLottie,
                onActionBtnPressed: () {
                  navController.selectedIndex.value = 1;
                  Get.to(() => const NavMenu());
                },
              ),
            );

            if (cartController.cartItems.isEmpty) {
              return noDataWidget;
            }
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                    top: CSizes.defaultSpace / 4,
                    left: CSizes.defaultSpace / 4,
                    right: CSizes.defaultSpace / 4,
                  ),
                  child: Column(
                    children: [
                      // -- list of items in the cart --
                      SizedBox(
                        height: cartController.cartItems.length <= 2
                            ? CHelperFunctions.screenHeight() * 0.30
                            : CHelperFunctions.screenHeight() * 0.42,
                        child: CRoundedContainer(
                          padding: EdgeInsets.all(
                            CSizes.defaultSpace / 4,
                          ),
                          bgColor: CColors.rBrown.withValues(
                            alpha: 0.2,
                          ),
                          child: CCartItems(),
                        ),
                      ),
                      //Divider(),
                      SizedBox(
                        height: CSizes.defaultSpace / 4,
                      ),

                      // -- billing section --
                      CRoundedContainer(
                        padding: const EdgeInsets.all(CSizes.md),
                        showBorder: true,
                        bgColor: isDarkTheme ? CColors.black : CColors.white,
                        child: Column(
                          children: [
                            // pricing
                            CBillingAmountSection(),
                            //const SizedBox(height: CSizes.spaceBtnItems),

                            // divider
                            Divider(),
                            //const SizedBox(height: CSizes.spaceBtnItems),
                            // payment methods
                            CPaymentMethodSection(),
                            // addresses
                            //CBillingAddressSection(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections,
                ),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: cartController.cartItems.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.to(
                    () {
                      return Obx(
                        () {
                          return CSuccessScreen(
                            title: 'txn success',
                            subTitle: 'transaction successful',
                            image: CImages.paymentSuccessfulAnimation,
                            onPressed: () {
                              navController.selectedIndex.value = 1;
                              Get.offAll(() => NavMenu());
                            },
                          );
                        },
                      );
                    },
                  );
                },
                label: Obx(
                  () {
                    return Text(
                      'CHECKOUT $currencySymbol.${cartController.totalCartPrice.value.toStringAsFixed(2)}',
                    );
                  },
                ),
                icon: Icon(
                  Iconsax.wallet_check,
                  color: CColors.white,
                ),
              ),
            )
          : null,
    );
  }
}
