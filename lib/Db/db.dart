import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../Models/note.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  static Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'note.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute(
        '''
      CREATE TABLE note (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      title TEXT NOT NULL,
      description TEXT,
      created TEXT NOT NULL,
      noteType TEXT NOT NULL
      )
      '''
    );
  }

  // Insert a new Note
  Future<int> insertItem(Note note) async {
    final db = await database;
    return await db.insert('note', {
      'title': note.title,
      'description': note.description,
      'created': note.created.toIso8601String().toString(),
      'noteType': note.noteType,
    });
  }

  // Query all Notes
  Future<List<Note>> getItems() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('note');
    return List.generate(maps.length, (i) {
      return Note(
        id: maps[i]['id'],
        title: maps[i]['title'],
        description: maps[i]['description'],
        created: DateTime.parse(maps[i]['created']),
        noteType: maps[i]['noteType'],
      );
    });
  }

  // Update a Note
  Future<int> updateItem(Note note) async {
    final db = await database;
    return await db.update(
      'note',
      note.toMap(),
      where: 'id = ?',
      whereArgs: [note.id],
    );
  }

  // Delete a Note
  Future<int> deleteItem(int id) async {
    final db = await database;
    return await db.delete(
      'note',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


  Future<Note> getItem(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'note',
      where: 'id = ?',
      whereArgs: [id],
    );

      return Note(
        id: maps[0]['id'],
        title: maps[0]['title'],
        description: maps[0]['description'],
        created: DateTime.parse(maps[0]['created']),
        noteType: maps[0]['noteType'],
      );

  }
}
