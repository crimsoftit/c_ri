import 'package:c_ri/common/widgets/products/cart/add_remove_btns.dart';
import 'package:c_ri/common/widgets/products/store_item.dart';
import 'package:c_ri/common/widgets/txt_widgets/product_price_txt.dart';
import 'package:c_ri/features/store/controllers/cart_controller.dart';
import 'package:c_ri/utils/constants/colors.dart';
import 'package:c_ri/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CCartItems extends StatelessWidget {
  const CCartItems({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());

    final scrollController = ScrollController();

    return Obx(
      () {
        return Scrollbar(
          thumbVisibility: true,
          controller: scrollController,
          child: ListView.separated(
            shrinkWrap: true,
            controller: scrollController,
            itemCount: cartController.cartItems.length,
            separatorBuilder: (_, __) {
              return SizedBox(
                height: CSizes.spaceBtnSections / 4,
              );
            },
            itemBuilder: (_, index) {
              final item = cartController.cartItems[index];
              cartController.qtyFieldControllers.add(TextEditingController());
              return Column(
                children: [
                  CStoreItemWidget(
                    cartItem: item,
                  ),
                  SizedBox(
                    height: CSizes.spaceBtnItems / 4,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          // -- some extra space --
                          SizedBox(
                            width: 45.0,
                          ),
                          // -- buttons to increment, decrement qty --
                          CItemQtyWithAddRemoveBtns(
                            qtyFieldInitialValue: cartController
                                .cartItems[index].quantity
                                .toString(),
                            qtyfieldController:
                                cartController.qtyFieldControllers[index],
                            onBtnChanged: () {
                              cartController.qtyFieldControllers[index].text =
                                  'r';
                            },
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                          right: 8.0,
                        ),
                        child: CProductPriceTxt(
                          price:
                              cartController.cartItems[index].price.toString(),
                          isLarge: true,
                          txtColor: CColors.rBrown,
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
      },
    );
  }
}
