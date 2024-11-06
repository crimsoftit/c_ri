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

        if (searchController.txtSalesSearch.text.isNotEmpty &&
            salesController.foundTxns.isEmpty &&
            space == 'sales') {
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
            var id = space == 'inventory'
                ? '#${invController.foundInventoryItems[index].productId}'
                : 'txn id: #${salesController.foundTxns[index].saleId}';

            var pCode = space == 'inventory'
                ? invController.foundInventoryItems[index].pCode
                : salesController.foundTxns[index].productCode;

            var amount = space == 'inventory'
                ? 'bp: Ksh.${invController.foundInventoryItems[index].buyingPrice}'
                : 't.Amount: Ksh.${salesController.foundTxns[index].totalAmount}';

            var qty = space == 'inventory'
                ? '(${invController.foundInventoryItems[index].quantity} stocked)'
                : 'qty: ${salesController.foundTxns[index].quantity}';

            var date = space == 'inventory'
                ? invController.foundInventoryItems[index].date
                : salesController.foundTxns[index].date;

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
                    space == 'inventory'
                        ? invController.foundInventoryItems[index].name[0]
                            .toUpperCase()
                        : salesController.foundTxns[index].productName[0]
                            .toUpperCase(),
                    style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: CColors.white,
                        ),
                  ),
                ),
                title: Text(
                  space == 'inventory'
                      ? '${invController.foundInventoryItems[index].name.toUpperCase()}($id)'
                      : '${salesController.foundTxns[index].productName.toUpperCase()} ($id)',
                  style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: CColors.rBrown,
                      ),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'pCode: $pCode    $amount   $qty',
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: CColors.rBrown.withOpacity(0.8),
                            //fontStyle: FontStyle.italic,
                          ),
                    ),
                    Text(
                      space == 'inventory'
                          ? 'unit selling price: ${invController.foundInventoryItems[index].unitSellingPrice}   modified: $date'
                          : 'payment method: ${salesController.foundTxns[index].paymentMethod}  modified: $date',
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                            color: CColors.rBrown.withOpacity(0.8),
                            //fontStyle: FontStyle.italic,
                          ),
                    ),
                    Text(
                      'modified: $date',
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