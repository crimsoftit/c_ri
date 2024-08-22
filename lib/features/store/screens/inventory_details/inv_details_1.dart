import 'package:c_ri/common/widgets/appbar/app_bar.dart';
import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/icon_buttons/trailing_icon_btn.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CInventoryDetailsScreen1 extends StatelessWidget {
  const CInventoryDetailsScreen1({
    super.key,
    required this.inventoryItem,
  });

  final CInventoryModel inventoryItem;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    //final inventoryController = Get.put(CInventoryController());

    return Scaffold(
      /// -- app bar --
      appBar: CAppBar(
        showBackArrow: true,
        backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
        title: Text(
          inventoryItem.name,
          style: Theme.of(context).textTheme.headlineSmall!.apply(
                fontSizeFactor: 0.7,
              ),
        ),
        actions: [
          // -- edit item button
          CTrailingIconBtn(
            iconColor: CColors.white,
            iconData: Iconsax.edit,
            onPressed: () {},
          ),
        ],
      ),
      body: const SingleChildScrollView(
        child: Column(
          children: [
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  SizedBox(
                    height: CSizes.spaceBtnSections,
                  ),

                  // -- ## ALL ABOUT CATEGORIES ## --
                  Padding(
                    padding: EdgeInsets.only(
                      left: CSizes.defaultSpace,
                    ),
                    child: Column(
                      children: [
                        // -- category heading --
                        CSectionHeading(
                          showActionBtn: true,
                          title: 'popular categories',
                          txtColor: CColors.white,
                          btnTitle: 'view all',
                          btnTxtColor: CColors.grey,
                          editFontSize: true,
                        ),
                        SizedBox(
                          height: CSizes.spaceBtnItems,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: CSizes.spaceBtnSections,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
