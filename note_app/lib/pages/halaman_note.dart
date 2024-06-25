import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/halaman_folder.dart';
import 'package:note_app/widgets/note_card.dart';
import 'package:note_app/pages/detail_note.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:note_app/pages/add_note.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';


class HalamanCatatan extends StatefulWidget {
  final Folder folder;

  HalamanCatatan({required this.folder});

  @override
  State<HalamanCatatan> createState() => _HalamanCatatanState();
}

class _HalamanCatatanState extends State<HalamanCatatan> {
  late List<Note> _notes = [];
  var _isLoading = false;
  int _currentIndex = 0;

  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });

    _notes = await DatabaseCatatan.instance
        .getNotesByFolder(widget.folder.folderId!);

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      
        backgroundColor: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 60,
                color: Color(0xFF78A083),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.arrow_back,
                                    color: Color(0xFF78A083)),
                                onPressed: () async {
                                  // Kembali ke halaman folder
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CatatanPage()),
                                  );
                                },
                              ),
                              Text(
                                widget.folder.namaFolder,
                                style: TextStyle(
                                  color: Color(0xFF78A083),
                                  fontSize: 25.0,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 48.0),
                            ],
                          ),
                        ),
                        Expanded(
                          child: _isLoading
                              ? Center(child: CircularProgressIndicator())
                              : _notes.isEmpty
                                  ? Center(
                                      child: Text('Notes Kosong!',
                                          style: TextStyle(
                                              color: Color(0xFF78A083))),
                                    )
                                  : StaggeredGridView.countBuilder(
                                      crossAxisCount: 2,
                                      itemCount: _notes.length,
                                      itemBuilder: (context, index) {
                                        final note = _notes[index];
                                        return GestureDetector(
                                          onTap: () async {
                                            await Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    NoteDetailPage(
                                                        id: note.noteId!),
                                              ),
                                            );
                                            _refreshNotes();
                                          },
                                          child: NoteCardWidget(
                                              note: note, index: index),
                                        );
                                      },
                                      staggeredTileBuilder: (int index) {
                                        if (index == 0) {
                                          return StaggeredTile.fit(1);
                                        } else if (index == 1 || index == 2) {
                                          return StaggeredTile.count(1, 0.8);
                                        } else {
                                          return StaggeredTile.fit(1);
                                        }
                                      },
                                      mainAxisSpacing: 4.0,
                                      crossAxisSpacing: 4.0,
                                    ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,
        buttonBackgroundColor: Color(0xFF78A083),
        color: Color(0xFF78A083),
        animationDuration: const Duration(milliseconds: 300),
        index: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });

          switch (_currentIndex) {
           
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      AddEditNotePage(folderId: widget.folder.folderId!),
                ),
              ).then((_) {
                _refreshNotes();
              });
              break;
         
          }
        },
        items: <Widget>[
         
          Icon(Icons.add,
              size: 30,
              color:
                  _currentIndex == 0 ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF)),
        
        ],
      ),
    );
  }
}
