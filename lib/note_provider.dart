import 'package:flutter/material.dart';
import 'note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NoteProvider with ChangeNotifier {
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  void addNote(Note note) {
    _notes.add(note);
    saveNotes();
    notifyListeners();
  }

  void deleteNote(int index) {
    _notes.removeAt(index);
    saveNotes();
    notifyListeners();
  }

  void sortNotesByDateTime() {
    _notes.sort((a, b) => b.dateTime.compareTo(a.dateTime));
    notifyListeners();
  }

  void loadNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? notesString = prefs.getString('notes');
    if (notesString != null) {
      List<dynamic> decodedNotes = jsonDecode(notesString);
      _notes = decodedNotes
          .map((json) => Note(
                heading: json['heading'], // Add this line
                content: json['content'],
                dateTime: DateTime.parse(json['dateTime']),
              ))
          .toList();
      notifyListeners();
    }
  }

  void saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> encodedNotes = _notes
        .map((note) => {
              'heading': note.heading, // Add this line
              'content': note.content,
              'dateTime': note.dateTime.toIso8601String(),
            })
        .toList();
    prefs.setString('notes', jsonEncode(encodedNotes));
  }
}
