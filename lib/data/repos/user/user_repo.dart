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
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CUserRepo extends GetxController {
  static CUserRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;

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
