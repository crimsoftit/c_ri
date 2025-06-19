import 'package:c_ri/features/store/controllers/checkout_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCheckoutScanFAB extends StatelessWidget {
  const CCheckoutScanFAB({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CCheckoutController());
    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return FloatingActionButton(
      //elevation: 0, // -- removes shadow
      onPressed: () {
        checkoutController.scanItemForCheckout();
      },
      backgroundColor: isConnectedToInternet ? CColors.rBrown : CColors.black,
      //backgroundColor: CColors.transparent,
      foregroundColor: CColors.white,

      child: const Icon(
        // Iconsax.scan_barcode,
        Iconsax.scan,
      ),
    );
  }
}
