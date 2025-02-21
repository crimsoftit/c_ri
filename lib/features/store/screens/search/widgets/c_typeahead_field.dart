import 'package:c_ri/common/widgets/products/cart/add_remove_btns.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CTypeAheadSearchField extends StatelessWidget {
  const CTypeAheadSearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final searchBarController = Get.put(CSearchBarController());
    final cartController = Get.put(CCartController());
    Get.put(CTxnsController());
    final screenWidth = CHelperFunctions.screenWidth();
    final userController = Get.put(CUserController());
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final currencySymbol =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);

    return TypeAheadField<CInventoryModel>(
      builder: (context, controller, focusNode) {
        return TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: true,
          style: TextStyle(
            color: CColors.rBrown,
            //fontSize: 11.0,
            fontStyle: FontStyle.normal,
            height: 3.0,
          ),
          decoration: InputDecoration(
            prefixIcon: Icon(
              Iconsax.search_favorite,
              size: CSizes.iconSm,
            ),
            prefixIconColor: CColors.rBrown,
            suffixIcon: InkWell(
              onTap: () {
                searchBarController.onTypeAheadSearchIconTap();
              },
              child: Icon(
                Iconsax.close_circle,
              ),
            ),
            suffixIconColor: CColors.rBrown,
            contentPadding: EdgeInsets.all(5.0),
            disabledBorder: InputBorder.none,
            enabledBorder: InputBorder.none,
            errorBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            border: InputBorder.none,
            //labelText: 'search inventory',
            hintText: 'search inventory',
            labelStyle: TextStyle(
              color: CColors.rBrown.withValues(alpha: 0.6),
              fontStyle: FontStyle.italic,
            ),
            hintStyle: TextStyle(
              color: CColors.rBrown.withValues(alpha: 0.6),
              fontStyle: FontStyle.normal,
            ),
          ),
          onFieldSubmitted: (value) {
            searchBarController.onTypeAheadSearchIconTap();
          },
        );
      },
      offset: Offset(0, 12),
      constraints: BoxConstraints(
        maxWidth: screenWidth,
      ),
      suggestionsCallback: (pattern) {
        //invController.fetchInventoryItems();

        var matches = invController.inventoryItems;

        return matches
            .where((item) =>
                item.name.toLowerCase().contains(pattern.toLowerCase()))
            .toList();
      },
      itemBuilder: (context, suggestion) {
        // var cartItem = cartController.cartItems
        //     .firstWhereOrNull((item) => item.productId == suggestion.productId);
        return ExpansionTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          backgroundColor: CColors.white,
          // collapsedBackgroundColor: CColors.rBrown.withValues(alpha: 0.08),
          collapsedBackgroundColor: CColors.grey,
          expandedCrossAxisAlignment: CrossAxisAlignment.start,

          // leading: CRoundedContainer(
          //   width: 35.0,
          //   child: CCircleAvatar(
          //     avatarInitial: suggestion.name[0].toUpperCase(),
          //     txtColor: isDarkTheme ? CColors.rBrown : CColors.white,
          //     bgColor: isDarkTheme ? CColors.white : CColors.rBrown,
          //   ),
          // ),
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${suggestion.name.toUpperCase()} (#${suggestion.productId})',
                style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: CColors.rBrown,
                      fontWeightDelta: 2,
                    ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              Text(
                'usp: $currencySymbol.${suggestion.unitSellingPrice}',
                style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: CColors.rBrown,
                    ),
              ),
              Text(
                'in stock:${suggestion.quantity}   unit bp:$currencySymbol.${suggestion.unitBp}',
                style: Theme.of(context).textTheme.labelSmall!.apply(
                      color: CColors.rBrown,
                    ),
              ),
            ],
          ),
          children: [
            Column(
              children: [
                Row(
                  //crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Get.toNamed(
                          '/inventory/item_details/',
                          arguments: suggestion.productId,
                        );
                      },
                      label: Text(
                        'info',
                        style: Theme.of(context).textTheme.labelMedium!.apply(
                              color: CColors.rBrown,
                            ),
                      ),
                      icon: const Icon(
                        Iconsax.information,
                        size: CSizes.iconSm,
                        color: CColors.rBrown,
                      ),
                    ),
                    SizedBox(
                      width: CSizes.defaultSpace / 3,
                    ),

                    // -- buttons to increment, decrement qty --
                    CItemQtyWithAddRemoveBtns(
                      useTxtFieldForQty: false,
                      horizontalSpacing: CSizes.spaceBtnItems / 4.0,
                      btnsLeftPadding: 0,
                      btnsRightPadding: 0,
                      iconWidth: 28.0,
                      iconHeight: 28.0,
                      // button to decrement item qty in the cart
                      removeItemBtnAction: () {
                        cartController.itemQtyInCart.value < 1
                            ? null
                            : cartController.itemQtyInCart.value -= 1;
                      },
                      qtyWidget: Obx(
                        () {
                          return Text(
                            //'${cartItem.quantity}',
                            cartController.itemQtyInCart.value.toString(),
                            style:
                                Theme.of(context).textTheme.labelMedium!.apply(
                                      color: CColors.rBrown,
                                    ),
                          );
                        },
                      ),

                      // button to increment item qty in the cart
                      addItemBtnAction: () {
                        if (cartController.itemQtyInCart.value <
                            suggestion.quantity) {
                          cartController.itemQtyInCart.value += 1;
                        } else {
                          CPopupSnackBar.warningSnackBar(
                              title:
                                  'only ${suggestion.quantity} of ${suggestion.name} are stocked',
                              message:
                                  'you can only add up to ${suggestion.quantity} ${suggestion.name} items to the cart');
                        }
                      },
                      qtyField: null,
                    ),

                    SizedBox(
                      width: CSizes.defaultSpace / 3,
                    ),
                    Obx(
                      () {
                        return TextButton.icon(
                          label: Text(
                            'add',
                            style:
                                Theme.of(context).textTheme.labelMedium!.apply(
                                      color: CColors.rBrown,
                                    ),
                          ),
                          onPressed: cartController.itemQtyInCart.value < 1
                              ? null
                              : () {
                                  cartController.addToCart(suggestion);
                                  cartController.fetchCartItems();
                                },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
      onSelected: (suggestion) {
        // Handle when a suggestion is selected.
        searchBarController.txtTypeAheadFieldController.text = suggestion.name;

        //print('Selected item: ${suggestion.name}');
      },
    );
  }
}
