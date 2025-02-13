import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CProductPriceTxt extends StatelessWidget {
  const CProductPriceTxt({
    super.key,
    this.currencySign,
    required this.price,
    this.maxLines = 1,
    this.isLarge = false,
    this.lineThrough = false,
    this.txtColor = Colors.black,
  });

  final String? currencySign;
  final String price;
  final int maxLines;
  final bool isLarge, lineThrough;
  final Color? txtColor;

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(CUserController());
    final currency =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);
    return Text(
      currencySign ?? '$currency.$price',
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: isLarge
          ? Theme.of(context).textTheme.headlineSmall!.apply(
                color: txtColor,
                decoration: lineThrough ? TextDecoration.lineThrough : null,
              )
          : Theme.of(context).textTheme.labelMedium!.apply(
                color: txtColor,
                //fontSizeDelta: 0.7,
                decoration: lineThrough ? TextDecoration.lineThrough : null,
              ),
    );
  }
}
