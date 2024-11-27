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

  /// -- variables --
  final RxString currentAddress = ''.obs;
  final RxString userCountry = ''.obs;
  final RxString permissionStatus = ''.obs;
  final RxBool locationServicesEnabled = false.obs;
  Position? currentPosition;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  Future<bool> handleLocationPermission() async {
    LocationPermission permission;

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
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;

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
    }).catchError((e) {
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
}
