import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class OtherScreensAppBar extends StatelessWidget {
  const OtherScreensAppBar({
    super.key,
    required this.showScanner,
    required this.title,
    required this.trailingIconLeftPadding,
  });

  final bool showScanner;
  final String title;
  final double trailingIconLeftPadding;

  @override
  Widget build(BuildContext context) {
    final salesController = Get.put(CSalesController());

    return CPrimaryHeaderContainer(
      child: Column(
        children: [
          const SizedBox(
            height: CSizes.spaceBtnSections,
          ),

          // -- ## APP BAR ## --
          Padding(
            padding: const EdgeInsets.all(
              CSizes.defaultSpace / 2,
            ),
            child: Row(
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge!.apply(
                        color: CColors.white,
                      ),
                ),
                const SizedBox(
                  width: CSizes.spaceBtnSections,
                ),
                showScanner
                    ? IconButton(
                        onPressed: () {
                          salesController.scanItemForSale();
                          CPopupSnackBar.customToast(
                              message:
                                  salesController.sellItemScanResults.value);
                          Get.toNamed(
                            '/sales/sell_item/',
                          );
                        },
                        icon: const Icon(
                          Iconsax.scan,
                          color: CColors.white,
                        ),
                      )
                    : const SizedBox(),
                const SizedBox(
                  width: CSizes.spaceBtnSections,
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: trailingIconLeftPadding,
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Iconsax.notification,
                      color: CColors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: CSizes.spaceBtnSections / 2,
          ),
        ],
      ),
    );
  }
}
