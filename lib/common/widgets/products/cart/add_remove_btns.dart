import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/icons/circular_icon.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CItemQtyWithAddRemoveBtns extends StatelessWidget {
  const CItemQtyWithAddRemoveBtns({
    super.key,
    this.addItemBtnAction,
    this.bgColor,
    this.btnsLeftPadding = CSizes.sm,
    this.btnsRightPadding = CSizes.sm,
    this.horizontalSpacing,
    required this.qtyField,
    this.iconWidth = 32.0,
    this.iconHeight = 32.0,
    this.qty = 1,
    this.qtyWidget,
    this.removeItemBtnAction,
    this.useTxtFieldForQty = true,
  });

  final Widget? qtyField, qtyWidget;
  final int? qty;
  final VoidCallback? addItemBtnAction, removeItemBtnAction;
  final double? iconWidth,
      iconHeight,
      btnsRightPadding,
      btnsLeftPadding,
      horizontalSpacing;
  final Color? bgColor;
  final bool useTxtFieldForQty;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    //final cartController = Get.put(CCartController());

    //cartController.fetchCartItems();

    return CRoundedContainer(
      showBorder: true,
      bgColor: bgColor.isBlank ?? isDarkTheme ? CColors.dark : CColors.white,
      // padding: EdgeInsets.only(
      //   top: CSizes.xs,
      //   bottom: CSizes.xs,
      //   right: CSizes.xs,
      //   left: CSizes.sm,
      // ),
      padding: EdgeInsets.only(
        top: 0,
        bottom: 0,
        right: btnsRightPadding ?? CSizes.sm,
        left: btnsLeftPadding ?? CSizes.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CCircularIcon(
            icon: Iconsax.minus,
            width: iconWidth,
            height: iconHeight,
            size: CSizes.md,
            color: isDarkTheme ? CColors.white : CColors.rBrown,
            bgColor: isDarkTheme ? CColors.darkerGrey : CColors.light,
            onPressed: removeItemBtnAction,
          ),
          SizedBox(
            width: horizontalSpacing ?? CSizes.spaceBtnItems,
          ),

          // -- field to set quantity --
          useTxtFieldForQty ? qtyField! : qtyWidget!,
          // Text(
          //   '2',
          // ),
          SizedBox(
            width: CSizes.spaceBtnItems,
          ),
          CCircularIcon(
            icon: Iconsax.add,
            width: iconWidth,
            height: iconHeight,
            size: CSizes.md,
            color: CColors.white,
            bgColor: CColors.rBrown,
            onPressed: addItemBtnAction,
          ),
        ],
      ),
    );
  }
}
