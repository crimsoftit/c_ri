import 'package:c_ri/common/widgets/success_screen/success_screen.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/models/cart_item_model.dart';
import 'package:c_ri/features/store/models/payment_method_model.dart';
import 'package:c_ri/features/store/models/txns_model.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/payment_methods/payment_methods_tile.dart';
import 'package:c_ri/nav_menu.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/popups/full_screen_loader.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CCheckoutController extends GetxController {
  static CCheckoutController get instance => Get.find();

  @override
  void onInit() {
    selectedPaymentMethod.value = CPaymentMethodModel(
      platformLogo: CImages.cash3,
      platformName: 'cash',
    );
    super.onInit();
  }

  /// -- variables --
  final Rx<CPaymentMethodModel> selectedPaymentMethod =
      CPaymentMethodModel.empty().obs;

  RxList<CCartItemModel> itemsInCart = <CCartItemModel>[].obs;

  final cartController = Get.put(CCartController());
  final navController = Get.put(NavMenuController());
  final userController = Get.put(CUserController());

  DbHelper dbHelper = DbHelper.instance;

  /// -- process txn --
  void processTxn() async {
    try {
      // -- start loader --
      CFullScreenLoader.openLoadingDialog(
        'processing txn...',
        CImages.pencilAnimation,
      );

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
            'cartItem.pCode',
            cartItem.pName,
            cartItem.quantity,
            cartController.txnTotals.value,
            1000,
            cartItem.price,
            selectedPaymentMethod.value.platformName,
            '',
            '',
            '',
            '',
            '',
            0,
            'append',
            'complete',
          );

          // save txn data into the db
          await dbHelper.addSoldItem(newTxnData);

          // update cart items
          cartController.clearCart();
          Get.off(
            () {
              return CSuccessScreen(
                title: 'txn success',
                subTitle: 'transaction successful',
                image: CImages.paymentSuccessfulAnimation,
                onPressed: () {
                  navController.selectedIndex.value = 2;
                  Get.offAll(() => NavMenu());
                },
              );
            },
          );
        }
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
