import 'package:c_ri/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:c_ri/common/widgets/layouts/grid_layout.dart';
import 'package:flutter/material.dart';

class CInvGridviewScreen extends StatelessWidget {
  const CInvGridviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CGridLayout(
        itemCount: 3,
        itemBuilder: (BuildContext context, int index) {
          return CRoundedContainer();
        },
      ),
    );
  }
}
