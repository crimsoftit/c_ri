import 'package:c_ri/api/sheets/store_sheets_api.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/models/dels_model.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

class CInventoryController extends GetxController {
  static CInventoryController get instance {
    return Get.find();
  }

  /// -- variables --
  final localStorage = GetStorage();

  DbHelper dbHelper = DbHelper.instance;
  final RxList<CInventoryModel> inventoryItems = <CInventoryModel>[].obs;

  final RxList<CInventoryModel> foundInventoryItems = <CInventoryModel>[].obs;

  final RxList<CDelsModel> dItems = <CDelsModel>[].obs;
  final RxList<CInventoryModel> allGSheetData = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> userGSheetData = <CInventoryModel>[].obs;

  final RxString scanResults = ''.obs;

  final RxBool itemExists = false.obs;
  final RxBool gSheetInvItemExists = false.obs;
  final RxInt currentItemId = 0.obs;

  final txtId = TextEditingController();
  final txtName = TextEditingController();
  final txtCode = TextEditingController();
  final txtQty = TextEditingController();
  final txtBP = TextEditingController();
  final txtUnitSP = TextEditingController();

  final txtSyncAction = TextEditingController();

  final addInvItemFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;

  final userController = Get.put(CUserController());
  final searchController = Get.put(CSearchBarController());

  final invSheet = StoreSheetsApi.invSheet;

  @override
  void onInit() async {
    /// -- check if cloud sync is needed for inventory items --

    dbHelper.openDb();

    fetchInventoryItems();
    //fetchUserInvSheetData();
    //fetchInvDels();
    //syncInvDels();
    if (searchController.salesShowSearchField.isTrue &&
        searchController.txtSalesSearch.text == '') {
      foundInventoryItems.value = inventoryItems;
    }
    await initInvSync();
    super.onInit();
  }

  ### ===DO THIS AT AUTHENTICATION LEVEL
  /// -- initialize cloud sync status --
  initInvSync() async {
    //localStorage.writeIfNull('SyncInvDataWithCloud', true);
    if (localStorage.read('SyncInvDataWithCloud') == true) {
      // CPopupSnackBar.customToast(
      //   message: 'CLOUD SYNC IS REQUIRED FOR INVENTORY!!!',
      // );
      importInvDataFromCloud();
      fetchInventoryItems();
      localStorage.write('SyncInvDataWithCloud', false);
    }
  }

