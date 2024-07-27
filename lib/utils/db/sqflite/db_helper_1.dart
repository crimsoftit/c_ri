import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/features/store/models/sold_items_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;

  Database? db;

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();

  // make this a singleton class
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (db != null) {
      return db!;
    }
    db = await openDatabase(join(await getDatabasesPath(), 'stock.db'),
        onCreate: (database, version) {
      database.execute('''
          CREATE TABLE inventory (
            id INTEGER,
            pCode CHAR(30) NOT NULL PRIMARY KEY,
            name CHAR(30) NOT NULL,
            quantity INTEGER NOT NULL,
            buyingPrice INTEGER NOT NULL,
            unitSellingPrice INTEGER NOT NULL,
            date CHAR(30) NOT NULL
            )
          ''');

      database.execute('''
          CREATE TABLE sales(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            productCode TEXT,
            name TEXT,
            quantity INTEGER,
            price INTEGER,
            date TEXT,
            FOREIGN KEY(productCode) REFERENCES inventory(pCode)
            )          
          ''');
    }, version: version);
    return db!;
  }

  Future testDb() async {
    db = await openDb();

    await db!.execute(
        'INSERT INTO inventory VALUES (0, "12", "fruit", 2, 200, 10, "3/2/2021")');
    await db!.execute(
        'INSERT INTO sales VALUES (0, "143d", "apples", 13, 15,  "2/1/2022")');
    //List inventory = await db!.rawQuery('select * from inventory');
    //List sales = await db!.rawQuery('select * from sales');
    //print(inventory[0].toString());
    //print(sales[0].toString());
  }

  // fetch operation: get all inventory objects from the database
  Future<List<Map<String, dynamic>>> getInventoryMapList() async {
    // var rawResult = await db.rawQuery('SELECT * FROM inventory order by priority');
    var ormResult = await db!.query('inventory');
    return ormResult;
  }

  // fetch operation: get barcode-scanned inventory object from the database
  Future<List<CInventoryModel>> getScannedInvList(String pCode) async {
    // var rawResult = await db.rawQuery('SELECT * FROM inventory order by priority');
    final List<Map<String, dynamic>> maps = await db!.query(
      'inventory',
      where: 'pCode = ?',
      whereArgs: [pCode],
    );
    return List.generate(maps.length, (i) {
      return CInventoryModel(
        maps[i]['id'],
        maps[i]['pCode'],
        maps[i]['name'],
        maps[i]['quantity'],
        maps[i]['buyingPrice'],
        maps[i]['unitSellingPrice'],
        maps[i]['date'],
      );
    });
  }

  Future<List<Map<String, dynamic>>> getSalesListMap() async {
    var ormResult = await db!.query('Sales');
    return ormResult;
  }

  Future<int> insertInventoryItem(CInventoryModel invModel) async {
    int id = await db!.insert(
      'inventory',
      invModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<int> insertSalesItem(SoldItemsModel soldItem) async {
    int productCode = await db!.insert(
      'sales',
      soldItem.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return productCode;
  }

  // get the 'Map List' [ List<Map> ] and convert it to 'Stock List' [ List<Stock> ]
  Future<List<CInventoryModel>> getInventoryList() async {
    var inventoryMapList = await getInventoryMapList();

    int invCount = inventoryMapList.length;

    List<CInventoryModel> inventoryItems = <CInventoryModel>[];

    // for loop to create an 'InventoryList' Object from a 'MapList' Object
    for (int i = 0; i < invCount; i++) {
      inventoryItems.add(CInventoryModel.fromMapObject(inventoryMapList[i]));
    }
    return inventoryItems;
  }

  Future<List<SoldItemsModel>> getSalesList() async {
    var soldItems = await getSalesListMap();

    int soldCount = soldItems.length;

    List<SoldItemsModel> itemsSold = <SoldItemsModel>[];

    // for loop to create an 'SalesList' Object from a 'MapList' Object
    for (int i = 0; i < soldCount; i++) {
      itemsSold.add(SoldItemsModel.fromMapObject(soldItems[i]));
    }
    return itemsSold;
  }

  Future<int> deleteInventoryItem(CInventoryModel inventory) async {
    int result = await db!.delete(
      'inventory',
      where: 'pCode = ?',
      whereArgs: [inventory.pCode],
    );

    return result;
  }

  Future<int> deleteSoldItem(SoldItemsModel soldItem) async {
    int result = await db!.delete(
      'sales',
      where: 'pCode = ?',
      whereArgs: [soldItem.productCode],
    );
    return result;
  }

  Future<int> onSaleSuccessUpdateInventory(int qty, String prCode) async {
    int result = await db!.rawUpdate(''' UPDATE inventory
          SET quantity = ?
          WHERE pCode = ?
      ''', [qty, prCode]);
    return result;
  }

  Future<int?> getFetchedItemCount(String pCode) async {
    Database? database = db;
    if (database != null) {
      var fCount = Sqflite.firstIntValue(await database.rawQuery(
          'select count (*) from inventory where pCode = ?', [pCode]));
      return fCount;
    }
    return null;
  }

  // get value of stock/inventory
  Future getInventoryValue() async {
    Database? database = db;
    if (database != null) {
      var inventoryValue = await database
          .rawQuery('SELECT SUM(buyingPrice) AS T_INV from inventory');
      print(inventoryValue.toList());
      return inventoryValue.toList();
    }
    return null;
  }
}
