import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CPopupSnackBar {
  static hideSnackBar() {
    ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
  }

  static customToast({required message}) {
    final isDarkTheme = CHelperFunctions.isDarkMode(Get.context!);

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 5),
        backgroundColor: Colors.transparent,
        content: Container(
          padding: const EdgeInsets.all(
            12.0,
          ),
          margin: const EdgeInsets.symmetric(
            horizontal: 30.0,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30.0),
            color: isDarkTheme
                ? CColors.darkGrey.withOpacity(0.9)
                : CColors.grey.withOpacity(0.9),
          ),
          child: Center(
            child: Text(
              message,
              style: Theme.of(Get.context!).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }

  static successSnackBar({
    required title,
    message = '',
    duration = 5,
  }) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: CColors.white,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10.0),
      icon: const Icon(
        Iconsax.check,
        color: CColors.white,
      ),
    );
  }

  static successSnackBar1({required title, message = '', duration = 5}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: CColors.white,
      backgroundColor: const Color.fromARGB(255, 235, 108, 108),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10.0),
      icon: const Icon(
        Iconsax.check,
        color: CColors.white,
      ),
    );
  }

  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      titleText: Text(
        title,
        style: Theme.of(Get.context!).textTheme.titleMedium!.apply(
              color: CColors.white,
            ),
      ),
      message,
      messageText: Text(
        message,
        style: Theme.of(Get.context!).textTheme.bodyMedium!.apply(
              color: CColors.white,
            ),
      ),
      isDismissible: true,
      shouldIconPulse: true,
      colorText: CColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 6),
      margin: const EdgeInsets.all(20.0),
      icon: const Icon(
        Iconsax.warning_2,
        color: CColors.white,
      ),
    );
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: CColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 5),
      margin: const EdgeInsets.all(20.0),
      icon: const Icon(
        Iconsax.warning_2,
        color: CColors.white,
      ),
    );
  }
}
