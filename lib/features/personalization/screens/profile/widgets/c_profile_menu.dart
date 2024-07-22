import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CProfileMenu extends StatelessWidget {
  const CProfileMenu({
    super.key,
    required this.title,
    required this.value,
    required this.onTap,
    this.icon = Iconsax.arrow_right_34,
  });

  final IconData icon;
  final String title, value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: CSizes.spaceBtnItems / 1.5,
        ),
        child: Row(
          children: [
            Expanded(
              flex: 3,
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodySmall!.apply(
                      color: CColors.darkGrey,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: 5,
              child: Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium!.apply(
                      color: CColors.rBrown,
                      fontWeightDelta: 1,
                    ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
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
