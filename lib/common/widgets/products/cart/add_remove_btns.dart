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
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return CRoundedContainer(
      showBorder: true,
      bgColor: isDarkTheme ? CColors.dark : CColors.white,
      padding: EdgeInsets.only(
        top: CSizes.xs,
        bottom: CSizes.xs,
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
          ),
          SizedBox(
            width: CSizes.spaceBtnItems,
          ),

          // -- field to set quantity --
          SizedBox(
            width: 40.0,
            child: TextFormField(
              decoration: InputDecoration(
                border: InputBorder.none,
                disabledBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                hintText: 'qty',
              ),
            ),
          ),
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
          ),
        ],
      ),
    );
  }
}
