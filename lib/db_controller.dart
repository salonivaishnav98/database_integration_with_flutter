import 'package:sqflite/sqflite.dart'as sql;

class DatabaseHelper{
  static Future<sql.Database> db() async{
    return sql.openDatabase(

      'my_database.db',
      version:1,
      onCreate:(sql.Database database, int version) async{
        await createTable(database);
      }

    );
  }
  static Future<void> createTable(sql.Database database) async{
      await database.execute("""CREATE TABLE user_data(
      
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      full_name TEXT,
      username TEXT,
      email TEXT,
      password TEXT,
      unique_id TEXT
      )
      """);
  }

  static Future<int> createItems(String fName, String username, String email, String password, String unique_Id) async {
    final db = await DatabaseHelper.db();//opens the database using the DatabaseHelper.db()
    final data = {'full_name':fName,'username':username,'email':email,'password':password,'unique_id':unique_Id};
    final id = db.insert('user_data',data, conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;//returns the ID of the inserted record.
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async{
    final db = await DatabaseHelper.db();
    return db.query('user_data', where: 'id=?', whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getItems() async{
    final db = await DatabaseHelper.db();
    return db.query('user_data',orderBy: 'id');
  }

  static Future<bool> checkUserExistance(String username) async{
    final db = await DatabaseHelper.db();
    final List<Map<String, dynamic>> result = await db.query('user_data', where: 'username=?',whereArgs: [username]);
    return result.isNotEmpty;
  }

  static Future<bool> checkEmailExistance(String email) async{
    final db = await DatabaseHelper.db();
    final List<Map<String,dynamic>> result = await db.query('user_data',where: 'email=?',whereArgs: [email]);
    return result.isNotEmpty;
  }

  static Future<List<Map<String,dynamic>>> authentication(String username, String password) async{
    final db = await DatabaseHelper.db();
    final result = await db.query('user_data',where:'username=? AND password=?', whereArgs: [username,password]);
    return result;
  }
}