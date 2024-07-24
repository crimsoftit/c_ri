import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CCustomIconBtn extends StatelessWidget {
  const CCustomIconBtn({
    super.key,
    this.iconColor,
    this.onPressed,
  });

  final Color? iconColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        icon: Icon(
          Iconsax.search_favorite,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
