import 'package:c_ri/features/personalization/controllers/user_controller.dart';
import 'package:c_ri/features/store/models/dels_model.dart';
import 'package:c_ri/features/store/models/inv_model.dart';
import 'package:c_ri/features/store/models/sold_items_model.dart';
import 'package:c_ri/utils/popups/snackbars.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;

  /// -- variables --
  Database? _db;

  final userController = Get.put(CUserController());

  final invTable = 'inventory';
  final salesTable = 'sales';
  final delsForSyncTable = 'delsForSync';

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
          CREATE TABLE IF NOT EXISTS $invTable (
            productId INTEGER PRIMARY KEY NOT NULL,
            userId TEXT NOT NULL,
            userEmail TEXT NOT NULL,
            userName TEXT NOT NULL,
            pCode LONGTEXT NOT NULL,
            name TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            buyingPrice REAL NOT NULL,
            unitSellingPrice REAL NOT NULL,
            date CHAR(30) NOT NULL,
            isSynced INTEGER NOT NULL,
            syncAction TEXT NOT NULL
            )
          ''');

      database.execute('''
          CREATE TABLE IF NOT EXISTS $salesTable(
            saleId INTEGER PRIMARY KEY AUTOINCREMENT,
            userId TEXT NOT NULL,
            userEmail TEXT NOT NULL,
            userName TEXT NOT NULL,
            productId INTEGER NOT NULL,
            productCode LONGTEXT NOT NULL,
            productName TEXT NOT NULL,
            quantity INTEGER NOT NULL,
            totalAmount  REAL NOT NULL,
            unitSellingPrice REAL NOT NULL,
            paymentMethod TEXT NOT NULL,
            customerName TEXT,
            customerContacts TEXT,
            date TEXT NOT NULL,
            FOREIGN KEY(productId) REFERENCES inventory(productId)
            )          
          ''');

      database.execute('''
          CREATE TABLE IF NOT EXISTS $delsForSyncTable (
            itemId INTEGER NOT NULL,
            itemName TEXT NOT NULL,
            itemCategory TEXT NOT NULL,
            isSynced INTEGER NOT NULL,
            syncAction TEXT NOT NULL
          )
        ''');
    }, version: version);
    return _db!;
  }

  Future testDb() async {
    _db = await openDb();

    await _db!.execute(
        'INSERT INTO $invTable VALUES (0, "as23df45", "sindani254@gmail.com", "Manu", "12w34dds1", "fruit", 2, 200, 10, "3/2/2021")');
    await _db!.execute(
        'INSERT INTO $salesTable VALUES (0, "as23df45", "sindani254@gmail.com", "Manu", "143d", "apples", 13, 15, 10.0, "Cash", "2/1/2022")');
    //List inventory = await db!.rawQuery('select * from inventory');
    //List sales = await db!.rawQuery('select * from sales');
    //print(inventory[0].toString());
    //print(sales[0].toString());
  }

  /// --- ### CRUD OPERATIONS ON INVENTORY TABLE ### ---

  Future<void> addInventoryItem(CInventoryModel inventoryItem) async {
    // Get a reference to the database.
    final db = _db;

    // Insert the inventoryItem into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same inventoryItem is inserted twice.
    //
    // In this case, replace any previous data.
    await db?.insert(invTable, inventoryItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  /// -- fetch operation: get all inventory objects from the database --
  Future<List<CInventoryModel>> fetchInventoryItems(String email) async {
    // Get a reference to the database.
    final db = _db;

    // Query the table for inventory list
    final result = await db!.rawQuery(
        'SELECT * FROM $invTable WHERE userEmail = ? ORDER BY date DESC',
        [email]);

    //final result = await db!.query(invTable, orderBy: 'productId ASC');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return result.map((json) => CInventoryModel.fromMapObject(json)).toList();
  }

  // fetch operation: get barcode-scanned inventory object from the database
  Future<List<CInventoryModel>> fetchInvItemByCodeAndEmail(
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
        maps[i]['isSynced'],
        maps[i]['syncAction'],
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

  /// -- delete inventory item --
  Future<int> deleteInventoryItem(CInventoryModel inventory) async {
    int result = await _db!.delete(
      'inventory',
      where: 'productId = ?',
      whereArgs: [inventory.productId],
    );

    return result;
  }

  /// -- update inventory upon sale --
  Future<int> updateStockCount(int newStockCount, int pId) async {
    try {
      int updateResult = await _db!.rawUpdate(
        '''
          UPDATE $invTable
          SET quantity = ?
          WHERE productId = ?
        ''',
        [newStockCount, pId],
      );
      return updateResult;
    } catch (e) {
      return CPopupSnackBar.errorSnackBar(
        title: 'error updating stock count',
        message: e.toString(),
      );
    }
  }

  /// ==== ### CRUD OPERATIONS ON SALES TABLE ### ====
  // -- save sale details to the database --
  Future<void> addSoldItem(CSoldItemsModel soldItem) async {
    try {
      // Get a reference to the database.
      final db = _db;
      // Insert the Note into the correct table. You might also specify the
      // `conflictAlgorithm` to use in case the same Inventory item is inserted twice.
      //
      // In this case, replace any previous data.
      await db?.insert(salesTable, soldItem.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error performing transaction',
        message: e.toString(),
      );
    }
  }

  /// -- fetch transactions --
  Future<List<CSoldItemsModel>> fetchTransactions(String email) async {
    final db = _db;

    final transactions = await db!.rawQuery(
        'SELECT * from $salesTable where userEmail = ? ORDER BY date DESC',
        [email]);

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return transactions
        .map((json) => CSoldItemsModel.fromMapObject(json))
        .toList();
  }

  Future<void> saveDelForSync(CDelsModel delItem) async {
    try {
      // get a reference to the local database.
      final db = _db;
      await db!.insert(
        delsForSyncTable,
        delItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error performing transaction',
        message: e.toString(),
      );
      throw e.toString();
    }
  }

  /// -- fetch all deletionForSyncItems --
  Future<List<CDelsModel>> fetchAllInvDels() async {
    // get a reference to the database.
    final db = _db;

    // raw query
    final dels = await db!.rawQuery(
        'SELECT * FROM delsForSync where syncAction = ? and itemCategory = ?',
        ['delete', 'inventory']);

    if (dels.isEmpty) {
      //CPopupSnackBar.customToast(message: 'IS EMPTY');
      return [];
    } else {
      final result =
          dels.map((json) => CDelsModel.fromMapObject(json)).toList();

      return result;
    }
  }

  /// -- fetch all updatesForSyncItems --
  Future<List<CDelsModel>> fetchAllInvUpdates() async {
    // get a reference to the database.
    final db = _db;

    // raw query
    final forUpdates = await db!.rawQuery(
        'SELECT * FROM delsForSync where syncAction = ? and itemCategory = ?',
        ['update', 'inventory']);

    final result =
        forUpdates.map((json) => CDelsModel.fromMapObject(json)).toList();

    return result;
  }

  Future<int> updateDel(CDelsModel delItem) async {
    int delRes = await _db!.update(
      delsForSyncTable,
      delItem.toMap(),
      where: 'itemId = ?',
      whereArgs: [delItem.itemId],
    );

    return delRes;
  }
}
