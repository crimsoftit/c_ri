import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CSearchBarController extends GetxController {
  static CSearchBarController get instance {
    return Get.find();
  }

  /// -- variables --
  RxBool invShowSearchField = false.obs;
  RxBool salesShowSearchField = false.obs;
  RxBool showAnimatedTypeAheadField = false.obs;

  final txtInvSearchField = TextEditingController();
  final txtSalesSearch = TextEditingController();
  final txtTypeAheadFieldController = TextEditingController();

  final cartController = Get.put(CCartController());
  @override
  void onInit() {
    invShowSearchField.value = false;
    salesShowSearchField.value = false;
    showAnimatedTypeAheadField.value = false;
    txtInvSearchField.text = '';
    txtSalesSearch.text = '';
    super.onInit();
  }

  // onSearchBtnPressed(String searchSpace) {
  //   if (searchSpace == 'inventory') {
  //     invShowSearchField.value = !invShowSearchField.value;
  //   } else if (searchSpace == 'inventory, transactions') {
  //     salesShowSearchField.value = !salesShowSearchField.value;
  //   }
  // }

  onSearchIconTap(String searchSpace) {
    if (searchSpace == 'inventory') {
      txtInvSearchField.text = '';
      invShowSearchField.value = !invShowSearchField.value;
    } else if (searchSpace == 'inventory, transactions') {
      txtSalesSearch.text = '';
      salesShowSearchField.value = !salesShowSearchField.value;
    }

    //invShowSearchField.value = !invShowSearchField.value;
  }

  onTypeAheadSearchIconTap() {
    showAnimatedTypeAheadField.value = !showAnimatedTypeAheadField.value;
    cartController.itemQtyInCart.value = 0;
  }
}
