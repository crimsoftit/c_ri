class InvSheetFields {
  static const String productId = 'productId';
  static const String userId = 'userId';
  static const String userEmail = 'userEmail';
  static const String userName = 'userName';
  static const String pCode = 'pCode';
  static const String name = 'name';
  static const String quantity = 'quantity';
  static const String qtySold = 'qtySold';
  static const String buyingPrice = 'buyingPrice';
  static const String unitBp = 'unitBp';
  static const String unitSellingPrice = 'unitSellingPrice';
  static const String date = 'date';
  static const String isSynced = 'isSynced';
  static const String syncAction = 'syncAction';

  static List<String> getInvSheetHeaders() {
    return [
      productId,
      userId,
      userEmail,
      userName,
      pCode,
      name,
      quantity,
      qtySold,
      buyingPrice,
      unitBp,
      unitSellingPrice,
      date,
      isSynced,
      syncAction,
    ];
  }
}
