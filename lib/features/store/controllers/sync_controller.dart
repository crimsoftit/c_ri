import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/controllers/txns_controller.dart';
import 'package:get/get.dart';

class CSyncController extends GetxController {
  static CSyncController get instance => Get.find();

  /// -- variables --
  final txnsController = Get.put(CTxnsController());
  final invController = Get.put(CInventoryController());

  void processSync() async {
    await invController.cloudSyncInventory();
    await invController.cloudSyncInventory();
    await txnsController.addSalesDataToCloud();
    //await txnsController.addSalesDataToCloud();
  }
}
