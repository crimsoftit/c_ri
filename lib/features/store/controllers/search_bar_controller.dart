import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CSearchBarController extends GetxController {
  static CSearchBarController get instance {
    return Get.find();
  }

  /// -- variables --
  RxBool showSearchField = false.obs;

  final txtSearchField = TextEditingController();
  final txtTypeAheadFieldController = TextEditingController();

  //final invController = Get.put(CInventoryController());

  @override
  void onInit() {
    showSearchField.value = false;
    //invController.fetchInventoryItems();
    super.onInit();
  }

  onSearchBtnPressed() {
    showSearchField.value = !showSearchField.value;
  }

  onCloseIconTap() {
    txtSearchField.text = '';
    showSearchField.value = !showSearchField.value;
  }
}
