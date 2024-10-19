import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final searchController = Get.put(CSearchBarController());

    invController.fetchInventoryItems();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
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
                      horizontalPadding: 10.0,
                      showBackArrow: false,
                      backIconAction: () {},
                    ),
                  ),

                  // const SizedBox(
                  //   width: CSizes.spaceBtnSections * 2,
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(
                      CSizes.defaultSpace / 2,
                    ),
                    child: TypeAheadField<CInventoryModel>(
                      builder: (context, controller, focusNode) {
                        return TextField(
                          controller: controller,
                          focusNode: focusNode,
                          autofocus: false,
                          style: const TextStyle(
                            color: CColors.white,
                          ),
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'search inventory, sold items',
                              hintText: 'search inventory, sold items'),
                        );
                      },
                      suggestionsCallback: (pattern) {
                        //invController.fetchInventoryItems();

                        var matches = invController.inventoryItems;

                        return matches
                            .where((item) => item.name
                                .toLowerCase()
                                .contains(pattern.toLowerCase()))
                            .toList();
                      },
                      itemBuilder: (context, suggestion) {
                        //invController.fetchInventoryItems();
                        return ListTile(
                          title: Text(suggestion.name),
                        );
                      },
                      onSelected: (suggestion) {
                        // Handle when a suggestion is selected.
                        searchController.txtTypeAheadFieldController.text =
                            suggestion.name;
                        //print('Selected item: ${suggestion.name}');
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
