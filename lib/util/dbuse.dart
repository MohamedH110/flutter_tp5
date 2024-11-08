import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../model/list_etudiants.dart';
import '../model/scol_list.dart';

class DbUse {
  final int version = 1;
  Database? _db;
  static final DbUse _dbHelper = DbUse._internal();

  DbUse._internal();

  factory DbUse() {
    return _dbHelper;
  }

  Future<Database> openDb() async {
    if (_db == null) {
      _db = await openDatabase(
        join(await getDatabasesPath(), 'scol.db'),
        onCreate: (database, version) async {
          await database.execute(
            'CREATE TABLE classes(codClass INTEGER PRIMARY KEY, nomClass TEXT, nbreEtud INTEGER)',
          );
          await database.execute(
            'CREATE TABLE etudiants(id INTEGER PRIMARY KEY, codClass INTEGER, nom TEXT, prenom TEXT, datNais TEXT, '
                'FOREIGN KEY(codClass) REFERENCES classes(codClass))',
          );
        },
        version: version,
      );
    }
    return _db!;
  }

  Future<List<ScolList>> getClasses() async {
    final db = await openDb();
    final List<Map<String, dynamic>> maps = await db.query('classes');
    return List.generate(maps.length, (i) {
      return ScolList(
        maps[i]['codClass'],
        maps[i]['nomClass'],
        maps[i]['nbreEtud'],
      );
    });
  }

  Future<int> insertClass(ScolList list) async {
    final db = await openDb();
    return await db.insert(
      'classes',
      list.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<int> insertEtudiants(ListEtudiants etud) async {
    final db = await openDb();
    return await db.insert(
      'etudiants',
      etud.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<ListEtudiants>> getEtudiants(int code) async {
    final db = await openDb(); // Ensure `db` is initialized
    final List<Map<String, dynamic>> maps = await db.query(
      'etudiants',
      where: 'codClass = ?',
      whereArgs: [code],
    );

    return List.generate(maps.length, (i) {
      return ListEtudiants(
        maps[i]['id'],
        maps[i]['codClass'],
        maps[i]['nom'],
        maps[i]['prenom'],
        maps[i]['datNais'],
      );
    });
  }

  Future<int> deleteClass(ScolList scolList) async {
    final db = await openDb();
    int result = await db.delete(
      'classes', // Table name
      where: "codClass = ?", // Column condition for deleting a class
      whereArgs: [scolList.codClass], // Class code (codClass)
    );
    return result;
  }

  Future<int> updateEtudiant(ListEtudiants student) async {
    final db = await openDb();

    // Update student details
    int result = await db.update(
      'etudiants',
      student.toMap(),
      where: 'id = ?',
      whereArgs: [student.id],
    );

    return result;
  }
  Future<int> deleteStudent(ListEtudiants student) async {
    final db = await openDb();
    int result = await db.delete(
      'etudiants', // Table name
      where: "id = ?", // Column condition for deleting a student
      whereArgs: [student.id], // Student ID
    );
    return result;
  }

}
