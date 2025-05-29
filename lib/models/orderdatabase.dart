import 'package:flutter_application_1/models/ordermodel.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class OrderDatabase {
  static final OrderDatabase instance = OrderDatabase._init();
  static Database? _database;

  OrderDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('orders.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE orders (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        price REAL,
        quantity INTEGER,
        imagePath TEXT
      )
    ''');
  }

  Future<void> insertOrder(OrderItem item) async {
    final db = await instance.database;
    await db.insert('orders', item.toMap());
  }

  Future<List<OrderItem>> fetchOrders() async {
    final db = await instance.database;
    final result = await db.query('orders');
    return result.map((map) => OrderItem.fromMap(map)).toList();
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
