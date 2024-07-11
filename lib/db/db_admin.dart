import 'dart:io';

import 'package:gastosappg8/models/gasto_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBAdmin {
  Database? myDatabase;

  static final DBAdmin _instance = DBAdmin._();
  DBAdmin._();

  factory DBAdmin() {
    return _instance;
  }

  Future<Database?> _checkDatabase() async {
    if (myDatabase == null) {
      myDatabase = await _initDatabase();
    }
    return myDatabase;
  }

  Future<Database> _initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String pathDatabase = join(directory.path, "PagosDB.db");
    return await openDatabase(
      pathDatabase,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute("""CREATE TABLE GASTOS(
                id INTEGER PRIMARY KEY AUTOINCREMENT, 
                title TEXT, 
                price REAL, 
                datetime TEXT, 
                type TEXT
              )""");
      },
    );
  }

  Future<int> insertarGasto(GastoModel gasto) async {
    Database? db = await _checkDatabase();
    int res = await db!.insert("GASTOS", gasto.convertiraMap());
    return res;
  }

  Future<List<GastoModel>> obtenerGastos() async {
    Database? db = await _checkDatabase();
    List<Map<String, dynamic>> data = await db!.query("GASTOS");

    List<GastoModel> gastosList =
        data.map((e) => GastoModel.fromDB(e)).toList();

    return gastosList;
  }

  Future<int> actualizarGasto(int id, GastoModel gasto) async {
    try {
      Database? db = await _checkDatabase();
      int res = await db!.update(
        "GASTOS",
        gasto.convertiraMap(),
        where: "id = ?",
        whereArgs: [id],
      );
      print("Gasto actualizado con ID: $res");
      return res;
    } catch (e) {
      print("Error updating gasto: $e");
      return -1;
    }
  }

  Future<int> eliminarGasto(int id) async {
    Database? db = await _checkDatabase();
    int res = await db!.delete("GASTOS", where: "id = ?", whereArgs: [id]);
    return res;
  }
}