  /// -- fetch list of inventory items from sqflite db --
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
          thisItem.first.isSynced = 1;
          thisItem.first.syncAction = "none";
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
            thisItem.first.isSynced,
            thisItem.first.syncAction,
          );
          StoreSheetsApi.saveToGSheets([gSheetsInvData.toMap()], invSheet!);

          CPopupSnackBar.customToast(
            message: 'rada safi',
          );

          /// -- update sync status
          inventoryItem.isSynced = thisItem.first.isSynced;
          inventoryItem.syncAction = 'none';
          await dbHelper.updateInventoryItem(
              inventoryItem, thisItem.first.productId!);
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
  Future<List<CInventoryModel>> fetchItemByCodeAndEmail(String code) async {
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

        txtSyncAction.text = 'update';
      } else {
        itemExists.value = false;
        txtId.text = '';
        txtName.text = '';
        txtQty.text = '';
        txtBP.text = '';
        txtUnitSP.text = '';

        txtSyncAction.text = 'append';
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

      inventoryItem.name = txtName.text.trim();
      inventoryItem.pCode = txtCode.text.toString().trim();
      inventoryItem.quantity = int.parse(txtQty.text.trim());
      inventoryItem.buyingPrice = double.parse(txtBP.text.trim());
      inventoryItem.unitSellingPrice = double.parse(txtUnitSP.text.trim());
      inventoryItem.date = DateFormat('yyyy-MM-dd - kk:mm').format(clock.now());

      inventoryItem.syncAction = txtSyncAction.text.trim();

      if (itemExists.value) {
        // -- check internet connectivity
        final isConnected = await CNetworkManager.instance.isConnected();

        if (isConnected) {
          //fetchInvSheetItemById(int.parse(txtId.text));
          inventoryItem.isSynced = 1;
          inventoryItem.syncAction = 'none';
          updateInvSheetItem(int.parse(txtId.text), inventoryItem);
          // -- success message
          CPopupSnackBar.successSnackBar(
            title: 'update sync',
            message: 'UPDATE SYNCRONIZED...',
          );
        } else {
          inventoryItem.isSynced = 0;
          inventoryItem.syncAction = txtSyncAction.text.trim();
          CPopupSnackBar.customToast(
            message:
                'while this works offline, consider using an internet connection to back up your data online!',
          );
        }
        updateInventoryItem(inventoryItem);
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
      fetchItemByCodeAndEmail(txtCode.text);
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
          // -- check internet connectivity
          final isConnected = await CNetworkManager.instance.isConnected();

          if (isConnected) {
            await fetchInvSheetItemById(inventoryItem.productId!);

            if (gSheetInvItemExists.value) {
              deleteInvSheetItem(inventoryItem.productId!);
            }
          } else {
            final delItem = CDelsModel(
              inventoryItem.productId!,
              inventoryItem.name,
              'inventory',
              0,
            );
            dbHelper.saveDelForSync(delItem);
          }
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

  /// -- fetch list of inventory items from google sheets --
  Future fetchAllInvSheetItems() async {
    try {
      // fetch items from sqflite db
      var gsheetItemsList = (await StoreSheetsApi.fetchAllGsheetInvItems())!;

      allGSheetData.assignAll(gsheetItemsList as Iterable<CInventoryModel>);

      //CPopupSnackBar.customToast(message: gSheetData.first.name);

      return allGSheetData;
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  /// -- fetch inventory data from google sheets by its id --
  Future fetchInvSheetItemById(int id) async {
    final invItem = await StoreSheetsApi.fetchInvItemById(id);
    var gSheetItemData = invItem!.toMap();
    if (gSheetItemData.isNotEmpty) {
      gSheetInvItemExists.value = true;

      CPopupSnackBar.customToast(message: '${gSheetItemData.entries}');
    } else if (gSheetItemData.isEmpty) {
      gSheetInvItemExists.value = false;
      CPopupSnackBar.errorSnackBar(
        title: 'item not found',
        message: "item with ID $id NOT FOUND!!",
      );
    }

    if (kDebugMode) {
      print("----------\n\n $gSheetItemData \n\n ----------");
    }
  }

  /// -- update single item data in google sheets --
  Future updateInvSheetItem(int id, CInventoryModel itemModel) async {
    try {
      await StoreSheetsApi.updateInvData(id, itemModel.toMap());
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error updating sheet data',
        message: e.toString(),
      );

      throw e.toString();
    }
  }

  /// -- delete inventory item from google sheets --
  Future deleteInvSheetItem(int id) async {
    try {
      var sheetName = 'inventory';

      //var invSheetItem = await StoreSheetsApi.fetchInvItemById(id);
      await StoreSheetsApi.deleteById(id, sheetName);
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'delete error',
        message: e.toString(),
      );
      throw e.toString();
    }
  }

  Future<List<CDelsModel>> fetchInvDels() async {
    try {
      await dbHelper.openDb();

      final dels = await dbHelper.fetchAllDels();
      dItems.assignAll(dels);

      if (dItems.isEmpty) {
        CPopupSnackBar.customToast(
          message: "NO DELS",
        );
        return [];
      } else {
        // for (var element in dItems) {
        //   CPopupSnackBar.customToast(
        //     message: '${element.itemId} ${element.category}',
        //   );
        // }

        return dItems;
      }
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'DELS ERROR',
        message: e.toString(),
      );
      throw e.toString();
    }
  }

  /// -- fetch inventory data from google sheets by userEmail --
  Future fetchUserInvSheetData() async {
    try {
      // fetch items from sqflite db
      var gsheetItemsList = (await StoreSheetsApi.fetchAllGsheetInvItems())!;

      allGSheetData.assignAll(gsheetItemsList as Iterable<CInventoryModel>);

      userGSheetData.value = allGSheetData
          .where((element) => element.userEmail
              .toLowerCase()
              .contains(userController.user.value.email.toLowerCase()))
          .toList();

      //CPopupSnackBar.customToast(message: gSheetData.first.name);

      return allGSheetData;
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  /// -- import inventory data from google sheets --
  Future importInvDataFromCloud() async {
    try {
      isLoading.value = true;
      await fetchUserInvSheetData();

      if (userGSheetData.isNotEmpty) {
        for (var element in userGSheetData) {
          var dbData = CInventoryModel.withID(
            element.productId,
            element.userId,
            element.userEmail,
            element.userName,
            element.pCode,
            element.name,
            element.quantity,
            element.buyingPrice,
            element.unitSellingPrice,
            element.date,
            element.isSynced,
            element.syncAction,
          );

          dbHelper.addInventoryItem(dbData);
          fetchInventoryItems();

          isLoading.value = false;

          CPopupSnackBar.successSnackBar(
            title: 'data sync successful',
            message: 'inventory data synced successfully...',
          );
        }
      } else if (userGSheetData.isEmpty) {
        isLoading.value = false;
        CPopupSnackBar.customToast(
          message: 'no data to import...',
        );
      }

      print("----------\n\n $userGSheetData \n\n ----------");
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        durationInSeconds: 10,
        title: 'ERROR IMPORTING USER DATA FROM CLOUD!',
        message: e.toString(),
      );
    }
  }

  Future syncInvDels() async {
    await dbHelper.openDb();
    // -- check internet connectivity
    final isConnected = await CNetworkManager.instance.isConnected();
    if (isConnected) {
      final dels = await dbHelper.fetchAllDels();
      dItems.assignAll(dels);

      if (dItems.isNotEmpty) {
        for (var element in dItems) {
          await deleteInvSheetItem(element.itemId!);

          final delItem = CDelsModel(
            element.itemId,
            element.itemName,
            'inventory',
            1,
          );

          await dbHelper.updateDel(delItem);
          CPopupSnackBar.customToast(
            message: 'DELETION SYNC RADA SAFI',
          );
        }
      } else {
        CPopupSnackBar.customToast(
          message: 'no sync needed - rada safi',
        );
      }
    }
  }
}
