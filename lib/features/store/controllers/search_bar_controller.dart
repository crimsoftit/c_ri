import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CSearchBarController extends GetxController {
  static CSearchBarController get instance {
    return Get.find();
  }

  /// -- variables --
  RxBool invShowSearchField = false.obs;
  RxBool salesShowSearchField = false.obs;

  final txtInvSearchField = TextEditingController();
  final txtSalesSearch = TextEditingController();
  final txtTypeAheadFieldController = TextEditingController();

  //final invController = Get.put(CInventoryController());

  @override
  void onInit() {
    invShowSearchField.value = false;
    salesShowSearchField.value = false;
    txtInvSearchField.text = '';
    txtSalesSearch.text = '';
    super.onInit();
  }

  onSearchBtnPressed(String searchSpace) {
    if (searchSpace == 'inventory') {
      invShowSearchField.value = !invShowSearchField.value;
    } else if (searchSpace == 'inventory, transactions') {
      salesShowSearchField.value = !salesShowSearchField.value;
    }
  }

  onCloseIconTap(String searchSpace) {
    if (searchSpace == 'inventory') {
      txtInvSearchField.text = '';
      invShowSearchField.value = !invShowSearchField.value;
    } else if (searchSpace == 'inventory, transactions') {
      txtSalesSearch.text = '';
      salesShowSearchField.value = !salesShowSearchField.value;
    }

    //invShowSearchField.value = !invShowSearchField.value;
  }
}
