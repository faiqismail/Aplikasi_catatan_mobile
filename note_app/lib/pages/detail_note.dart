import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/pages/edit_note.dart';
import 'package:provider/provider.dart';
import 'package:flutter_html/flutter_html.dart';
import 'theme_provider.dart';

class NoteDetailPage extends StatefulWidget {
  const NoteDetailPage({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  _NoteDetailPageState createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage> {
  late Note _note;
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    _refreshNote();
  }

  Future<void> _refreshNote() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var note = await DatabaseCatatan.instance.getNoteById(widget.id);
      if (note != null) {
        _note = note;
      } else {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Error'),
              content: const Text('Note not found'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.of(context).pop();
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? Color.fromARGB(255, 42, 44, 60)
          : Colors.white,
      appBar: AppBar(
        backgroundColor: Color(0xFF78A083),
        automaticallyImplyLeading: false,
        toolbarHeight: 20,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
              color: themeProvider.isDarkMode
                  ? const Color.fromARGB(255, 42, 44, 60)
                  : Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          color: Color(0xFF78A083),
                        ),
                        SizedBox(width: 16),
                        Text(
                          '             Detail ',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF78A083),
                          ),
                        ),
                        Spacer(),
                        _deleteButton(),
                        _editButton(),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: screenWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Card(
                                color: Color(0xFF78A083),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _note.judul,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Color.fromARGB(255, 255, 255, 255),
                                        ),
                                      ),
                                      SizedBox(height: 12),
                                      Text(
                                        DateFormat.yMMMd().format(_note.time),
                                        style: TextStyle(
                                          color: Color.fromARGB(255, 255, 255, 255),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                          SizedBox(
                            width: screenWidth,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Card(
                                color: Color(0xFF78A083),
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Html(
                                    data: _note.isi,
                                    style: {
                                      "body": Style(
                                        fontSize: FontSize(20),
                                        color: Color.fromARGB(255, 255, 255, 255),
                                      ),
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _deleteButton() {
    return IconButton(
      onPressed: () async {
        if (_isLoading) return;
        await DatabaseCatatan.instance.deleteNote(widget.id);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Catatan berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      },
      icon: Icon(
        Icons.delete,
        color: Color(0xFF78A083),
      ),
    );
  }

  Widget _editButton() {
    return IconButton(
      onPressed: () async {
        if (_isLoading) return;
       await Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => AddEditNotePage(note: _note, folderId: _note.folderId),
  ),
);

        _refreshNote();
      },
      icon: Icon(
        Icons.edit_outlined,
        color: Color(0xFF78A083),
      ),
    );
  }
}
