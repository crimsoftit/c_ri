import 'package:c_ri/common/widgets/txt_widgets/product_price_txt.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CBillingAmountSection extends StatelessWidget {
  const CBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());

    return Column(
      children: [
        /// -- sub total --
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'subtotal',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            CProductPriceTxt(
              price: cartController.totalCartPrice.value.toStringAsFixed(2),
              isLarge: true,
              txtColor: CColors.rBrown,
            ),
            Text(
              cartController.totalCartPrice.value.toStringAsFixed(2),
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),

        SizedBox(
          height: CSizes.spaceBtnItems / 2,
        ),
      ],
    );
  }
}
