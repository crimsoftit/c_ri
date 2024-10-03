import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/device/device_utilities.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CAppBar({
    super.key,
    this.title,
    this.actions,
    this.leadingIcon,
    this.leadingOnPressed,
    this.showBackArrow = true,
    this.backIconColor,
    required this.backIconAction,
    this.horizontalPadding = CSizes.md,
    this.leadingWidget,
    this.showSubTitle = false,
  });

  final Widget? title;
  final Widget? leadingWidget;
  final bool showBackArrow;
  final bool? showSubTitle;
  final IconData? leadingIcon;
  final Color? backIconColor;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final VoidCallback backIconAction;
  final double? horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        //horizontal: CSizes.md,
        horizontal: horizontalPadding!,
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
        //leadingWidth: 280.0,
        leadingWidth: CHelperFunctions.screenWidth() * 0.799,

        leading: showBackArrow
            ? IconButton(
                onPressed: backIconAction,
                icon: Icon(
                  Iconsax.arrow_left,
                  color: backIconColor,
                ),
              )
            : leadingIcon != null
                ? IconButton(
                    onPressed: leadingOnPressed,
                    icon: Icon(
                      leadingIcon,
                      color: backIconColor,
                      //color: CColors.white,
                    ),
                  )
                : leadingWidget,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CDeviceUtils.getAppBarHeight());
}
