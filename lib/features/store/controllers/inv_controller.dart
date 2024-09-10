import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CInventoryController extends GetxController {
  static CInventoryController get instance {
    return Get.find();
  }

  /// -- variables --
  DbHelper dbHelper = DbHelper.instance;
  final RxList<CInventoryModel> inventoryItems = <CInventoryModel>[].obs;

  final RxString scanResults = ''.obs;

  final RxBool itemExists = false.obs;

  final txtName = TextEditingController();
  final txtCode = TextEditingController();
  final txtQty = TextEditingController();
  final txtBP = TextEditingController();
  final txtUnitSP = TextEditingController();

  final addInvItemFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  final RxInt invQty = 0.obs;

  @override
  void onInit() {
    fetchInventoryItems();
    super.onInit();
  }

  /// -- fetch list of inventory items --
  Future<List<CInventoryModel>> fetchInventoryItems() async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      await dbHelper.openDb();

      // fetch items from sqflite db
      final fetchedItems = await dbHelper.fetchInventoryItems();

      // assign inventory items
      inventoryItems.assignAll(fetchedItems);

      // stop loader
      isLoading.value = false;

      return fetchedItems;
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
    // finally {
    //   isLoading.value = false;
    // }
  }

  /// -- add inventory item to sqflite database --
  addInventoryItem(CInventoryModel inventoryItem) {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // fetch items from sqflite db
      dbHelper.addInventoryItem(inventoryItem);

      isLoading.value = false;
      fetchInventoryItems();
      CPopupSnackBar.successSnackBar(
        title: 'item added successfully',
        message: '${inventoryItem.name} added successfully...',
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

  /// -- fetch inventory item by code --
  Future<List<CInventoryModel>> fetchItemByCode(String code) async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // fetch scanned item from sqflite db
      final fetchedItems = await dbHelper.getScannedInvItem(code);

      if (fetchedItems.isNotEmpty) {
        itemExists.value = true;
        txtName.text = fetchedItems.first.name;
        txtQty.text = (fetchedItems.first.quantity).toString();
        txtBP.text = (fetchedItems.first.buyingPrice).toString();
        txtUnitSP.text = (fetchedItems.first.unitSellingPrice).toString();

        invQty.value = fetchedItems.first.quantity;
      } else {
        itemExists.value = false;
        txtName.text = '';
        txtQty.text = '';
        txtBP.text = '';
        txtUnitSP.text = '';
      }

      return fetchedItems;
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  /// -- update inventory item --
  updateInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // -- start loader
      isLoading.value = true;

      // -- update entry
      await dbHelper.updateInventoryItem(inventoryItem);

      // -- refresh inventory list
      fetchInventoryItems();

      // -- stop loader
      isLoading.value = false;

      // -- success message
      CPopupSnackBar.successSnackBar(
        title: 'update success',
        message: '${inventoryItem.name} updated successfully...',
      );
    } catch (e) {
      // -- stop loader
      isLoading.value = false;
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// -- delete inventory item entry --
  Future<void> deleteInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // -- start loader
      isLoading.value = true;

      // -- update entry
      await dbHelper.deleteInventoryItem(inventoryItem);

      // -- refresh inventory list
      fetchInventoryItems();

      // -- stop loader
      isLoading.value = false;

      // -- success message
      CPopupSnackBar.successSnackBar(
        title: 'delete success',
        message: '${inventoryItem.name} deleted successfully...',
      );
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error deleting data',
        message: e.toString(),
      );
    }
  }

  /// -- add or update inventory item using sqflite
  Future<void> addOrUpdateInventoryItem(CInventoryModel inventoryItem) async {
    // Validate returns true if the form is valid, or false otherwise.
    if (addInvItemFormKey.currentState!.validate()) {
      inventoryItem.name = txtName.text;
      inventoryItem.pCode = txtCode.text;
      inventoryItem.quantity = int.parse(txtQty.text);
      inventoryItem.buyingPrice = int.parse(txtBP.text);
      inventoryItem.unitSellingPrice = int.parse(txtUnitSP.text);
      inventoryItem.date = DateFormat('yyyy-MM-dd - kk:mm').format(clock.now());

      if (itemExists.value) {
        updateInventoryItem(inventoryItem);
        fetchInventoryItems();
      } else {
        addInventoryItem(inventoryItem);
      }
    }
  }

  /// -- barcode scanner --
  void scanBarcodeNormal() async {
    try {
      scanResults.value = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);
      txtCode.text = scanResults.value;
      fetchItemByCode(scanResults.value);
    } on PlatformException {
      scanResults.value = "ERROR!! failed to get platform version";
    } catch (e) {
      scanResults.value = "ERROR!! failed to get platform version";
      CPopupSnackBar.errorSnackBar(
        title: 'scan error',
        message: e.toString(),
      );
    }
  }

  /// -- delete account warning popup snackbar --
  void deleteInventoryWarningPopup(CInventoryModel inventoryItem) {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(CSizes.md),
      title: 'Delete ${inventoryItem.name}?',
      middleText:
          'Are you certain you want to permanently delete this item? This action can\'t be undone!',
      confirm: ElevatedButton(
        onPressed: () async {
          deleteInventoryItem(inventoryItem);
          fetchInventoryItems();
          Navigator.of(Get.overlayContext!).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(
            color: Colors.red,
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(
            horizontal: CSizes.lg,
          ),
          child: Text('delete'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () {
          fetchInventoryItems();
          Navigator.of(Get.overlayContext!).pop();
        },
        child: const Text('cancel'),
      ),
    );
  }
}
