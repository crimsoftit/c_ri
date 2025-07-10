import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/screens/store_items_tings/inventory/widgets/inv_dialog_form.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddUpdateItemDialogRaw {
  Widget buildDialog(
      BuildContext context, CInventoryModel invModel, bool isNew) {
    var textStyle = Theme.of(context).textTheme.bodySmall;

    final invController = Get.put(CInventoryController());

    if (!isNew) {
      invController.txtId.text = invModel.productId.toString();
      invController.txtNameController.text = invModel.name;
      invController.txtCode.text = invModel.pCode.toString();
      invController.txtQty.text = invModel.quantity.toString();
      invController.txtBP.text = invModel.buyingPrice.toString();
      invController.unitBP.value = invModel.unitBp;
      invController.txtUnitSP.text = invModel.unitSellingPrice.toString();
    }

    return PopScope(
      canPop: false,
      child: StatefulBuilder(
        builder: (BuildContext context, setState) {
          return AlertDialog(
            insetPadding: const EdgeInsets.all(10.0),
            title: Obx(
              () => Row(
                children: [
                  Expanded(
                    child: Text(
                      (invController.itemExists.value)
                          ? 'update ${invController.txtNameController.text.trim()}'
                          : 'add inventory...',
                      style: Theme.of(context).textTheme.labelLarge,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // const SizedBox(
                  //   width: CSizes.spaceBtnInputFields / 2,
                  // ),
                  Visibility(
                    visible:
                        invController.supplierDetailsExist.value ? false : true,
                    child: Expanded(
                      child: TextButton(
                        onPressed: () {
                          invController.toggleSupplierDetsFieldsVisibility();
                        },
                        child: Text(
                          invController.includeSupplierDetails.value
                              ? 'exclude supplier details?'
                              : 'include supplier details?',
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium!
                              .apply(color: CColors.rBrown),
                        ),
                      ),
                    ),
                  ),
                ],
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
