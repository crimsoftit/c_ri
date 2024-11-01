import 'dart:async';
import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
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

  final RxString sellItemScanResults = ''.obs;
  final RxString selectedPaymentMethod = 'Cash'.obs;

  final RxBool itemExists = false.obs;
  final RxBool showAmountIssuedField = false.obs;
  final isLoading = false.obs;

  final txtSaleItemQty = TextEditingController();
  final txtSaleItemBp = TextEditingController();
  final txtSaleItemUsp = TextEditingController();
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

  final txnsFormKey = GlobalKey<FormState>();

  /// -- add sale transactions data to sqflite db --
  saveTransaction() {
    try {
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
          selectedPaymentMethod.value,
          DateFormat('yyyy-MM-dd - kk:mm').format(clock.now()),
        );

        // soldItem.userId = userController.user.value.id;
        // soldItem.userEmail = userController.user.value.email;
        // soldItem.userName = userController.user.value.fullName;

        // soldItem.productId = sellItemId.value;
        // soldItem.productCode = saleItemCode.value;
        // soldItem.productName = saleItemName.value;
        // soldItem.quantity = int.parse(txtSaleItemQty.text);
        // soldItem.totalAmount = totalAmount.value;
        // soldItem.paymentMethod = selectedPaymentMethod.value;
        // soldItem.date = DateFormat('yyyy-MM-dd - kk:mm').format(clock.now());

        // save txn data into the db
        dbHelper.addSoldItem(newTxn);

        // stop loader
        CFullScreenLoader.stopLoading();
        isLoading.value = false;

        CPopupSnackBar.successSnackBar(
            title: 'success!', message: 'transaction successful!');
      }
    } catch (e) {
      isLoading.value = false;
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap! error saving transaction details',
        message: e.toString(),
      );
    } finally {
      isLoading.value = false;
      // -- remove loader --
      CFullScreenLoader.stopLoading();
      return;
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

      // stop loader
      isLoading.value = false;

      return txns;
    } catch (e) {
      isLoading.value = false;
      return CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
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
        txtSaleItemBp.text = (fetchedItem.first.buyingPrice).toString();
        txtSaleItemUsp.text = (fetchedItem.first.unitSellingPrice).toString();
      } else {
        itemExists.value = false;
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

  /// -- when search result item is selected --
  onSellItemBtnAction(CInventoryModel foundItem) {
    sellItemId.value = foundItem.productId!;
    saleItemCode.value = foundItem.pCode;
    saleItemName.value = foundItem.name;
    saleItemBp.value = foundItem.buyingPrice;
    saleItemUsp.value = foundItem.unitSellingPrice;
    qtyAvailable.value = foundItem.quantity;

    Get.toNamed(
      '/sales/sell_item/',
    );
  }

  /// -- calculate totals --
  computeTotals(String value, double usp) {
    if (value.isNotEmpty) {
      totalAmount.value = int.parse(value) * usp;
    } else {
      totalAmount.value = 0.0;
    }
  }

  /// -- calculate totals --
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

  /// -- reset sales --
  resetSales() {
    isLoading.value = false;
    selectedPaymentMethod.value = 'Cash';
    sellItemScanResults.value = '';
    itemExists.value = false;
    txtAmountIssued.text = '';
    txtSaleItemQty.text = '';
    txtSaleItemBp.text = '';
    txtSaleItemUsp.text = '';
    showAmountIssuedField.value = false;
  }
}
