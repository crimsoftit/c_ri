import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:c_ri/api/sheets/store_sheets_api.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/models/txns_model.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';

class CTxnsController extends GetxController {
  static CTxnsController get instance {
    return Get.find();
  }

  @override
  void onInit() async {
    await dbHelper.openDb();

    await fetchTransactions();
    await initTxnsSync();

    showAmountIssuedField.value = true;

    super.onInit();
  }

  /// -- initialize cloud sync --
  Future initTxnsSync() async {
    if (localStorage.read('SyncTxnsDataWithCloud') == true) {
      await importTxnsFromCloud();
      localStorage.write('SyncTxnsDataWithCloud', false);

      await fetchTransactions();
    }
  }

  /// -- variables --
  final localStorage = GetStorage();

  DbHelper dbHelper = DbHelper.instance;

  final RxList<CTxnsModel> transactions = <CTxnsModel>[].obs;
  final RxList<CTxnsModel> foundTxns = <CTxnsModel>[].obs;
  final RxList<CTxnsModel> unsyncedTxnAppends = <CTxnsModel>[].obs;
  final RxList<CTxnsModel> allGsheetTxnsData = <CTxnsModel>[].obs;
  final RxList<CTxnsModel> userGsheetTxnsData = <CTxnsModel>[].obs;

  RxList txnDets = [].obs;

  final RxString sellItemScanResults = ''.obs;
  final RxString selectedPaymentMethod = 'Cash'.obs;
  final RxString stockUnavailableErrorMsg = ''.obs;
  final RxString customerBalErrorMsg = ''.obs;
  final RxString amtIssuedFieldError = ''.obs;

  final RxBool itemExists = false.obs;
  final RxBool showAmountIssuedField = true.obs;
  final RxBool isLoading = false.obs;
  final RxBool syncIsLoading = false.obs;
  final RxBool includeCustomerDetails = false.obs;
  final RxBool txnSuccesfull = false.obs;
  final RxBool txnsFetched = false.obs;

  final txtSaleItemQty = TextEditingController();
  final txtAmountIssued = TextEditingController();
  final txtCustomerName = TextEditingController();
  final txtCustomerContacts = TextEditingController();
  final txtTxnAddress = TextEditingController();

  final RxInt sellItemId = 0.obs;
  final RxInt qtyAvailable = 0.obs;
  final RxInt totalSales = 0.obs;

  final RxString saleItemName = ''.obs;
  final RxString saleItemCode = ''.obs;

  final RxDouble saleItemBp = 0.0.obs;
  final RxDouble saleItemUsp = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble customerBal = 0.0.obs;

  final userController = Get.put(CUserController());
  final searchController = Get.put(CSearchBarController());
  final invController = Get.put(CInventoryController());

  final txnsFormKey = GlobalKey<FormState>();

  /// -- add sale transactions data to sqflite db --
  // Future processTransaction() async {
  //   try {
  //     final isConnected = await CNetworkManager.instance.isConnected();

  //     if (customerBal.value < 0) {
  //       customerBalErrorMsg.value = 'the amount issued is not enough!!';
  //       CPopupSnackBar.errorSnackBar(
  //         title: 'customer still owes you!!',
  //         message: 'the amount issued is not enough',
  //       );
  //       return;
  //     } else if (txtAmountIssued.text == '' &&
  //         showAmountIssuedField.value == true) {
  //       amtIssuedFieldError.value =
  //           'please enter the amount issued by customer!!';
  //       return;
  //     } else {
  //       // Validate returns true if the form is valid, or false otherwise.
  //       if (txnsFormKey.currentState!.validate() &&
  //           customerBalErrorMsg.value == '') {
  //         // start loader while products are fetched
  //         isLoading.value = true;
  //         // -- start loader
  //         CFullScreenLoader.openLoadingDialog(
  //           "we're processing your info...",
  //           CImages.docerAnimation,
  //         );

  //         final newTxn = CTxnsModel(
  //           CHelperFunctions.generateId(),
  //           userController.user.value.id,
  //           userController.user.value.email,
  //           userController.user.value.fullName,
  //           sellItemId.value,
  //           saleItemCode.value,
  //           saleItemName.value,
  //           int.parse(txtSaleItemQty.text.trim()),
  //           totalAmount.value,
  //           selectedPaymentMethod.value == 'Cash'
  //               ? double.parse(txtAmountIssued.text.trim())
  //               : 0.0,
  //           saleItemUsp.value,
  //           selectedPaymentMethod.value,
  //           txtCustomerName.text,
  //           txtCustomerContacts.text,
  //           txtTxnAddress.text,
  //           userController.user.value.locationCoordinates,
  //           DateFormat('yyyy-MM-dd - kk:mm').format(clock.now()),
  //           isConnected ? 1 : 0,
  //           isConnected ? 'none' : 'append',
  //           'complete',
  //         );

