import 'package:mobile/Db/db.dart';
import 'package:mobile/Models/note.dart';

class HomeController {
  final dbHelper = DatabaseHelper();

  Future<List<Note>> fetchNotes() async {
    return await dbHelper.getItems();
  }
}
