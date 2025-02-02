import 'package:flutter/material.dart';

class CProductTitleText extends StatelessWidget {
  const CProductTitleText({
    super.key,
    required this.title,
    this.maxLines = 1,
    this.txtAlign = TextAlign.left,
    this.smallSize = false,
  });

  final String title;
  final bool smallSize;
  final int maxLines;
  final TextAlign? txtAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: smallSize
          ? Theme.of(context).textTheme.labelSmall
          : Theme.of(context).textTheme.titleSmall,
      overflow: TextOverflow.ellipsis,
      maxLines: maxLines,
      textAlign: txtAlign,
    );
  }
}
