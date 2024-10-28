import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';

class CTypeAheadSearchField extends StatelessWidget {
  const CTypeAheadSearchField({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final searchController = Get.put(CSearchBarController());

    return TypeAheadField<CInventoryModel>(
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
            //hintText: 'search inventory, sold items',
          ),
        );
      },
      suggestionsCallback: (pattern) {
        //invController.fetchInventoryItems();

        var matches = invController.inventoryItems;

        return matches
            .where((item) =>
                item.name.toLowerCase().contains(pattern.toLowerCase()))
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
        searchController.txtTypeAheadFieldController.text = suggestion.name;
        //print('Selected item: ${suggestion.name}');
      },
    );
  }
}
