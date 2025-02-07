import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CPaymentMethodSection extends StatelessWidget {
  const CPaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        CSectionHeading(
          showActionBtn: true,
          title: 'payment method(cash)',
          btnTitle: 'change',
          editFontSize: false,
          onPressed: () {},
        ),
        SizedBox(
          height: CSizes.spaceBtnItems / 5,
        ),
        Row(
          children: [
            CRoundedContainer(
              width: 60.0,
              height: 45.0,
              bgColor: isDarkTheme ? CColors.light : CColors.white,
              padding: const EdgeInsets.all(
                CSizes.sm,
              ),
              child: Image(
                image: AssetImage(CImages.mPesaLogo),
                fit: BoxFit.contain,
              ),
            ),
            // SizedBox(
            //   height: CSizes.spaceBtnItems / 2,
            // ),
            Text(
              'mPesa',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ],
    );
  }
}
