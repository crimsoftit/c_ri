import 'package:c_ri/common/widgets/appbar/other_screens_app_bar.dart';
import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
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
                  title: 'sell',
                  trailingIconLeftPadding: CHelperFunctions.screenWidth() * 0.2,
                  showBackActionIcon: true,
                ),

                /// -- typeahead search field --
                Padding(
                  padding: const EdgeInsets.all(
                    CSizes.defaultSpace,
                  ),
                  child: Form(
                    child: // -- item barcode field --
                        Column(
                      children: [
                        TextFormField(
                          controller: salesController.txtSaleItemId,
                          style: const TextStyle(
                            height: 0.7,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Iconsax.barcode,
                              color: CColors.rBrown.withOpacity(0.5),
                            ),
                            labelText: 'product id',
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnInputFields,
                        ),
                        TextFormField(
                          controller: salesController.txtSaleItemCode,
                          style: const TextStyle(
                            height: 0.7,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Iconsax.barcode,
                              color: CColors.rBrown.withOpacity(0.5),
                            ),
                            labelText: 'product code',
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnInputFields,
                        ),
                        TextFormField(
                          controller: salesController.txtSaleItemName,
                          style: const TextStyle(
                            height: 0.7,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Iconsax.information,
                              color: CColors.rBrown.withOpacity(0.5),
                            ),
                            labelText: 'product name',
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnInputFields,
                        ),
                        TextFormField(
                          controller: salesController.txtSaleItemQty,
                          style: const TextStyle(
                            height: 0.7,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Iconsax.quote_up_square,
                              color: CColors.rBrown.withOpacity(0.5),
                            ),
                            labelText:
                                'qty/no.of units (${salesController.qtyAvailable.value})',
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnInputFields,
                        ),
                        TextFormField(
                          controller: salesController.txtSaleItemBp,
                          style: const TextStyle(
                            height: 0.7,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Iconsax.quote_up_square,
                              color: CColors.rBrown.withOpacity(0.5),
                            ),
                            labelText: 'buying price',
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnInputFields,
                        ),
                        TextFormField(
                          controller: salesController.txtSaleItemUsp,
                          style: const TextStyle(
                            height: 0.7,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: Icon(
                              Iconsax.quote_up_square,
                              color: CColors.rBrown.withOpacity(0.5),
                            ),
                            labelText: 'unit selling price',
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnInputFields,
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
