import 'package:c_ri/common/widgets/products/cart/positioned_cart_counter_widget.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/screens/checkout/checkout_screen.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCartCounterIcon extends StatelessWidget {
  const CCartCounterIcon({
    super.key,
    this.iconColor,
    this.counterBgColor,
    this.counterTxtColor,
  });

  final Color? iconColor, counterBgColor, counterTxtColor;

  @override
  Widget build(BuildContext context) {
    //cartController.fetchCartItems();

    return Stack(
      children: [
        IconButton(
          onPressed: () {
            final cartController = Get.put(CCartController());
            cartController.fetchCartItems();
            Get.to(() => const CCheckoutScreen());
          },
          icon: Icon(
            Iconsax.shopping_bag,
            color: iconColor,
          ),
        ),
        CPositionedCartCounterWidget(
          counterBgColor: CColors.white,
          counterTxtColor: CColors.rBrown,
        ),
      ],
    );
  }
}
