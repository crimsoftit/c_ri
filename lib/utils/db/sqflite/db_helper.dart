import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;

  /// -- variables --
  Database? _db;
  final invTable = 'inventory';
  final userController = Get.put(CUserController());

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
            productId INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT NOT NULL,
            userEmail TEXT NOT NULL,
            userName TEXT NOT NULL,
            pCode TEXT NOT NULL,
            name TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            buyingPrice REAL NOT NULL,
            unitSellingPrice REAL NOT NULL,
            date CHAR(30) NOT NULL
            )
          ''');

      database.execute('''
          CREATE TABLE $salesTable(
            productId INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT NOT NULL,
            userEmail TEXT NOT NULL,
            userName TEXT NOT NULL,
            productCode TEXT,
            name TEXT,
            quantity INTEGER,
            price REAL,
            date TEXT,
            FOREIGN KEY(productId) REFERENCES inventory(productId)
            )          
          ''');
    }, version: version);
    return _db!;
  }

  Future testDb() async {
    _db = await openDb();

    await _db!.execute(
        'INSERT INTO $invTable VALUES (0, "manu245", "sindani254@gmail.com", "Manu, "12", "fruit", 2, 200, 10, "3/2/2021")');
    await _db!.execute(
        'INSERT INTO $salesTable VALUES (0, "manu", "143d", "apples", 13, 15,  "2/1/2022")');
    //List inventory = await db!.rawQuery('select * from inventory');
    //List sales = await db!.rawQuery('select * from sales');
    //print(inventory[0].toString());
    //print(sales[0].toString());
  }

  /// -- fetch operation: get all inventory objects from the database --
  /// --  A method that retrieves all the notes from the Notes table. --
  Future<List<CInventoryModel>> fetchInventoryItems(String email) async {
    // Get a reference to the database.
    final db = _db;

    //var userId = userController.user.value.id;

    // Query the table for inventory list
    final result = await db!.rawQuery(
        'SELECT * FROM $invTable WHERE userEmail = ? ORDER BY date DESC',
        [email]);

    //final result = await db!.query(invTable, orderBy: 'productId ASC');

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
  Future<List<CInventoryModel>> getScannedInvItem(
      String code, String email) async {
    final List<Map<String, dynamic>> maps = await _db!.query(
      invTable,
      where: 'pCode = ? and userEmail = ?',
      whereArgs: [code, email],
    );
    return List.generate(maps.length, (i) {
      return CInventoryModel.withID(
        maps[i]['productId'],
        maps[i]['userId'],
        maps[i]['userEmail'],
        maps[i]['userName'],
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
  Future<int> updateInventoryItem(CInventoryModel invItem, int pID) async {
    try {
      // Update the given inventory item.
      var updateResult = await _db!.update(invTable, invItem.toMap(),

          // ensure that the inventory item has a matching product id.
          where: 'productId = ?',

          // pass the item's pCode as a whereArg to prevent SQL injection
          whereArgs: [pID]);
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
      where: 'productId = ?',
      whereArgs: [inventory.productId],
    );

    return result;
  }
}
