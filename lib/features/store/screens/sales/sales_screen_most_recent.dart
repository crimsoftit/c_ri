import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/search_bar/animated_search_bar.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SalesScreenMostRecent extends StatelessWidget {
  const SalesScreenMostRecent({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final searchController = Get.put(CSearchBarController());

    return Scaffold(
      /// -- body --
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  /// -- app bar --
                  Obx(
                    () {
                      return CAppBar(
                        leadingWidget: searchController
                                .salesShowSearchField.value
                            ? null
                            : Padding(
                                padding:
                                    const EdgeInsets.only(top: 8.0, left: 10.0),
                                child: Row(
                                  children: [
                                    Text(
                                      'transactions',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge!
                                          .apply(
                                            color: CColors.white,
                                          ),
                                    ),
                                    const SizedBox(
                                      width: CSizes.spaceBtnSections,
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(
                                        Iconsax.scan,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        horizontalPadding: 1.0,
                        showBackArrow: false,
                        backIconColor:
                            isDarkTheme ? CColors.white : CColors.rBrown,
                        title: CAnimatedSearchBar(
                          hintTxt: 'inventory, transactions',
                          boxColor: searchController.salesShowSearchField.value
                              ? CColors.white
                              : Colors.transparent,
                          controller: searchController.txtSalesSearch,
                        ),
                        backIconAction: () {
                          // Navigator.pop(context, true);
                          // Get.back();
                        },
                      );
                    },
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
