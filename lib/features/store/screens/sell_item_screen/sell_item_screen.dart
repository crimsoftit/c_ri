import 'package:c_ri/common/widgets/appbar/other_screens_app_bar.dart';
import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CSellItemScreen extends StatelessWidget {
  const CSellItemScreen({super.key});

  //var sellItemId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final salesController = Get.put(CSalesController());

    return Obx(
      () {
        return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                OtherScreensAppBar(
                  showScanner: false,
                  title: 'sell [product name]',
                  trailingIconLeftPadding: CHelperFunctions.screenWidth() * 0.2,
                ),

                /// -- typeahead search field --
                Padding(
                  padding: const EdgeInsets.all(
                    8.0,
                  ),
                  child: Form(
                    child: // -- item barcode field --
                        Column(
                      children: [
                        TextFormField(
                          controller: salesController.txtSaleItemCode,
                          // initialValue:
                          //     salesController.sellItemScanResults.value : null,
                          style: const TextStyle(
                            height: 0.7,
                          ),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.barcode),
                            labelText: 'product code',
                          ),
                          // validator: (value) {
                          //   return null;

                          //   //return CValidator.validateEmail(value);
                          // },
                        ),
                        Text(
                          salesController.sellItemScanResults.value,
                        ),
                      ],
                    ),
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
