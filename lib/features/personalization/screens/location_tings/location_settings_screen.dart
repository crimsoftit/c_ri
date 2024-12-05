import 'package:c_ri/common/widgets/login_signup/form_divider.dart';
import 'package:c_ri/data/repos/auth/auth_repo.dart';
import 'package:c_ri/features/personalization/controllers/location_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CLocationSettings extends StatelessWidget {
  const CLocationSettings({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final locationController = Get.put(CLocationController());

    /// #### ==== CHECK OUT SQUARE POS DEVICE SETTINGS SCREEN === #### ///
    return Scaffold(
      appBar: locationController.isLoading.value
          ? !locationController.locationFetchedSuccessfully.value
              ? AppBar(
                  backgroundColor: CColors.rBrown.withOpacity(0.4),
                  title: const Text('Location Settings'),
                )
              : null
          : null,
      body: Obx(
        () {
          //locationController.handleLocationPermission();

          if (locationController.isLoading.value) {
            return const Scaffold(
              backgroundColor: CColors.rBrown,
              body: Center(
                child: CircularProgressIndicator(
                  color: CColors.white,
                ),
              ),
            );
          }

          if (locationController.permissionStatus.value ==
                  'permission granted' &&
              locationController.isLoading.value == false) {
            //CPopupSnackBar.successSnackBar(title: 'rada safi');
            locationController.fetchUserCurrencyByCountry(
                locationController.userCountry.value);
            locationController.updateUserCurrency();
            AuthRepo.instance.screenRedirect();
          }

          if (locationController.isLoading.value) {
            return const Scaffold(
              backgroundColor: CColors.rBrown,
              body: Center(
                child: CircularProgressIndicator(
                  color: CColors.white,
                ),
              ),
            );
          }

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(
                CSizes.defaultSpace,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Visibility(
                    visible: false,
                    child: Column(
                      children: [
                        Text(
                          locationController.userCountry.value,
                        ),
                        Text(
                          locationController.uCurCode.value,
                        ),
                        Text(
                          locationController.permissionStatus.value,
                        ),
                      ],
                    ),
                  ),
                  !locationController.locationFetchedSuccessfully.value
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "please select the country from where you'll collect payments...",
                              style:
                                  Theme.of(context).textTheme.bodyLarge!.apply(
                                        color: CColors.rBrown,
                                      ),
                            ),
                            const SizedBox(
                              height: CSizes.defaultSpace,
                            ),
                            Form(
                              key: locationController.selectCountryFormKey,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(0),
                                    width: CHelperFunctions.screenWidth() * 0.6,
                                    decoration: BoxDecoration(
                                      color: CColors.rBrown.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: CountryCodePicker(
                                      padding: const EdgeInsets.all(2.0),
                                      alignLeft: true,
                                      boxDecoration: BoxDecoration(
                                        //color: CColors.rBrown,
                                        border: Border.all(),
                                        borderRadius: BorderRadius.circular(
                                          5.0,
                                        ),
                                      ),
                                      showDropDownButton: true,
                                      initialSelection: 'KE',
                                      showCountryOnly: true,
                                      onInit: (country) {
                                        // uCountry = country!.name.toString();
                                        // signupController
                                        //     .fetchUserCurrencyByCountry(
                                        //         country.name.toString());

                                        debugPrint(country?.name.toString());
                                      },
                                      showOnlyCountryWhenClosed: true,
                                      onChanged: (value) {
                                        locationController.onCountryChanged(
                                            value.toCountryStringOnly());
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: CSizes.spaceBtnInputFields,
                                  ),

                                  SizedBox(
                                    width: double.infinity,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        locationController.updateUserCurrency();
                                      },
                                      child: const Text(
                                        'CONTINUE',
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: CSizes.spaceBtnInputFields,
                                  ),

                                  // -- divider --
                                  const CFormDivider(
                                    dividerText:
                                        'or enable location services below',
                                  ),

                                  const SizedBox(
                                    height: CSizes.spaceBtnSections,
                                  ),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextButton.icon(
                                          onPressed: locationController
                                              .openLocationSettings,
                                          label: const Text(
                                            'open settings',
                                          ),
                                          icon: const Icon(
                                            Iconsax.location,
                                            size: CSizes.iconSm,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: CColors.rBrown,
                                            backgroundColor:
                                                CColors.rBrown.withOpacity(
                                              0.2,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: CSizes.spaceBtnInputFields,
                                      ),
                                      Expanded(
                                        child: TextButton.icon(
                                          onPressed: locationController
                                              .getCurrentPosition,
                                          label: const Text(
                                            'refresh',
                                          ),
                                          icon: const Icon(
                                            Iconsax.refresh,
                                            size: CSizes.iconSm,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: CColors.rBrown,
                                            backgroundColor:
                                                CColors.rBrown.withOpacity(
                                              0.2,
                                            ),
                                          ),
                                        ),
                                        // child: ElevatedButton(
                                        //   onPressed: locationController
                                        //       .openLocationSettings,
                                        //   child: const Text(
                                        //     'open location settings',
                                        //   ),
                                        // ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
