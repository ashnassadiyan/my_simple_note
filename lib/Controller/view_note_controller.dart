import 'package:mobile/Db/db.dart';
import 'package:mobile/Models/note.dart';

class ViewNoteController{

  final dbHelper = DatabaseHelper();

  Future<Note?> viewNote(int id)async{
  return await  dbHelper.getItem(id);

  }

}


