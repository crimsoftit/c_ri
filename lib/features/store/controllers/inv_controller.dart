import 'package:c_ri/api/sheets/store_sheets_api.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
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

  final RxList<CInventoryModel> foundInventoryItems = <CInventoryModel>[].obs;

  final RxString scanResults = ''.obs;
  final RxString currencySymbol = ''.obs;
  final RxString countryCode = ''.obs;

  final RxBool itemExists = false.obs;
  final RxInt currentItemId = 0.obs;

  final txtId = TextEditingController();
  final txtName = TextEditingController();
  final txtCode = TextEditingController();
  final txtQty = TextEditingController();
  final txtBP = TextEditingController();
  final txtUnitSP = TextEditingController();

  final addInvItemFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  final userController = Get.put(CUserController());
  final searchController = Get.put(CSearchBarController());

  final invSheet = StoreSheetsApi.invSheet;

  @override
  void onInit() {
    fetchInventoryItems();
    if (searchController.salesShowSearchField.isTrue &&
        searchController.txtSalesSearch.text == '') {
      foundInventoryItems.value = inventoryItems;
    }
    super.onInit();
  }

  /// -- fetch list of inventory items --
  Future<List<CInventoryModel>> fetchInventoryItems() async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      await dbHelper.openDb();

      // fetch items from sqflite db
      final fetchedItems =
          await dbHelper.fetchInventoryItems(userController.user.value.email);

      // assign inventory items
      inventoryItems.assignAll(fetchedItems);

      if (searchController.salesShowSearchField.isTrue &&
          searchController.txtSalesSearch.text == '') {
        foundInventoryItems.value = inventoryItems;
      }

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
  }

  /// ### -- MICROSECONDS_SINCE_EPOCH FOR PRODUCT ID -- ### ///
  /// -- add inventory item to sqflite database --
  addInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // add inventory item into sqflite db
      inventoryItem.productId = CHelperFunctions.generateId();

      dbHelper.addInventoryItem(inventoryItem);
      fetchInventoryItems();

      // fetch this item from sqflite db to get the product id
      var thisItem = await dbHelper.fetchInvItemByCodeAndEmail(
          inventoryItem.pCode, userController.user.value.email);

      // -- check internet connectivity
      final isConnected = await CNetworkManager.instance.isConnected();

      if (isConnected) {
        if (thisItem.isNotEmpty) {
          // -- save data to gsheets --
          var gSheetsInvData = CInventoryModel.withID(
            thisItem.first.productId,
            userController.user.value.id,
            userController.user.value.email,
            userController.user.value.fullName,
            txtCode.text.toString(),
            txtName.text,
            int.parse(txtQty.text),
            double.parse(txtBP.text),
            double.parse(txtUnitSP.text),
            DateFormat('yyyy-MM-dd - kk:mm').format(
              clock.now(),
            ),
          );
          StoreSheetsApi.saveToGSheets([gSheetsInvData.toMap()], invSheet!);
          CPopupSnackBar.customToast(
            message: 'rada safi',
          );
        } else {
          isLoading.value = false;
          CPopupSnackBar.errorSnackBar(
              title: 'ERROR SAVING ITEM ONLINE: DOES NOT EXIST!!! ',
              message: 'MAKOSA MAKOSA MAKOSA!!! PROBLEMS PROBLEMS PROBLEMS!!!');
        }
      } else {
        CPopupSnackBar.customToast(
          message:
              'while this works offline, consider using an internet connection to back up your data online!',
        );
      }

      isLoading.value = false;

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
      final fetchedItem = await dbHelper.fetchInvItemByCodeAndEmail(
          code, userController.user.value.email);

      //fetchInventoryItems();

      if (fetchedItem.isNotEmpty) {
        currentItemId.value = fetchedItem.first.productId!;

        itemExists.value = true;
        txtId.text = currentItemId.value.toString();
        txtName.text = fetchedItem.first.name;
        txtQty.text = (fetchedItem.first.quantity).toString();
        txtBP.text = (fetchedItem.first.buyingPrice).toString();
        txtUnitSP.text = (fetchedItem.first.unitSellingPrice).toString();
      } else {
        itemExists.value = false;
        txtId.text = '';
        txtName.text = '';
        txtQty.text = '';
        txtBP.text = '';
        txtUnitSP.text = '';
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

  void runInvScanner() {
    txtId.text = "";
    txtName.text = "";
    txtCode.text = "";
    txtQty.text = "";
    txtBP.text = "";
    txtUnitSP.text = "";
    scanBarcodeNormal();
  }

  onSearchInventory(String value) {
    //fetchInventoryItems();

    foundInventoryItems.value = inventoryItems
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  /// -- update inventory item --
  updateInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // -- start loader
      isLoading.value = true;

      // -- update entry
      await dbHelper.updateInventoryItem(inventoryItem, int.parse(txtId.text));

      // -- refresh inventory list
      fetchInventoryItems();

      // -- stop loader
      isLoading.value = false;

      // -- success message
      CPopupSnackBar.successSnackBar(
        title: 'update success',
        message: '${inventoryItem.name} updated successfully...',
      );

      // -- stop loader
      //isLoading.value = false;
    } catch (e) {
      // -- stop loader
      isLoading.value = false;
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
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

      searchController.txtInvSearchField.text = '';

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
      inventoryItem.userId = userController.user.value.id;
      inventoryItem.userEmail = userController.user.value.email;
      inventoryItem.userName = userController.user.value.fullName;

      inventoryItem.name = txtName.text;
      inventoryItem.pCode = txtCode.text.toString();
      inventoryItem.quantity = int.parse(txtQty.text);
      inventoryItem.buyingPrice = double.parse(txtBP.text);
      inventoryItem.unitSellingPrice = double.parse(txtUnitSP.text);
      inventoryItem.date = DateFormat('yyyy-MM-dd - kk:mm').format(clock.now());

      if (itemExists.value) {
        updateInventoryItem(inventoryItem);
        //fetchInventoryItems();
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
      fetchItemByCode(txtCode.text);
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
