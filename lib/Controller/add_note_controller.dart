import 'package:mobile/Db/db.dart';
import 'package:mobile/Models/note.dart';

class AddNoteController{

  final dbHelper = DatabaseHelper();

  void addNewNote(String title,String description,String priority){
    Note note=Note(description: description, title: title, created: DateTime.now(), noteType: priority);
    dbHelper.insertItem(note);
  }


}