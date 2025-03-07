import 'package:c_ri/common/widgets/success_screen/success_screen.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/models/cart_item_model.dart';
import 'package:c_ri/features/store/models/payment_method_model.dart';
import 'package:c_ri/features/store/models/txns_model.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/payment_methods/payment_methods_tile.dart';
import 'package:c_ri/nav_menu.dart';
import 'package:c_ri/services/pdf_services.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/popups/full_screen_loader.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CCheckoutController extends GetxController {
  static CCheckoutController get instance => Get.find();

  @override
  void onInit() async {
    await dbHelper.openDb();
    selectedPaymentMethod.value = CPaymentMethodModel(
      platformLogo: CImages.cash6,
      platformName: 'cash',
    );
    amtIssuedFieldController.text = '';
    setFocusOnAmtIssuedField.value = false;
    //txnsController.importTxnsFromCloud();

    super.onInit();
  }

  /// -- variables --
  final Rx<CPaymentMethodModel> selectedPaymentMethod =
      CPaymentMethodModel.empty().obs;

  final pdfServices = CPdfServices.instance;

  RxList<CCartItemModel> itemsInCart = <CCartItemModel>[].obs;

  //final RxInt itemStockCount = 0.obs;
  //final RxInt totalInvSales = 0.obs;

  final RxBool setFocusOnAmtIssuedField = false.obs;

  final cartController = Get.put(CCartController());
  final navController = Get.put(NavMenuController());
  final txnsController = Get.put(CTxnsController());
  final userController = Get.put(CUserController());

  final TextEditingController amtIssuedFieldController =
      TextEditingController();

  DbHelper dbHelper = DbHelper.instance;

  /// -- process txn --
  void processTxn() async {
    try {
      // -- start loader --
      CFullScreenLoader.openLoadingDialog(
        'processing txn...',
        CImages.docerAnimation,
      );

      txnsController.fetchTransactions();

      // -- fetch cart content --
      cartController.fetchCartItems();

      // -- txn details --

      if (cartController.cartItems.isNotEmpty) {
        for (var item in cartController.cartItems) {
          itemsInCart.add(item);
        }
      }

      final txnId = CHelperFunctions.generateId();

      if (itemsInCart.isNotEmpty) {
        for (var cartItem in itemsInCart) {
          var newTxnData = CTxnsModel(
            txnId,
            userController.user.value.id,
            userController.user.value.email,
            userController.user.value.fullName,
            cartItem.productId,
            cartItem.pCode,
            cartItem.pName,
            cartItem.quantity,
            cartController.txnTotals.value,
            selectedPaymentMethod.value.platformName == 'cash'
                ? double.parse(amtIssuedFieldController.text.trim())
                : 0.00,
            cartItem.price,
            selectedPaymentMethod.value.platformName,
            '',
            '',
            '',
            '',
            DateFormat('yyyy-MM-dd - kk:mm').format(clock.now()),
            0,
            'append',
            'complete',
          );

          // save txn data into the db
          await dbHelper.addSoldItem(newTxnData).then((result) {
            if (dbHelper.saleItemAddedToDb.value) {
              result = 'item added';

              // -- update stock count & total sales for this inventory item --
              final invController = Get.put(CInventoryController());
              invController.fetchInventoryItems();
              var invItem = invController.inventoryItems
                  .firstWhere((item) => item.productId == cartItem.productId);

              invItem.qtySold += cartItem.quantity;
              invItem.quantity -= cartItem.quantity;

              dbHelper.updateInventoryItem(invItem, cartItem.productId);

              if (kDebugMode) {
                CPopupSnackBar.successSnackBar(
                  title: 'inventory stock update',
                  message: 'inventory stock update successful',
                );
              }

              // -- update sync status/action for this inventory item --
              dbHelper.updateInvOfflineSyncAfterStockUpdate(
                  'update', cartItem.productId);
            } else {
              result = 'ERROR ADDING SALE ITEM';
            }
            CPopupSnackBar.customToast(
              message: result,
              forInternetConnectivityStatus: false,
            );
          });

          // itemStockCount.value -= cartItem.quantity;
          // totalInvSales.value += cartItem.quantity;

          // await dbHelper.updateStockCountAndSales(
          //     itemStockCount.value, totalInvSales.value, cartItem.productId);
        }

        Get.off(
          () {
            return CSuccessScreen(
              title: 'txn success',
              subTitle: 'transaction successful',
              image: CImages.paymentSuccessfulAnimation,
              // onGenerateRecieptBtnPressed: () async {
              //   final pdfData = await pdfServices.createHelloWorld();
              //   pdfServices.savePdfFile('receipt_1', pdfData);
              // },
              onGenerateRecieptBtnPressed: () async {
                final pdfData = await pdfServices.generateReceipt(itemsInCart);
                pdfServices.savePdfFile('receipt_1', pdfData);
              },
              onContinueBtnPressed: () {
                navController.selectedIndex.value = 2;

                // TODO: save receipts before clearing
                // clear cart
                cartController.clearCart();
                txnsController.fetchTransactions();

                Get.offAll(() => NavMenu());
              },
            );
          },
        );
      }
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error processing txn..',
        message: '$e',
      );
      throw e.toString();
    }
  }

  /// -- method to select payment method --
  Future<dynamic> selectPaymentMethod(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(
              CSizes.lg / 3,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CSectionHeading(
                  showActionBtn: false,
                  title: 'select payment method...',
                  btnTitle: '',
                  editFontSize: true,
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections / 4,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.cash6,
                    platformName: 'cash',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections / 4,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.mPesaLogo,
                    platformName: 'mPesa',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections / 4,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.googlePayLogo,
                    platformName: 'google pay',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections / 4,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.paypalLogo,
                    platformName: 'paypal',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections / 4,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.masterCardLogo,
                    platformName: 'master card',
                  ),
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections / 4,
                ),
                CPaymentMethodsTile(
                  paymentMethod: CPaymentMethodModel(
                    platformLogo: CImages.visaLogo,
                    platformName: 'visa',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
