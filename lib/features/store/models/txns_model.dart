// ignore_for_file: unnecessary_getters_setters

class CTxnsModel {
  String _userId = "";
  String _userEmail = "";
  String _userName = "";
  int? _txnId;
  int _productId = 0;
  String _productCode = "";
  String _productName = "";
  int _quantity = 0;
  double _totalAmount = 0.0;
  double _amountIssued = 0.0;
  double _unitSellingPrice = 0.0;
  String _paymentMethod = "";
  String _customerName = "";
  String _customerContacts = "";
  String _txnAddress = "";
  String _txnAddressCoordinates = "";
  String _date = "";
  int _isSynced = 0;
  String _syncAction = "";
  String _txnStatus = "";

  CTxnsModel(
    this._userId,
    this._userEmail,
    this._userName,
    this._productId,
    this._productCode,
    this._productName,
    this._quantity,
    this._totalAmount,
    this._amountIssued,
    this._unitSellingPrice,
    this._paymentMethod,
    this._customerName,
    this._customerContacts,
    this._txnAddress,
    this._txnAddressCoordinates,
    this._date,
    this._isSynced,
    this._syncAction,
    this._txnStatus,
  );

  CTxnsModel.withId(
    this._txnId,
    this._userId,
    this._userEmail,
    this._userName,
    this._productId,
    this._productCode,
    this._productName,
    this._quantity,
    this._totalAmount,
    this._amountIssued,
    this._unitSellingPrice,
    this._paymentMethod,
    this._customerName,
    this._customerContacts,
    this._txnAddress,
    this._txnAddressCoordinates,
    this._date,
    this._isSynced,
    this._syncAction,
    this._txnStatus,
  );

  static List<String> getHeaders() {
    return [
      'txnId',
      'userId',
      'userEmail',
      'userName',
      'productId',
      'productCode',
      'productName',
      'quantity',
      'totalAmount',
      'amountIssued',
      'unitSellingPrice',
      'paymentMethod',
      'customerName',
      'customerContacts',
      'txnAddress',
      'txnAddressCoordinates',
      'date',
      'isSynced',
      'syncAction',
      'txnStatus',
    ];
  }

  int? get txnId => _txnId;

  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;
  int get productId => _productId;
  String get productCode => _productCode;
  String get productName => _productName;
  int get quantity => _quantity;
  double get totalAmount => _totalAmount;
  double get amountIssued => _amountIssued;
  double get unitSellingPrice => _unitSellingPrice;
  String get paymentMethod => _paymentMethod;
  String get customerName => _customerName;
  String get customerContacts => _customerContacts;
  String get txnAddress => _txnAddress;
  String get txnAddressCoordinates => _txnAddressCoordinates;
  String get date => _date;
  int get isSynced => _isSynced;
  String get syncAction => _syncAction;
  String get txnStatus => _txnStatus;

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

  set amountIssued(double newAmountIssued) {
    if (newAmountIssued > 0) {
      _amountIssued = newAmountIssued;
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

  set txnAddress(String newTxnAddress) {
    _txnAddress = newTxnAddress;
  }

  set txnAddressCoordinates(String newTxnAddressCoordinates) {
    _txnAddressCoordinates = newTxnAddressCoordinates;
  }

  set date(String newDate) {
    _date = newDate;
  }

  set isSynced(int syncStatus) {
    _isSynced = syncStatus;
  }

  set syncAction(String newSyncAction) {
    _syncAction = newSyncAction;
  }

  set txnStatus(String newTxnStatus) {
    _txnStatus = newTxnStatus;
  }

  // convert a SoldItemsModel Object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (txnId != null) {
      map['txnId'] = _txnId;
    }
    map['userId'] = _userId;
    map['userEmail'] = _userEmail;
    map['userName'] = _userName;

    map['productId'] = _productId;
    map['productCode'] = _productCode;
    map['productName'] = _productName;
    map['quantity'] = _quantity;
    map['totalAmount'] = _totalAmount;
    map['amountIssued'] = _amountIssued;
    map['unitSellingPrice'] = _unitSellingPrice;
    map['paymentMethod'] = _paymentMethod;
    map['customerName'] = _customerName;
    map['customerContacts'] = _customerContacts;
    map['txnAddress'] = _txnAddress;
    map['txnAddressCoordinates'] = _txnAddressCoordinates;
    map['date'] = _date;
    map['isSynced'] = _isSynced;
    map['syncAction'] = _syncAction;
    map['txnStatus'] = _txnStatus;

    return map;
  }

  // extract a SoldItemsModel object from a Map object
  CTxnsModel.fromMapObject(Map<String, dynamic> map) {
    _txnId = map['txnId'];
    _userId = map['userId'];
    _userEmail = map['userEmail'];
    _userName = map['userName'];
    _productId = map['productId'];
    _productCode = map['productCode'];
    _productName = map['productName'];
    _quantity = map['quantity'];
    _totalAmount = map['totalAmount'];
    _amountIssued = map['amountIssued'];
    _unitSellingPrice = map['unitSellingPrice'];
    _paymentMethod = map['paymentMethod'];
    _customerName = map['customerName'];
    _customerContacts = map['customerContacts'];
    _txnAddress = map['txnAddress'];
    _txnAddressCoordinates = map['txnAddressCoordinates'];
    _date = map['date'];
    _isSynced = map['isSynced'];
    _syncAction = map['syncAction'];
    _txnStatus = map['txnStatus'];
  }
}
