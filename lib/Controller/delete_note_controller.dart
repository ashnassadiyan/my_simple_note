import 'package:mobile/Db/db.dart';

class DeleteNoteController {
  final dbHelper = DatabaseHelper();

  void deleteNote(int id) async {
     await dbHelper.deleteItem(id);
  }
}
