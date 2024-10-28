import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  final RxBool sellItemExists = false.obs;
  final RxInt sellItemId = 0.obs;

  final txtSaleItemId = TextEditingController();
  final txtSaleItemName = TextEditingController();
  final txtSaleItemCode = TextEditingController();
  final txtSaleItemQty = TextEditingController();

  Future scanItemForSale() async {
    try {
      var result = await BarcodeScanner.scan();
      var rContent = result.rawContent;
      sellItemScanResults.value = rContent;
      //CPopupSnackBar.customToast(message: sellItemScanResults.value);
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
}
