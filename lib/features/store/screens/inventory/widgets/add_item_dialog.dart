import 'package:c_ri/features/store/controllers/inventory_controller.dart';
import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/validators/validation.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddItemDialog {
  Widget buildDialog(
      BuildContext context, CInventoryModel invModel, bool isNew) {
    var textStyle = Theme.of(context).textTheme.bodySmall;

    final invController = Get.put(CInventoryController());

    if (!isNew) {
      invController.txtName.text = invModel.name;
      invController.txtCode.text = invModel.pCode.toString();
      invController.txtQty.text = invModel.quantity.toString();
      invController.txtBP.text = invModel.buyingPrice.toString();
      invController.txtUnitSP.text = invModel.unitSellingPrice.toString();
    } else {
      invController.txtName.text = "";
      invController.txtCode.text = "";
      invController.txtQty.text = "";
      invController.txtBP.text = "";
      invController.txtUnitSP.text = "";
      invController.scanBarcodeNormal();
    }

    return AlertDialog(
      title: Text((isNew) ? 'new entry...' : 'update ${invModel.name}'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            const SizedBox(
              height: CSizes.spaceBtnInputFields / 2,
            ),
            // form to handle input data
            Form(
              key: invController.addInvItemFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: invController.txtName,
                    //readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'product name',
                      labelStyle: textStyle,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    validator: (value) {
                      return CValidator.validateEmptyText(
                          'product name', value);
                    },
                  ),
                  // TextFormField(
                  //   controller: invController.,
                  //   decoration: InputDecoration(
                  //     labelText: '',
                  //     labelStyle: textStyle,
                  //     focusedBorder: const UnderlineInputBorder(
                  //       borderSide: BorderSide(color: Colors.green),
                  //     ),
                  //     enabledBorder: const UnderlineInputBorder(
                  //       borderSide: BorderSide(
                  //         color: Colors.green,
                  //       ),
                  //     ),
                  //   ),
                  //   style: const TextStyle(
                  //     fontWeight: FontWeight.normal,
                  //   ),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please enter some text';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 2,
                  ),
                  TextFormField(
                    controller: invController.txtCode,
                    //readOnly: true,
                    decoration: InputDecoration(
                      labelText: 'barcode value',
                      labelStyle: textStyle,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    validator: (value) {
                      return CValidator.validateEmptyText(
                          'barcode value', value);
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 2,
                  ),
                  TextFormField(
                    controller: invController.txtQty,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: false,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    decoration: InputDecoration(
                      labelText: 'quantity/no. of units',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      return CValidator.validateEmptyText(
                          'quantity/no. of units', value);
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 2,
                  ),
                  TextFormField(
                    controller: invController.txtBP,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'buying price',
                      labelStyle: textStyle,
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    validator: (value) {
                      return CValidator.validateEmptyText(
                          'buying price', value);
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 2,
                  ),
                  TextFormField(
                    controller: invController.txtUnitSP,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    decoration: InputDecoration(
                      labelText: 'unit selling price',
                      labelStyle: textStyle,
                    ),
                    validator: (value) {
                      return CValidator.validateEmptyText(
                          'unit selling price', value);
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 2,
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.adf_scanner_outlined,
                    ),
                    onPressed: () {
                      invController.scanBarcodeNormal();
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields,
                  ),
                  Obx(
                    () => ElevatedButton(
                      child: Text(
                        invController.itemExists.value ? 'update' : 'add entry',
                      ),
                      onPressed: () {
                        // Validate returns true if the form is valid, or false otherwise.
                        if (invController.addInvItemFormKey.currentState!
                            .validate()) {
                          invModel.name = invController.txtName.text;
                          invModel.pCode = invController.txtCode.text;
                          invModel.quantity =
                              int.parse(invController.txtQty.text);
                          invModel.buyingPrice =
                              int.parse(invController.txtBP.text);
                          invModel.unitSellingPrice =
                              int.parse(invController.txtUnitSP.text);
                          invModel.date = DateFormat('yyyy-MM-dd - kk:mm')
                              .format(clock.now());

                          if (invController.itemExists.value) {
                            invController.updateInventoryItem(invModel);
                          } else {
                            invController.addInventoryItem(invModel);
                          }

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Processing Data')),
                          );

                          Navigator.pop(context, true);
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
