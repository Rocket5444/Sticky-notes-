import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'note_provider.dart';
import 'note_model.dart';
import 'dart:ui';
import 'dart:math';
import 'profile_page.dart';

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  bool _isAddingNote = false;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Load notes when the page initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<NoteProvider>(context, listen: false).loadNotes();
    });
  }

  Color _getRandomRainbowColor() {
    final List<Color> rainbowColors = [
      Colors.red,
      Colors.orange,
      Colors.yellow,
      Colors.green,
      Colors.blue,
      Colors.indigo,
      Colors.purple,
    ];
    return rainbowColors[Random().nextInt(rainbowColors.length)];
  }

  void _toggleAddNote() {
    setState(() {
      _isAddingNote = !_isAddingNote;
      if (_isAddingNote) {
        _selectedIndex = 1;
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (index == 1) {
        _toggleAddNote();
      } else if (index == 2) {
        _isAddingNote = false;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: !_isAddingNote
            ? Text(
                'Sticky Notes',
                style: TextStyle(
                  fontFamily: 'Cursive',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      blurRadius: 10.0,
                      color: Colors.black45,
                      offset: Offset(3.0, 3.0),
                    ),
                  ],
                  color: Colors.white,
                ),
              )
            : null,
        centerTitle: true,
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: Icon(Icons.share),
            onPressed: () {
              // Implement your share functionality here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'Assets/images/mmy3.jpg', // Add your image path here
              fit: BoxFit.cover,
            ),
          ),
          // Notes or Add Note form
          _selectedIndex == 1 && _isAddingNote
              ? Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextField(
                        controller: _headingController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey[
                              50], // Background color of the text field
                          labelText: 'Note Heading...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.blueGrey[
                              50], // Background color of the text field
                          labelText: 'Write a note...',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_headingController.text.isNotEmpty &&
                              _contentController.text.isNotEmpty) {
                            Provider.of<NoteProvider>(context, listen: false)
                                .addNote(Note(
                              heading: _headingController.text,
                              content: _contentController.text,
                              dateTime: DateTime.now(),
                            ));
                            _headingController.clear();
                            _contentController.clear();
                            _toggleAddNote();
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              if (states.contains(MaterialState.hovered))
                                return Colors.orangeAccent.withOpacity(0.8);
                              return Colors.orangeAccent;
                            },
                          ),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ),
                          ),
                        ),
                        child: Text(
                          'Add Note',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Consumer<NoteProvider>(
                  builder: (context, noteProvider, child) {
                    return GridView.builder(
                      padding: EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                        childAspectRatio: 3 / 2,
                      ),
                      itemCount: noteProvider.notes.length,
                      itemBuilder: (context, index) {
                        final note = noteProvider.notes[index];
                        return Stack(
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => Dialog(
                                    backgroundColor: Colors.blueGrey,
                                    child: Stack(
                                      children: [
                                        Positioned.fill(
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 5.0, sigmaY: 5.0),
                                            child: Container(
                                              color:
                                                  Colors.black.withOpacity(0.5),
                                            ),
                                          ),
                                        ),
                                        Center(
                                          child: AnimatedScale(
                                            scale: 1.25,
                                            duration:
                                                Duration(milliseconds: 300),
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.8,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.25,
                                              decoration: BoxDecoration(
                                                color: _getRandomRainbowColor(),
                                                borderRadius:
                                                    BorderRadius.circular(15.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      note.heading,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 24,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    Expanded(
                                                      child: Text(
                                                        note.content,
                                                        style: TextStyle(
                                                          fontSize: 18,
                                                          color: Colors.white70,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(height: 16),
                                                    Text(
                                                      note.dateTime.toString(),
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.white60,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                color: _getRandomRainbowColor(),
                                elevation: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        note.heading,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18,
                                          color: Colors.white,
                                          fontFamily: 'Cursive',
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Expanded(
                                        child: Text(
                                          note.content,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        note.dateTime.toString(),
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.white60,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              right: 8.0,
                              top: 8.0,
                              child: IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('Confirm Delete'),
                                      content: Text(
                                          'Are you sure you want to delete this note?'),
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Provider.of<NoteProvider>(context,
                                                    listen: false)
                                                .deleteNote(index);
                                            Navigator.of(context).pop();
                                          },
                                          child: Text('Delete'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                          child: Text('Cancel'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
          if (_selectedIndex == 2)
            Positioned.fill(
              child: Container(
                color: Colors.black54,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      'Profile Page',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: _selectedIndex == 0 ? 'Home' : '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: _selectedIndex == 1 ? 'Add Note' : '',
            backgroundColor: Colors.blueGrey,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: _selectedIndex == 2 ? 'Profile' : '',
          ),
        ],
        selectedItemColor: Colors.blueGrey,
        onTap: _onItemTapped,
      ),
    );
  }
}
