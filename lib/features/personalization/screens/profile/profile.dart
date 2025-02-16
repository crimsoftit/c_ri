import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/img_widgets/c_circular_img.dart';
import 'package:c_ri/common/widgets/shimmers/shimmer_effects.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/personalization/screens/profile/widgets/c_profile_menu.dart';
import 'package:c_ri/features/personalization/screens/profile/widgets/update_name.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userController = Get.put(CUserController());

    return Scaffold(
      // appBar: CAppBar(
      //   bgColor: CColors.rBrown,
      //   showBackArrow: false,
      //   backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
      //   title: Text(
      //     'me profile',
      //     style: Theme.of(context).textTheme.headlineSmall,
      //   ),
      //   backIconAction: () {
      //     //Get.back();
      //   },
      // ),
      appBar: AppBar(
        backgroundColor: CColors.rBrown,
        automaticallyImplyLeading: false,
        title: Text(
          'me profile',
          style: Theme.of(context).textTheme.bodyLarge!.apply(
                color: CColors.white,
              ),
        ),
      ),

      // -- body --
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Column(
            children: [
              // -- profile picture
              SizedBox(
                width: double.infinity,
                child: Column(
                  children: [
                    CRoundedContainer(
                      bgColor: CColors.rBrown,
                      showBorder: true,
                      radius: 100,
                      borderColor: CColors.rBrown.withValues(alpha: 0.3),
                      child: Stack(
                        children: [
                          Obx(
                            () {
                              final networkImg =
                                  userController.user.value.profPic;
                              final dpImg = networkImg.isNotEmpty
                                  ? networkImg
                                  : CImages.user;

                              return userController.imgUploading.value
                                  ? const CShimmerEffect(
                                      width: 80.0,
                                      height: 80.0,
                                      radius: 80.0,
                                    )
                                  : CCircularImg(
                                      img: dpImg,
                                      width: 80.0,
                                      height: 80.0,
                                      padding: 10.0,
                                      isNetworkImg: networkImg.isNotEmpty,
                                    );
                            },
                          ),
                          Positioned(
                            right: 2,
                            bottom: 3,
                            child: SizedBox(
                              width: 20,
                              height: 20,
                              child: IconButton(
                                onPressed: () {
                                  userController.uploadUserProfPic();
                                },
                                icon: Icon(
                                  Iconsax.edit,
                                  size: 18.0,
                                  color: isDarkTheme
                                      ? CColors.white
                                      : CColors.rBrown.withValues(alpha: 0.6),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: CSizes.spaceBtnItems / 4,
                    ),
                    TextButton(
                      onPressed: () {
                        userController.uploadUserProfPic();
                      },
                      child: Text(
                        'change profile picture',
                        style: Theme.of(context).textTheme.labelMedium!.apply(
                              color: CColors.darkGrey,
                            ),
                      ),
                    ),

                    const SizedBox(
                      height: CSizes.spaceBtnItems / 2,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: CSizes.spaceBtnItems,
                    ),

                    // -- profile details
                    const CSectionHeading(
                      showActionBtn: false,
                      title: 'profile info...',
                      btnTitle: '',
                      editFontSize: false,
                    ),
                    const SizedBox(
                      height: CSizes.spaceBtnItems,
                    ),

                    CProfileMenu(
                      title: 'name',
                      value: userController.user.value.fullName,
                      titleFlex: 2,
                      secondRowWidgetFlex: 6,
                      onTap: () {
                        Get.to(() => const CUpdateName());
                      },
                    ),

                    CProfileMenu(
                      title: 'username',
                      value: 'retail intelligence',
                      titleFlex: 2,
                      secondRowWidgetFlex: 6,
                      onTap: () {},
                    ),

                    const SizedBox(
                      height: CSizes.spaceBtnItems / 2,
                    ),
                    const Divider(),
                    const SizedBox(
                      height: CSizes.spaceBtnItems,
                    ),

                    // -- personal info headings
                    const CSectionHeading(
                      showActionBtn: false,
                      title: 'personal info...',
                      btnTitle: '',
                      editFontSize: false,
                    ),
                    const SizedBox(
                      height: CSizes.spaceBtnItems,
                    ),

                    CProfileMenu(
                      title: 'user id',
                      value: userController.user.value.id,
                      icon: Iconsax.copy,
                      titleFlex: 2,
                      secondRowWidgetFlex: 6,
                      onTap: () {},
                    ),
                    CProfileMenu(
                      title: 'e-mail',
                      value: userController.user.value.email,
                      titleFlex: 2,
                      secondRowWidgetFlex: 6,
                      onTap: () {},
                    ),
                    CProfileMenu(
                      title: 'phone no.',
                      value: userController.user.value.phoneNo,
                      titleFlex: 2,
                      secondRowWidgetFlex: 6,
                      onTap: () {},
                    ),
                    CProfileMenu(
                      title: 'gender',
                      value: 'male',
                      titleFlex: 2,
                      secondRowWidgetFlex: 6,
                      onTap: () {},
                    ),
                    CProfileMenu(
                      title: 'dob.',
                      value: '8 Aug, 2000',
                      titleFlex: 2,
                      secondRowWidgetFlex: 6,
                      onTap: () {},
                    ),
                    const Divider(),
                    const SizedBox(
                      height: CSizes.spaceBtnItems,
                    ),

                    Center(
                      child: TextButton(
                        onPressed: () {
                          userController.deleteAccountWarningPopup();
                        },
                        child: const Text(
                          'close my account',
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
