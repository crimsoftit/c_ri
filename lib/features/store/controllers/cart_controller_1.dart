import 'package:c_ri/features/store/models/cart_item_model.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/local_storage/storage_utility.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:get/get.dart';

class CCartController extends GetxController {
  static CCartController get instance => Get.find();

  /// -- variables --
  RxInt noOfCartItems = 0.obs;
  RxInt itemQtyInCart = 0.obs;
  RxDouble totalCartPrice = 0.0.obs;
  RxList<CCartItemModel> cartItems = <CCartItemModel>[].obs;

  /// -- add items to cart --
  void addToCart(CInventoryModel item) {
    // qty check
    if (itemQtyInCart.value < 1) {
      CPopupSnackBar.customToast(
        message: 'select quantity',
        forInternetConnectivityStatus: false,
      );
      return;
    }
    if (item.quantity < 1) {
      CPopupSnackBar.warningSnackBar(
        title: 'oh snap!',
        message: '${item.name} is out of stock!!',
      );
      return;
    }
    if (itemQtyInCart > item.quantity) {
      CPopupSnackBar.warningSnackBar(
        title: 'oh snap!',
        message: 'only ${item.quantity} items are stocked!',
      );
      return;
    }

    // convert the CInventoryModel to a CCartItemModel
    final selectedCartItem = convertInvToCartItem(item, itemQtyInCart.value);

    // check if selected cart item already exists in the cart
    int index = cartItems.indexWhere(
        (cartItem) => cartItem.productId == selectedCartItem.productId);

    if (index >= 0) {
      // item already added to cart
      cartItems[index].quantity = selectedCartItem.quantity;
    } else {
      cartItems.add(selectedCartItem);
    }

    // update cart for specific user
    updateCart();
    CPopupSnackBar.customToast(
      message: 'item successfully added to cart',
      forInternetConnectivityStatus: false,
    );
  }

  /// -- convert a CInventoryModel to a CCartItemModel --
  CCartItemModel convertInvToCartItem(CInventoryModel item, int quantity) {
    return CCartItemModel(
      productId: item.productId.toString(),
      pName: item.name,
      quantity: quantity,
      price: item.unitSellingPrice,
    );
  }

  /// -- update cart content --
  void updateCart() {
    updateCartTotals();
    saveCartItems();
    cartItems.refresh();
  }

  /// -- update cart totals --
  void updateCartTotals() {
    double computedTotalCartPrice = 0.0;
    int computedCartItemsCount = 0;

    for (var item in cartItems) {
      computedTotalCartPrice += (item.price) * item.quantity.toDouble();
      computedCartItemsCount += item.quantity;
    }

    totalCartPrice.value = computedTotalCartPrice;
    noOfCartItems.value = computedCartItemsCount;
  }

  /// -- save cart items to device storage --
  void saveCartItems() {
    final cartItemsStrings = cartItems.map((item) => item.toJson()).toList();
    CLocalStorage.instance().writeData('cartItems', cartItemsStrings);
  }

  /// -- fetch cart items from device storage --
  void fetchCartItems() {
    final cartItemsStrings =
        CLocalStorage.instance().readData<List<dynamic>>('cartItems');

    if (cartItemsStrings != null) {
      cartItems.assignAll(cartItemsStrings.map(
          (item) => CCartItemModel.fromJson(item as Map<String, dynamic>)));
      updateCartTotals();
    }
  }

  /// -- get a specific item's quantity in the cart --
  int getItemQtyInCart(String pId) {
    final foundCartItemQty = cartItems
        .where((item) => item.productId == pId)
        .fold(0, (previousValue, element) => previousValue + element.quantity);

    return foundCartItemQty;
  }

  /// -- clear cart content --
  void clearCart() {
    itemQtyInCart.value = 0;
    cartItems.clear();
    updateCart();
  }
}
