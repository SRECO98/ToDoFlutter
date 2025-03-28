import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/models/todo.dart';
import 'database_helper.dart';

//TodoDatabase → Handles specific CRUD database operations.

class TodoDatabase {
  
  final DatabaseHelper _databaseHelper = DatabaseHelper();  // Correct initialization
  static const String tableName = 'todos';

  // Create table query
  static const String createTableQuery = '''
    CREATE TABLE $tableName (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      isCompleted INTEGER NOT NULL DEFAULT 0
    )
  ''';

  Future<int> insertToDo(ToDo todo) async{
    //get reference to the database.
    final db = await _databaseHelper.getDatabase;

    return await db.insert(
      tableName, 
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ToDo>> getTodos() async{
    final db = await _databaseHelper.getDatabase;
    //// Query the 'todos' table
    final List<Map<String, dynamic>> maps = await db.query(tableName);

    // Convert the List<Map<String, dynamic>> into List<ToDo> and return it
    return List.generate(maps.length, (i){
      return ToDo.fromMap(maps[i]); // Convert each map to ToDo object
    });
  }


  //If return gives 1, one task was deleted.
  //If return gives 0, no task was deleted (maybe the ID didn’t exist).
  Future<int> updateTodo(ToDo todo) async{
    final db = await _databaseHelper.getDatabase;

    return await db.update(
      tableName,  //table name
      todo.toMap(),  //Convert ToDo object to Map
      where: "id = ?", // Specify which row to update
      whereArgs: [todo.id], // The ? placeholder gets replaced by todo.id.s
    );
  }

  //If return gives 1, one row was updated.
  //If return gives 0, nothing was updated (maybe the task ID was wrong).
  Future<int> deleteTodo(int id) async{
    final db = await _databaseHelper.getDatabase;

    return await db.delete(
      tableName,
      where: "id = ?",
      whereArgs: [id], //add id to where and delete the task wtih this id.
    );
  }

  Future<int> toggleDoneTodo(int id) async{
    final db = await _databaseHelper.getDatabase;

    // Update the 'isCompleted' status of the todo item (toggle its current status)
    int result = await db.rawUpdate(
      'UPDATE $tableName SET isCompleted = CASE WHEN isCompleted = 1 THEN 0 ELSE 1 END WHERE id = ?',
      [id],
    );

    return result; // Return the result of the update operation, is it sucessful or not.
  }

  Future<int> updateToDO(ToDo todo) async{
    final db = await _databaseHelper.getDatabase;

    return await db.update(
      tableName, 
      {
        'title': todo.title,
        'description': todo.description,
        'isCompleted': todo.isCompleted ? 1 : 0,
      },
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }
  
}
