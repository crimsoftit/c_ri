import 'package:c_ri/common/widgets/products/cart/add_remove_btns.dart';
import 'package:c_ri/common/widgets/products/store_item.dart';
import 'package:c_ri/common/widgets/txt_widgets/product_price_txt.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CCartItems extends StatelessWidget {
  const CCartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final scrollController = ScrollController();
    return Scrollbar(
      thumbVisibility: true,
      controller: scrollController,
      child: ListView.separated(
        shrinkWrap: true,
        controller: scrollController,
        itemCount: 10,
        separatorBuilder: (_, __) {
          return SizedBox(
            height: CSizes.spaceBtnSections,
          );
        },
        itemBuilder: (_, index) {
          return Column(
            children: [
              CStoreItemWidget(),
              SizedBox(
                height: CSizes.spaceBtnItems / 2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // -- some extra space --
                      SizedBox(
                        width: 40.0,
                      ),
                      // -- buttons to increment, decrement qty --
                      CItemQtyWithAddRemoveBtns(),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 8.0,
                    ),
                    child: CProductPriceTxt(
                      price: '256',
                      isLarge: true,
                      //txtColor: CColors.black,
                    ),
                  ),
                  // SizedBox(
                  //   width: 10.0,
                  // ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
