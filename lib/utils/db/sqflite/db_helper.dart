import 'package:c_ri/features/store/models/inventory_model.dart';
import 'package:c_ri/features/store/models/sold_items_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final int version = 1;

  Database? _db;

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
    return _db!;
  }

  Future testDb() async {
    _db = await openDb();

    await _db!.execute(
        'INSERT INTO inventory VALUES (0, "12", "fruit", 2, 200, 10, "3/2/2021")');
    await _db!.execute(
        'INSERT INTO sales VALUES (0, "143d", "apples", 13, 15,  "2/1/2022")');
    //List inventory = await db!.rawQuery('select * from inventory');
    //List sales = await db!.rawQuery('select * from sales');
    //print(inventory[0].toString());
    //print(sales[0].toString());
  }

  // fetch operation: get all inventory objects from the database
  // A method that retrieves all the notes from the Notes table.
  Future<List<CInventoryModel>> fetchInventoryItems() async {
    // Get a reference to the database.
    final db = await _db;

    // Query the table for all The Notes. {SELECT * FROM Notes ORDER BY Id ASC}
    final result = await db!.query('inventory', orderBy: 'id ASC');

    // Convert the List<Map<String, dynamic> into a List<Note>.
    return result.map((json) => CInventoryModel.fromMapObject(json)).toList();
  }

  // Define a function that inserts notes into the database
  Future<void> addInventoryItem(CInventoryModel inventoryItem) async {
    // Get a reference to the database.
    final db = await _db;

    // Insert the Note into the correct table. You might also specify the
    // `conflictAlgorithm` to use in case the same Note is inserted twice.
    //
    // In this case, replace any previous data.
    await db?.insert('inventory', inventoryItem.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
