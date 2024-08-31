import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/shimmers/shimmer_effects.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/txt_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CHomeAppBarWidget extends StatelessWidget {
  const CHomeAppBarWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //final currentUser = FirebaseAuth.instance.currentUser;
    final userController = Get.put(CUserController());

    return CAppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            CTexts.homeAppbarTitle,
            style: Theme.of(context).textTheme.labelMedium!.apply(
                  color: CColors.grey,
                ),
          ),
          Obx(
            () {
              if (userController.profileLoading.value) {
                // -- display a shimmer loader effect while loading user profile
                return const CShimmerEffect(
                  width: 80.0,
                  height: 15.0,
                );
              } else {
                return Text(
                  userController.user.value.fullName,
                  style: Theme.of(context).textTheme.headlineSmall!.apply(
                        color: CColors.white,
                        fontSizeFactor: 0.7,
                      ),
                );
              }
            },
          ),
          // Text(
          //   userController.user.value.email,
          //   style: Theme.of(context).textTheme.headlineSmall!.apply(
          //         color: CColors.white,
          //         fontSizeFactor: 0.7,
          //       ),
          // ),
        ],
      ),
      actions: const [
        // -- cart counter icon --
        // CCartCounterIcon(
        //   iconColor: Colors.white,
        // ),
      ],
      backIconAction: () {
        Get.back();
      },
    );
  }
}