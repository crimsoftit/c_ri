import 'package:c_ri/features/store/controllers/inventory_controller.dart';
import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class AddItemDialog {
  Widget buildDialog(
      BuildContext context, CInventoryModel invModel, bool isNew) {
    final formKey = GlobalKey<FormState>();
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
      title: Text((isNew) ? 'new entry...' : invModel.name),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // form to handle input data
            Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: invController.txtName,
                    decoration: InputDecoration(
                      labelText: 'product name',
                      labelStyle: textStyle,
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.green,
                        ),
                      ),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields,
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
                      if (value == null || value.isEmpty) {
                        return 'please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields,
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
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields,
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
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields,
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
                      if (value == null || value.isEmpty) {
                        return 'please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields,
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
                  ElevatedButton(
                    child: const Text('save'),
                    onPressed: () {
                      // Validate returns true if the form is valid, or false otherwise.
                      if (formKey.currentState!.validate()) {
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
                        invController.addInventoryItem(invModel);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Processing Data')),
                        );
                        Navigator.pop(context, true);
                      }
                    },
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
