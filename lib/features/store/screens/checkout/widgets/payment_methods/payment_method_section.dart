import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/controllers/checkout_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CPaymentMethodSection extends StatelessWidget {
  const CPaymentMethodSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final checkoutController = Get.put(CCheckoutController());

    return Column(
      children: [
        CSectionHeading(
          showActionBtn: true,
          title: 'payment method',
          btnTitle: 'change',
          btnTxtColor: CColors.darkerGrey,
          editFontSize: true,
          fSize: 13.0,
          onPressed: () {
            checkoutController.selectPaymentMethod(context);
          },
        ),
        SizedBox(
          height: CSizes.spaceBtnItems / 8,
        ),
        Obx(
          () {
            return Row(
              children: [
                CRoundedContainer(
                  width: 60.0,
                  height: 45.0,
                  bgColor: isDarkTheme ? CColors.light : CColors.white,
                  padding: const EdgeInsets.all(
                    CSizes.sm / 4,
                  ),
                  child: Image(
                    image: AssetImage(
                      checkoutController
                          .selectedPaymentMethod.value.platformLogo,
                    ),
                    fit: BoxFit.contain,
                  ),
                ),
                // SizedBox(
                //   height: CSizes.spaceBtnItems / 2,
                // ),
                Text(
                  checkoutController.selectedPaymentMethod.value.platformName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
