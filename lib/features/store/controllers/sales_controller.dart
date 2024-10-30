import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

class CSalesController extends GetxController {
  static CSalesController get instance {
    return Get.find();
  }

  @override
  void onInit() {
    //fetchInventoryItems();
    super.onInit();
  }

  /// -- variables --
  DbHelper dbHelper = DbHelper.instance;
  final RxString sellItemScanResults = ''.obs;

  final RxBool itemExists = false.obs;
  final isLoading = false.obs;

  final RxInt sellItemId = 0.obs;
  final RxInt qtyAvailable = 0.obs;

  final txtSaleItemId = TextEditingController();
  final txtSaleItemName = TextEditingController();
  final txtSaleItemCode = TextEditingController();
  final txtSaleItemQty = TextEditingController();
  final txtSaleItemBp = TextEditingController();
  final txtSaleItemUsp = TextEditingController();

  final userController = Get.put(CUserController());

  /// -- barcode scanner using flutter_barcode_scanner package --
  Future<void> scanItemForSale() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);

      sellItemScanResults.value = barcodeScanRes;

      // -- set inventory item details to fields --
      fetchForSaleItemByCode(sellItemScanResults.value);
    } on PlatformException catch (platformException) {
      if (platformException.code == BarcodeScanner.cameraAccessDenied) {
        CPopupSnackBar.warningSnackBar(
            title: 'camera access denied',
            message: 'permission to use your camera is denied!!!');
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'platform exception error!',
          message: platformException.message,
        );
      }
    } on FormatException catch (formatException) {
      CPopupSnackBar.errorSnackBar(
        title: 'format exception error!!',
        message: formatException.message,
      );
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'sell item scan error!',
        message: e.toString(),
      );
    }
  }

  /// -- fetch inventory item by code --
  Future<List<CInventoryModel>> fetchForSaleItemByCode(String code) async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // fetch scanned item from sqflite db
      final fetchedItem = await dbHelper.getScannedInvItem(
          code, userController.user.value.email);

      //fetchInventoryItems();

      if (fetchedItem.isNotEmpty) {
        sellItemId.value = fetchedItem.first.productId!;

        itemExists.value = true;
        txtSaleItemId.text = sellItemId.value.toString();
        txtSaleItemName.text = fetchedItem.first.name;
        qtyAvailable.value = fetchedItem.first.quantity;
        txtSaleItemBp.text = (fetchedItem.first.buyingPrice).toString();
        txtSaleItemUsp.text = (fetchedItem.first.unitSellingPrice).toString();
      } else {
        itemExists.value = false;
        txtSaleItemId.text = '';
        txtSaleItemName.text = '';
        txtSaleItemQty.text = '';
        txtSaleItemBp.text = '';
        txtSaleItemUsp.text = '';
      }

      return fetchedItem;
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  /// -- set text to form fields --
  setFormFieldValues(String saleItemBarcode) {
    txtSaleItemCode.text = saleItemBarcode;
  }
}
