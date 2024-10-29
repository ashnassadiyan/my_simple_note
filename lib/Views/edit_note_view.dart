import 'package:flutter/material.dart';
import 'package:mobile/Controller/view_note_controller.dart';
import 'package:mobile/Controller/edit_note_controller.dart';
import 'package:mobile/Models/note.dart';
import 'package:mobile/Views/home_view.dart';

class EditNoteView extends StatefulWidget {
  final int id;

  const EditNoteView(this.id, {Key? key}) : super(key: key);

  @override
  State<EditNoteView> createState() => _EditNoteViewState();
}

class _EditNoteViewState extends State<EditNoteView> {
  late Future<Note?> note;
  final ViewNoteController viewNoteController = ViewNoteController();
  final EditNoteController editNoteController = EditNoteController();

  // Controllers to manage the text fields
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  String? dropdownValue;

  @override
  void initState() {
    super.initState();
    note = viewNoteController.viewNote(widget.id);
    loadNoteData();
  }

  void loadNoteData() async {
    final loadedNote = await note;
    if (loadedNote != null) {
      setState(() {
        titleController.text = loadedNote.title;
        descriptionController.text = loadedNote.description;
        dropdownValue = loadedNote.noteType;
      });
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  // Function to save the updated note
  Future<void> saveNote() async {
    final updatedNote = Note(
      id: widget.id,
      title: titleController.text,
      description: descriptionController.text,
      noteType: dropdownValue ?? Note.noteTypePriorityLow, // Default if none selected
      created: DateTime.now(), // Update created or retain old created date if necessary
    );

    editNoteController.updateNote(updatedNote);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Note updated successfully",
          style: TextStyle(fontSize: 20.0),
        ),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeView()),
          (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Note"),
      ),
      body: FutureBuilder<Note?>(
        future: note,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData) {
            return const Center(child: Text("Note not found"));
          } else {
            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                      hintText: "Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: TextFormField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                        hintText: "Description",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      maxLines: 20,
                    ),
                  ),
                  const SizedBox(height: 15),
                  DropdownButtonFormField<String>(
                    hint: const Text("Select Priority"),
                    value: dropdownValue,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    items: [
                      DropdownMenuItem(
                        child: Text(Note.noteTypePriorityLow),
                        value: Note.noteTypePriorityLow,
                      ),
                      DropdownMenuItem(
                        child: Text(Note.noteTypePriorityMedium),
                        value: Note.noteTypePriorityMedium,
                      ),
                      DropdownMenuItem(
                        child: Text(Note.noteTypePriorityHigh),
                        value: Note.noteTypePriorityHigh,
                      ),
                    ],
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 15),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.blue),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    onPressed: saveNote,
                    child: const Text(
                      'Save',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
