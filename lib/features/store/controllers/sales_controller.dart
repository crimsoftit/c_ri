import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/models/sold_items_model.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/popups/full_screen_loader.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CSalesController extends GetxController {
  static CSalesController get instance {
    return Get.find();
  }

  @override
  void onInit() {
    isLoading.value = false;
    fetchTransactions();

    resetSales();
    if (selectedPaymentMethod.value == 'Cash') {
      showAmountIssuedField.value = true;
    } else {
      showAmountIssuedField.value = false;
    }
    super.onInit();
  }

  /// -- variables --
  DbHelper dbHelper = DbHelper.instance;

  final RxList<CSoldItemsModel> transactions = <CSoldItemsModel>[].obs;
  final RxList<CSoldItemsModel> foundTxns = <CSoldItemsModel>[].obs;
  RxList txnDets = [].obs;

  final RxString sellItemScanResults = ''.obs;
  final RxString selectedPaymentMethod = 'Cash'.obs;
  final RxString stockUnavailableErrorMsg = ''.obs;
  final RxString customerBalErrorMsg = ''.obs;

  final RxBool itemExists = false.obs;
  final RxBool showAmountIssuedField = false.obs;
  final RxBool isLoading = false.obs;

  final txtSaleItemQty = TextEditingController();
  final txtAmountIssued = TextEditingController();

  final RxInt sellItemId = 0.obs;
  final RxInt qtyAvailable = 0.obs;

  final RxString saleItemName = ''.obs;
  final RxString saleItemCode = ''.obs;

  final RxDouble saleItemBp = 0.0.obs;
  final RxDouble saleItemUsp = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;
  final RxDouble customerBal = 0.0.obs;

  final userController = Get.put(CUserController());
  final searchController = Get.put(CSearchBarController());

  final txnsFormKey = GlobalKey<FormState>();

  /// -- get to transaction details page --
  // getToTxnDetails(int txnId) {
  //   txnDets = transactions.firstWhere((txn) => txn.saleId == txnId);
  // }

  /// -- add sale transactions data to sqflite db --
  Future processTransaction() async {
    try {
      if (customerBal.value < 0) {
        customerBalErrorMsg.value = 'the amount issued is not enough!!';
        CPopupSnackBar.errorSnackBar(
          title: 'customer still owes you!!',
          message: 'the amount issued is not enough',
        );
      } else {
        customerBalErrorMsg.value = '';
        // Validate returns true if the form is valid, or false otherwise.
        if (txnsFormKey.currentState!.validate()) {
          // start loader while products are fetched
          isLoading.value = true;
          // -- start loader
          CFullScreenLoader.openLoadingDialog(
            "we're processing your info...",
            CImages.docerAnimation,
          );

          final newTxn = CSoldItemsModel(
            userController.user.value.id,
            userController.user.value.email,
            userController.user.value.fullName,
            sellItemId.value,
            saleItemCode.value,
            saleItemName.value,
            int.parse(txtSaleItemQty.text),
            totalAmount.value,
            saleItemUsp.value,
            selectedPaymentMethod.value,
            DateFormat('yyyy-MM-dd - kk:mm').format(clock.now()),
          );

          // save txn data into the db
          await dbHelper.addSoldItem(newTxn);

          // set the updated stock count
          qtyAvailable.value -= int.parse(txtSaleItemQty.text);
          await dbHelper.updateStockCount(qtyAvailable.value, sellItemId.value);

          resetSales();

          fetchTransactions();

          // stop loader
          CFullScreenLoader.stopLoading();
          isLoading.value = false;

          CPopupSnackBar.successSnackBar(
            title: 'success!',
            message: 'transaction successful!',
          );

          Get.back();
        }
      }
    } catch (e) {
      isLoading.value = false;
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap! error saving transaction details',
        message: e.toString(),
      );
      return;
    } finally {
      isLoading.value = false;
      // -- remove loader --
      CFullScreenLoader.stopLoading();
    }
  }

  /// -- fetch transactions from sqflite db --
  Future<List<CSoldItemsModel>> fetchTransactions() async {
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

      // stop loader
      isLoading.value = false;

      return txns;
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

  /// -- barcode scanner using flutter_barcode_scanner package --
  Future<void> scanItemForSale() async {
    try {
      String barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'cancel', true, ScanMode.BARCODE);

      sellItemScanResults.value = barcodeScanRes;

      // -- set inventory item details to fields --
      fetchForSaleItemByCode(sellItemScanResults.value);
      if (itemExists.value) {
        Get.toNamed(
          '/sales/sell_item/',
        );
      } else {
        CPopupSnackBar.customToast(
            message: 'item not found! please scan again or search inventory');
        fetchTransactions();
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
        itemExists.value = true;
        sellItemId.value = fetchedItem.first.productId!;
        saleItemCode.value = fetchedItem.first.pCode;
        saleItemName.value = fetchedItem.first.name;
        saleItemBp.value = fetchedItem.first.buyingPrice;
        saleItemUsp.value = fetchedItem.first.unitSellingPrice;

        qtyAvailable.value = fetchedItem.first.quantity;
      } else {
        itemExists.value = false;
        txtSaleItemQty.text = '';
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

  onSearchTransactions(String value) {
    foundTxns.value = transactions
        .where((txn) =>
            txn.productName.toLowerCase().contains(value.toLowerCase()))
        .toList();
  }

  /// -- when search result item is selected --
  onSellItemBtnAction(CInventoryModel foundItem) {
    setTransactionDetails(foundItem);
    Get.toNamed(
      '/sales/sell_item/',
    );
  }

  /// -- calculate totals --
  computeTotals(String value, double usp) {
    if (value.isNotEmpty) {
      totalAmount.value = int.parse(value) * usp;

      // if (int.parse(value) > qtyAvailable.value) {
      //   stockUnavailableErrorMsg.value = 'insufficient stock!!';
      // } else {
      //   stockUnavailableErrorMsg.value = '';
      // }
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

  /// -- set text to form fields --
  setPaymentMethod(String value) {
    selectedPaymentMethod.value = value;
    if (selectedPaymentMethod.value == 'Cash') {
      showAmountIssuedField.value = true;
    } else {
      showAmountIssuedField.value = false;
    }
  }

  /// -- set sale details --
  setTransactionDetails(CInventoryModel foundItem) {
    sellItemId.value = foundItem.productId!;
    saleItemCode.value = foundItem.pCode;
    saleItemName.value = foundItem.name;
    saleItemBp.value = foundItem.buyingPrice;
    saleItemUsp.value = foundItem.unitSellingPrice;
    qtyAvailable.value = foundItem.quantity;
  }

  /// -- reset sales --
  resetSales() {
    sellItemScanResults.value = '';
    selectedPaymentMethod.value = 'Cash';
    itemExists.value = false;
    //showAmountIssuedField.value = false;
    isLoading.value = false;
    txtSaleItemQty.text = '';
    txtAmountIssued.text = '';
    saleItemName.value = '';
    saleItemCode.value = '';
    qtyAvailable.value = 0;
    saleItemBp.value = 0.0;
    saleItemUsp.value = 0.0;
    totalAmount.value = 0.0;
    customerBal.value = 0.0;
  }
}
