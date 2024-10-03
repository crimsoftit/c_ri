import 'package:get/get.dart';

class CSearchBarController extends GetxController {
  static CSearchBarController get instance {
    return Get.find();
  }

  /// -- variables --
  RxBool showSearchField = false.obs;

  @override
  void onInit() {
    showSearchField.value = false;
    super.onInit();
  }

  onSearchBtnPressed() {
    showSearchField.value = !showSearchField.value;
  }

  onCloseIconTap() {
    showSearchField.value = !showSearchField.value;
  }
}
