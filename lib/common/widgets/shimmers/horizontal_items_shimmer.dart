import 'package:c_ri/common/widgets/shimmers/shimmer_effects.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CHorizontalProductShimmer extends StatelessWidget {
  const CHorizontalProductShimmer({
    super.key,
    this.itemCount = 4,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        bottom: CSizes.spaceBtnSections,
      ),
      height: 50.0,
      child: ListView.separated(
        itemCount: itemCount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return const SizedBox(
            height: CSizes.spaceBtnItems * 2,
          );
        },
        itemBuilder: (_, __) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // -- product initials section --
              CShimmerEffect(
                width: 40.0,
                height: 40.0,
                radius: 40.0,
              ),
              SizedBox(
                width: CSizes.spaceBtnItems,
              ),

              // -- text section --
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: CSizes.spaceBtnItems / 2,
                  ),
                  CShimmerEffect(
                    width: 200.0,
                    height: 15.0,
                  ),
                  SizedBox(
                    height: CSizes.spaceBtnItems / 2,
                  ),
                  CShimmerEffect(
                    width: 180.0,
                    height: 15.0,
                  ),
                  Spacer(),
                ],
              ),

              SizedBox(
                width: CSizes.spaceBtnItems,
              ),

              // -- trailing icon section
              CShimmerEffect(
                width: 15.0,
                height: 30.0,
              ),
            ],
          );
        },
      ),
    );
  }
}
