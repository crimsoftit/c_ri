import 'package:c_ri/common/widgets/list_tiles/menu_tile.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddUpdateInventoryForm extends StatelessWidget {
  const AddUpdateInventoryForm({
    super.key,
    required this.invController,
    required this.textStyle,
    required this.inventoryItem,
  });

  final CInventoryController invController;
  final TextStyle? textStyle;
  final CInventoryModel inventoryItem;

  @override
  Widget build(BuildContext context) {
    //String formattedBp;

    return Column(
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
              Visibility(
                maintainState: true,
                visible: false,
                child: Column(
                  children: [
                    TextFormField(
                      controller: invController.txtId,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'product id',
                        labelStyle: textStyle,
                      ),
                    ),
                    TextFormField(
                      controller: invController.txtSyncAction,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'sync action',
                        labelStyle: textStyle,
                      ),
                    ),
                  ],
                ),
              ),
              TextFormField(
                controller: invController.txtName,
                decoration: InputDecoration(
                  labelText: 'product name',
                  labelStyle: textStyle,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                validator: (value) {
                  return CValidator.validateEmptyText('product name', value);
                },
              ),
              const SizedBox(
                height: CSizes.spaceBtnInputFields / 2,
              ),
              TextFormField(
                controller: invController.txtCode,
                //readOnly: true,
                decoration: InputDecoration(
                  labelText: 'barcode value',
                  labelStyle: textStyle,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Iconsax.scan,
                    ),
                    color: CColors.rBrown,
                    onPressed: () {
                      invController.scanBarcodeNormal();
                    },
                  ),
                ),
                onChanged: (barcodeValue) {
                  invController.fetchItemByCodeAndEmail(barcodeValue);
                },
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                validator: (value) {
                  return CValidator.validateBarcode('barcode value', value);
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
                  return CValidator.validateNumber(
                      'quantity/no. of units', value);
                },
                onChanged: (value) {
                  if (invController.txtBP.text.isNotEmpty && value.isNotEmpty) {
                    invController.computeUnitBP(
                      double.parse(invController.txtBP.text.trim()),
                      int.parse(value.trim()),
                    );
                  }
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
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
                ],
                decoration: InputDecoration(
                  labelText: 'buying price',
                  labelStyle: textStyle,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                validator: (value) {
                  return CValidator.validateNumber('buying price', value);
                },
                onChanged: (value) {
                  if (invController.txtQty.text.isNotEmpty &&
                      value.isNotEmpty) {
                    invController.computeUnitBP(
                      double.parse(value),
                      int.parse(invController.txtQty.text),
                    );
                  }
                },
              ),
              Obx(
                () {
                  final userController = Get.put(CUserController());
                  final currency = CHelperFunctions.formatCurrency(
                      userController.user.value.currencyCode);
                  return Container(
                    width: CHelperFunctions.screenWidth() * .97,
                    alignment: Alignment.topRight,
                    child: Text(
                      'unit BP: ~$currency.${invController.unitBP.value.toStringAsFixed(2)}',
                      style: Theme.of(context).textTheme.labelSmall!.apply(
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  );
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
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
                ],
                decoration: InputDecoration(
                  labelText: 'unit selling price',
                  labelStyle: textStyle,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                validator: (value) {
                  return CValidator.validateNumber('unit selling price', value);
                },
              ),
              const SizedBox(
                height: CSizes.spaceBtnInputFields / 2,
              ),
              TextFormField(
                controller: invController.txtStockNotifierLimit,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: false,
                  signed: false,
                ),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
                ],
                decoration: InputDecoration(
                  labelText: 'notify if stock count falls below:',
                  labelStyle: textStyle,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.normal,
                ),
                validator: (value) {
                  return CValidator.validateNumber(
                      'low stock notification limit', value);
                },
              ),
              const SizedBox(
                height: CSizes.spaceBtnSections,
              ),
              CMenuTile(
                icon: Iconsax.add_circle,
                title: 'include supplier details',
                subTitle: 'add name and contacts of your supplier',
                trailing: Switch(
                  value: false,
                  activeColor: CColors.rBrown,
                  onChanged: (value) {},
                ),
              ),
              const SizedBox(
                height: CSizes.spaceBtnInputFields,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 4,
                    child: TextButton.icon(
                      icon: const Icon(
                        Iconsax.save_add,
                        size: CSizes.iconSm,
                        color: CColors.white,
                      ),
                      label: Obx(
                        () => Text(
                          invController.itemExists.value ? 'update' : 'add',
                          style: Theme.of(context).textTheme.labelMedium!.apply(
                                color: CColors.white,
                              ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor:
                            CColors.white, // foreground (text) color
                        backgroundColor: CColors.rBrown, // background color
                      ),
                      onPressed: () {
                        // -- form validation
                        if (!invController.addInvItemFormKey.currentState!
                            .validate()) {
                          return;
                        }
                        invController.addOrUpdateInventoryItem(inventoryItem);
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                  const SizedBox(
                    width: CSizes.spaceBtnSections / 4,
                  ),
                  Expanded(
                    flex: 4,
                    child: TextButton.icon(
                      icon: const Icon(
                        Iconsax.undo,
                        size: CSizes.iconSm,
                        color: CColors.rBrown,
                      ),
                      label: Text(
                        'back',
                        style: Theme.of(context)
                            .textTheme
                            .labelMedium!
                            .apply(color: Colors.red),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.red, // foreground (text) color
                        backgroundColor: CColors.white, // background color
                      ),
                      onPressed: () {
                        invController.fetchInventoryItems();
                        Navigator.pop(context, true);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
