import 'package:flutter/material.dart';
import 'package:mobile/Components/Item_note.dart';
import 'package:mobile/Components/button.dart';
import 'package:mobile/Controller/home_controller.dart';
import 'package:mobile/Views/add_note_view.dart';
import 'package:mobile/Models/note.dart';
import 'package:mobile/Views/edit_note_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  List<Note> notes = [];
  final HomeController homeController = HomeController();

  @override
  void initState() {
    super.initState();
    refreshItems();
  }

  Future<void> refreshItems() async {
    final List<Note> data = await homeController.fetchNotes();
    setState(() {
      notes = data;
    });

    // Print headers
    print("ID | Title | Description | Created | NoteType");

    // Loop through and print each note with headers
    for (var note in notes) {
      print("${note.id} | ${note.title} | ${note.description ?? ''} | ${note.created} | ${note.noteType}");
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        title: const Text(
          "My Simple Note",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontFamily: "PlaywriteGBS",
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(15),
        children: [
          const SizedBox(height: 20),
          ...notes.map(
                (note) => GestureDetector(
              onTap: () async {
                // Navigate to EditNoteView and refresh after returning if there were changes
                bool? updated = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditNoteView(note.id ?? 0)),
                );
                if (updated == true) {
                  await refreshItems();
                }
              },
              child: ItemNote(
                id: note.id ?? 0,
                title: note.title,
                description: note.description,
                date: note.created,
                priority: note.noteType,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to AddNote and refresh after returning if a new note was added
          bool? added = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddNote()),
          );
          if (added == true) {
            await refreshItems();
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.edit),
        foregroundColor: Colors.white,
      ),
    );
  }
}
