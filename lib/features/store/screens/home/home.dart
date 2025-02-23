import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/products/cart/cart_counter_icon.dart';
import 'package:c_ri/common/widgets/products/circle_avatar.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/controllers/inv_controller.dart';
import 'package:c_ri/features/store/screens/home/widgets/home_appbar.dart';
import 'package:c_ri/nav_menu.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/constants/txt_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final navController = Get.put(NavMenuController());

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  // -- ## HOME PAGE APP BAR ## --
                  CHomeAppBarWidget(
                    appBarTitle: CTexts.homeAppbarTitle,
                    actionsSection: CCartCounterIcon(
                      iconColor: Colors.white,
                    ),
                    screenTitle: '',
                    isHomeScreen: true,
                  ),

                  // -- ## ALL ABOUT CATEGORIES ## --
                  Padding(
                    padding: const EdgeInsets.only(
                      left: CSizes.defaultSpace,
                    ),
                    child: Obx(
                      () {
                        return Column(
                          children: [
                            // -- top sellers category heading --
                            CSectionHeading(
                              showActionBtn: true,
                              title: 'top sellers...',
                              txtColor: CColors.white,
                              btnTitle: 'view all',
                              btnTxtColor: CColors.grey,
                              editFontSize: true,
                              onPressed: () {
                                navController.selectedIndex.value = 1;
                                Get.to(() => const NavMenu());
                              },
                            ),
                            const SizedBox(
                              height: CSizes.spaceBtnItems / 4.0,
                            ),
                            // -- top sellers list of items --
                            SizedBox(
                              height: 100.0,
                              child: ListView.separated(
                                itemCount: invController.topSoldItems.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                separatorBuilder: (_, __) {
                                  return SizedBox(
                                    width: CSizes.spaceBtnItems / 2,
                                  );
                                },
                                itemBuilder: (_, index) {
                                  return InkWell(
                                    onTap: () {
                                      Get.toNamed(
                                        '/inventory/item_details/',
                                        arguments: invController
                                            .topSoldItems[index].productId,
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 56.0,
                                          height: 56.0,
                                          padding: const EdgeInsets.all(
                                            CSizes.sm,
                                          ),
                                          decoration: BoxDecoration(
                                            color: CColors.white,
                                            borderRadius: BorderRadius.circular(
                                              100.0,
                                            ),
                                          ),
                                          child: Center(
                                            child: CCircleAvatar(
                                              avatarInitial: invController
                                                  .topSoldItems[index].name[0]
                                                  .toUpperCase(),
                                              bgColor: CColors.white,
                                              txtColor: CColors.rBrown,
                                            ),
                                          ),
                                        ),

                                        // CProductTitleText(
                                        //   title: invController
                                        //       .topSoldItems[index].name,
                                        //   smallSize: true,
                                        //   txtColor: CColors.white,
                                        // ),
                                        CRoundedContainer(
                                          bgColor: Colors.transparent,
                                          showBorder: false,
                                          width: 90.0,
                                          child: Column(
                                            children: [
                                              Text(
                                                invController
                                                    .topSoldItems[index].name,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .apply(
                                                      fontWeightDelta: 2,
                                                      color: CColors.white,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                              ),
                                              Text(
                                                '${invController.topSoldItems[index].qtySold} sold',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .labelMedium!
                                                    .apply(
                                                      color: CColors.white,
                                                    ),
                                                overflow: TextOverflow.fade,
                                                maxLines: 1,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnSections,
                  ),
                ],
              ),
            ),

            // CSectionHeading(
            //               showActionBtn: true,
            //               title: 'top sellers...',
            //               txtColor: CColors.white,
            //               btnTitle: 'gsheet inventory data',
            //               btnTxtColor: CColors.grey,
            //               editFontSize: true,
            //               onPressed: () {
            //                 Get.to(() => const GsheetsInvScreen());
            //               },
            //             ),
            //             const SizedBox(
            //               height: CSizes.spaceBtnItems,
            //             ),

            // CSectionHeading(
            //   showActionBtn: true,
            //   title: 'popular categories',
            //   txtColor: CColors.white,
            //   btnTitle: 'gsheet txns data',
            //   btnTxtColor: CColors.grey,
            //   editFontSize: true,
            //   onPressed: () {
            //     Get.to(() => const GsheetsTxnsScreen());
            //   },
            // ),
            // const SizedBox(
            //   height: CSizes.spaceBtnItems,
            // ),
            // CSectionHeading(
            //   showActionBtn: true,
            //   title: 'dels',
            //   txtColor: CColors.white,
            //   btnTitle: 'view all',
            //   btnTxtColor: CColors.grey,
            //   editFontSize: true,
            //   onPressed: () {
            //     Get.to(() => const CDels());
            //   },
            // ),
            // const SizedBox(
            //   height: CSizes.spaceBtnItems,
            // ),
            // CSectionHeading(
            //   showActionBtn: true,
            //   title: 'pending updates',
            //   txtColor: CColors.white,
            //   btnTitle: 'view all',
            //   btnTxtColor: CColors.grey,
            //   editFontSize: true,
            //   onPressed: () {
            //     Get.to(() => const InvForUpdates());
            //   },
            // ),
            // const SizedBox(
            //   height: CSizes.spaceBtnItems,
            // ),
            // CSectionHeading(
            //   showActionBtn: true,
            //   title: 'pending txns',
            //   txtColor: CColors.white,
            //   btnTitle: 'view all',
            //   btnTxtColor: CColors.grey,
            //   editFontSize: true,
            //   onPressed: () {
            //     Get.to(() => const TxnsForAppends());
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
