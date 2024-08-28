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
      height: 120.0,
      child: ListView.separated(
        itemCount: itemCount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return const SizedBox(
            width: CSizes.spaceBtnItems,
          );
        },
        itemBuilder: (_, __) {
          return const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // -- image section --
              CShimmerEffect(
                width: 120.0,
                height: 120.0,
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
                    width: 160.0,
                    height: 15.0,
                  ),
                  SizedBox(
                    height: CSizes.spaceBtnItems / 2,
                  ),
                  CShimmerEffect(
                    width: 110.0,
                    height: 15.0,
                  ),
                  SizedBox(
                    height: CSizes.spaceBtnItems / 2,
                  ),
                  CShimmerEffect(
                    width: 80.0,
                    height: 15.0,
                  ),
                  Spacer(),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
