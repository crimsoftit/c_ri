import 'package:c_ri/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:c_ri/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CPrimaryHeaderContainer extends StatelessWidget {
  const CPrimaryHeaderContainer({
    super.key,
    required this.child,
    this.height,
  });

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CCurvedEdgeWidget(
      child: Container(
        color: CColors.primaryBrown,
        padding: const EdgeInsets.all(0),
        height: height,
        child: Stack(
          children: [
            // -- background custom shapes
            Positioned(
              top: -150,
              right: -250,
              child: CCircularContainer(
                bgColor: CColors.txtWhite.withOpacity(0.1),
              ),
            ),
            Positioned(
              top: 100,
              right: -300,
              child: CCircularContainer(
                bgColor: CColors.txtWhite.withOpacity(0.1),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}
