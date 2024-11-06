import 'package:c_ri/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/sales_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/screens/search/widgets/no_results_screen.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CItemsListView extends StatelessWidget {
  const CItemsListView({
    super.key,
    required this.space,
  });

  final String space;

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final salesController = Get.put(CSalesController());

    final searchController = Get.put(CSearchBarController());

    return Obx(
      () {
        // run loader --
        if (invController.isLoading.value) {
          return const CVerticalProductShimmer(
            itemCount: 7,
          );
        }

        //invController.fetchInventoryItems();

        if (searchController.txtSalesSearch.text.isNotEmpty &&
            invController.foundInventoryItems.isEmpty &&
            space == 'inventory') {
          return const NoSearchResultsScreen();
        }

        return ListView.builder(
          padding: const EdgeInsets.all(2.0),
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: space == 'inventory'
              ? invController.foundInventoryItems.length
              : salesController.foundTxns.length,
          itemBuilder: (context, index) {
            return Card(
              color: CColors.white,
              elevation: 0.3,
              child: ListTile(
                horizontalTitleGap: 10,
                contentPadding: const EdgeInsets.all(
                  10.0,
                ),
                leading: CircleAvatar(
                  backgroundColor: Colors.brown[300],
                  radius: 16.0,
                  child: Text(
                    'P',
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: CColors.white,
                        ),
                  ),
                ),
                title: Text(
                  space == 'inventory'
                      ? invController.foundInventoryItems[index].name
                      : salesController.foundTxns[index].productName,
                  style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: CColors.rBrown,
                      ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'pCode:  t.Amount: Ksh. ',
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: CColors.rBrown.withOpacity(0.8),
                            //fontStyle: FontStyle.italic,
                          ),
                    ),
                    Text(
                      'payment method:   qty:   ',
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: CColors.rBrown.withOpacity(0.8),
                            //fontStyle: FontStyle.italic,
                          ),
                    ),
                    Text(
                      'modified: date here',
                      style: Theme.of(context).textTheme.labelSmall!.apply(
                            color: CColors.rBrown.withOpacity(0.7),
                            //fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
