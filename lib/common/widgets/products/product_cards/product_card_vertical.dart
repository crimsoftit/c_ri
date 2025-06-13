import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/icon_buttons/circular_icon_btn.dart';
import 'package:c_ri/common/widgets/products/cart/add_to_cart_btn.dart';
import 'package:c_ri/common/widgets/products/circle_avatar.dart';
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
    required this.itemName,
    required this.pCode,
    required this.pId,
    this.bp,
    this.date,
    this.itemAvatar,
    this.lowStockNotifierLimit,
    this.usp,
    this.qtyAvailable,
    this.qtyRefunded,
    this.qtySold,
    this.deleteAction,
  });

  final String? bp, date, itemAvatar, usp, qtyAvailable, qtyRefunded, qtySold;
  final String itemName, pCode;
  final int pId;
  final int? lowStockNotifierLimit;
  final VoidCallback? deleteAction;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 170,
        //height: 200.0,
        padding: EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          boxShadow: [],
          borderRadius: BorderRadius.circular(CSizes.borderRadiusSm * 4.0),
          color: CColors.transparent,
        ),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: CSizes.spaceBtnInputFields / 5,
            ),
            CRoundedContainer(
              bgColor: isDarkTheme
                  ? CColors.rBrown.withValues(alpha: 0.3)
                  : CColors.lightGrey,
              borderRadius: CSizes.pImgRadius - 4,
              height: 157.5,
              padding: const EdgeInsets.only(
                left: CSizes.sm,
              ),
              width: CHelperFunctions.screenWidth() * 0.46,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CRoundedContainer(
                    width: CHelperFunctions.screenWidth() * 0.45,
                    height: 50.0,
                    bgColor: Colors.transparent,
                    boxShadow: [],
                    child: Stack(
                      children: [
                        /// -- sale tag --
                        Positioned(
                          top: 0,
                          left: 0,
                          child: CCircularIconBtn(
                            bgColor: isDarkTheme
                                ? CColors.transparent
                                : CColors.white,
                            color: isDarkTheme ? CColors.white : CColors.rBrown,
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
                            color: isDarkTheme ? CColors.white : Colors.red,
                            icon: Icons.delete,
                            iconSize: CSizes.md,
                            height: 33.0,
                            width: 33.0,
                            bgColor: isDarkTheme
                                ? CColors.transparent
                                : CColors.white,
                            onPressed: deleteAction,
                          ),
                        ),

                        /// -- avatar and date --
                        Positioned(
                          top: 2,
                          left: 40.0,
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CCircleAvatar(
                                  avatarInitial: itemAvatar!,
                                  // bgColor: int.parse(qtyAvailable!) <
                                  //         lowStockNotifierLimit!
                                  //     ? Colors.red
                                  //     : CColors.rBrown,
                                  bgColor: int.parse(qtyAvailable!) <
                                          lowStockNotifierLimit!
                                      ? Colors.red
                                      : CColors.transparent,
                                  txtColor: isDarkTheme
                                      ? CColors.white
                                      : CColors.rBrown,
                                ),
                                Text(
                                  date!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(
                                        color: isDarkTheme
                                            ? CColors.grey
                                            : CColors.darkGrey,
                                        fontSizeFactor: 0.9,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 2.5,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CProductTitleText(
                          //smallSize: true,
                          title: itemName.toUpperCase(),
                          txtColor:
                              isDarkTheme ? CColors.white : CColors.rBrown,
                          maxLines: 1,
                        ),
                        Text(
                          '($qtyAvailable stocked, $qtySold sold)',
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                                color: isDarkTheme
                                    ? CColors.white
                                    : CColors.darkGrey,
                                fontSizeFactor: 1,
                              ),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        Text(
                          '($qtyRefunded unit(s) refunded)',
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                                color: isDarkTheme
                                    ? CColors.white
                                    : CColors.darkGrey,
                              ),
                        ),
                        Text(
                          'sku: $pCode',
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
                          price: bp!,
                          maxLines: 1,
                          isLarge: true,
                          txtColor:
                              isDarkTheme ? CColors.white : CColors.darkGrey,
                          fSizeFactor: 0.7,
                        ),

                        SizedBox(
                          width: 170,
                          height: 30,
                          child: Stack(
                            children: [
                              Positioned(
                                bottom: 2,
                                child: CProductPriceTxt(
                                  // priceCategory: 'price: ',
                                  priceCategory: '@',
                                  price: usp!,
                                  maxLines: 1,
                                  isLarge: true,
                                  txtColor: isDarkTheme
                                      ? CColors.white
                                      : CColors.rBrown,
                                  fSizeFactor: 0.9,
                                ),
                              ),

                              /// -- add item to cart button --
                              Positioned(
                                right: 0,
                                bottom: 0,
                                child: CAddToCartBtn(
                                  pId: pId,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Row(
                        //   spacing: 0,
                        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //   mainAxisSize: MainAxisSize.min,
                        //   children: [
                        //     /// -- prices (usp)--

                        // CProductPriceTxt(
                        //   priceCategory: 'usp: ',
                        //   price: usp!,
                        //   maxLines: 1,
                        //   isLarge: true,
                        //   txtColor:
                        //       isDarkTheme ? CColors.white : CColors.rBrown,
                        //   fSizeFactor: 0.7,
                        // ),

                        /// -- add item to cart button --
                        // CAddToCartBtn(
                        //   pId: pId,
                        // ),
                        //   ],
                        // ),
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
