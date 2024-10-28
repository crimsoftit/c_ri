import 'package:c_ri/utils/db/sqflite/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CSalesController extends GetxController {
  static CSalesController get instance {
    return Get.find();
  }

  /// -- variables --
  DbHelper dbHelper = DbHelper.instance;
  final RxString sellItemResults = ''.obs;

  final RxBool sellItemExists = false.obs;
  final RxInt sellItemId = 0.obs;

  final txtSaleItemId = TextEditingController();
  final txtSaleItemName = TextEditingController();
  final txtSaleItemCode = TextEditingController();
  final txtSaleItemQty = TextEditingController();
}
