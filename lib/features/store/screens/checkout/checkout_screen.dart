import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/billing_section.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/cart_items.dart';
import 'package:c_ri/features/store/screens/home/widgets/home_appbar.dart';
import 'package:c_ri/features/store/screens/search/search_results.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/constants/txt_strings.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCheckoutScreen extends StatelessWidget {
  const CCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(CUserController());

    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final currencySymbol =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);

    return Scaffold(
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  CHomeAppBarWidget(
                    appBarTitle: CTexts.homeAppbarTitle,
                    actionsSection: IconButton(
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
                    screenTitle: '',
                    isHomeScreen: true,
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnSections,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: CSizes.defaultSpace,
              ),
              child: Column(
                children: [
                  // -- list of items in the cart --
                  SizedBox(
                    height: CHelperFunctions.screenHeight() * 0.52,
                    child: CCartItems(),
                  ),

                  // -- billing section --
                  CRoundedContainer(
                    showBorder: true,
                    bgColor: isDarkTheme ? CColors.black : CColors.white,
                    child: Column(
                      children: [
                        // pricing
                        //CBill

                        // divider
                        // payment methods
                        // addresses
                        CBillingAddressSection(),
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
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton.icon(
          onPressed: () {},
          label: Text(
            'CHECKOUT $currencySymbol.1200.00',
          ),
          icon: Icon(
            Iconsax.wallet_check,
            color: CColors.white,
          ),
        ),
      ),
    );
  }
}
