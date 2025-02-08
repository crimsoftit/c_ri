import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/icons/circular_icon.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CItemQtyWithAddRemoveBtns extends StatelessWidget {
  const CItemQtyWithAddRemoveBtns({
    super.key,
    required this.qtyTxtField,
    this.addItemBtnAction,
    this.removeItemBtnAction,
  });

  final Widget qtyTxtField;
  final VoidCallback? addItemBtnAction, removeItemBtnAction;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    //final cartController = Get.put(CCartController());

    //cartController.fetchCartItems();

    return CRoundedContainer(
      showBorder: true,
      bgColor: isDarkTheme ? CColors.dark : CColors.white,
      // padding: EdgeInsets.only(
      //   top: CSizes.xs,
      //   bottom: CSizes.xs,
      //   right: CSizes.xs,
      //   left: CSizes.sm,
      // ),
      padding: EdgeInsets.only(
        top: 0,
        bottom: 0,
        right: CSizes.xs,
        left: CSizes.sm,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CCircularIcon(
            icon: Iconsax.minus,
            width: 32.0,
            height: 32.0,
            size: CSizes.md,
            color: isDarkTheme ? CColors.white : CColors.rBrown,
            bgColor: isDarkTheme ? CColors.darkerGrey : CColors.light,
            onPressed: removeItemBtnAction,
          ),
          SizedBox(
            width: CSizes.spaceBtnItems,
          ),

          // -- field to set quantity --
          qtyTxtField,
          // Text(
          //   '2',
          // ),
          SizedBox(
            width: CSizes.spaceBtnItems,
          ),
          CCircularIcon(
            icon: Iconsax.add,
            width: 32.0,
            height: 32.0,
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
