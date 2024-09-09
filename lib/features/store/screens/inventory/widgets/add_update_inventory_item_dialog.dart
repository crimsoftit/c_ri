import 'package:c_ri/features/store/controllers/inventory_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/screens/inventory/widgets/inv_dialog_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUpdateItemDialog {
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

    return PopScope(
      canPop: false,
      child: AlertDialog(
        title: Text(
          (invController.itemExists.value)
              ? 'update ${invController.txtName.text}'
              : 'new entry...',
          style: Theme.of(context).textTheme.labelLarge,
        ),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        content: SingleChildScrollView(
          child: AddUpdateInventoryForm(
            invController: invController,
            textStyle: textStyle,
            inventoryItem: invModel,
          ),
        ),
      ),
    );
  }
}
