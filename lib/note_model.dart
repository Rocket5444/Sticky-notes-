class Note {
  String heading; // New property for the note heading
  String content;
  DateTime dateTime;

  Note({
    required this.heading, // Add this parameter to the constructor
    required this.content,
    required this.dateTime,
  });
}
