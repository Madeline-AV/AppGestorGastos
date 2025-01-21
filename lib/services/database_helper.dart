import 'package:gestor_de_gastos/model/notes_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper _instancia = DatabaseHelper._internal();

  static Database? _database;

  factory DatabaseHelper()=> _instancia;
  DatabaseHelper._internal();

  Future<Database> get database async{
  if(_database != null) return _database!;
  _database = await _initDatabase();
  return _database!;
  }
  
  Future<Database> _initDatabase() async{
    String path = join(await getDatabasesPath(), 'my_gastos.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async{
    await db.execute('''
    CREATE TABLE gastos(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    titulo TEXT,
    descricion TEXT,
    categorias TEXT,
    monto TEXT,
    fecha TEXT,
    ''');
  }
  
  Future<List> calculateTotal() async{
    var db = await database;
    var result = await db.rawQuery("SELECT SUM(monto) as TOTAL FROM gastos");

    return result.toList();

  }

  Future<int> inserGasto(Gastos gastos) async{
    final db = await database;
    return await db.insert('gasto', gastos.toMap());
  }

  Future<List<Gastos>> getGasto()async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('gastos');
    return List.generate(maps.length, (i) => Gastos.fromMap(maps[i]));
  }

  Future<int> Updategasto(Gastos gastos) async{
    final db = await database;
    return await db.update('gastos', gastos.toMap(),
    where: 'id = ?',
    whereArgs: [gastos.id]
    );
  }

  Future<int> Deletegasto(int id) async{
    final db = await database;
    return await db.delete(
        'gastos',
        where: 'id = ?',
        whereArgs: [id]
    );
  }

}