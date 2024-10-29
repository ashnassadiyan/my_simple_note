import 'package:mobile/Db/db.dart';
import 'package:mobile/Models/note.dart';

class EditNoteController{

  final dbHelper = DatabaseHelper();

  void updateNote(Note note){
    print(note);
    dbHelper.updateItem(note);
  }

}