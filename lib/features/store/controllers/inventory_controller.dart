import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';

class CInventoryController extends GetxController {
  static CInventoryController get instance {
    return Get.find();
  }

  /// -- variables --
  DbHelper dbHelper = DbHelper.instance;
  final RxList<CInventoryModel> inventoryItems = <CInventoryModel>[].obs;

  final txtName = TextEditingController();
  final txtCode = TextEditingController();
  final txtQty = TextEditingController();
  final txtBP = TextEditingController();
  final txtUnitSP = TextEditingController();

  final isLoading = false.obs;

  @override
  void onInit() {
    fetchInventoryItems();
    super.onInit();
  }

  Future<List<CInventoryModel>> fetchInventoryItems() async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      await dbHelper.openDb();

      // fetch items from sqflite db
      final fetchedItems = await dbHelper.fetchInventoryItems();

      // assign inventory items
      inventoryItems.assignAll(fetchedItems);

      return fetchedItems;
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  addInventoryItem(CInventoryModel inventoryItem) {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // fetch items from sqflite db
      dbHelper.addInventoryItem(inventoryItem);

      isLoading.value = false;
      fetchInventoryItems();
      CPopupSnackBar.successSnackBar1(
        title: 'item added successfully',
        message: 'item added successfully',
      );
    } catch (e) {
      isLoading.value = false;
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  void scanBarcodeNormal() async {
    String scanResults = '';

    try {
      scanResults = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);
      txtCode.text = scanResults;
    } on PlatformException {
      scanResults = "ERROR!! failed to get platform version";
    } catch (e) {
      scanResults = "ERROR!! failed to get platform version";
      CPopupSnackBar.errorSnackBar(
        title: 'scan error',
        message: e.toString(),
      );
    }
  }
}
