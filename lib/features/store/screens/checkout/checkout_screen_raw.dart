import 'dart:async';
import 'dart:developer';

import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/loaders/animated_loader.dart';
import 'package:c_ri/common/widgets/loaders/default_loader.dart';
import 'package:c_ri/common/widgets/search_bar/animated_typeahead_field.dart';
import 'package:c_ri/features/personalization/controllers/location_controller.dart';
import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/personalization/screens/location_tings/widgets/device_settings_btn.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/features/store/controllers/checkout_controller.dart';
import 'package:c_ri/features/store/controllers/search_bar_controller.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/billing_amount_section.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/cart_items.dart';
import 'package:c_ri/features/store/screens/checkout/widgets/payment_methods/payment_method_section.dart';
import 'package:c_ri/main.dart';
import 'package:c_ri/nav_menu.dart';
import 'package:c_ri/services/location_services.dart';
import 'package:c_ri/services/permission_provider.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/img_strings.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:c_ri/utils/helpers/network_manager.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';

class CCheckoutScreen1 extends StatefulWidget {
  const CCheckoutScreen1({super.key});

  @override
  State<CCheckoutScreen1> createState() => _CCheckoutScreenState();
}

class _CCheckoutScreenState extends State<CCheckoutScreen1> {
  /// -- variables --
  late StreamController<PermissionStatus> _permissionStatusStream;
  late StreamController<AppLifecycleState> _appCycleStateStream;
  late final AppLifecycleListener _listener;
  bool geoSwitchIsOn = false;

  final CLocationController locationController =
      Get.put<CLocationController>(CLocationController());

  @override
  void initState() {
    super.initState();
    _permissionStatusStream = StreamController<PermissionStatus>();
    _appCycleStateStream = StreamController<AppLifecycleState>();
    _listener = AppLifecycleListener(
      onStateChange: _onStateChange,
      onResume: _onResume,
      onInactive: _onInactive,
      onHide: _onHide,
      onShow: _onShow,
      onPause: _onPause,
      onRestart: _onRestart,
      onDetach: _onDetach,
    );
    _appCycleStateStream.sink.add(SchedulerBinding.instance.lifecycleState!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPermissionAndListenLocation();
    });

