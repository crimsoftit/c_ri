import 'package:c_ri/common/widgets/loaders/loading_dialog.dart';
import 'package:c_ri/data/repos/auth/auth_repo.dart';
import 'package:c_ri/data/repos/user/user_repo.dart';
import 'package:c_ri/features/authentication/screens/signup/verify_email.dart';
import 'package:c_ri/features/personalization/models/user_model.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:c_ri/utils/popups/full_screen_loader.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  static SignupController get instance => Get.find();

  // -- variables --
  final hidePswdTxt = true.obs;
  RxString countryCode = ''.obs;
  final checkPrivacyPolicy = false.obs;

  final hideConfirmPswdTxt = true.obs;
  final fullName = TextEditingController();
  final email = TextEditingController();
  final phoneNumber = TextEditingController();
  final password = TextEditingController();
  final confirmPasswordd = TextEditingController();

  GlobalKey<FormState> signupFormKey = GlobalKey<FormState>();

  // -- firebase signup function --
  void signup() async {
    try {
      // -- start loader
      CFullScreenLoader.openLoadingDialog(
        "we're processing your info...",
        CImages.docerAnimation,
      );

      // -- check internet connectivity
      final isConnected = await CNetworkManager.instance.isConnected();
      if (!isConnected) {
        // -- remove loader
        CFullScreenLoader.stopLoading();
        CPopupSnackBar.customToast(
          message: 'please check your internet connection',
        );
        return;
      }

      // -- form validation
      if (!signupFormKey.currentState!.validate()) {
        // -- remove loader
        CFullScreenLoader.stopLoading();
        return;
      }

      // -- privacy policy check
      if (!checkPrivacyPolicy.value) {
        CFullScreenLoader.stopLoading();
        CPopupSnackBar.warningSnackBar(
            title: 'accept privacy policy',
            message:
                'to create an account, you must read and accept the privacy policy & terms of use!');
        return;
      }

      // -- register user implementing Firebase Authentication & save user data in the Firebase database
      final userCredentials =
          await AuthRepo.instance.signupWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // -- save user data in the Firestore database
      final newUser = CUserModel(
        id: userCredentials.user!.uid,
        fullName: fullName.text,
        email: email.text.trim(),
        countryCode: countryCode.value,
        phoneNo: phoneNumber.text.trim(),
        profPic: '',
      );

      final userRepo = Get.put(CUserRepo());
      await userRepo.saveUserDetails(newUser);

      // -- remove loader
      CFullScreenLoader.stopLoading();

      // -- show signup success message
      CPopupSnackBar.successSnackBar(
          title: 'ngrats!',
          message:
              'your account has been created! verify your e-mail address to proceed!');

      // -- move to verify email screen
      Get.to(() => VerifyEmailScreen(
            email: email.text.trim(),
          ));
    } catch (e) {
      // -- remove loader --
      CLoadingDialog.hideLoader();
      // -- show some generic error msg to the user
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
      // -- remove loader --
      CLoadingDialog.hideLoader();
      return;
    }
  }
}