  //         // set the updated stock count
  //         qtyAvailable.value -= int.parse(txtSaleItemQty.text);
  //         totalSales.value += int.parse(txtSaleItemQty.text.trim());

  //         // -- check internet connectivity
  //         if (isConnected) {
  //           // upload txn data to cloud
  //           await StoreSheetsApi.saveTxnsToGSheets([newTxn.toMap()]);

  //           // update stock count for inventory item's cloud data
  //           StoreSheetsApi.updateInvStockCount(
  //             id: sellItemId.value,
  //             key: 'quantity',
  //             value: qtyAvailable.value,
  //           );

  //           // update total sales for inventory item's cloud data
  //           await StoreSheetsApi.updateInvItemsSalesCount(
  //             id: sellItemId.value,
  //             key: 'qtySold',
  //             value: totalSales.value,
  //           );
  //         } else {
  //           await dbHelper.updateInvOfflineSyncAfterStockUpdate(
  //               'update', sellItemId.value);
  //         }

  //         // save txn data into the db
  //         await dbHelper.addSoldItem(newTxn);

  //         await dbHelper.updateStockCountAndSales(
  //             qtyAvailable.value, totalSales.value, sellItemId.value);

  //         await fetchTransactions();
  //         await invController.fetchInventoryItems();

  //         // stop loader
  //         isLoading.value = false;

  //         CFullScreenLoader.stopLoading();

  //         CPopupSnackBar.successSnackBar(
  //           title: 'success!',
  //           message: 'transaction successful!',
  //         );

  //         txnSuccesfull.value = true;

  //         Future.delayed(
  //           Duration(seconds: 2),
  //           () {
  //             resetSalesFields();
  //             Navigator.pop(Get.overlayContext!);
  //             //Get.back();
  //           },
  //         );
  //       }
  //     }
  //   } catch (e) {
  //     isLoading.value = false;
  //     CFullScreenLoader.stopLoading();
  //     if (txtAmountIssued.text == '' && showAmountIssuedField.value == true) {
  //       amtIssuedFieldError.value =
  //           'please enter the amount issued by customer!!';
  //       CPopupSnackBar.errorSnackBar(
  //         title: 'invalid value for amount issued!!',
  //         message: 'please enter the amount issued by customer!!',
  //       );
  //       return;
  //     } else {
  //       CPopupSnackBar.errorSnackBar(
  //         title: 'Oh Snap! error saving transaction details',
  //         message: e.toString(),
  //       );
  //       return;
  //     }
  //   }
  // }

