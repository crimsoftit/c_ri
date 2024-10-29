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

  final flashOnController = TextEditingController(text: 'Flash on');
  final flashOffController = TextEditingController(text: 'Flash off');
  final cancelController = TextEditingController(text: 'Cancel');

  var aspectTolerance = 0.00;
  var numberOfCameras = 0;
  var selectedCamera = -1;
  var useAutoFocus = true;
  var autoEnableFlash = false;

  /// -- barcode scanner using barcode_scan2 flutter package --
  Future<void> scanItemForSale() async {
    try {
      // var scanOptions = const ScanOptions(
      //   autoEnableFlash: false,
      //   strings: {
      //     'cancel': 'Cancel',
      //     'flash_on': 'Flash on',
      //     'flash_off': 'Flash off',
      //   },
      //   android: AndroidOptions(
      //     aspectTolerance: BorderSide.strokeAlignCenter,
      //     useAutoFocus: true,
      //   ),
      // );

      var result = await BarcodeScanner.scan(
        options: ScanOptions(
          strings: {
            'cancel': cancelController.text,
            'flash_on': flashOnController.text,
            'flash_off': flashOffController.text,
          },
          //restrictFormat: selectedFormats,
          useCamera: selectedCamera,
          autoEnableFlash: autoEnableFlash,
          android: AndroidOptions(
            aspectTolerance: aspectTolerance,
            useAutoFocus: useAutoFocus,
          ),
        ),
      );
      var rContent = result.rawContent;
      sellItemScanResults.value = rContent;

      // -- remove later --
      setFormFieldValues(sellItemScanResults.value);
      // -- //
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

  /// -- set text to form fields --
  setFormFieldValues(String saleItemBarcode) {
    txtSaleItemCode.text = saleItemBarcode;
  }
}
