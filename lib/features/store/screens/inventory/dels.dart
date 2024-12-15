import 'package:c_ri/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CDels extends StatelessWidget {
  const CDels({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    invController.fetchInvDels();
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(
            () {
              // -- no data widget --
              if (invController.dItems.isEmpty) {
                return const Center(
                  child: NoDataScreen(
                    lottieImage: CImages.noDataLottie,
                    txt: 'No data found!',
                  ),
                );
              }

              invController.fetchInvDels();
              return SizedBox(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: invController.dItems.length,
                  itemBuilder: (context, index) {
                    return Card(
                      color: CColors.lightGrey,
                      elevation: 1,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: CColors.rBrown[300],
                          radius: 16,
                          child: Text(
                            invController.dItems[index].itemName[0],
                          ),
                        ),
                        title: Text(
                          invController.dItems[index].itemName,
                        ),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              invController.dItems[index].category,
                            ),
                            Text(
                              invController.dItems[index].itemId.toString(),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
