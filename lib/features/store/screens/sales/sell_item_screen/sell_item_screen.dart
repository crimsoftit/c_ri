import 'package:c_ri/common/widgets/appbar/other_screens_app_bar.dart';
import 'package:c_ri/features/personalization/screens/profile/widgets/c_profile_menu.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:c_ri/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CSellItemScreen extends StatelessWidget {
  const CSellItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final salesController = Get.put(CTxnsController());

    return Obx(
      () {
        return PopScope(
          canPop: true,
          onPopInvoked: (didPop) async {
            salesController.resetSales();
          },
          child: Scaffold(
            body: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  OtherScreensAppBar(
                    showScanner: false,
                    title: '#${salesController.sellItemId.value}',
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
                      key: salesController.txnsFormKey,
                      child: Column(
                        children: [
                          CProfileMenu(
                            title: 'code',
                            value: salesController.saleItemCode.value,
                            verticalPadding: 7.0,
                            showTrailingIcon: false,
                            onTap: () {},
                          ),
                          CProfileMenu(
                            title: 'name',
                            value: salesController.saleItemName.value,
                            verticalPadding: 7.0,
                            showTrailingIcon: false,
                            onTap: () {},
                          ),
                          CProfileMenu(
                            title: 'usp',
                            value:
                                'Ksh. ${(salesController.saleItemUsp.value)}',
                            verticalPadding: 7.0,
                            showTrailingIcon: false,
                            onTap: () {},
                          ),
                          CProfileMenu(
                            title: 'total amount',
                            value:
                                'Ksh. ${(salesController.totalAmount.value)}',
                            verticalPadding: 7.0,
                            showTrailingIcon: false,
                            onTap: () {},
                          ),
                          Visibility(
                            visible:
                                salesController.showAmountIssuedField.value,
                            child: CProfileMenu(
                              title: 'customer balance',
                              value:
                                  'Ksh. ${(salesController.customerBal.value)}',
                              verticalPadding: 15.0,
                              showTrailingIcon: false,
                              onTap: () {},
                            ),
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
                                'on the house',
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
                              value:
                                  salesController.selectedPaymentMethod.value,
                              //style: TextStyle(height: 7.0),
                              onChanged: (value) {
                                salesController.setPaymentMethod(value!);
                              },
                            ),
                            verticalPadding: 15.0,
                            showTrailingIcon: false,
                            onTap: () {},
                          ),
                          // if (salesController.showAmountIssuedField.value)
                          //   const SizedBox(
                          //     height: CSizes.spaceBtnInputFields,
                          //   ),
                          Visibility(
                            visible:
                                salesController.showAmountIssuedField.value,
                            child: Column(
                              children: [
                                TextFormField(
                                  autofocus: false,
                                  controller: salesController.txtAmountIssued,
                                  style: TextStyle(
                                    height: 0.7,
                                    fontWeight: FontWeight.normal,
                                    color: salesController
                                                .customerBalErrorMsg.value ==
                                            'the amount issued is not enough!!'
                                        ? Colors.red
                                        : CColors.rBrown,
                                  ),
                                  keyboardType:
                                      const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: false,
                                  ),
                                  inputFormatters: <TextInputFormatter>[
                                    FilteringTextInputFormatter.digitsOnly,
                                  ],
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Iconsax.quote_up_square,
                                      color: salesController
                                                  .customerBalErrorMsg.value ==
                                              'the amount issued is not enough!!'
                                          ? Colors.red
                                          : CColors.grey,
                                    ),
                                    labelText: 'amount issued by customer',
                                  ),
                                  validator: (value) =>
                                      CValidator.validateCustomerBal(
                                          'amount issued',
                                          value,
                                          salesController.totalAmount.value),
                                  onChanged: (value) {
                                    salesController.computeCustomerBal(
                                        double.parse(value),
                                        salesController.totalAmount.value);
                                  },
                                ),
                                Text(
                                  salesController.customerBalErrorMsg.value,
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic,
                                      ),
                                ),
                                const SizedBox(
                                  height: CSizes.spaceBtnInputFields,
                                ),
                              ],
                            ),
                          ),

                          TextFormField(
                            autofocus: true,
                            controller: salesController.txtSaleItemQty,
                            style: TextStyle(
                              height: 0.7,
                              fontWeight: FontWeight.normal,
                              color: salesController
                                          .stockUnavailableErrorMsg.value ==
                                      'insufficient stock!!'
                                  ? Colors.red
                                  : CColors.rBrown,
                            ),
                            decoration: InputDecoration(
                              prefixIcon: Icon(
                                Iconsax.quote_up_square,
                                color: salesController
                                            .stockUnavailableErrorMsg.value ==
                                        'insufficient stock!!'
                                    ? Colors.red
                                    : CColors.grey,
                              ),
                              hintStyle: TextStyle(
                                color: salesController
                                            .stockUnavailableErrorMsg.value ==
                                        'insufficient stock!!'
                                    ? Colors.red
                                    : CColors.rBrown,
                              ),
                              labelText:
                                  'qty/no.of units (${salesController.qtyAvailable.value} in stock)',
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: false,
                              signed: false,
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            onChanged: (value) {
                              var usp = salesController.saleItemUsp.value;
                              salesController.computeTotals(value, usp);
                              salesController.computeCustomerBal(
                                  double.parse(
                                      salesController.txtAmountIssued.text),
                                  salesController.totalAmount.value);
                            },
                          ),

                          /// -- stock insufficient error message

                          Visibility(
                            visible: salesController
                                        .stockUnavailableErrorMsg.value ==
                                    'insufficient stock!!'
                                ? true
                                : false,
                            child: Text(
                              salesController.stockUnavailableErrorMsg.value,
                              style:
                                  Theme.of(context).textTheme.labelSmall!.apply(
                                        color: Colors.red,
                                        fontStyle: FontStyle.italic,
                                      ),
                            ),
                          ),
                          const SizedBox(
                            height: CSizes.spaceBtnInputFields / 2,
                          ),
                          TextFormField(
                            controller: salesController.txtCustomerName,
                            style: const TextStyle(
                              height: 0.7,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Iconsax.quote_up_square,
                                color: CColors.grey,
                              ),
                              labelText: 'customer name',
                            ),
                          ),
                          const SizedBox(
                            height: CSizes.spaceBtnInputFields / 2,
                          ),
                          TextFormField(
                            controller: salesController.txtCustomerContacts,
                            style: const TextStyle(
                              height: 0.7,
                              fontWeight: FontWeight.normal,
                            ),
                            decoration: const InputDecoration(
                              prefixIcon: Icon(
                                Iconsax.quote_up_square,
                                color: CColors.grey,
                              ),
                              labelText: 'customer contacts',
                            ),
                          ),
                          const SizedBox(
                            height: CSizes.spaceBtnInputFields,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: salesController
                                          .stockUnavailableErrorMsg.value ==
                                      'insufficient stock!!'
                                  ? null
                                  : () {
                                      if (salesController.customerBal.value <
                                          0) {
                                        salesController
                                                .customerBalErrorMsg.value ==
                                            'the amount issued is not enough!!';
                                        CPopupSnackBar.errorSnackBar(
                                          title: 'customer still owes you!!',
                                          message:
                                              'the amount issued is not enough',
                                        );
                                      } else {
                                        salesController.processTransaction();
                                      }
                                    },
                              child: Text(
                                salesController
                                            .stockUnavailableErrorMsg.value ==
                                        'insufficient stock!!'
                                    ? 'insufficient stock!!'
                                    : 'confirm sale',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelMedium!
                                    .apply(
                                      fontWeightDelta: 1,
                                      color: salesController
                                                  .stockUnavailableErrorMsg
                                                  .value ==
                                              'insufficient stock!!'
                                          ? Colors.red
                                          : CColors.white,
                                    ),
                              ),
                            ),
                          ),
                          Text(
                            salesController.saleItemCode.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
