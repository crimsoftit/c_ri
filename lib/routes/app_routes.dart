import 'package:c_ri/features/authentication/screens/login/login.dart';
import 'package:c_ri/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:c_ri/features/authentication/screens/pswd_config/forgot_password.dart';
import 'package:c_ri/features/authentication/screens/signup/signup.dart';
import 'package:c_ri/features/authentication/screens/signup/verify_email.dart';
import 'package:c_ri/features/personalization/screens/profile/profile.dart';
import 'package:c_ri/features/personalization/screens/settings/user_settings.dart';
import 'package:c_ri/features/store/screens/home/home.dart';
import 'package:c_ri/features/store/screens/inventory/inventory_screen.dart';
import 'package:c_ri/features/store/screens/inventory_details/inventory_details.dart';
import 'package:c_ri/features/store/screens/sales/sales_screen.dart';
import 'package:c_ri/features/store/screens/search/search_results.dart';
import 'package:c_ri/features/store/screens/sales/sell_item_screen/sell_item_screen.dart';
import 'package:get/get.dart';

import 'routes.dart';

class CAppRoutes {
  static final pages = [
    GetPage(
      name: CRoutes.home,
      page: () => const HomeScreen(),
    ),
    GetPage(
      name: CRoutes.inventory,
      page: () => const InventoryScreen(),
    ),
    GetPage(
      name: CRoutes.inventoryDetails,
      page: () => const CInventoryDetailsScreen(),
    ),
    GetPage(
      name: CRoutes.sales,
      page: () => const SalesScreen(),
    ),
    GetPage(
      name: CRoutes.sellItemScreen,
      page: () => const CSellItemScreen(),
    ),
    GetPage(
      name: CRoutes.settings,
      page: () => const SettingsScreen(),
    ),
    GetPage(
      name: CRoutes.userProfile,
      page: () => const ProfileScreen(),
    ),
    GetPage(
      name: CRoutes.signup,
      page: () => const SignupScreen(),
    ),
    GetPage(
      name: CRoutes.verifyEmail,
      page: () => const VerifyEmailScreen(),
    ),
    GetPage(
      name: CRoutes.login,
      page: () => const LoginScreen(),
    ),
    GetPage(
      name: CRoutes.forgotPassword,
      page: () => const ForgotPasswordScreen(),
    ),
    GetPage(
      name: CRoutes.onBoarding,
      page: () => const OnboardingScreen(),
    ),
    GetPage(
      name: CRoutes.searchResults,
      page: () => const CSearchResultsScreen(),
    ),
  ];
}
