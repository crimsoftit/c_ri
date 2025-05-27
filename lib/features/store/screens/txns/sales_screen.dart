import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CSalesScreen extends StatelessWidget {
  const CSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final txnsController = Get.put(CTxnsController());

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CColors.white,
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  left: 20.0,
                  top: 70.0,
                ),
                child: Column(
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
                      height: 30.0,
                    ),
                    Container(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Sales',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    Column(
                      children: [
                        SizedBox(
                          child: TabBar(
                            tabs: [
                              Tab(
                                text: 'all',
                              ),
                              Tab(
                                text: 'refunds',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: CHelperFunctions.screenHeight() * 0.7,
                          child: TabBarView(
                            children: [
                              ListView.builder(
                                padding: const EdgeInsets.all(2.0),
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: txnsController.sales.length,
                                itemBuilder: (context, index) {
                                  return Card(
                                    color: CColors.lightGrey,
                                    elevation: 0.3,
                                    child: ListTile(
                                      horizontalTitleGap: 10,
                                      contentPadding: const EdgeInsets.all(
                                        5.0,
                                      ),
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.brown[300],
                                        radius: 16.0,
                                        child: Text(
                                          txnsController
                                              .sales[index].productName[0]
                                              .toUpperCase(),
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelLarge!
                                              .apply(
                                                color: CColors.white,
                                              ),
                                        ),
                                      ),
                                      title: Text(
                                        '${txnsController.sales[index].productName.toUpperCase()} ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium!
                                            .apply(
                                              color: CColors.rBrown,
                                            ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              Text(
                                'nucho',
                              ),
                            ],
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
