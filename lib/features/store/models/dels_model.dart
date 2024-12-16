// ignore_for_file: unnecessary_getters_setters

class CDelsModel {
  int? _itemId;
  String _itemName = "";
  String _category = "";
  int _isSynced = 0;

  CDelsModel(
    this._itemId,
    this._itemName,
    this._category,
    this._isSynced,
  );

  int? get itemId => _itemId;
  String get itemName => _itemName;
  String get category => _category;
  int get isSynced => _isSynced;

  set itemId(int? newId) {
    _itemId = newId;
  }

  set itemName(String newItemName) {
    itemName = newItemName;
  }

  set category(String newCategory) {
    _category = newCategory;
  }

  set isSynced(int syncStatus) {
    _isSynced = syncStatus;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['itemId'] = _itemId;
    map['itemName'] = _itemName;
    map['itemCategory'] = _category;
    map['isSynced'] = _isSynced;

    return map;
  }

  CDelsModel.fromMapObject(Map<String, dynamic> map) {
    _itemId = map['itemId'];
    _itemName = map['itemName'];
    _category = map['itemCategory'];
    _isSynced = map['isSynced'];
  }
}
