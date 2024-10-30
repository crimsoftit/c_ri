import 'package:c_ri/common/widgets/appbar/other_screens_app_bar.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/screens/search/widgets/c_typeahead_field.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    //final salesController = Get.put(CSalesController());

    invController.fetchInventoryItems();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            OtherScreensAppBar(
              showScanner: true,
              title: 'transactions',
              trailingIconLeftPadding: CHelperFunctions.screenWidth() * 0.2,
              showBackActionIcon: false,
            ),

            /// -- typeahead search field --
            const Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
              ),
              child: CTypeAheadSearchField(),
            ),
          ],
        ),
      ),
    );
  }
}
