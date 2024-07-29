import 'package:c_ri/common/widgets/custom_shapes/containers/primary_header_container.dart';
import 'package:c_ri/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:c_ri/features/store/screens/home/widgets/home_appbar.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return const Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            CPrimaryHeaderContainer(
              child: Column(
                children: [
                  // -- ## HOME PAGE APP BAR ## --
                  CHomeAppBarWidget(),

                  SizedBox(
                    height: CSizes.spaceBtnSections,
                  ),

                  // -- ## SEARCH BAR ## --

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
