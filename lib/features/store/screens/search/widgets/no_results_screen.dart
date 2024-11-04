import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class NoSearchResultsScreen extends StatelessWidget {
  const NoSearchResultsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const Icon(
            Icons.search_off_outlined,
            size: CSizes.iconLg * 3,
            color: CColors.rBrown,
          ),
          const SizedBox(
            height: CSizes.spaceBtnSections,
          ),
          Text(
            'search results not found!',
            style: Theme.of(context).textTheme.labelLarge!.apply(
                //fontWeightDelta: 1,
                ),
          ),
        ],
      ),
    );
  }
}
