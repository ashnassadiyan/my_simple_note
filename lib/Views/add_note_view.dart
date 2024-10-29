import 'package:flutter/material.dart';
import 'package:mobile/Controller/add_note_controller.dart';
import "package:mobile/Models/note.dart";
import 'package:mobile/Views/home_view.dart';

class AddNote extends StatefulWidget {
  const AddNote({super.key});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  String? dropdownValue;

  final AddNoteController addNoteController = AddNoteController();
  final _formKey = GlobalKey<FormState>();


  void addNewNote()async {
    if (_formKey.currentState?.validate() ?? false) {
      addNoteController.addNewNote(
          titleController.text, descriptionController.text, dropdownValue ?? "");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Note Saved successfully",style: TextStyle(
              fontSize:20.0
          ),),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3), // Adjust duration as needed
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => HomeView()),
            (Route<dynamic> route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Note"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Form(
          key: _formKey,
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a title';
                  }
                  return null;
                },
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
                  validator: (value) {
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 15),
              DropdownButtonFormField<String>(
                hint: Text("Select Priority"),
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
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a priority';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: addNewNote,
                child: Text(
                  'Save',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
