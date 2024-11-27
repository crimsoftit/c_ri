import 'package:c_ri/features/personalization/controllers/location_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CLocationSettings extends StatelessWidget {
  const CLocationSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final locationController = Get.put(CLocationController());

    return Scaffold(
      key
      appBar: AppBar(
        backgroundColor: CColors.rBrown.withOpacity(0.4),
        title: const Text('Location Settings'),
      ),
      body: Obx(
        () {
          if (locationController.isLoading.value) {
            return CircularProgressIndicator.adaptive();
          }
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    locationController.userCountry.value,
                  ),
                  Text(
                    locationController.permissionStatus.value,
                  ),
                  !locationController.locationServicesEnabled.value
                      ? ElevatedButton(
                          onPressed: locationController.openLocationSettings,
                          child: const Text(
                            'open location settings',
                          ),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
