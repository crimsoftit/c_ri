import 'package:c_ri/common/styles/spacing_styles.dart';
import 'package:c_ri/common/widgets/login_signup/form_divider.dart';
import 'package:c_ri/common/widgets/login_signup/social_buttons.dart';
import 'package:c_ri/features/authentication/screens/login/widgets/login_form.dart';
import 'package:c_ri/features/authentication/screens/login/widgets/login_header.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/constants/txt_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CColors.primaryBrown,
        title: Text(
          'sign in...',
          style: Theme.of(context).textTheme.labelLarge!.apply(
                color: CColors.white,
              ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: CSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- logo, title, and subtitle --
              const LoginHeader(),

              // -- login form --
              const LoginForm(),

              // -- divider --
              CFormDivider(
                dividerText: CTexts.orSignInWith.capitalize!,
              ),
              const SizedBox(
                height: CSizes.spaceBtnSections,
              ),

              // -- footer --
              const CSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
