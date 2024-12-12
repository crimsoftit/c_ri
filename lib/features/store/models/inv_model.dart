// ignore_for_file: unnecessary_getters_setters

import 'dart:convert';

import 'package:c_ri/features/store/models/gsheet_models/inv_sheet_fields.dart';

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
  int _isSynced = 0;

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
    this._isSynced,
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
    this._isSynced,
  );

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
  int get isSynced => _isSynced;

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

  set isSynced(int syncState) {
    _isSynced = syncState;
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
    map['isSynced'] = _isSynced;

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
    _isSynced = map['isSynced'];
  }

  // extract a InventoryModel object from a GSheet Map object
  static CInventoryModel gSheetFromJson(Map<String, dynamic> json) {
    return CInventoryModel.withID(
      jsonDecode(json[InvSheetFields.productId]),
      json[InvSheetFields.userId],
      json[InvSheetFields.userEmail],
      json[InvSheetFields.userName],
      json[InvSheetFields.pCode],
      json[InvSheetFields.name],
      jsonDecode(json[InvSheetFields.quantity]),
      double.parse(json[InvSheetFields.buyingPrice]),
      double.parse(json[InvSheetFields.unitSellingPrice]),
      json[InvSheetFields.date],
      json[InvSheetFields.isSynced],
    );
  }
}
