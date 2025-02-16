class CCartItemModel {
  int productId;
  String pName, pCode;
  int quantity;
  int availableStockQty;
  double price;

  CCartItemModel({
    required this.productId,
    this.pName = '',
    required this.pCode,
    required this.quantity,
    required this.availableStockQty,
    this.price = 0.0,
  });

  /// -- empty cart --
  static CCartItemModel empty() {
    return CCartItemModel(
      pCode: '',
      productId: 0,
      quantity: 0,
      availableStockQty: 0,
    );
  }

  /// -- convert a CartItem to a JSON map --
  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'pCode': pCode,
      'pName': pName,
      'quantity': quantity,
      'availableStockQty': availableStockQty,
      'price': price,
    };
  }

  /// -- create a CartItem from a JSON map --
  factory CCartItemModel.fromJson(Map<String, dynamic> json) {
    return CCartItemModel(
      productId: json['productId'],
      pCode: json['pCode'],
      pName: json['pName'],
      quantity: json['quantity'],
      availableStockQty: json['availableStockQty'],
      price: json['price'],
    );
  }
}
