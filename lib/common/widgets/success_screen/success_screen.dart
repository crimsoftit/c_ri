import 'package:c_ri/common/styles/spacing_styles.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SuccessScreen extends StatelessWidget {
  const SuccessScreen({
    super.key,
    required this.image,
    required this.title,
    required this.subTitle,
    required this.onPressed,
  });

  final String image, title, subTitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(CUserController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: CSpacingStyle.paddingWithAppBarHeight * 2,
          child: Column(
            children: [
              // -- header image --
              Lottie.asset(
                image,
                width: MediaQuery.of(context).size.width * 0.8,
              ),

              const SizedBox(
                height: CSizes.spaceBtnSections,
              ),

              // -- title & subtitle --
              Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: CSizes.spaceBtnItems,
              ),
              Obx(
                () => Text(
                  userController.user.value.email,
                  style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: CColors.grey,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: CSizes.spaceBtnItems,
              ),
              Text(
                subTitle,
                style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: CColors.darkGrey,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: CSizes.spaceBtnSections,
              ),

              // -- buttons --
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onPressed,
                  child: Text(
                    'CONTINUE',
                    style: Theme.of(context).textTheme.labelMedium?.apply(
                          color: CColors.white,
                        ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
