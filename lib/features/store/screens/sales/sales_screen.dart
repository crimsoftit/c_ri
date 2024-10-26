import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/screens/search/search_results.dart';
import 'package:c_ri/features/store/screens/search/widgets/c_typeahead_field.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    //final searchController = Get.put(CSearchBarController());

    invController.fetchInventoryItems();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Obx(
          () {
            if (invController.isLoading.value) {
              return const Center(
                child: Text(
                  'loading...',
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              );
            }

            invController.fetchInventoryItems();

            return SingleChildScrollView(
              child: Column(
                children: [
                  // -- header section --
                  CPrimaryHeaderContainer(
                    height: CHelperFunctions.screenHeight() * 0.13,
                    // -- app bar
                    child: CAppBar(
                      leadingWidget: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        //mainAxisSize: MainAxisSize.max,
                        children: [
                          Row(
                            children: [
                              Text(
                                'sales',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
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

                          // const SizedBox(
                          //   height: CSizes.spaceBtnSections,
                          // ),
                        ],
                      ),
                      title: IconButton(
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
                        ),
                      ),
                      horizontalPadding: 10.0,
                      showBackArrow: false,
                      backIconAction: () {},
                    ),
                  ),

                  /// -- typeahead search field --
                  const CTypeAheadSearchField(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
