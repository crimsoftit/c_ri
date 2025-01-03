import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:c_ri/data/repos/auth/auth_repo.dart';
import 'package:c_ri/features/personalization/models/user_model.dart';
import 'package:c_ri/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:c_ri/utils/exceptions/format_exceptions.dart';
import 'package:c_ri/utils/exceptions/platform_exceptions.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CUserRepo extends GetxController {
  static CUserRepo get instance => Get.find();

  final RxBool locationServicesEnabled = false.obs;
  LocationPermission? permission;

  Position? currentPosition;

  final RxString currentAddress = ''.obs;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Future<bool> handleLocationPermission() async {
  //   locationServicesEnabled.value = await Geolocator.isLocationServiceEnabled();
  //   if (!locationServicesEnabled.value) {
  //     ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //           'location services are disabled! please enable the services.',
  //         ),
  //       ),
  //     );
  //     return false;
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
  //         const SnackBar(
  //           content: Text(
  //             'location permissions are denied!!',
  //           ),
  //         ),
  //       );
  //       return false;
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
  //       const SnackBar(
  //         content: Text(
  //             'Location permissions are permanently denied, we cannot request permissions.'),
  //       ),
  //     );
  //     return false;
  //   }

  //   return true;
  // }

  // Future<void> getCurrentPosition() async {
  //   final hasPermission = await handleLocationPermission();

  //   if (!hasPermission) return;

  //   // await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
  //   //     .then((Position position) {
  //   //   setState(() => currentPosition = position);
  //   // }).catchError((e) {
  //   //   debugPrint(e);
  //   // });

  //   await Geolocator.getCurrentPosition(
  //     locationSettings: locationSettings,
  //   ).then((Position position) {
  //     currentPosition = position;

  //     getAddressFromLatLng(currentPosition!);
  //   }).catchError((e) {
  //     ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
  //       const SnackBar(
  //         content: Text('error fetching current position'),
  //       ),
  //     );
  //     debugPrint(e);
  //   });
  // }

  // Future<void> getAddressFromLatLng(Position position) async {
  //   await placemarkFromCoordinates(
  //           currentPosition!.latitude, currentPosition!.longitude)
  //       .then(
  //     (List<Placemark> placemarks) {
  //       Placemark place = placemarks[0];
  //       currentAddress.value =
  //           '${place.street}, ${place.subLocality}, ${place.subAdministrativeArea} ${place.postalCode}';
  //     },
  //   ).catchError((onError) {
  //     ScaffoldMessenger.of(Get.overlayContext!).showSnackBar(
  //       const SnackBar(
  //         content: Text('error fetching current position'),
  //       ),
  //     );
  //     debugPrint(onError);
  //   });
  // }

  /* ===== save user data to firestore ===== */
  Future<void> saveUserDetails(CUserModel users) async {
    try {
      await _db.collection("users").doc(users.id).set(users.toJson());
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      throw CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
    } on FormatException catch (e) {
      // CPopupLoader.errorSnackBar(
      //   title: "format exception error",
      //   message: e.message,
      // );
      throw CPopupSnackBar.errorSnackBar(
        title: "format exception error",
        message: e.message,
      );
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      throw 'something went wrong! please try again!';
    }
  }

  /* == fetch user details based on user ID == */
  Future<CUserModel> fetchUserDetails() async {
    try {
      final docSnapshot = await _db
          .collection("users")
          .doc(AuthRepo.instance.authUser?.uid)
          .get();
      if (docSnapshot.exists) {
        return CUserModel.fromSnapshot(docSnapshot);
      } else {
        return CUserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      throw 'something went wrong! please try again!';
    }
  }

  /* == check if phone no. already exists == */
  Future<bool> checkIfPhoneNoExists(String phoneNo) async {
    try {
      final QuerySnapshot result = await _db
          .collection('users')
          .where('PhoneNo', isEqualTo: phoneNo)
          .limit(1)
          .get();

      final List<DocumentSnapshot> docs = result.docs;
      return docs.length == 1;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      throw 'something went wrong! please try again!';
    }
  }

  /* == update user data in firestore == */
  Future<void> updateUserDetails(CUserModel updatedUser) async {
    try {
      await _db
          .collection("users")
          .doc(updatedUser.id)
          .update(updatedUser.toJson());
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      throw 'something went wrong! please try again!';
    }
  }

  /* == update any fields in a Specific user's collection == */
  Future<void> updateSpecificUser(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("users")
          .doc(AuthRepo.instance.authUser?.uid)
          .update(json);
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      throw 'something went wrong! please try again!';
    }
  }

  /* == update any fields in a Specific user's collection == */
  Future<void> updateUserCurrency(String curCode) async {
    try {
      await _db
          .collection("users")
          .doc(AuthRepo.instance.authUser?.uid)
          .update({
        'CurrencyCode': curCode,
      });
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      throw 'something went wrong! please try again!';
    }
  }

  /* == remove user data from firestore == */
  Future<void> deleteUserRecord(String userID) async {
    try {
      await _db.collection("users").doc(userID).delete();
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      throw 'something went wrong! please try again!';
    }
  }

  /* == upload user profile pic (or any image) == */
  Future<String> uploadImage(String imgPath, XFile imgFile) async {
    try {
      final ref = FirebaseStorage.instance.ref(imgPath).child(imgFile.name);
      await ref.putFile(File(imgFile.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      throw 'something went wrong! please try again!';
    }
  }
}
