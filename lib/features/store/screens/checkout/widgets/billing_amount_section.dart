import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CBillingAmountSection extends StatelessWidget {
  const CBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
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
            Text(
              'Ksh.256,000.00',
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
