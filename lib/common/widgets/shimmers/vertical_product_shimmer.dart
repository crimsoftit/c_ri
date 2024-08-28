import 'package:c_ri/common/widgets/layouts/grid_layout.dart';
import 'package:c_ri/common/widgets/shimmers/shimmer_effects.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CVerticalProductShimmer extends StatelessWidget {
  const CVerticalProductShimmer({
    super.key,
    required this.itemCount,
  });

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return CGridLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) {
        return const SizedBox(
          width: 180.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- image section --
              CShimmerEffect(
                width: 160.0,
                height: 160.0,
              ),

              SizedBox(
                height: CSizes.spaceBtnItems,
              ),

              // -- text section --
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
            ],
          ),
        );
      },
    );
  }
}
