import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/loaders/animated_loader.dart';
import 'package:c_ri/common/widgets/search_bar/animated_typeahead_field.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/controllers/checkout_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/billing_amount_section.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/cart_items.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/payment_methods/payment_method_section.dart';
import 'package:c_ri/nav_menu.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCheckoutScreen extends StatelessWidget {
  const CCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final checkoutController = Get.put(CCheckoutController());
    final navController = Get.put(NavMenuController());
    final userController = Get.put(CUserController());
    final searchBarController = Get.put(CSearchBarController());

    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final currencySymbol =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 30.0,
          backgroundColor: CColors.rBrown,
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
            child: IconButton(
              icon: Icon(
                Iconsax.arrow_left,
                size: CSizes.iconMd,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
            child: Obx(
              () {
                return searchBarController.showAnimatedTypeAheadField.value
                    ? CAnimatedTypeaheadField(
                        boxColor: CColors.white,
                      )
                    : Row(
                        children: [
                          Text(
                            'checkout...',
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                                  color: CColors.white,
                                ),
                          ),
                          SizedBox(
                            width: CSizes.spaceBtnItems * 10.1,
                          ),
                          CAnimatedTypeaheadField(
                            boxColor: Colors.transparent,
                          ),
                        ],
                      );
              },
            ),
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(
                () {
                  /// -- empty data widget --
                  final noDataWidget = CAnimatedLoaderWidget(
                    showActionBtn: true,
                    text: 'whoops! cart is EMPTY!',
                    actionBtnText: 'let\'s fill it',
                    animation: CImages.emptyCartLottie,
                    onActionBtnPressed: () {
                      navController.selectedIndex.value = 1;
                      Get.to(() => const NavMenu());
                    },
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
                              bgColor:
                                  isDarkTheme ? CColors.black : CColors.white,
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
            ],
          ),
        ),
        bottomNavigationBar: Obx(
          () {
            if (cartController.cartItems.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (checkoutController
                            .selectedPaymentMethod.value.platformName ==
                        'cash') {
                      if (checkoutController.amtIssuedFieldController.text ==
                          '') {
                        CPopupSnackBar.customToast(
                          message:
                              'please enter the amount issued by customer!!',
                          forInternetConnectivityStatus: false,
                        );
                        checkoutController.setFocusOnAmtIssuedField.value =
                            true;
                        return;
                      } else if (double.parse(checkoutController
                              .amtIssuedFieldController.text
                              .trim()) <
                          cartController.totalCartPrice.value) {
                        CPopupSnackBar.errorSnackBar(
                          title: 'customer still owes you!!',
                          message: 'the amount issued is not enough',
                        );
                        return;
                      } else {
                        checkoutController.processTxn();
                      }
                    } else {
                      checkoutController.processTxn();
                    }
                  },
                  label: Text(
                    'CHECKOUT $currencySymbol.${cartController.totalCartPrice.value.toStringAsFixed(2)}',
                  ),
                  icon: Icon(
                    Iconsax.wallet_check,
                    color: CColors.white,
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ));
  }
}
