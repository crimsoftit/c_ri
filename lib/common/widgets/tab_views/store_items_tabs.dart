import 'package:c_ri/common/widgets/layouts/items_listview.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CStoreItemsTabs extends StatelessWidget {
  const CStoreItemsTabs({
    super.key,
    required this.tab1Title,
    required this.tab2Title,
  });

  final String tab1Title, tab2Title;

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());

    return Column(
      children: [
        SizedBox(
          child: TabBar(
            tabs: [
              Tab(
                text: tab1Title,
              ),
              Tab(
                text: tab2Title,
              ),
            ],
          ),
        ),

        /// -- tab bar views
        SizedBox(
          height: CHelperFunctions.screenHeight() * 0.7,
          child: const TabBarView(
            physics: BouncingScrollPhysics(),
            children: [
              /// -- inventory list items --
              CItemsListView(
                space: 'inventory',
              ),

              /// -- transactions list view --
              CItemsListView(
                space: 'sales',
              ),
            ],
          ),
        ),
      ],
    );
  }
}
