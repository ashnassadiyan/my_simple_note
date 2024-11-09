import 'package:flutter/material.dart';
import 'package:mobile/Controller/delete_note_controller.dart';
import 'package:mobile/Views/edit_note_view.dart';
import 'package:mobile/Views/view_note_view.dart';
import 'package:mobile/Models/note.dart';
import 'package:intl/intl.dart';

class ItemNote extends StatefulWidget {
  final int id;
  final String title;
  final String description;
  final DateTime date;
  final String priority;

  const ItemNote({
    Key? key,
    required this.id,
    required this.title,
    required this.description,
    required this.date,
    required this.priority,
  }) : super(key: key);

  @override
  _ItemNoteState createState() => _ItemNoteState();
}

class _ItemNoteState extends State<ItemNote> {

  final DeleteNoteController deleteNoteController = DeleteNoteController();

  void deleteNote(int id){
    deleteNoteController.deleteNote(id);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Note deleted successfully",style: TextStyle(
          fontSize:20.0
        ),),
        backgroundColor: Colors.deepOrange,
        duration: Duration(seconds: 2), // Adjust duration as needed
      ),
    );
  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      background: _swipeActionLeft(),
      secondaryBackground: _swipeActionRight(),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.endToStart) {
          final isConfirmed = await showConfirmationDialog(context, "Delete", "Are you sure you want to delete this note?");
          if (isConfirmed != null && isConfirmed) {
            deleteNote(widget.id);
          }
          return isConfirmed;
        } else if (direction == DismissDirection.startToEnd) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditNoteView(widget.id),
              ),
            );
        }
        return false;
      },
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ViewNoteView(widget.id),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 5),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: getColors(widget.priority),
                ),
                child: Column(
                  children: [
                    Text(
                      DateFormat('MMM').format(widget.date).toUpperCase(),
                      style: const TextStyle(color: Colors.white),
                    ),
                    Text(
                      widget.date.day.toString().padLeft(2, '0'),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      widget.date.year.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: const TextStyle(
                        fontFamily: "PlaywriteGBS",
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.description.length > 50
                          ? '${widget.description.substring(0, 50)}...'
                          : widget.description,
                      style: const TextStyle(
                        fontWeight: FontWeight.w300,
                        height: 1,
                        fontFamily: "PlaywriteGBS",
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<bool?> showConfirmationDialog(BuildContext context, String action, String message) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("$action Note"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text(action),
            ),
          ],
        );
      },
    );
  }

  Widget _swipeActionLeft() {
    return Container(
      alignment: Alignment.centerLeft,
      color: Colors.blue,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: const [
          Icon(Icons.archive, color: Colors.white),
          SizedBox(width: 5),
          Text('Edit', style: TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  Widget _swipeActionRight() {
    return Container(
      alignment: Alignment.centerRight,
      color: Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Text('Delete', style: TextStyle(color: Colors.white)),
          SizedBox(width: 5),
          Icon(Icons.delete, color: Colors.white),
        ],
      ),
    );
  }

  Color getColors(String color) {
    if (color == Note.noteTypePriorityMedium) {
      return Colors.amber;
    } else if (color == Note.noteTypePriorityLow) {
      return Colors.green;
    } else {
      return Colors.deepOrange;
    }
  }
}
