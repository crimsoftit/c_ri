import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CCircleAvatar extends StatelessWidget {
  const CCircleAvatar({
    super.key,
    this.bgColor = CColors.rBrown,
    this.txtColor = CColors.white,
    this.radius = 16.0,
    required this.avatarInitial,
  });

  final String avatarInitial;
  final Color? bgColor, txtColor;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: bgColor,
      // backgroundColor: Colors.brown[300],
      radius: radius,
      child: Text(
        avatarInitial.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge!.apply(
              color: txtColor,
            ),
      ),
    );
  }
}
