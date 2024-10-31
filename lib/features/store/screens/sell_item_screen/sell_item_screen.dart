import 'package:c_ri/common/widgets/appbar/other_screens_app_bar.dart';
import 'package:c_ri/features/personalization/screens/profile/widgets/c_profile_menu.dart';
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                OtherScreensAppBar(
                  showScanner: false,
                  title: 'sell item #${salesController.sellItemId.value}',
                  trailingIconLeftPadding:
                      CHelperFunctions.screenWidth() * 0.25,
                  //trailingIconLeftPadding: 70,
                  showBackActionIcon: true,
                  showTrailingIcon: true,
                  showSubTitle: false,
                  subTitle: 'code:',
                ),

                /// -- 4 sale item form fields --
                Padding(
                  padding: const EdgeInsets.all(
                    CSizes.defaultSpace,
                  ),
                  child: Form(
                    child: Column(
                      children: [
                        CProfileMenu(
                          title: 'code',
                          value: salesController.saleItemCode.value,
                          verticalPadding: 15.0,
                          showTrailingIcon: false,
                          onTap: () {},
                        ),
                        CProfileMenu(
                          title: 'name',
                          value: salesController.saleItemName.value,
                          verticalPadding: 15.0,
                          showTrailingIcon: false,
                          onTap: () {},
                        ),
                        CProfileMenu(
                          title: 'usp',
                          value: 'Ksh. ${(salesController.saleItemUsp.value)}',
                          verticalPadding: 15.0,
                          showTrailingIcon: false,
                          onTap: () {},
                        ),
                        CProfileMenu(
                          title: 'total amount',
                          value: 'Ksh. ${(salesController.totalAmount.value)}',
                          verticalPadding: 15.0,
                          showTrailingIcon: false,
                          onTap: () {},
                        ),
                        CProfileMenu(
                          title: 'pay via:',
                          valueIsWidget: true,
                          valueWidget: DropdownButtonFormField(
                            hint: const Text('Cash'),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Iconsax.sort,
                              ),
                            ),
                            //padding: EdgeInsets.only(left: 2),
                            items: [
                              'Cash',
                              'Mpesa',
                              'In-house',
                            ]
                                .map(
                                  (option) => DropdownMenuItem(
                                    value: option,
                                    enabled: true,
                                    child: Text(
                                      option,
                                    ),
                                  ),
                                )
                                .toList(),
                            value: salesController.selectedPaymentMethod.value,
                            //style: TextStyle(height: 7.0),
                            onChanged: (value) {
                              salesController.setPaymentMethod(value!);
                            },
                          ),
                          verticalPadding: 15.0,
                          showTrailingIcon: false,
                          onTap: () {},
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnInputFields,
                        ),
                        Visibility(
                          visible: salesController.showAmountIssuedField.value,
                          child: TextFormField(
                            autofocus: false,
                            controller: salesController.txtAmountIssued,
                            style: const TextStyle(
                              height: 0.7,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Iconsax.quote_up_square,
                                color: CColors.grey,
                              ),
                              labelText: 'amount issued by customer',
                            ),
                            onChanged: (value) {},
                          ),
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnInputFields,
                        ),
                        TextFormField(
                          autofocus: true,
                          controller: salesController.txtSaleItemQty,
                          style: const TextStyle(
                            height: 0.7,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                            prefixIcon: const Icon(
                              Iconsax.quote_up_square,
                              color: CColors.grey,
                            ),
                            labelText:
                                'qty/no.of units (${salesController.qtyAvailable.value} in stock)',
                          ),
                          onChanged: (value) {
                            var usp = salesController.saleItemUsp.value;
                            salesController.computeTotals(value, usp);
                          },
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
