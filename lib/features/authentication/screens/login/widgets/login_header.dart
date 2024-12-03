import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/constants/txt_strings.dart';
import 'package:flutter/material.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(
          //width: double.infinity,
          child: Image(
            height: 120.0,
            //image: AssetImage( isDark ? RImages.darkAppLogo_1 : RImages.lightAppLogo_1),
            // image: AssetImage(
            //   isDarkTheme ? CImages.darkAppLogo : CImages.lightAppLogo,
            // ),
            image: AssetImage(
              CImages.darkAppLogo,
            ),
          ),
        ),
        Text(
          CTexts.loginTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(
          height: CSizes.sm,
        ),
        Text(
          CTexts.loginSubTitle,
          style: Theme.of(context).textTheme.labelSmall,
        ),
      ],
    );
  }
}
