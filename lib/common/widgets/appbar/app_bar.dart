import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/device/device_utilities.dart';
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
  });

  final Widget? title;
  final bool showBackArrow;
  final IconData? leadingIcon;
  final Color? backIconColor;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final VoidCallback backIconAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: CSizes.md,
      ),
      child: AppBar(
        automaticallyImplyLeading: false,
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
                : null,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CDeviceUtils.getAppBarHeight());
}
