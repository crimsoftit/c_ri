import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;

  /// -- variables --
  Database? _db;
  final invTable = 'inventory';
  static const String colId = 'id';
  static const String colPcode = 'pCode';

  final salesTable = 'sales';

  static final DbHelper _dbHelper = DbHelper._internal();
  DbHelper._internal();

  // make this a singleton class
  DbHelper._privateConstructor();
  static final DbHelper instance = DbHelper._privateConstructor();

  factory DbHelper() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (_db != null) {
      return _db!;
    }
    _db = await openDatabase(join(await getDatabasesPath(), 'stock.db'),
        onCreate: (database, version) {
      database.execute('''
          CREATE TABLE $invTable (
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
          CREATE TABLE $salesTable(
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
    return _db!;
  }

  Future testDb() async {
    _db = await openDb();

    await _db!.execute(
        'INSERT INTO $invTable VALUES (0, "12", "fruit", 2, 200, 10, "3/2/2021")');
    await _db!.execute(
        'INSERT INTO $salesTable VALUES (0, "143d", "apples", 13, 15,  "2/1/2022")');
    //List inventory = await db!.rawQuery('select * from inventory');
    //List sales = await db!.rawQuery('select * from sales');
    //print(inventory[0].toString());
    //print(sales[0].toString());
  }

  /// -- fetch operation: get all inventory objects from the database --
  /// --  A method that retrieves all the notes from the Notes table. --
  Future<List<CInventoryModel>> fetchInventoryItems() async {
    // Get a reference to the database.
    final db = _db;

    // Query the table for all The Notes. {SELECT * FROM Notes ORDER BY Id ASC}
    final result = await db!.query(invTable, orderBy: 'id ASC');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return result.map((json) => CInventoryModel.fromMapObject(json)).toList();
  }

  // Define a function that inserts notes into the database
  Future<void> addInventoryItem(CInventoryModel inventoryItem) async {
    // Get a reference to the database.
    final db = _db;

    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Note is inserted twice.
    //
    // In this case, replace any previous data.
    await db?.insert(invTable, inventoryItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // fetch operation: get barcode-scanned inventory object from the database
  Future<List<CInventoryModel>> getScannedInvItem(String pCode) async {
    final List<Map<String, dynamic>> maps = await _db!.query(
      invTable,
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

  /// -- defines a function to update an inventory item --
  Future<int> updateInventoryItem(CInventoryModel invItem) async {
    // Get a reference to the database.
    //final db = await _db;

    try {
      // Update the given inventory item.
      var updateResult = await _db!.update(invTable, invItem.toMap(),

          // ensure that the inventory item has a matching product code.
          where: '$colPcode = ?',

          // pass the item's pCode as a whereArg to prevent SQL injection
          whereArgs: [invItem.pCode]);
      return updateResult;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: e.toString(),
      );
      return 0;
    }
  }

  Future<int> deleteInventoryItem(CInventoryModel inventory) async {
    int result = await _db!.delete(
      'inventory',
      where: '$colPcode = ?',
      whereArgs: [inventory.pCode],
    );

    return result;
  }
}
