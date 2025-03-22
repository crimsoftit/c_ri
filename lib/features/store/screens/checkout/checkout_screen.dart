import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/icons/circular_icon.dart';
import 'package:c_ri/common/widgets/loaders/animated_loader.dart';
import 'package:c_ri/common/widgets/products/store_item.dart';
import 'package:c_ri/common/widgets/search_bar/animated_typeahead_field.dart';
import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/common/widgets/txt_widgets/product_price_txt.dart';
import 'package:c_ri/features/personalization/controllers/location_controller.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/controllers/checkout_controller.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/billing_amount_section.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/payment_methods/payment_method_section.dart';
import 'package:c_ri/features/store/screens/search/widgets/c_typeahead_field.dart';
import 'package:c_ri/nav_menu.dart';
import 'package:c_ri/services/location_services.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCheckoutScreen extends StatelessWidget {
  const CCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final checkoutController = Get.put(CCheckoutController());
    final invController = Get.put(CInventoryController());
    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final navController = Get.put(NavMenuController());
    final userController = Get.put(CUserController());
    final scrollController = ScrollController();
    final searchBarController = Get.put(CSearchBarController());
    final txnsController = Get.put(CTxnsController());

    final currencySymbol =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);

    final CLocationController locationController =
        Get.put<CLocationController>(CLocationController());

    CLocationServices.instance
        .getUserLocation(locationController: locationController);

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
              //Get.back();
              Navigator.pop(context);
            },
          ),
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Obx(
            () {
              final screenWidth = CHelperFunctions.screenWidth();
              return searchBarController.showAnimatedTypeAheadField.value
                  ?
                  // ? CAnimatedTypeaheadField(
                  //     boxColor: CColors.white,
                  //   )
                  AnimatedContainer(
                      padding: const EdgeInsets.all(CSizes.defaultSpace / 4),
                      duration: const Duration(milliseconds: 200),
                      width:
                          searchBarController.showAnimatedTypeAheadField.value
                              ? screenWidth * .93
                              : 50.0,
                      // width: searchBarController.showAnimatedTypeAheadField.value
                      //     ? double.maxFinite
                      //     : 40.0,
                      height: 50.0,
                      decoration: BoxDecoration(
                        borderRadius:
                            searchBarController.showAnimatedTypeAheadField.value
                                ? BorderRadius.circular(5.0)
                                : BorderRadius.circular(20.0),
                        color: CColors.white,
                        //boxShadow: kElevationToShadow[2],
                      ),
                      child:
                          searchBarController.showAnimatedTypeAheadField.value
                              ? SizedBox(
                                  child: CRoundedContainer(
                                    width: screenWidth * .88,
                                    showBorder: false,
                                    radius: 5.0,
                                    child: const CTypeAheadSearchField(),
                                  ),
                                )
                              : Material(
                                  type: MaterialType.transparency,
                                  child: InkWell(
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(0),
                                      topRight: Radius.circular(32),
                                      bottomLeft: Radius.circular(0),
                                      bottomRight: Radius.circular(32),
                                    ),
                                    onTap: () {
                                      searchBarController
                                          .onTypeAheadSearchIconTap();
                                      invController.fetchInventoryItems();
                                      // salesController.fetchTransactions();
                                    },
                                    child: const Icon(
                                      Iconsax.search_normal,
                                      color: CColors.white,
                                      size: CSizes.iconMd,
                                    ),
                                  ),
                                ),
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

                // run loader --
                // if (txnsController.isLoading.value ||
                //     invController.isLoading.value ||
                //     invController.syncIsLoading.value ||
                //     cartController.cartItemsLoading.value) {
                //   //return const DefaultLoaderScreen();
                //   return const CVerticalProductShimmer(
                //     itemCount: 7,
                //   );
                // }
                if (txnsController.isLoading.value ||
                    invController.isLoading.value ||
                    invController.syncIsLoading.value) {
                  //return const DefaultLoaderScreen();
                  return const CVerticalProductShimmer(
                    itemCount: 7,
                  );
                }

                if (cartController.userCartItems.isEmpty &&
                    !cartController.cartItemsLoading.value) {
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
                            height: cartController.userCartItems.length <= 2
                                ? CHelperFunctions.screenHeight() * 0.30
                                : CHelperFunctions.screenHeight() * 0.42,
                            child: CRoundedContainer(
                              padding: EdgeInsets.all(
                                CSizes.defaultSpace / 4,
                              ),
                              bgColor: CColors.rBrown.withValues(
                                alpha: 0.2,
                              ),
                              child: Scrollbar(
                                thumbVisibility: true,
                                controller: scrollController,
                                child: ListView.separated(
                                  shrinkWrap: true,
                                  controller: scrollController,
                                  itemCount:
                                      cartController.userCartItems.length,
                                  separatorBuilder: (_, __) {
                                    return SizedBox(
                                      height: CSizes.spaceBtnSections / 4,
                                    );
                                  },
                                  itemBuilder: (_, index) {
                                    cartController.qtyFieldControllers.add(
                                        TextEditingController(
                                            text: cartController
                                                .userCartItems[index].quantity
                                                .toString()));

                                    return Column(
                                      children: [
                                        CStoreItemWidget(
                                          cartItem: cartController
                                              .userCartItems[index],
                                        ),
                                        SizedBox(
                                          height: CSizes.spaceBtnItems / 4,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                // -- some extra space --
                                                SizedBox(
                                                  width: 45.0,
                                                ),
                                                // -- buttons to increment, decrement qty --
                                                CRoundedContainer(
                                                  showBorder: true,
                                                  // bgColor: bgColor.isBlank ?? isDarkTheme ? CColors.dark : CColors.white,
                                                  bgColor: isDarkTheme
                                                      ? CColors.dark
                                                      : CColors.white,
                                                  padding: EdgeInsets.only(
                                                    top: 0,
                                                    bottom: 0,
                                                    right: CSizes.sm,
                                                    left: CSizes.sm,
                                                  ),
                                                  child: Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    children: [
                                                      CCircularIcon(
                                                        icon: Iconsax.minus,
                                                        width: 32.0,
                                                        height: 32.0,
                                                        iconBorderRadius: 100,
                                                        size: CSizes.md,
                                                        color: isDarkTheme
                                                            ? CColors.white
                                                            : CColors.rBrown,
                                                        bgColor: isDarkTheme
                                                            ? CColors.darkerGrey
                                                            : CColors.light,
                                                        onPressed: () {
                                                          if (cartController
                                                                  .qtyFieldControllers[
                                                                      index]
                                                                  .text !=
                                                              '') {
                                                            invController
                                                                .fetchInventoryItems();
                                                            cartController
                                                                .fetchCartItems();
                                                            var invItem = invController
                                                                .inventoryItems
                                                                .firstWhere((item) =>
                                                                    item.productId
                                                                        .toString() ==
                                                                    cartController
                                                                        .userCartItems[
                                                                            index]
                                                                        .productId
                                                                        .toString()
                                                                        .toLowerCase());
                                                            final thisCartItem =
                                                                cartController
                                                                    .convertInvToCartItem(
                                                                        invItem,
                                                                        1);
                                                            cartController
                                                                .removeSingleItemFromCart(
                                                                    thisCartItem,
                                                                    true);
                                                            cartController
                                                                .fetchCartItems();

                                                            cartController
                                                                    .qtyFieldControllers[
                                                                        index]
                                                                    .text =
                                                                cartController
                                                                    .userCartItems[
                                                                        index]
                                                                    .quantity
                                                                    .toString();
                                                            if (checkoutController
                                                                    .amtIssuedFieldController
                                                                    .text !=
                                                                '') {
                                                              checkoutController
                                                                  .computeCustomerBal(
                                                                cartController
                                                                    .totalCartPrice
                                                                    .value,
                                                                double.parse(
                                                                    checkoutController
                                                                        .amtIssuedFieldController
                                                                        .text
                                                                        .trim()),
                                                              );
                                                            }
                                                          }
                                                        },
                                                      ),
                                                      SizedBox(
                                                        width: CSizes
                                                            .spaceBtnItems,
                                                      ),

                                                      // -- field to set quantity --
                                                      SizedBox(
                                                        width: 40.0,
                                                        child: TextFormField(
                                                          controller: cartController
                                                                  .qtyFieldControllers[
                                                              index],
                                                          //initialValue: qtyFieldInitialValue,
                                                          decoration:
                                                              InputDecoration(
                                                            border: InputBorder
                                                                .none,
                                                            contentPadding:
                                                                EdgeInsets.zero,
                                                            disabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            enabledBorder:
                                                                InputBorder
                                                                    .none,
                                                            errorBorder:
                                                                InputBorder
                                                                    .none,
                                                            focusedBorder:
                                                                InputBorder
                                                                    .none,
                                                            hintText: 'qty',
                                                          ),
                                                          keyboardType:
                                                              const TextInputType
                                                                  .numberWithOptions(
                                                            decimal: false,
                                                            signed: false,
                                                          ),
                                                          inputFormatters: <TextInputFormatter>[
                                                            FilteringTextInputFormatter
                                                                .digitsOnly
                                                          ],
                                                          style: TextStyle(
                                                            color: isDarkTheme
                                                                ? CColors.white
                                                                : CColors
                                                                    .rBrown,
                                                          ),

                                                          onChanged: (value) {
                                                            // value = cartController
                                                            //     .qtyFieldControllers[index].text
                                                            //     .trim();
                                                            invController
                                                                .fetchInventoryItems();
                                                            cartController
                                                                .fetchCartItems();
                                                            if (cartController
                                                                    .qtyFieldControllers[
                                                                        index]
                                                                    .text !=
                                                                '') {
                                                              var invItem = invController.inventoryItems.firstWhere((item) =>
                                                                  item.productId
                                                                      .toString() ==
                                                                  cartController
                                                                      .userCartItems[
                                                                          index]
                                                                      .productId
                                                                      .toString()
                                                                      .toLowerCase());

                                                              final thisCartItem =
                                                                  cartController.convertInvToCartItem(
                                                                      invItem,
                                                                      int.parse(
                                                                          value));

                                                              cartController
                                                                  .addSingleItemToCart(
                                                                      thisCartItem,
                                                                      true,
                                                                      value);
                                                              if (checkoutController
                                                                      .amtIssuedFieldController
                                                                      .text !=
                                                                  '') {
                                                                checkoutController
                                                                    .computeCustomerBal(
                                                                  cartController
                                                                      .totalCartPrice
                                                                      .value,
                                                                  double.parse(
                                                                      checkoutController
                                                                          .amtIssuedFieldController
                                                                          .text),
                                                                );
                                                              }
                                                            }
                                                          },
                                                        ),
                                                      ),
                                                      // Text(
                                                      //   '2',
                                                      // ),

                                                      CCircularIcon(
                                                        icon: Iconsax.add,
                                                        iconBorderRadius: 100,
                                                        width: 32.0,
                                                        height: 32.0,
                                                        size: CSizes.md,
                                                        color: CColors.white,
                                                        bgColor: CColors.rBrown,
                                                        onPressed: () {
                                                          if (cartController
                                                                  .qtyFieldControllers[
                                                                      index]
                                                                  .text !=
                                                              '') {
                                                            invController
                                                                .fetchInventoryItems();
                                                            cartController
                                                                .fetchCartItems();
                                                            var invItem = invController
                                                                .inventoryItems
                                                                .firstWhere((item) =>
                                                                    item.productId
                                                                        .toString() ==
                                                                    cartController
                                                                        .userCartItems[
                                                                            index]
                                                                        .productId
                                                                        .toString()
                                                                        .toLowerCase());
                                                            final thisCartItem =
                                                                cartController
                                                                    .convertInvToCartItem(
                                                                        invItem,
                                                                        1);
                                                            cartController
                                                                .addSingleItemToCart(
                                                                    thisCartItem,
                                                                    false,
                                                                    null);
                                                            cartController
                                                                .fetchCartItems();
                                                            // cartController.qtyFieldControllers[index].text =
                                                            //     cartItem.quantity.toString();
                                                            cartController
                                                                    .qtyFieldControllers[
                                                                        index]
                                                                    .text =
                                                                cartController
                                                                    .userCartItems[
                                                                        index]
                                                                    .quantity
                                                                    .toString();
                                                            if (checkoutController
                                                                    .amtIssuedFieldController
                                                                    .text !=
                                                                '') {
                                                              checkoutController
                                                                  .computeCustomerBal(
                                                                cartController
                                                                    .totalCartPrice
                                                                    .value,
                                                                double.parse(
                                                                    checkoutController
                                                                        .amtIssuedFieldController
                                                                        .text),
                                                              );
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 8.0,
                                              ),
                                              child: CProductPriceTxt(
                                                price: (cartController
                                                            .userCartItems[
                                                                index]
                                                            .price *
                                                        cartController
                                                            .userCartItems[
                                                                index]
                                                            .quantity)
                                                    .toStringAsFixed(2),
                                                isLarge: true,
                                                txtColor: isDarkTheme
                                                    ? CColors.white
                                                    : CColors.rBrown,
                                              ),
                                            ),
                                            // SizedBox(
                                            //   width: 10.0,
                                            // ),
                                          ],
                                        ),
                                      ],
                                    );
                                  },
                                ),
                              ),
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
                                CPaymentMethodSection(
                                  platformName: checkoutController
                                                  .selectedPaymentMethod
                                                  .value
                                                  .platformName ==
                                              'cash' ||
                                          checkoutController
                                                  .selectedPaymentMethod
                                                  .value
                                                  .platformName ==
                                              'mPesa'
                                      ? checkoutController.selectedPaymentMethod
                                          .value.platformName
                                      : '',
                                  platformLogo: checkoutController
                                      .selectedPaymentMethod.value.platformLogo,
                                  txtFieldSpace: checkoutController
                                              .selectedPaymentMethod
                                              .value
                                              .platformName ==
                                          'cash'
                                      ? Row(
                                          children: [
                                            const SizedBox(
                                              width: CSizes.spaceBtnItems * 1.3,
                                              height: 38.0,
                                            ),
                                            CRoundedContainer(
                                              width: CHelperFunctions
                                                      .screenWidth() *
                                                  0.5,
                                              bgColor: isDarkTheme
                                                  ? CColors.rBrown
                                                      .withValues(alpha: 0.3)
                                                  : CColors.white,
                                              child: TextFormField(
                                                // keyboardType:
                                                //     const TextInputType
                                                //         .numberWithOptions(
                                                //   decimal: true,
                                                //   signed: false,
                                                // ),
                                                inputFormatters: <TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .allow(RegExp(
                                                          r'^\d+(\.\d*)?')),
                                                ],
                                                // autofocus: checkoutController
                                                //     .setFocusOnAmtIssuedField
                                                //     .value,
                                                autofocus: false,
                                                controller: checkoutController
                                                    .amtIssuedFieldController,
                                                decoration: InputDecoration(
                                                  focusColor:
                                                      CColors.rBrown.withValues(
                                                    alpha: 0.3,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      CSizes.cardRadiusLg,
                                                    ),
                                                    borderSide: BorderSide(
                                                      color: CColors.grey,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: CColors.rBrown
                                                          .withValues(
                                                        alpha: 0.3,
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      CSizes.cardRadiusLg,
                                                    ),
                                                  ),
                                                  //border: InputBorder.none,
                                                  labelText:
                                                      'amount issued by customer',
                                                ),
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                                onChanged: (value) {
                                                  if (value != '') {
                                                    checkoutController
                                                        .computeCustomerBal(
                                                      cartController
                                                          .totalCartPrice.value,
                                                      double.parse(value),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          children: [
                                            const SizedBox(
                                              width: CSizes.spaceBtnItems * 1.1,
                                              height: 38.0,
                                            ),
                                            CRoundedContainer(
                                              width: CHelperFunctions
                                                      .screenWidth() *
                                                  0.5,
                                              bgColor: isDarkTheme
                                                  ? CColors.rBrown
                                                      .withValues(alpha: 0.3)
                                                  : CColors.white,
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.text,
                                                // focusNode: checkoutController
                                                //     .customerNameFocusNode
                                                //     .value,
                                                autofocus: false,

                                                controller: checkoutController
                                                    .customerNameFieldController,
                                                decoration: InputDecoration(
                                                  focusColor:
                                                      CColors.rBrown.withValues(
                                                    alpha: 0.3,
                                                  ),
                                                  enabledBorder:
                                                      OutlineInputBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      CSizes.cardRadiusLg,
                                                    ),
                                                    borderSide: BorderSide(
                                                      color: CColors.grey,
                                                    ),
                                                  ),
                                                  focusedBorder:
                                                      OutlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: CColors.rBrown
                                                          .withValues(
                                                        alpha: 0.3,
                                                      ),
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                      CSizes.cardRadiusLg,
                                                    ),
                                                  ),
                                                  labelText: checkoutController
                                                              .selectedPaymentMethod
                                                              .value
                                                              .platformName ==
                                                          'mPesa'
                                                      ? 'customer name'
                                                      : 'customer name(optional)',
                                                ),
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  color: isDarkTheme
                                                      ? CColors.white
                                                      : CColors.rBrown,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                ),
                                // addresses
                                //CBillingAddressSection(),
                                // Visibility(
                                //   visible: true,
                                //   child: Column(
                                //     children: [
                                //       Text(
                                //         'latitude: ${locationController.userLocation.value!.latitude}',
                                //         overflow: TextOverflow.ellipsis,
                                //       ),
                                //       Text(
                                //         'longitude: ${locationController.userLocation.value!.longitude}',
                                //         overflow: TextOverflow.ellipsis,
                                //       ),
                                //       Text(
                                //         'user Address: ${locationController.uAddress.value}',
                                //         overflow: TextOverflow.ellipsis,
                                //       ),
                                //     ],
                                //   ),
                                // ),
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          checkoutController.scanItemForCheckout();
        },
        label: Text(
          'scan',
        ),
        icon: const Icon(
          // Iconsax.scan_barcode,
          Iconsax.scan,
        ),
        backgroundColor: isConnectedToInternet
            ? Colors.brown
            : CColors.rBrown.withValues(
                alpha: 0.3,
              ),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBar: Obx(
        () {
          if (cartController.userCartItems.isNotEmpty) {
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
                        message: 'please enter the amount issued by customer!!',
                        forInternetConnectivityStatus: false,
                      );
                      checkoutController.setFocusOnAmtIssuedField.value = true;
                      return;
                    }
                    if (double.parse(checkoutController
                            .amtIssuedFieldController.text
                            .trim()) <
                        cartController.totalCartPrice.value) {
                      CPopupSnackBar.errorSnackBar(
                        title: 'customer still owes you!!',
                        message: 'the amount issued is not enough',
                      );
                      return;
                    }
                  }
                  if (checkoutController
                              .selectedPaymentMethod.value.platformName ==
                          'mPesa' &&
                      checkoutController.customerNameFieldController.text ==
                          '') {
                    checkoutController.customerNameFocusNode.value
                        .requestFocus();
                    CPopupSnackBar.warningSnackBar(
                      title: 'customer details required!',
                      message:
                          'please provide customer\'s name for ${checkoutController.selectedPaymentMethod.value.platformName} payment verification',
                    );
                    return;
                  }
                  checkoutController.processTxn();
                },
                label: SizedBox(
                  height: 34.1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        'CHECKOUT',
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: CColors.white,
                              fontSizeFactor: 0.88,
                              fontWeightDelta: 1,
                            ),
                      ),
                      Text(
                        '$currencySymbol.${cartController.totalCartPrice.value.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.bodyMedium!.apply(
                              color: CColors.white,
                              fontSizeFactor: 1.10,
                              fontWeightDelta: 2,
                            ),
                      ),
                    ],
                  ),
                ),
                icon: Icon(
                  Iconsax.wallet_check,
                  color: CColors.white,
                ),
              ),
            );
          } else {
            CPopupSnackBar.errorSnackBar(
              title: 'no user cart items',
              message: 'no user cart items found for checkout',
            );
            return SizedBox();
          }
        },
      ),
    );
  }
}
