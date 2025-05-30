import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CExpansionTile extends StatelessWidget {
  const CExpansionTile({
    super.key,
    required this.avatarTxt,
    required this.titleTxt,
    required this.subTitleTxt1Item1,
    required this.subTitleTxt1Item2,
    required this.subTitleTxt2Item1,
    required this.subTitleTxt2Item2,
    required this.subTitleTxt3Item1,
    required this.subTitleTxt3Item2,
    this.btn1NavAction,
    this.btn1Txt = '',
    this.btn2Txt = '',
    this.btn1Icon,
    this.btn2Icon,
    this.btn2NavAction,
  });

  final String avatarTxt;
  final String titleTxt;
  final String subTitleTxt1Item1;
  final String subTitleTxt1Item2;
  final String subTitleTxt2Item1;
  final String subTitleTxt2Item2;
  final String subTitleTxt3Item1;
  final String subTitleTxt3Item2;
  final String btn1Txt, btn2Txt;
  final VoidCallback? btn1NavAction, btn2NavAction;
  final Icon? btn1Icon, btn2Icon;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return ExpansionTile(
      title: ListTile(
        horizontalTitleGap: 10,
        contentPadding: const EdgeInsets.all(
          5.0,
        ),
        leading: CircleAvatar(
          backgroundColor: Colors.brown[300],
          radius: 16.0,
          child: Text(
            avatarTxt,
            style: Theme.of(context).textTheme.labelLarge!.apply(
                  color: CColors.white,
                ),
          ),
        ),
        title: Text(
          titleTxt,
          style: Theme.of(context).textTheme.labelMedium!.apply(
                color: isDarkTheme ? CColors.white : CColors.rBrown,
                //fontSizeFactor: 1.2,
                //fontWeightDelta: 2,
              ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              '$subTitleTxt1Item1 $subTitleTxt1Item2',
              style: Theme.of(context).textTheme.labelMedium!.apply(
                    color: isDarkTheme
                        ? CColors.white
                        : CColors.rBrown.withValues(alpha: 0.8),
                    //fontStyle: FontStyle.italic,
                  ),
            ),
            Text(
              '$subTitleTxt2Item1 $subTitleTxt2Item2',
              style: Theme.of(context).textTheme.labelMedium!.apply(
                    color: isDarkTheme
                        ? CColors.white
                        : CColors.rBrown.withValues(alpha: 0.8),
                    //fontStyle: FontStyle.italic,
                  ),
            ),
            Text(
              '$subTitleTxt3Item1 $subTitleTxt3Item2',
              style: Theme.of(context).textTheme.labelSmall!.apply(
                    color: isDarkTheme
                        ? CColors.white
                        : CColors.rBrown.withValues(alpha: 0.7),
                    //fontStyle: FontStyle.italic,
                  ),
            ),
          ],
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
          ),
          child: Row(
            children: [
              SizedBox(
                child: TextButton.icon(
                  label: Text(
                    btn1Txt,
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                          color: isDarkTheme ? CColors.white : CColors.rBrown,
                        ),
                  ),
                  icon: Icon(
                    Iconsax.info_circle,
                    color: isDarkTheme ? CColors.white : CColors.rBrown,
                  ),
                  onPressed: btn1NavAction,
                ),
              ),
              const SizedBox(
                width: CSizes.spaceBtnInputFields,
              ),
              SizedBox(
                child: TextButton.icon(
                  label: Text(
                    btn2Txt,
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                          color: isDarkTheme ? CColors.white : CColors.rBrown,
                        ),
                  ),
                  icon: btn2Icon,
                  onPressed: btn2NavAction,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
