// ignore_for_file: unnecessary_getters_setters

class CDelsModel {
  int? _itemId;
  String _itemName = "";
  String _category = "";

  CDelsModel(
    this._itemId,
    this._itemName,
    this._category,
  );

  int? get itemId => _itemId;
  String get itemName => _itemName;
  String get category => _category;

  set itemId(int? newId) {
    _itemId = newId;
  }

  set itemName(String newItemName) {
    itemName = newItemName;
  }

  set category(String newCategory) {
    _category = newCategory;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['itemId'] = _itemId;
    map['itemName'] = _itemName;
    map['itemCategory'] = _category;

    return map;
  }

  CDelsModel.fromMapObject(Map<String, dynamic> map) {
    _itemId = map['itemId'];
    _itemName = map['itemName'];
    _category = map['itemCategory'];
  }
}
