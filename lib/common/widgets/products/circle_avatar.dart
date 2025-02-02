import 'package:c_ri/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CCircleAvatar extends StatelessWidget {
  const CCircleAvatar({
    super.key,
    required this.title,
    this.bgColor = CColors.rBrown,
    this.txtColor = CColors.white,
  });

  final String title;
  final Color? bgColor, txtColor;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: bgColor,
      // backgroundColor: Colors.brown[300],
      radius: 16.0,
      child: Text(
        'K',
        style: Theme.of(context).textTheme.labelLarge!.apply(
              color: txtColor,
            ),
      ),
    );
  }
}
