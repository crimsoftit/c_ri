class CCartItemModel {
  String productId;
  String pName;
  int quantity;
  double price;

  CCartItemModel({
    required this.productId,
    this.pName = '',
    required this.quantity,
    this.price = 0.0,
  });

  /// -- empty cart --
  static CCartItemModel empty() {
    return CCartItemModel(
      productId: '',
      quantity: 0,
    );
  }

  /// -- convert a CartItem to a JSON map --
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'pName': pName,
      'quantity': quantity,
      'price': price,
    };
  }

  /// -- create a CartItem from a JSON map --
  factory CCartItemModel.fromJson(Map<String, dynamic> json) {
    return CCartItemModel(
      productId: json['productId'],
      pName: json['pName'],
      quantity: json['quantity'],
      price: json['price'],
    );
  }
}
