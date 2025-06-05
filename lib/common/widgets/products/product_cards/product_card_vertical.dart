import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/icon_buttons/circular_icon_btn.dart';
import 'package:c_ri/common/widgets/products/cart/add_to_cart_btn.dart';
import 'package:c_ri/common/widgets/txt_widgets/product_price_txt.dart';
import 'package:c_ri/common/widgets/txt_widgets/product_title_txt.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CProductCardVertical extends StatelessWidget {
  const CProductCardVertical({
    super.key,
    this.itemAvatar,
    required this.itemName,
  });

  final String? itemAvatar;
  final String itemName;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 180,
        //height: 200.0,
        padding: EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          boxShadow: [],
          borderRadius: BorderRadius.circular(CSizes.borderRadiusSm * 4.0),
          // color: isDarkTheme
          //     ? CColors.rBrown.withValues(alpha: 0.3)
          //     : CColors.lightGrey,
          color: Colors.transparent,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: CSizes.spaceBtnInputFields / 4,
            ),
            CRoundedContainer(
              width: CHelperFunctions.screenWidth() * 0.45,
              height: 180.0,
              padding: const EdgeInsets.only(
                left: CSizes.sm,
              ),
              bgColor: isDarkTheme
                  ? CColors.rBrown.withValues(alpha: 0.3)
                  : CColors.lightGrey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CRoundedContainer(
                    width: CHelperFunctions.screenWidth() * 0.45,
                    height: 70.0,
                    bgColor: Colors.transparent,
                    boxShadow: [],
                    child: Stack(
                      children: [
                        /// -- sale tag --
                        Positioned(
                          top: 0,
                          left: 0,
                          child: CCircularIconBtn(
                            color: Colors.red,
                            icon: Iconsax.heart_add,
                            iconSize: CSizes.md,
                            height: 33.0,
                            width: 33.0,
                          ),
                          // CRoundedContainer(
                          //   borderRadius: CSizes.sm,
                          //   bgColor: CColors.secondary.withValues(
                          //     alpha: 0.6,
                          //   ),
                          //   padding: const EdgeInsets.symmetric(
                          //     horizontal: CSizes.sm,
                          //     vertical: CSizes.xs,
                          //   ),
                          //   boxShadow: [],
                          //   child: Text(
                          //     '20%',
                          //     style:
                          //         Theme.of(context).textTheme.labelLarge!.apply(
                          //               color: CColors.black,
                          //             ),
                          //   ),
                          // ),
                        ),

                        /// -- delete item iconButton --
                        Positioned(
                          top: 0,
                          right: 0,
                          child: CCircularIconBtn(
                            color: Colors.red,
                            icon: Icons.delete,
                            iconSize: CSizes.md,
                            height: 33.0,
                            width: 33.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: CSizes.sm),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '2025-05-28 @ 17:20',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                                color: isDarkTheme
                                    ? CColors.grey
                                    : CColors.darkGrey,
                                fontSizeFactor: 0.8,
                              ),
                        ),
                        CProductTitleText(
                          //smallSize: true,
                          title: itemName,
                          txtColor:
                              isDarkTheme ? CColors.white : CColors.rBrown,
                          maxLines: 1,
                        ),
                        Text(
                          '(100 unit(s) stocked)',
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                                color: isDarkTheme
                                    ? CColors.white
                                    : CColors.darkGrey,
                              ),
                        ),
                        Text(
                          'sku: 6009607673321',
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                                color: isDarkTheme
                                    ? CColors.white
                                    : CColors.darkGrey,
                              ),
                        ),
                        // SizedBox(
                        //   height: CSizes.spaceBtnInputFields,
                        // ),
                        CProductPriceTxt(
                          priceCategory: 'bp: ',
                          price: '1000.0',
                          maxLines: 1,
                          isLarge: true,
                          txtColor:
                              isDarkTheme ? CColors.white : CColors.rBrown,
                          fSizeFactor: 0.7,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            /// -- prices --

                            CProductPriceTxt(
                              priceCategory: 'usp: ',
                              price: '10.0',
                              maxLines: 1,
                              isLarge: true,
                              txtColor:
                                  isDarkTheme ? CColors.white : CColors.rBrown,
                              fSizeFactor: 0.7,
                            ),

                            /// -- add item to cart button --
                            CAddToCartBtn(
                              pId: 1,
                            ),
                          ],
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
