// ignore_for_file: unnecessary_getters_setters

class CInventoryModel {
  int? _productId;

  String _userId = "";
  String _userEmail = "";
  String _userName = "";

  String _pCode = "";
  String _name = "";
  int _quantity = 0;
  double _buyingPrice = 0.0;
  double _unitSellingPrice = 0.0;
  String _date = "";

  CInventoryModel(
    //this._productId,
    this._userId,
    this._userEmail,
    this._userName,
    this._pCode,
    this._name,
    this._quantity,
    this._buyingPrice,
    this._unitSellingPrice,
    this._date,
  );

  CInventoryModel.withID(
    this._productId,
    this._userId,
    this._userEmail,
    this._userName,
    this._pCode,
    this._name,
    this._quantity,
    this._buyingPrice,
    this._unitSellingPrice,
    this._date,
  );

  // CInventoryModel copy({
  //   String? strProductId,
  //   String? roductId,
  // }) {
  //   return CInventoryModel.withID(
  //     _productId ?? ,
  //     _userId,
  //     _userEmail,
  //     _userName,
  //     _pCode,
  //     _name,
  //     _quantity,
  //     _buyingPrice,
  //     _unitSellingPrice,
  //     _date,
  //   );
  // }

  int? get productId => _productId;
  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;

  String get pCode => _pCode;
  String get name => _name;
  int get quantity => _quantity;
  double get buyingPrice => _buyingPrice;
  double get unitSellingPrice => _unitSellingPrice;
  String get date => _date;

  static List<String> getHeaders() {
    return [
      'productId',
      'userId',
      'userEmail',
      'userName',
      'pCode',
      'name',
      'quantity',
      'buyingPrice',
      'unitSellingPrice',
      'date',
    ];
  }

  set userId(String newUid) {
    _userId = newUid;
  }

  set userEmail(String newUEmail) {
    _userEmail = newUEmail;
  }

  set userName(String newUName) {
    _userName = newUName;
  }

  set productId(int? newId) {
    _productId = newId;
  }

  set pCode(String newPcode) {
    _pCode = newPcode;
  }

  set name(String newName) {
    if (newName.length <= 255 || newName.length >= 3) {
      _name = newName;
    }
  }

  set quantity(int newQty) {
    if (newQty > 0) {
      _quantity = newQty;
    }
  }

  set buyingPrice(double newBP) {
    if (newBP >= 1.0) {
      _buyingPrice = newBP;
    }
  }

  set unitSellingPrice(double newUSP) {
    if (newUSP >= 1.0) {
      _unitSellingPrice = newUSP;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // convert an InventoryModel object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (productId != null) {
      map['productId'] = _productId;
    }
    map['userId'] = _userId;
    map['userEmail'] = _userEmail;
    map['userName'] = _userName;

    map['pCode'] = _pCode;
    map['name'] = _name;
    map['quantity'] = _quantity;
    map['buyingPrice'] = _buyingPrice;
    map['unitSellingPrice'] = _unitSellingPrice;
    map['date'] = _date;

    return map;
  }

  // extract a InventoryModel object from a Map object
  CInventoryModel.fromMapObject(Map<String, dynamic> map) {
    _productId = map['productId'];
    _userId = map['userId'];
    _userEmail = map['userEmail'];
    _userName = map['userName'];

    _name = map['name'];
    _pCode = map['pCode'];
    _quantity = map['quantity'];
    _buyingPrice = map['buyingPrice'];
    _unitSellingPrice = map['unitSellingPrice'];
    _date = map['date'];
  }
}
