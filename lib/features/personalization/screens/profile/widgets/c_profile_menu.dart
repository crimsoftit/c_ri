import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CProfileMenu extends StatelessWidget {
  const CProfileMenu({
    super.key,
    required this.title,
    this.value,
    required this.onTap,
    this.icon = Iconsax.arrow_right_34,
    this.verticalPadding = CSizes.spaceBtnItems / 3,
    this.showTrailingIcon = true,
    this.valueIsWidget = false,
    this.valueWidget,
  });

  final IconData icon;
  final String title;
  final String? value;
  final double? verticalPadding;
  final VoidCallback onTap;
  final bool? showTrailingIcon, valueIsWidget;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: verticalPadding!,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall!.apply(
                      color: CColors.darkGrey,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 6,
              child: valueIsWidget!
                  ? valueWidget!
                  : Text(
                      value!,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                            color: CColors.rBrown,
                            fontWeightDelta: 1,
                          ),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            if (showTrailingIcon!)
              Expanded(
                child: IconButton(
                  onPressed: onTap,
                  icon: Icon(
                    icon,
                    size: 18.0,
                    color: CColors.rBrown,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
