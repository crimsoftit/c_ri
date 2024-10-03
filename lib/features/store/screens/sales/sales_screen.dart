import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/icon_buttons/trailing_icon_btn.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class SalesScreen extends StatelessWidget {
  const SalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return Scaffold(
      /// -- app bar --
      appBar: CAppBar(
        showBackArrow: true,
        backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
        title: Text(
          'sales',
          style: Theme.of(context).textTheme.headlineSmall!.apply(
                fontSizeFactor: 0.7,
              ),
        ),
        actions: [
          // -- search button
          CTrailingIconBtn(
            iconColor: CColors.white,
            onPressed: () {},
            iconData: Iconsax.search_favorite,
          ),
        ],
        backIconAction: () {
          Navigator.pop(context, true);
          Get.back();
        },
        showSubTitle: false,
      ),

      /// -- body --
      body: const SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(CSizes.defaultSpace),
        ),
      ),
    );
  }
}
