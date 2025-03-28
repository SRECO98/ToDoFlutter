import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/database/todo_database.dart';


//DatabaseHelper → Manages the database connection (opening, closing).
class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  //factory is a special constructor that doesn't create a new object every time you call it.
  factory DatabaseHelper() {
    return _instance;
  }

  //A Future in Dart mean's something that will be completed later. We need to wait for database to be
  //created so we can use also async.
  Future<Database> get getDatabase async {
    
    //if database is created return it.
    if (_database != null) return _database!;

    //else init database and return it.
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = "$dbPath/todo.db";

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async{
        await db.execute(TodoDatabase.createTableQuery);
      },
    );
  }
}
