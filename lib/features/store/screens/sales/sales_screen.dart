import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            CPrimaryHeaderContainer(
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
                          'sales',
                          style: Theme.of(context).textTheme.bodyLarge!.apply(
                                color: CColors.white,
                              ),
                        ),
                        const SizedBox(
                          width: CSizes.spaceBtnSections,
                        ),
                        IconButton(
                          onPressed: () {
                            Get.toNamed(
                              '/sales/sell_item/',
                            );
                          },
                          icon: const Icon(
                            Iconsax.scan,
                            color: CColors.white,
                          ),
                        ),
                        const SizedBox(
                          width: CSizes.spaceBtnSections,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            left: CHelperFunctions.screenWidth() * 0.42,
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