  /// -- fetch transactions from sqflite db --
  Future<List<CTxnsModel>> fetchTransactions() async {
    try {
      // start loader while txns are fetched
      isLoading.value = true;
      await dbHelper.openDb();

      // fetch
      final txns =
          await dbHelper.fetchTransactions(userController.user.value.email);

      // assign txns to soldItemsList
      transactions.assignAll(txns);

      foundTxns.value = transactions;

      // assign values for unsynced txn appends
      unsyncedTxnAppends.value = transactions
          .where((unAppendedTxn) =>
              unAppendedTxn.syncAction.toLowerCase().contains('append'))
          .toList();

      // stop loader
      isLoading.value = false;
      txnsFetched.value = true;

      return txns;
    } catch (e) {
      isLoading.value = false;
      txnsFetched.value = false;

      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message: e.toString(),
        );
      }
      throw e.toString();
    } finally {
      isLoading.value = false;
    }
  }

  /// -- barcode scanner using flutter_barcode_scanner package --
  Future<void> scanItemForSale() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666',
          'cancel',
          true,
          ScanMode.BARCODE,
          3000,
          CameraFace.back.toString(),
          ScanFormat.ALL_FORMATS);

      sellItemScanResults.value = barcodeScanRes;

      // -- set inventory item details to fields --
      if (sellItemScanResults.value != '' &&
          sellItemScanResults.value != '-1') {
        //fetchForSaleItemByCode(sellItemScanResults.value);
        await fetchTransactions();
        await fetchForSaleItemByCode(barcodeScanRes);
      }

      if (itemExists.value && !isLoading.value) {
        Get.toNamed(
          '/sales/sell_item/',
        );
      } else {
        CPopupSnackBar.customToast(
          message: 'item not found! please scan again or search inventory',
          forInternetConnectivityStatus: false,
        );
        await fetchTransactions();
      }
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
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'sell item scan error!',
          message: e.toString(),
        );
      }
      throw e.toString();
    }
  }

  /// -- fetch inventory item by code --
  Future<List<CInventoryModel>> fetchForSaleItemByCode(String code) async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // fetch scanned item from sqflite db
      final fetchedItem = await dbHelper.fetchInvItemByCodeAndEmail(
          code, userController.user.value.email);

      //fetchInventoryItems();

      if (fetchedItem.isNotEmpty) {
        itemExists.value = true;
        sellItemId.value = fetchedItem.first.productId!;
        saleItemCode.value = fetchedItem.first.pCode;
        saleItemName.value = fetchedItem.first.name;
        saleItemBp.value = fetchedItem.first.buyingPrice;
        saleItemUsp.value = fetchedItem.first.unitSellingPrice;

        qtyAvailable.value = fetchedItem.first.quantity;
        totalSales.value = fetchedItem.first.qtySold;
      } else {
        itemExists.value = false;
        txtSaleItemQty.text = '';
        totalSales.value = 0;
      }

      isLoading.value = false;

      return fetchedItem;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('****');
        print(e.toString());
        print('****');
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching scan item!',
          message: 'error fetching scan item for sale: $e',
        );
      }

      throw e.toString();
    }
  }

  onSearchTransactions(String value) {
    foundTxns.value = transactions
        .where((txn) =>
            txn.productName.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  /// -- when search result item is selected --
  onSellItemBtnAction(CInventoryModel foundItem) {
    //onInit();
    selectedPaymentMethod.value == "Cash";
    showAmountIssuedField.value == true;
    setTransactionDetails(foundItem);
    Get.toNamed(
      '/sales/sell_item/',
    );
  }

  /// -- calculate totals --
  computeTotals(String value, double usp) {
    if (value.isNotEmpty) {
      totalAmount.value = int.parse(value) * usp;

      checkStockStatus(value);
    } else {
      totalAmount.value = 0.0;
    }
  }

  /// -- check if stock is available for sale --
  checkStockStatus(String value) {
    if (value != '') {
      if (int.parse(value) > qtyAvailable.value) {
        stockUnavailableErrorMsg.value = 'insufficient stock!!';
      } else {
        //qtyAvailable.value -= int.parse(value);
        stockUnavailableErrorMsg.value = '';
      }
    }
  }

  /// -- calculate customer balance --
  computeCustomerBal(double amountIsued, double totals) {
    if (txtAmountIssued.text.isNotEmpty && txtSaleItemQty.text.isNotEmpty) {
      customerBal.value = amountIsued - totals;
    } else {
      customerBal.value = 0.0;
    }
  }

  /// -- set payment method --
  setPaymentMethod(String value) {
    selectedPaymentMethod.value = value;
    if (selectedPaymentMethod.value == 'Cash') {
      showAmountIssuedField.value = true;
    } else {
      showAmountIssuedField.value = false;
    }

    // CPopupSnackBar.customToast(
    //   message: selectedPaymentMethod.value,
    // );
  }

  /// -- set sale details --
  setTransactionDetails(CInventoryModel foundItem) {
    sellItemId.value = foundItem.productId!;
    saleItemCode.value = foundItem.pCode;
    saleItemName.value = foundItem.name;
    saleItemBp.value = foundItem.buyingPrice;
    saleItemUsp.value = foundItem.unitSellingPrice;
    qtyAvailable.value = foundItem.quantity;
    totalSales.value = foundItem.qtySold;
    showAmountIssuedField.value = true;
    selectedPaymentMethod.value == 'Cash';
    if (selectedPaymentMethod.value == 'Cash') {
      showAmountIssuedField.value = true;
    } else {
      showAmountIssuedField.value = false;
    }
  }

  /// -- reset sales --
  resetSalesFields() {
    sellItemScanResults.value = '';
    selectedPaymentMethod.value == 'Cash';
    itemExists.value = false;
    showAmountIssuedField.value = true;
    isLoading.value = false;
    txtSaleItemQty.text = '';
    txtAmountIssued.text = '';
    saleItemName.value = '';
    saleItemCode.value = '';
    qtyAvailable.value = 0;
    totalSales.value = 0;
    saleItemBp.value = 0.0;
    saleItemUsp.value = 0.0;
    totalAmount.value = 0.0;
    customerBal.value = 0.0;
  }

  /// -- add unsynced txns to the cloud --
  Future<void> addSalesDataToCloud() async {
    try {
      isLoading.value = true;
      syncIsLoading.value = true;
      await fetchTransactions().then(
        (result) {
          if (result.isNotEmpty) {
            final unsyncedTxns = transactions.where((unsyncedTxn) =>
                unsyncedTxn.syncAction.toLowerCase() == 'append'.toLowerCase());

            if (unsyncedTxns.isNotEmpty) {
              var gSheetTxnAppends = unsyncedTxns
                  .map(
                    (sale) => {
                      'soldItemId': sale.soldItemId,
                      'txnId': sale.txnId,
                      'userId': sale.userId,
                      'userEmail': sale.userEmail,
                      'userName': sale.userName,
                      'productId': sale.productId,
                      'productCode': sale.productCode,
                      'productName': sale.productName,
                      'quantity': sale.quantity,
                      'totalAmount': sale.totalAmount,
                      'amountIssued': sale.amountIssued,
                      'customerBalance': sale.customerBalance,
                      'unitSellingPrice': sale.unitSellingPrice,
                      'paymentMethod': sale.paymentMethod,
                      'customerName': sale.customerName,
                      'customerContacts': sale.customerContacts,
                      'txnAddress': sale.txnAddress,
                      'txnAddressCoordinates': sale.txnAddressCoordinates,
                      'date': sale.date,
                      'isSynced': 1,
                      'syncAction': 'none',
                      'txnStatus': sale.txnStatus,
                    },
                  )
                  .toList();

              // -- save sales data to cloud --
              //StoreSheetsApi.initSpreadSheets();
              StoreSheetsApi.saveTxnsToGSheets(gSheetTxnAppends)
                  .then((result) async {
                if (result) {
                  // -- update txns status locally --

                  for (var forSyncItem in unsyncedTxns) {
                    await dbHelper.updateTxnItemsSyncStatus(
                        1, 'none', forSyncItem.soldItemId!);
                  }
                  isLoading.value = false;
                  syncIsLoading.value = false;
                } else {
                  syncIsLoading.value = false;
                  CPopupSnackBar.errorSnackBar(
                    title: 'ERROR SYNCING TXNS TO CLOUD...',
                    message: 'an error occurred while uploading txns to cloud',
                  );
                }
              });
            } else {
              syncIsLoading.value = false;
              isLoading.value = false;
              if (kDebugMode) {
                print('***** ALL TXNS RADA SAFI *****');
              }
              CPopupSnackBar.customToast(
                message: '***** ALL TXNS RADA SAFI *****',
                forInternetConnectivityStatus: false,
              );
            }
          } else {
            syncIsLoading.value = false;
            isLoading.value = false;
            CPopupSnackBar.customToast(
              message: 'NO SALES/TXNS FOUND!',
              forInternetConnectivityStatus: false,
            );
          }
        },
      );
    } catch (e) {
      syncIsLoading.value = false;
      isLoading.value = false;
      if (kDebugMode) {
        print('***');
        print('* an error occurred while uploading txns to cloud: $e *');
        print('***');
        CPopupSnackBar.errorSnackBar(
          title: 'ERROR SYNCING TXNS TO CLOUD...',
          message: 'an error occurred while uploading txns to cloud: $e',
        );
      }

      throw e.toString();
    } finally {
      syncIsLoading.value = false;
      isLoading.value = false;
    }
  }

  /// -- fetch txns from google sheets by userEmail --
  Future fetchUserTxnsSheetData() async {
    try {
      isLoading.value = true;

      var gSheetTxnsList = await StoreSheetsApi.fetchAllTxnsFromCloud();

      allGsheetTxnsData.assignAll(gSheetTxnsList!);

      userGsheetTxnsData.value = allGsheetTxnsData
          .where((element) => element.userEmail
              .toLowerCase()
              .contains(userController.user.value.email.toLowerCase()))
          .toList();

      return userGsheetTxnsData;
    } catch (e) {
      isLoading.value = false;

      if (kDebugMode) {
        print('***');
        print(
            '* an error occurred while fetching user\'s cloud txn data: $e *');
        print('***');
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message: e.toString(),
        );
      }

      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: 'an error occurred while fetching user\'s cloud txn data',
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// -- import transactions from cloud --
  Future importTxnsFromCloud() async {
    try {
      isLoading.value = true;

      await fetchTransactions();

      await fetchUserTxnsSheetData();

      if (userGsheetTxnsData.isNotEmpty) {
        if (transactions.isEmpty) {
          for (var element in userGsheetTxnsData) {
            var dbTxnImports = CTxnsModel.withId(
              element.soldItemId,
              element.txnId,
              element.userId,
              element.userEmail,
              element.userName,
              element.productId,
              element.productCode,
              element.productName,
              element.quantity,
              element.totalAmount,
              element.amountIssued,
              element.customerBalance,
              element.unitSellingPrice,
              element.paymentMethod,
              element.customerName,
              element.customerContacts,
              element.txnAddress,
              element.txnAddressCoordinates,
              element.date,
              element.isSynced,
              element.syncAction,
              element.txnStatus,
            );

            await dbHelper.addSoldItem(dbTxnImports);
            await fetchTransactions();
            isLoading.value = false;

            if (kDebugMode) {
              print(
                  "----------\n ===SYNCED TXNS=== \n ${userGsheetTxnsData.iterator} \n\n ----------");
            }
          }
        }
      }
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'ERROR IMPORTING USER DATA FROM CLOUD!',
        message: e.toString(),
      );
    }
  }
}
