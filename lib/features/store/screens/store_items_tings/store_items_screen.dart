import 'package:c_ri/common/widgets/tab_views/store_items_tabs.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/features/store/screens/inventory/widgets/inv_dialog.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CStoreItemsScreen extends StatelessWidget {
  const CStoreItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final txnsController = Get.put(CTxnsController());

    txnsController.fetchTxns();
    AddUpdateItemDialog dialog = AddUpdateItemDialog();

    invController.fetchUserInventoryItems();

    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 15.0,
                  top: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.menu,
                          size: 30.0,
                          color: CColors.rBrown,
                        ),
                        Expanded(
                          child: Container(),
                        ),
                        Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        'Store',
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                              color: CColors.rBrown,
                              fontSizeFactor: 2.5,
                              fontWeightDelta: -2,
                            ),
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: const CStoreItemsTabs(
                              tab1Title: 'inventory',
                              tab2Title: 'sales',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
