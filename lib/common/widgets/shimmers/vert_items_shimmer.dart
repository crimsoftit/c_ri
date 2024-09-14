import 'package:c_ri/common/widgets/layouts/list_layout.dart';
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
    return CListViewLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) {
        return const SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                children: [
                  CShimmerEffect(
                    width: 170.0,
                    height: 15.0,
                  ),
                  SizedBox(
                    height: CSizes.spaceBtnItems / 2,
                  ),
                  CShimmerEffect(
                    width: 150.0,
                    height: 15.0,
                  ),
                  SizedBox(
                    height: CSizes.spaceBtnItems / 2,
                  ),
                  CShimmerEffect(
                    width: 140.0,
                    height: 15.0,
                  ),
                ],
              ),
              SizedBox(
                width: CSizes.spaceBtnItems,
              ),

              // -- trailing icon section
              CShimmerEffect(
                width: 15.0,
                height: 26.0,
                radius: 5.0,
              ),
            ],
          ),
        );
      },
    );
  }
}
