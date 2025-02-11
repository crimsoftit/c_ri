import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/products/cart/cart_counter_icon.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/screens/home/widgets/home_appbar.dart';
import 'package:c_ri/features/store/screens/inventory/gsheets_inv_table_screen.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/constants/txt_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  // -- ## HOME PAGE APP BAR ## --
                  CHomeAppBarWidget(
                    appBarTitle: CTexts.homeAppbarTitle,
                    actionsSection: CCartCounterIcon(
                      iconColor: Colors.white,
                    ),
                    screenTitle: '',
                    isHomeScreen: true,
                  ),

                  // -- ## ALL ABOUT CATEGORIES ## --
                  Padding(
                    padding: const EdgeInsets.only(
                      left: CSizes.defaultSpace,
                    ),
                    child: Column(
                      children: [
                        // -- top sellers category heading --
                        CSectionHeading(
                          showActionBtn: true,
                          title: 'top sellers...',
                          txtColor: CColors.white,
                          btnTitle: 'gsheet inventory data',
                          btnTxtColor: CColors.grey,
                          editFontSize: true,
                          onPressed: () {
                            Get.to(() => const GsheetsInvScreen());
                          },
                        ),
                        const SizedBox(
                          height: CSizes.spaceBtnItems,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnSections,
                  ),
                ],
              ),
            ),

            // CSectionHeading(
            //   showActionBtn: true,
            //   title: 'popular categories',
            //   txtColor: CColors.white,
            //   btnTitle: 'gsheet txns data',
            //   btnTxtColor: CColors.grey,
            //   editFontSize: true,
            //   onPressed: () {
            //     Get.to(() => const GsheetsTxnsScreen());
            //   },
            // ),
            // const SizedBox(
            //   height: CSizes.spaceBtnItems,
            // ),
            // CSectionHeading(
            //   showActionBtn: true,
            //   title: 'dels',
            //   txtColor: CColors.white,
            //   btnTitle: 'view all',
            //   btnTxtColor: CColors.grey,
            //   editFontSize: true,
            //   onPressed: () {
            //     Get.to(() => const CDels());
            //   },
            // ),
            // const SizedBox(
            //   height: CSizes.spaceBtnItems,
            // ),
            // CSectionHeading(
            //   showActionBtn: true,
            //   title: 'pending updates',
            //   txtColor: CColors.white,
            //   btnTitle: 'view all',
            //   btnTxtColor: CColors.grey,
            //   editFontSize: true,
            //   onPressed: () {
            //     Get.to(() => const InvForUpdates());
            //   },
            // ),
            // const SizedBox(
            //   height: CSizes.spaceBtnItems,
            // ),
            // CSectionHeading(
            //   showActionBtn: true,
            //   title: 'pending txns',
            //   txtColor: CColors.white,
            //   btnTitle: 'view all',
            //   btnTxtColor: CColors.grey,
            //   editFontSize: true,
            //   onPressed: () {
            //     Get.to(() => const TxnsForAppends());
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