    if (PermissionProvider.locationServiceIsOn) {
      setState(() {
        geoSwitchIsOn = true;
      });
      CLocationServices.instance
          .getUserLocation(locationController: locationController);
    }
    // CLocationServices.instance
    //     .getUserLocation(locationController: locationController);
  }

  void _onStateChange(AppLifecycleState state) =>
      _appCycleStateStream.sink.add(state);

  void _onResume() async {
    if (PermissionProvider.permissionDialogRoute != null &&
        PermissionProvider.permissionDialogRoute!.isActive) {
      Navigator.of(globalNavigatorKey.currentContext!)
          .removeRoute(PermissionProvider.permissionDialogRoute!);
    }
    Future.delayed(const Duration(milliseconds: 250), () async {
      checkPermissionAndListenLocation();
    });

    if (PermissionProvider.locationServiceIsOn) {
      setState(() {
        geoSwitchIsOn = true;
      });
      CLocationServices.instance
          .getUserLocation(locationController: locationController);
    }
  }

  void _onInactive() => log('onInactive');

  void _onHide() => log('onHide');

  void _onShow() => log('onShow');

  void _onPause() => log('onPause');

  void _onRestart() => log('onRestart');

  void _onDetach() => log('onDetach');

  @override
  void dispose() {
    _listener.dispose();
    _permissionStatusStream.close();
    _appCycleStateStream.close();
    super.dispose();
  }

  void checkPermissionAndListenLocation() {
    PermissionProvider.handleLocationPermission().then((_) {
      _permissionStatusStream.sink.add(PermissionProvider.locationPermission);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final checkoutController = Get.put(CCheckoutController());
    final navController = Get.put(NavMenuController());
    final userController = Get.put(CUserController());
    final searchBarController = Get.put(CSearchBarController());

    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final currencySymbol =
        CHelperFunctions.formatCurrency(userController.user.value.currencyCode);

    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;

    return Scaffold(
        appBar: AppBar(
          leadingWidth: 30.0,
          backgroundColor: CColors.rBrown,
          leading: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
            child: IconButton(
              icon: Icon(
                Iconsax.arrow_left,
                size: CSizes.iconMd,
              ),
              onPressed: () {
                //Get.back();
                Navigator.pop(context);
              },
            ),
          ),
          title: Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
            child: Obx(
              () {
                return searchBarController.showAnimatedTypeAheadField.value
                    ? CAnimatedTypeaheadField(
                        boxColor: CColors.white,
                      )
                    : Row(
                        children: [
                          Text(
                            'checkout...',
                            style: Theme.of(context).textTheme.bodyLarge!.apply(
                                  color: CColors.white,
                                ),
                          ),
                          SizedBox(
                            width: CSizes.spaceBtnItems * 10.1,
                          ),
                          CAnimatedTypeaheadField(
                            boxColor: Colors.transparent,
                          ),
                        ],
                      );
              },
            ),
          ),
          actions: [],
        ),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Obx(
                () {
                  /// -- empty data widget --
                  final noDataWidget = CAnimatedLoaderWidget(
                    showActionBtn: true,
                    text: 'whoops! cart is EMPTY!',
                    actionBtnText: 'let\'s fill it',
                    animation: CImages.emptyCartLottie,
                    onActionBtnPressed: () {
                      navController.selectedIndex.value = 1;
                      Get.to(() => const NavMenu());
                    },
                  );

                  if (cartController.cartItems.isEmpty) {
                    return noDataWidget;
                  }

                  if (PermissionProvider.locationServiceIsOn &&
                      isConnectedToInternet) {
                    CLocationServices.instance.getUserLocation(
                        locationController: locationController);
                  }

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CSizes.defaultSpace / 4,
                          left: CSizes.defaultSpace / 4,
                          right: CSizes.defaultSpace / 4,
                        ),
                        child: Column(
                          children: [
                            // -- list of items in the cart --
                            SizedBox(
                              height: cartController.cartItems.length <= 2
                                  ? CHelperFunctions.screenHeight() * 0.30
                                  : CHelperFunctions.screenHeight() * 0.42,
                              child: CRoundedContainer(
                                padding: EdgeInsets.all(
                                  CSizes.defaultSpace / 4,
                                ),
                                bgColor: CColors.rBrown.withValues(
                                  alpha: 0.2,
                                ),
                                child: CCartItems(),
                              ),
                            ),
                            //Divider(),
                            SizedBox(
                              height: CSizes.defaultSpace / 4,
                            ),

                            // -- billing section --
                            CRoundedContainer(
                              padding: const EdgeInsets.all(CSizes.md),
                              showBorder: true,
                              bgColor:
                                  isDarkTheme ? CColors.black : CColors.white,
                              child: Column(
                                children: [
                                  // pricing
                                  CBillingAmountSection(),
                                  //const SizedBox(height: CSizes.spaceBtnItems),

                                  // divider
                                  Divider(),
                                  //const SizedBox(height: CSizes.spaceBtnItems),
                                  // payment methods
                                  CPaymentMethodSection(),
                                  // addresses
                                  //CBillingAddressSection(),
                                  Center(
                                    child: StreamBuilder<PermissionStatus>(
                                      stream: _permissionStatusStream.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          // Display a loading indicator when waiting for data
                                          return SizedBox(
                                            height: CHelperFunctions
                                                    .screenHeight() *
                                                0.5,
                                            child: const DefaultLoaderScreen(),
                                          );
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}'); // Display an error message if an error occurs
                                        } else if (!snapshot.hasData) {
                                          return const Text(
                                              'No Data Available'); // Display a message when no data is available
                                        } else {
                                          return Column(
                                            children: [
                                              Visibility(
                                                visible: true,
                                                child: Text(
                                                  'Location Service: ${PermissionProvider.locationServiceIsOn ? "On" : "Off"}\n${snapshot.data}',
                                                  // style: const TextStyle(fontSize: 24),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge!
                                                      .apply(),
                                                ),
                                              ),
                                              const SizedBox(
                                                height: CSizes.spaceBtnSections,
                                              ),
                                              // CMenuTile(
                                              //   icon: Iconsax.location,
                                              //   title:
                                              //       'enable location services',
                                              //   subTitle:
                                              //       'rIntel requires location info to protect buyers & sellers',
                                              //   trailing: Switch(
                                              //     value: geoSwitchIsOn,
                                              //     activeColor: CColors.rBrown,
                                              //     onChanged: (value) {
                                              //       setState(
                                              //         () {
                                              //           geoSwitchIsOn = value;
                                              //         },
                                              //       );

                                              //       if (geoSwitchIsOn) {
                                              //         CLocationServices
                                              //             .instance
                                              //             .getUserLocation(
                                              //                 locationController:
                                              //                     locationController);
                                              //       }
                                              //     },
                                              //   ),
                                              // ),
                                            ],
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                  Center(
                                    child: StreamBuilder<AppLifecycleState>(
                                      stream: _appCycleStateStream.stream,
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return SizedBox(
                                            height: CHelperFunctions
                                                    .screenHeight() *
                                                0.5,
                                            child: const DefaultLoaderScreen(),
                                          ); // Display a loading indicator when waiting for data
                                        } else if (snapshot.hasError) {
                                          return Text(
                                              'Error: ${snapshot.error}'); // Display an error message if an error occurs
                                        } else if (!snapshot.hasData) {
                                          return const Text(
                                              'No data available'); // Display a message when no data is available
                                        } else {
                                          //if (locationController.processingLocationAccess.value)
                                          if (locationController
                                                      .processingLocationAccess
                                                      .value &&
                                                  locationController
                                                          .uAddress.value ==
                                                      '' ||
                                              locationController
                                                      .uCurCode.value ==
                                                  '') {
                                            if (!geoSwitchIsOn) {
                                              return const DeviceSettingsBtn();
                                            } else {
                                              return SizedBox(
                                                height: CHelperFunctions
                                                        .screenHeight() *
                                                    0.5,
                                                child:
                                                    const DefaultLoaderScreen(),
                                              );
                                            }
                                          }

                                          if (geoSwitchIsOn) {
                                            CLocationServices.instance
                                                .getUserLocation(
                                                    locationController:
                                                        locationController);
                                          }

                                          return Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              mainAxisSize: MainAxisSize.min,
                                              children: <Widget>[
                                                Visibility(
                                                  visible: true,
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        'latitude: ${locationController.userLocation.value!.latitude ?? ''}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      Text(
                                                        'longitude: ${locationController.userLocation.value!.longitude ?? ''}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      Text(
                                                        'user country: ${locationController.uCountry.value}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      Text(
                                                        'user Address: ${locationController.uAddress.value}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 2,
                                                      ),
                                                      Text(
                                                        'user currency code: ${locationController.uCurCode.value}',
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                      Text(
                                                        '${snapshot.data}',
                                                        style: const TextStyle(
                                                          fontSize: 24,
                                                        ),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                        maxLines: 1,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                const DeviceSettingsBtn(),
                                              ],
                                            ),
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: CSizes.spaceBtnSections,
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            checkoutController.scanItemForCheckout();
          },
          label: Text(
            'scan',
          ),
          icon: const Icon(
            // Iconsax.scan_barcode,
            Iconsax.scan,
          ),
          backgroundColor: isConnectedToInternet ? Colors.brown : CColors.black,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBar: Obx(
          () {
            if (cartController.cartItems.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton.icon(
                  onPressed: () {
                    if (checkoutController
                            .selectedPaymentMethod.value.platformName ==
                        'cash') {
                      if (checkoutController.amtIssuedFieldController.text ==
                          '') {
                        CPopupSnackBar.customToast(
                          message:
                              'please enter the amount issued by customer!!',
                          forInternetConnectivityStatus: false,
                        );
                        checkoutController.setFocusOnAmtIssuedField.value =
                            true;
                        return;
                      }
                      if (double.parse(checkoutController
                              .amtIssuedFieldController.text
                              .trim()) <
                          cartController.totalCartPrice.value) {
                        CPopupSnackBar.errorSnackBar(
                          title: 'customer still owes you!!',
                          message: 'the amount issued is not enough',
                        );
                        return;
                      }
                    }
                    checkoutController.processTxn();
                  },
                  label: SizedBox(
                    height: 34.1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'CHECKOUT',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color: CColors.white,
                                fontSizeFactor: 0.88,
                                fontWeightDelta: 1,
                              ),
                        ),
                        Text(
                          '$currencySymbol.${cartController.totalCartPrice.value.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.bodyMedium!.apply(
                                color: CColors.white,
                                fontSizeFactor: 1.10,
                                fontWeightDelta: 2,
                              ),
                        ),
                      ],
                    ),
                  ),
                  icon: Icon(
                    Iconsax.wallet_check,
                    color: CColors.white,
                  ),
                ),
              );
            } else {
              return SizedBox();
            }
          },
        ));
  }
}
