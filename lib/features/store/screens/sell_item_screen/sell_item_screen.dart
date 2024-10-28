import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CSellItemScreen extends StatelessWidget {
  const CSellItemScreen({super.key});

  //var sellItemId = Get.arguments;

  @override
  Widget build(BuildContext context) {
    final salesController = Get.put(CSalesController());

    return Obx(
      () {
        return Center(
          child: Text(
            'sell item code: ${salesController.sellItemScanResults.value}',
          ),
        );
      },
    );
  }
}
