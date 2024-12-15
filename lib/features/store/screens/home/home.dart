import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/screens/home/widgets/home_appbar.dart';
import 'package:c_ri/features/store/screens/inventory/dels.dart';
import 'package:c_ri/features/store/screens/inventory/gsheets_inv_table_screen.dart';
import 'package:c_ri/features/store/screens/search/search_results.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/constants/txt_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

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
                    actionsSection: IconButton(
                      onPressed: () {
                        Get.to(
                          () {
                            return const CSearchResultsScreen();
                          },
                        );
                      },
                      icon: const Icon(
                        Iconsax.search_normal,
                        color: CColors.white,
                        size: CSizes.iconMd,
                      ),
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
                        // -- category heading --
                        CSectionHeading(
                          showActionBtn: true,
                          title: 'popular categories',
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
                        CSectionHeading(
                          showActionBtn: true,
                          title: 'dels',
                          txtColor: CColors.white,
                          btnTitle: 'view all',
                          btnTxtColor: CColors.grey,
                          editFontSize: true,
                          onPressed: () {
                            Get.to(() => const CDels());
                          },
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
          ],
        ),
      ),
    );
  }
}
