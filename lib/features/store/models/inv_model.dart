// ignore_for_file: unnecessary_getters_setters

class CInventoryModel {
  int? _id;
  String _pCode = "";
  String _name = "";
  int _quantity = 0;
  int _buyingPrice = 0;
  int _unitSellingPrice = 0;
  String _date = "";

  CInventoryModel(
    //this._id,
    this._pCode,
    this._name,
    this._quantity,
    this._buyingPrice,
    this._unitSellingPrice,
    this._date,
  );

  CInventoryModel.withID(
    this._id,
    this._pCode,
    this._name,
    this._quantity,
    this._buyingPrice,
    this._unitSellingPrice,
    this._date,
  );

  int? get id => _id;
  String get pCode => _pCode;
  String get name => _name;
  int get quantity => _quantity;
  int get buyingPrice => _buyingPrice;
  int get unitSellingPrice => _unitSellingPrice;
  String get date => _date;

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

  set buyingPrice(int newBP) {
    if (newBP >= 5) {
      _buyingPrice = newBP;
    }
  }

  set unitSellingPrice(int newUSP) {
    if (newUSP >= 5) {
      _unitSellingPrice = newUSP;
    }
  }

  set date(String newDate) {
    _date = newDate;
  }

  // convert an InventoryModel object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (id != null) {
      map['id'] = _id;
    }
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
    _id = map['id'];
    _name = map['name'];
    _pCode = map['pCode'];
    _quantity = map['quantity'];
    _buyingPrice = map['buyingPrice'];
    _unitSellingPrice = map['unitSellingPrice'];
    _date = map['date'];
  }
}
