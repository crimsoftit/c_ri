import 'package:c_ri/api/sheets/store_sheets_api.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/models/inv_dels_model.dart';
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
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class CInventoryController extends GetxController {
  static CInventoryController get instance {
    return Get.find();
  }

  /// -- variables --
  final localStorage = GetStorage();

  DbHelper dbHelper = DbHelper.instance;
  final RxList<CInventoryModel> inventoryItems = <CInventoryModel>[].obs;

  final RxList<CInventoryModel> foundInventoryItems = <CInventoryModel>[].obs;

  final RxList<CInvDelsModel> dItems = <CInvDelsModel>[].obs;
  final RxList<CInvDelsModel> pendingUpdates = <CInvDelsModel>[].obs;
  final RxList<CInventoryModel> allGSheetData = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> topSoldItems = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> unSyncedAppends = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> unSyncedUpdates = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> userGSheetData = <CInventoryModel>[].obs;

  final RxString scanResults = ''.obs;

  final RxBool itemExists = false.obs;
  final RxBool gSheetInvItemExists = false.obs;
  final RxBool includeSupplierDetails = false.obs;
  final RxBool supplierDetailsExist = false.obs;

  final RxInt currentItemId = 0.obs;

  final RxDouble unitBP = 0.0.obs;

  final txtId = TextEditingController();
  final txtName = TextEditingController();
  final txtCode = TextEditingController();
  final txtQty = TextEditingController();
  final txtBP = TextEditingController();
  final txtUnitSP = TextEditingController();
  final txtStockNotifierLimit = TextEditingController();
  final txtSupplierName = TextEditingController();
  final txtSupplierContacts = TextEditingController();
  final txtSyncAction = TextEditingController();

  final addInvItemFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final syncIsLoading = false.obs;

  final searchController = Get.put(CSearchBarController());
  final userController = Get.put(CUserController());

  @override
  void onInit() async {
    dbHelper.openDb();
    fetchUserInventoryItems();
    fetchInvDels();
    fetchInvUpdates();

    await initInvSync();
    fetchTopSellers();

    super.onInit();
  }

  /// -- initialize cloud sync --
  initInvSync() async {
    //final isConnected = await CNetworkManager.instance.isConnected();

    if (localStorage.read('SyncInvDataWithCloud') == true) {
      importInvDataFromCloud();
      localStorage.write('SyncInvDataWithCloud', false);

      fetchUserInventoryItems();
    }
  }

  /// -- fetch list of inventory items from sqflite db --
  Future<List<CInventoryModel>> fetchUserInventoryItems() async {
    try {
      // start loader while products are fetched
      isLoading.value = true;
      foundInventoryItems.clear();

      await dbHelper.openDb();

      // fetch items from sqflite db
      final fetchedItems =
          await dbHelper.fetchInventoryItems(userController.user.value.email);

      // assign inventory items
      inventoryItems.assignAll(fetchedItems);

      if (searchController.showSearchField.isTrue &&
          searchController.txtSearchField.text == '') {
        foundInventoryItems.assignAll(fetchedItems);
      }

      // unsynced appends
      unSyncedAppends.value = inventoryItems
          .where((appendItem) =>
              appendItem.syncAction.toLowerCase().contains('append'))
          .toList();

      // unsynced updates
      unSyncedUpdates.value = inventoryItems
          .where((updateItem) =>
              updateItem.syncAction.toLowerCase().contains('update'))
          .toList();

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

  /// -- add inventory item to sqflite database --
  addInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // add inventory item into sqflite db
      inventoryItem.productId = CHelperFunctions.generateInvId();

      // -- check internet connectivity
      final isConnected = await CNetworkManager.instance.isConnected();

      if (isConnected) {
        // -- save data to gsheets --
        var gSheetsInvData = CInventoryModel.withID(
          inventoryItem.productId,
          userController.user.value.id,
          userController.user.value.email,
          userController.user.value.fullName,
          txtCode.text,
          txtName.text,
          0,
          int.parse(txtQty.text),
          0,
          0,
          double.parse(txtBP.text.trim()),
          unitBP.value,
          double.parse(txtUnitSP.text.trim()),
          txtStockNotifierLimit.text != ''
              ? int.parse(txtStockNotifierLimit.text.trim())
              : (int.parse(txtQty.text) / 5).toInt(),
          txtSupplierName.text.trim(),
          txtSupplierContacts.text.trim(),
          DateFormat('yyyy-MM-dd @ kk:mm').format(clock.now()),
          DateFormat('yyyy-MM-dd @ kk:mm').format(clock.now()),
          1,
          'none',
        );
        await StoreSheetsApi.saveInvItemsToGSheets([gSheetsInvData.toMap()]);

        /// -- update sync status
        inventoryItem.isSynced = 1;
        inventoryItem.syncAction = 'none';
      } else {
        inventoryItem.isSynced = 0;
        inventoryItem.syncAction = 'append';
        CPopupSnackBar.customToast(
          message:
              'while this works offline, consider using an internet connection to back up your data online!',
          forInternetConnectivityStatus: true,
        );
      }

      await dbHelper.addInventoryItem(inventoryItem);
      await fetchUserInventoryItems();

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

  /// -- upload unsynced data to the cloud --
  Future<void> addUnsyncedInvToCloud() async {
    isLoading.value = true;
    await fetchUserInventoryItems();

    // -- check internet connectivity
    final isConnectedToInternet = await CNetworkManager.instance.isConnected();

    if (isConnectedToInternet) {
      var gSheetAppendItems = unSyncedAppends
          .map((e) => {
                'productId': e.productId,
                'userId': e.userId,
                'userEmail': e.userEmail,
                'userName': e.userName,
                'pCode': e.pCode,
                'name': e.name,
                'markedAsFavorite': e.markedAsFavorite,
                'quantity': e.quantity,
                'qtySold': e.qtySold,
                'qtyRefunded': e.qtyRefunded,
                'buyingPrice': e.buyingPrice,
                'unitBp': e.unitBp,
                'unitSellingPrice': e.unitSellingPrice,
                'lowStockNotifierLimit': e.lowStockNotifierLimit,
                'supplierName': e.supplierName,
                'supplierContacts': e.supplierContacts,
                'dateAdded': e.dateAdded,
                'lastModified': e.lastModified,
                'isSynced': 1,
                'syncAction': 'none',
              })
          .toList();

      if (unSyncedAppends.isNotEmpty) {
        if (kDebugMode) {
          print(gSheetAppendItems);
        }

        await StoreSheetsApi.saveInvItemsToGSheets(gSheetAppendItems);

        await updateSyncedInvAppends();
        isLoading.value = false;
      }
    }
  }

  Future updateSyncedInvAppends() async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // -- check internet connectivity
      final isConnectedToInternet =
          await CNetworkManager.instance.isConnected();

      if (isConnectedToInternet) {
        unSyncedAppends.value = inventoryItems
            .where((item) => item.syncAction.toLowerCase().contains('append'))
            .toList();

        if (unSyncedAppends.isNotEmpty) {
          for (var element in unSyncedAppends) {
            var syncAppendsData = CInventoryModel.withID(
              element.productId,
              element.userId,
              element.userEmail,
              element.userName,
              element.pCode,
              element.name,
              element.markedAsFavorite,
              element.quantity,
              element.qtySold,
              element.qtyRefunded,
              element.buyingPrice,
              element.unitBp,
              element.unitSellingPrice,
              element.lowStockNotifierLimit,
              element.supplierName,
              element.supplierContacts,
              element.dateAdded,
              element.lastModified,
              1,
              'none',
            );

            await dbHelper.updateInventoryItem(
                syncAppendsData, element.productId!);
            isLoading.value != isLoading.value;
          }
        }
      }
    } catch (e) {
      isLoading.value = false;
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
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
        unitBP.value = fetchedItem.first.unitBp;
        txtUnitSP.text = (fetchedItem.first.unitSellingPrice).toString();

        txtStockNotifierLimit.text =
            (fetchedItem.first.lowStockNotifierLimit).toString();
        txtSupplierName.text = fetchedItem.first.supplierName;
        txtSupplierContacts.text = fetchedItem.first.supplierContacts;

        if (fetchedItem.first.supplierName != '' ||
            fetchedItem.first.supplierContacts != '') {
          supplierDetailsExist.value = true;
        } else {
          supplierDetailsExist.value = false;
        }

        txtSyncAction.text = 'update';
      } else {
        itemExists.value = false;
        supplierDetailsExist.value = false;
        txtId.text = '';
        txtName.text = '';
        txtQty.text = '';
        txtBP.text = '';
        unitBP.value = 0.0;
        txtUnitSP.text = '';
        txtStockNotifierLimit.text = '';
        txtSupplierName.text = '';
        txtSupplierContacts.text = '';
        txtSyncAction.text = 'append';
      }
      isLoading.value = false;
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
    unitBP.value = 0.0;
    txtUnitSP.text = "";
    txtStockNotifierLimit.text = "";
    txtSupplierName.text = "";
    txtSupplierContacts.text = '';
    scanBarcodeNormal();
  }

  searchInventory(String value) {
    fetchUserInventoryItems();
    foundInventoryItems.clear();

    var invSearchItems = inventoryItems
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()) ||
            element.productId
                .toString()
                .toLowerCase()
                .contains(value.toLowerCase()) ||
            element.pCode.toLowerCase().contains(value.toLowerCase()))
        .toList();

    foundInventoryItems.assignAll(invSearchItems);
  }

  /// -- update inventory item --
  updateInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // -- start loader
      isLoading.value = true;

      // -- update entry
      await dbHelper.updateInventoryItem(inventoryItem, int.parse(txtId.text));

      // -- refresh inventory list
      fetchUserInventoryItems();

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
      fetchUserInventoryItems();

      searchController.txtSearchField.text = '';

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
      inventoryItem.pCode = txtCode.text.trim();
      inventoryItem.quantity = int.parse(txtQty.text.trim());
      inventoryItem.buyingPrice = double.parse(txtBP.text.trim());
      inventoryItem.unitBp = unitBP.value;
      inventoryItem.unitSellingPrice = double.parse(txtUnitSP.text);
      inventoryItem.lowStockNotifierLimit = txtStockNotifierLimit.text != ''
          ? int.parse(txtStockNotifierLimit.text.trim())
          : (int.parse(txtQty.text.trim()) / 5).toInt();
      inventoryItem.supplierName = txtSupplierName.text.trim();
      inventoryItem.supplierContacts = txtSupplierContacts.text.trim();
      inventoryItem.lastModified =
          DateFormat('yyyy-MM-dd @ kk:mm').format(clock.now());

      inventoryItem.syncAction = txtSyncAction.text.trim();

      if (itemExists.value) {
        // -- check internet connectivity
        final isConnected = await CNetworkManager.instance.isConnected();

        if (isConnected) {
          //fetchInvSheetItemById(int.parse(txtId.text));
          inventoryItem.isSynced = 1;
          inventoryItem.syncAction = 'none';
          updateInvSheetItem(int.parse(txtId.text.trim()), inventoryItem);
        } else {
          //inventoryItem.isSynced = 0;
          inventoryItem.syncAction =
              inventoryItem.isSynced == 1 ? 'update' : 'append';

          final updateItem = CInvDelsModel(
            inventoryItem.productId!,
            inventoryItem.name,
            'inventory',
            inventoryItem.isSynced,
            inventoryItem.syncAction,
          );
          await dbHelper.saveInvDelsForSync(updateItem);
          CPopupSnackBar.customToast(
            message:
                'while this works offline, consider using an internet connection to back up your data online!',
            forInternetConnectivityStatus: true,
          );
        }
        updateInventoryItem(inventoryItem);
      } else {
        inventoryItem.dateAdded =
            DateFormat('yyyy-MM-dd @ kk:mm').format(clock.now());
        addInventoryItem(inventoryItem);
      }
    }
  }

  /// -- barcode scanner --
  void scanBarcodeNormal() async {
    try {
      scanResults.value = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'cancel',
          true,
          ScanMode.BARCODE,
          2000,
          CameraFace.back.toString(),
          ScanFormat.ALL_FORMATS);
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
      title: 'permanently delete ${inventoryItem.name}?',
      middleText:
          'Are you certain you want to permanently delete this item? This action can\'t be undone!',
      confirm: ElevatedButton(
        onPressed: () async {
          // -- check internet connectivity
          final isConnected = await CNetworkManager.instance.isConnected();

          if (isConnected) {
            if (inventoryItem.isSynced == 1) {
              deleteInvSheetItem(inventoryItem.productId!);
            }
          } else {
            final delItem = CInvDelsModel(
              inventoryItem.productId!,
              inventoryItem.name,
              'inventory',
              inventoryItem.isSynced,
              'delete',
            );
            await dbHelper.saveInvDelsForSync(delItem);
          }
          deleteInventoryItem(inventoryItem);
          fetchUserInventoryItems();

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
          fetchUserInventoryItems();
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

      return allGSheetData;
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
    }
  }

  /// -- update single item cloud data --
  Future updateInvSheetItem(int id, CInventoryModel itemModel) async {
    try {
      //await StoreSheetsApi.initializeSpreadSheets();
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
      await StoreSheetsApi.deleteInvItemById(id);
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'delete error',
        message: e.toString(),
      );
      throw e.toString();
    }
  }

  /// -- fetch inventory data from google sheets by userEmail --
  Future fetchUserInvSheetData() async {
    try {
      // fetch inventory items from cloud
      var gsheetItemsList = (await StoreSheetsApi.fetchAllGsheetInvItems())!;

      allGSheetData.assignAll(gsheetItemsList as Iterable<CInventoryModel>);

      userGSheetData.value = allGSheetData
          .where((element) => element.userEmail
              .toLowerCase()
              .contains(userController.user.value.email.toLowerCase()))
          .toList();

      return userGSheetData;
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap! ERROR FETCHING USER GSHEET INV DATA',
        message: e.toString(),
      );
    }
  }

  /// -- import inventory data from google sheets --
  Future importInvDataFromCloud() async {
    try {
      isLoading.value = true;

      // -- check internet connectivity
      final isConnectedToInternet =
          await CNetworkManager.instance.isConnected();

      if (isConnectedToInternet) {
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
              element.markedAsFavorite,
              element.quantity,
              element.qtySold,
              element.qtyRefunded,
              element.buyingPrice,
              element.unitBp,
              element.unitSellingPrice,
              element.lowStockNotifierLimit,
              element.supplierName,
              element.supplierContacts,
              element.dateAdded,
              element.lastModified,
              element.isSynced,
              element.syncAction,
            );

            // -- save imported data to local sqflite database --
            dbHelper.addInventoryItem(dbData);

            // -- fetch inventory items --
            fetchUserInventoryItems();

            isLoading.value = false;
          }
        }

        if (kDebugMode) {
          print("----------\n\n $userGSheetData \n\n ----------");
        }
      }
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'ERROR IMPORTING inventory DATA FROM CLOUD!',
        message: e.toString(),
      );
    }
  }

  Future<List<CInvDelsModel>> fetchInvDels() async {
    try {
      await dbHelper.openDb();

      final dels = await dbHelper.fetchAllInvDels();
      dItems.assignAll(dels);

      // if (dItems.isEmpty) {
      //   return {[]};
      // } else {
      //   return dItems;
      // }
      return dItems.toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'DELS ERROR',
          message: e.toString(),
        );
      }

      throw e.toString();
    }
  }

  Future syncInvDels() async {
    await dbHelper.openDb();
    // -- check internet connectivity
    final isConnectedToInternet = await CNetworkManager.instance.isConnected();
    if (isConnectedToInternet) {
      final dels = await dbHelper.fetchAllInvDels();
      dItems.assignAll(dels);

      if (dItems.isNotEmpty) {
        for (var element in dItems) {
          await deleteInvSheetItem(element.itemId!);

          final delItem = CInvDelsModel(
            element.itemId,
            element.itemName,
            'inventory',
            1,
            'none',
          );

          await dbHelper.updateDel(delItem);
        }
      }
    }
  }

  /// -- fetch items with pending updates --
  Future<List<CInvDelsModel>> fetchInvUpdates() async {
    try {
      await dbHelper.openDb();

      final pUpdates = await dbHelper.fetchAllInvUpdates();
      pendingUpdates.assignAll(pUpdates);

      return pendingUpdates;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'DELS ERROR',
          message: e.toString(),
        );
      }

      throw e.toString();
    }
  }

  Future syncInvUpdates() async {
    await fetchUserInventoryItems();

    // -- check internet connectivity
    final isConnectedToInternet = await CNetworkManager.instance.isConnected();

    if (isConnectedToInternet) {
      if (unSyncedUpdates.isNotEmpty) {
        for (var element in unSyncedUpdates) {
          if (element.isSynced == 1) {
            await deleteInvSheetItem(element.productId!);
          }
          final invUpdateItem = CInventoryModel.withID(
            element.productId,
            element.userId,
            element.userEmail,
            element.userName,
            element.pCode,
            element.name,
            element.markedAsFavorite,
            element.quantity,
            element.qtySold,
            element.qtyRefunded,
            element.buyingPrice,
            element.unitBp,
            element.unitSellingPrice,
            element.lowStockNotifierLimit,
            element.supplierName,
            element.supplierContacts,
            element.dateAdded,
            element.lastModified,
            0,
            'append',
          );

          await dbHelper.updateInventoryItem(invUpdateItem, element.productId!);

          final delItem = CInvDelsModel(
            element.productId,
            element.name,
            'inventory',
            1,
            'none',
          );
          await dbHelper.updateDel(delItem);

          fetchUserInventoryItems();
        }
      } else {
        if (kDebugMode) {
          print('/n/n ----- /n all updates rada safi \n -----');
        }
      }
    }
  }

  Future<bool> cloudSyncInventory() async {
    try {
      // start loader
      syncIsLoading.value = true;
      await fetchUserInventoryItems();
      await fetchInvDels();

      // -- check internet connectivity
      final isConnectedToInternet =
          await CNetworkManager.instance.isConnected();

      if (isConnectedToInternet) {
        /// -- initialize spreadsheets --
        await StoreSheetsApi.initSpreadSheets();
        await syncInvDels();
        await addUnsyncedInvToCloud();
        await syncInvUpdates();
        // stop loader
        syncIsLoading.value = false;
        return true;
      } else {
        // stop loader
        syncIsLoading.value = false;
        CPopupSnackBar.warningSnackBar(
          title: 'cloud sync requires internet',
          message: 'an internet connection is required for cloud sync...',
        );
        return false;
      }
    } catch (e) {
      // stop loader
      syncIsLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'inventory cloud sync ERROR!',
          message: 'inventory sync error: $e',
        );
      }
      return false;
    } finally {
      // stop loader
      syncIsLoading.value = false;
    }
  }

  /// -- fetch top sellers --
  Future<List<CInventoryModel>> fetchTopSellers() async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      await dbHelper.openDb();

      final topSellers =
          await dbHelper.fetchTopSellers(userController.user.value.email);

      // assign top sold items to a list
      topSoldItems.assignAll(topSellers);

      // stop loader
      isLoading.value = false;

      return topSellers;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message: e.toString(),
        );
      }
      return [];
    }
  }

  /// -- compute unitBP --
  computeUnitBP(double bp, int qty) {
    unitBP.value = bp / qty;
  }

  toggleSupplierDetsFieldsVisibility() {
    if (includeSupplierDetails.value) {
      includeSupplierDetails.value = false;
    } else {
      includeSupplierDetails.value = true;
    }
  }

  /// -- reset fields --
  resetInvFields() {
    txtId.text = "";
    txtName.text = "";
    txtCode.text = "";
    txtQty.text = "";
    txtBP.text = "";
    unitBP.value = 0.0;
    txtUnitSP.text = "";
    txtStockNotifierLimit.text = "";
    txtSupplierName.text = "";
    txtSupplierContacts.text = '';
  }
}
