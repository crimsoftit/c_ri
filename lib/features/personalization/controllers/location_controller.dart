import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class CLocationController extends GetxController {
  static CLocationController get instance => Get.find();

  // -- initialize user data when home screen loads --
  @override
  void onInit() {
    getCurrentPosition();
    super.onInit();
  }

  Notification callback when permission has changed

  /// -- variables --
  final RxString currentAddress = ''.obs;
  final RxString userCountry = ''.obs;
  final RxString permissionStatus = ''.obs;
  final RxBool locationServicesEnabled = false.obs;
  final RxBool isLoading = false.obs;
  Position? currentPosition;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Future<bool> handleLocationPermission() async {
    LocationPermission permission;

    //isLoading.value = true;

    locationServicesEnabled.value = await Geolocator.isLocationServiceEnabled();
    if (!locationServicesEnabled.value) {
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
        const SnackBar(
          content: Text(
            'location services are disabled! please enable the services.',
          ),
        ),
      );
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      permissionStatus.value = 'denied';
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
          const SnackBar(
            content: Text(
              'location permissions are denied!!',
            ),
          ),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      permissionStatus.value = 'deniedForever';
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
        const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.'),
        ),
      );
      return false;
    }

    return true;
  }

  Future<void> getCurrentPosition() async {
    isLoading.value = true;
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) {
      isLoading.value = false;
      permissionStatus.value = "NO PERMISSION";
      return;
    }

    // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
    //     .then((Position position) {
    //   setState(() => currentPosition = position);
    // }).catchError((e) {
    //   debugPrint(e);
    // });

    await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    ).then((Position position) {
      currentPosition = position;
      getAddressFromLatLng(currentPosition!);
      isLoading.value = false;
    }).catchError((e) {
      isLoading.value = false;
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
        const SnackBar(
          content: Text('error fetching current position'),
        ),
      );
      debugPrint(e);
    });
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude)
        .then(
      (List<Placemark> placemarks) {
        Placemark place = placemarks[0];
        currentAddress.value =
            '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea} ${place.postalCode}';
        userCountry.value = '${place.country}';
      },
    ).catchError((onError) {
      ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
        const SnackBar(
          content: Text('error fetching current position'),
        ),
      );
      debugPrint(onError);
    });
  }

  void openLocationSettings() async {
    //AppSettings.openAppSettings();
    const intent = AndroidIntent(
      action: 'android.settings.LOCATION_SOURCE_SETTINGS',
    );

    await intent.launch();
  }
}
