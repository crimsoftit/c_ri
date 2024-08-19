import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/img_widgets/c_circular_img.dart';
import 'package:c_ri/common/widgets/shimmers/shimmer_effects.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CUserProfileTile extends StatelessWidget {
  const CUserProfileTile({
    super.key,
    required this.onPressed,
  });

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    //final currentUser = FirebaseAuth.instance.currentUser;
    final userController = Get.put(CUserController());

    return ListTile(
      leading: CRoundedContainer(
        showBorder: true,
        radius: 120,
        borderColor: CColors.rBrown.withOpacity(0.3),
        child: CCircularImg(
          img: userController.user.value.profPic,
          width: 47.0,
          height: 47.0,
          //padding: 10.0,
        ),
      ),
      title: Obx(() {
        if (userController.profileLoading.value) {
          // -- display a shimmer loader effect while loading user profile
          return const CShimmerEffect(
            width: 80.0,
            height: 15.0,
          );
        } else {
          return Text(
            userController.user.value.fullName,
            style: Theme.of(context).textTheme.labelMedium!.apply(
                  color: CColors.grey,
                ),
          );
        }
      }),
      subtitle: Obx(() {
        if (userController.profileLoading.value) {
          return const CShimmerEffect(
            width: 80.0,
            height: 15.0,
          );
        } else {
          return Text(
            userController.user.value.email,
            style: Theme.of(context).textTheme.headlineSmall!.apply(
                  color: CColors.white,
                  fontSizeFactor: 0.6,
                ),
          );
        }
      }),
      trailing: IconButton(
        onPressed: onPressed,
        icon: const Icon(
          Iconsax.edit,
          color: CColors.white,
        ),
      ),
    );
  }
}
