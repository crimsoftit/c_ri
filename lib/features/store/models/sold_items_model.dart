// ignore_for_file: unnecessary_getters_setters

class CSoldItemsModel {
  String _userId = "";
  String _userEmail = "";
  String _userName = "";
  int? _saleId;
  int _productId = 0;
  String _productCode = "";
  String _productName = "";
  int _quantity = 0;
  double _totalAmount = 0.0;
  double _unitSellingPrice = 0.0;
  String _paymentMethod = "";
  String _customerName = "";
  String _customerContacts = "";
  String _date = "";

  CSoldItemsModel(
    this._userId,
    this._userEmail,
    this._userName,
    this._productId,
    this._productCode,
    this._productName,
    this._quantity,
    this._totalAmount,
    this._unitSellingPrice,
    this._paymentMethod,
    this._customerName,
    this._customerContacts,
    this._date,
  );

  CSoldItemsModel.withId(
    this._saleId,
    this._userId,
    this._userEmail,
    this._userName,
    this._productId,
    this._productCode,
    this._productName,
    this._quantity,
    this._totalAmount,
    this._unitSellingPrice,
    this._paymentMethod,
    this._customerName,
    this._customerContacts,
    this._date,
  );

  static List<String> getHeaders() {
    return [
      'saleId',
      'userId',
      'userEmail',
      'userName',
      'productId',
      'productCode',
      'productName',
      'quantity',
      'totalAmount',
      'unitSellingPrice',
      'paymentMethod',
      'customerName',
      'customerContacts',
      'date',
    ];
  }

  int? get saleId => _saleId;

  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;
  int get productId => _productId;
  String get productCode => _productCode;
  String get productName => _productName;
  int get quantity => _quantity;
  double get totalAmount => _totalAmount;
  double get unitSellingPrice => _unitSellingPrice;
  String get paymentMethod => _paymentMethod;
  String get customerName => _customerName;
  String get customerContacts => _customerContacts;
  String get date => _date;

  // set saleId(int newSaleId) {
  //   _saleId = newSaleId;
  // }

  set userId(String newUid) {
    _userId = newUid;
  }

  set userEmail(String newUEmail) {
    _userEmail = newUEmail;
  }

  set userName(String newUName) {
    _userName = newUName;
  }

  set productId(int newPId) {
    productId = newPId;
  }

  set productCode(String newPcode) {
    _productCode = newPcode;
  }

  set productName(String newPname) {
    _productName = newPname;
  }

  set quantity(int newQty) {
    if (newQty >= 1) {
      _quantity = newQty;
    }
  }

  set totalAmount(double newtotalAmount) {
    if (newtotalAmount >= 0) {
      _totalAmount = newtotalAmount;
    }
  }

  set unitSellingPrice(double newUsp) {
    if (newUsp >= 0) {
      _unitSellingPrice = newUsp;
    }
  }

  set paymentMethod(String newPaymentMethod) {
    if (newPaymentMethod != '') {
      _paymentMethod = newPaymentMethod;
    }
  }

  set customerName(String newCustomerName) {
    _customerName = newCustomerName;
  }

  set customerContacts(String newCustomerContacts) {
    _customerContacts = newCustomerContacts;
  }

  set date(String newDate) {
    _date = newDate;
  }

  // convert a SoldItemsModel Object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (saleId != null) {
      map['saleId'] = _saleId;
    }
    map['userId'] = _userId;
    map['userEmail'] = _userEmail;
    map['userName'] = _userName;

    map['productId'] = _productId;
    map['productCode'] = _productCode;
    map['productName'] = _productName;
    map['quantity'] = _quantity;
    map['totalAmount'] = _totalAmount;
    map['unitSellingPrice'] = _unitSellingPrice;
    map['paymentMethod'] = _paymentMethod;
    map['customerName'] = _customerName;
    map['customerContacts'] = _customerContacts;
    map['date'] = _date;

    return map;
  }

  // extract a SoldItemsModel object from a Map object
  CSoldItemsModel.fromMapObject(Map<String, dynamic> map) {
    _saleId = map['saleId'];
    _userId = map['userId'];
    _userEmail = map['userEmail'];
    _userName = map['userName'];
    _productId = map['productId'];
    _productCode = map['productCode'];
    _productName = map['productName'];
    _quantity = map['quantity'];
    _totalAmount = map['totalAmount'];
    _unitSellingPrice = map['unitSellingPrice'];
    _paymentMethod = map['paymentMethod'];
    _customerName = map['customerName'];
    _customerContacts = map['customerContacts'];
    _date = map['date'];
  }
}
