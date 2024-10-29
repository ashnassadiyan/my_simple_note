class Note {
  int? id;
  String title;
  String description;
  DateTime created;
  String noteType;


  Note({
    this.id,
    required this.description,
    required this.title,
    required this.created,
    required this.noteType,
  });

  //   // priorities
  static String noteTypePriorityMedium="Medium";
  static String noteTypePriorityLow="Low";
  static String noteTypePriorityHigh="High";

  // Convert a Note into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created': created.toIso8601String(),
      'noteType': noteType,
    };
  }

  // Convert a Map into a Note
  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      created: DateTime.parse(map['created']),
      noteType: map['noteType'],
    );
  }
}
