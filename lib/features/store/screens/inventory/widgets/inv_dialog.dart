import 'package:c_ri/features/store/controllers/inv_controller.dart';
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
      //invController.txtId.text = invModel.productId.toString();
      invController.txtName.text = invModel.name;
      invController.txtCode.text = invModel.pCode.toString();
      invController.txtQty.text = invModel.quantity.toString();
      invController.txtBP.text = invModel.buyingPrice.toString();
      invController.txtUnitSP.text = invModel.unitSellingPrice.toString();
    } else {
      invController.txtId.text = "";
      invController.txtName.text = "";
      invController.txtCode.text = "";
      invController.txtQty.text = "";
      invController.txtBP.text = "";
      invController.txtUnitSP.text = "";
      invController.scanBarcodeNormal();
    }

    return PopScope(
      canPop: true,
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10.0),
            title: Obx(
              () => Text(
                (invController.itemExists.value)
                    ? 'update ${invController.txtName.text}'
                    : 'new entry...',
                style: Theme.of(context).textTheme.labelLarge,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            content: SingleChildScrollView(
              child: AddUpdateInventoryForm(
                invController: invController,
                textStyle: textStyle,
                inventoryItem: invModel,
              ),
            ),
          );
        },
      ),
    );
  }
}
