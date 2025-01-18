import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CNetworkManager extends GetxController {
  static CNetworkManager get instance => Get.find();

  /// -- variables --
  final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;
  // final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  final RxBool hasConnection = false.obs;
  final deviceStorage = GetStorage();

  /// -- initialize the network manager and set up a stream to continually check the connection status --
  @override
  void onInit() {
    super.onInit();
    _connectivitySubscription = InternetConnection().onStatusChange.listen(
      (event) {
        switch (event) {
          case InternetStatus.connected:
            hasConnection.value = true;

            if (deviceStorage.read('ShowOnlineStatusOnResume') == true) {
              CPopupSnackBar.customToast(
                forInternetConnectivityStatus: true,
                message: 'back online...',
              );
            }

            break;
          case InternetStatus.disconnected:
            hasConnection.value = false;
            CPopupSnackBar.customToast(
              forInternetConnectivityStatus: true,
              message: 'offline cruise...',
            );
            deviceStorage.writeIfNull('ShowOnlineStatusOnResume', true);

            break;
          // default:
          //   hasConnection.value = false;
          //   break;
        }
      },
    );
  }

  /// -- check internet connection status --
  Future<bool> isConnected() async {
    try {
      final result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.none) {
        return false;
      } else {
        return true;
      }
    } on PlatformException catch (_) {
      return false;
    }
  }

  // -- update the connection status and show relevant popup --
  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   _connectionStatus.value = result;
  //   if (result == ConnectivityResult.none) {
  //     CPopupSnackBar.customToast(
  //       message: 'please check your internet connection...',
  //     );
  //     // CPopupSnackBar.warningSnackBar(
  //     //   title: 'check your internet connection',
  //     // );
  //   }
  // }

  // -- dispose or close the active connectivity stream

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription!.cancel();
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription!.cancel();
  }
}
