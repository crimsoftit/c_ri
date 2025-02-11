import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/models/payment_method_model.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/payment_methods/payment_methods_tile.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CCheckoutController extends GetxController {
  static CCheckoutController get instance => Get.find();

  @override
  void onInit() {
    selectedPaymentMethod.value = CPaymentMethodModel(
      platformLogo: CImages.cash3,
      platformName: 'cash',
    );
    super.onInit();
  }

  /// -- variables --
  final Rx<CPaymentMethodModel> selectedPaymentMethod =
      CPaymentMethodModel.empty().obs;

  /// -- method to select payment method --
  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(
              CSizes.lg,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CSectionHeading(
                  showActionBtn: false,
                  title: 'select payment method...',
                  btnTitle: '',
                  editFontSize: true,
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.cash3,
                    platformName: 'cash',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.googlePayLogo,
                    platformName: 'google pay',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.mPesaLogo,
                    platformName: 'mPesa',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.paypalLogo,
                    platformName: 'paypal',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.masterCardLogo,
                    platformName: 'master card',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.visaLogo,
                    platformName: 'visa',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
