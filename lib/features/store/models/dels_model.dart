// ignore_for_file: unnecessary_getters_setters

class CDelsModel {
  int? _itemId;
  String _category = "";

  CDelsModel(
    this._itemId,
    this._category,
  );

  int? get itemId => _itemId;
  String get category => _category;

  set itemId(int? newId) {
    _itemId = newId;
  }

  set category(String newCategory) {
    _category = newCategory;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['itemId'] = _itemId;
    map['itemCategory'] = _category;

    return map;
  }

  CDelsModel.fromMapObject(Map<String, dynamic> map) {
    _itemId = map['itemId'];
    _category = map['itemCategory'];
  }
}
