import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:get/get.dart';

class CGeneralBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(CNetworkManager());
  }
}
