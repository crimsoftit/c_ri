import 'package:c_ri/common/widgets/products/circle_avatar.dart';
import 'package:c_ri/common/widgets/txt_widgets/product_title_txt.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:c_ri/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CStoreItemWidget extends StatelessWidget {
  const CStoreItemWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Row(
      children: [
        CCircleAvatar(
          title: 'K',
          txtColor: isDarkTheme ? CColors.rBrown : CColors.white,
          bgColor: isDarkTheme ? CColors.white : CColors.rBrown,
        ),
        SizedBox(
          width: CSizes.spaceBtnInputFields,
        ),
        Expanded(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- item title, price, and stock count --
              CProductTitleText(
                title: DateTime.now().toString(),
                smallSize: true,
              ),
              Flexible(
                fit: FlexFit.loose,
                child: CProductTitleText(
                  title: 'KIFARU MATCHES',
                  smallSize: false,
                ),
              ),

              // -- item attributes --
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '100 stocked',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    TextSpan(
                      text: 'usp: Ksh.20.00',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    TextSpan(
                      text: 'code: 6009607673321',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
