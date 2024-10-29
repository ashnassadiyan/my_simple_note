import 'package:flutter/material.dart';
import 'package:mobile/Controller/view_note_controller.dart';
import 'package:mobile/Models/note.dart';
import 'package:mobile/Views/edit_note_view.dart';

class ViewNoteView extends StatefulWidget {
  final int id;

  const ViewNoteView(this.id, {Key? key}) : super(key: key);

  @override
  State<ViewNoteView> createState() => _ViewNoteViewState();
}

class _ViewNoteViewState extends State<ViewNoteView> {
  late Future<Note?> note;
  final ViewNoteController viewNoteController = ViewNoteController();

  @override
  void initState() {
    super.initState();
    note = viewNoteController.viewNote(widget.id);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void navigateToEdit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditNoteView(widget.id),
      ),
    ).then((_) {
      // Refresh the view when returning from EditNoteView
      setState(() {
        note = viewNoteController.viewNote(widget.id);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("View Note"),
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
            final noteData = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Center(
                    child: Text(
                      noteData.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "PlaywriteGBS",
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    noteData.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: "PlaywriteGBS",
                    ),
                  ),
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      width: 150,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors.orange),
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        onPressed: navigateToEdit,
                        child: const Text(
                          'Edit',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
