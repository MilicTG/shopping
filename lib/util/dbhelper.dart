import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

//Model classes
import '../models/list_items.dart';
import '../models/shopping_list.dart';

class DbHelper {
  final int version = 1;
  Database db;

  Future<Database> openDb() async {
    if (db == null) {
      db = await openDatabase(join(await getDatabasesPath(), 'shopping.db'),
          onCreate: (database, version) {
        database.execute(
            'CREATE TABLE lists(id INTEGER PROMARY KEY, name TEXT, priority INTEGER)');
        database.execute(
            'CREATE TABLE items(id INTEGER PRIMARY KEY, idList INTEGER, name TEXT, quantity TEXT, note TEXT, ' +
                'FOREIGN KEY(idList) REFERENCES lists(id))');
      }, version: version);
    }
    return db;
  }

  Future<int> insertList(ShoppingList list) async {
    int id = await this.db.insert('lists', list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int> insertItem(ListItem item) async {
    int id = await this.db.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<List<ShoppingList>> getLists()async{
      final List<Map<String, dynamic>> maps = await db.query('lists');

      return List.generate(maps.length, (i){
        return ShoppingList(
          maps[i]['id'],
          maps[i]['name'],
          maps[i]['priority']
        );
      });
  } 
}
