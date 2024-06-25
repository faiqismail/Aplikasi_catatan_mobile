import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/database/note_database.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:flutter/foundation.dart';

class AddEditNotePage extends StatefulWidget {
  const AddEditNotePage({Key? key, this.note, required this.folderId})
      : super(key: key);

  final Note? note;
  final int folderId;

  @override
  _AddEditNotePageState createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {
  late TextEditingController _titleController;
  final HtmlEditorController _descriptionController = HtmlEditorController();
  String? _initialTitle;
  String? _initialDescription;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.judul ?? '');
    _initialTitle = widget.note?.judul ?? '';
    _initialDescription = widget.note?.isi ?? '';

    // Tunggu sedikit sebelum menetapkan teks ke editor
    Future.delayed(Duration(milliseconds: 500), () {
      _descriptionController.setText(_initialDescription ?? '');
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    final currentTitle = _titleController.text.trim();
    final currentDescription = await _descriptionController.getText();
    if (currentTitle != _initialTitle || currentDescription != _initialDescription) {
      _saveNote();
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF78A083),
          automaticallyImplyLeading: false,
          toolbarHeight: 20,
        ),
        body: Container(
          color: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () async {
                          if (await _onWillPop()) {
                            Navigator.pop(context);
                          }
                        },
                        icon: Icon(
                          Icons.arrow_back,
                          color: Color(0xFF78A083),
                        ),
                      ),
                      Text(
                        widget.note == null ? 'Tambah Catatan' : 'Edit Catatan',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF78A083),
                        ),
                      ),
                      IconButton(
                        onPressed: _saveNote,
                        icon: Icon(
                          Icons.check,
                          color: Color(0xFF78A083),
                        ),
                      ),
                    ],
                  ),
                ),
                Card(
                  color: Color(0xFF78A083),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _titleController,
                          style: TextStyle(
                            color: _titleController.text.isEmpty
                                ? Color.fromARGB(255, 255, 255, 255)
                                : Colors.white,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Judul',
                            hintStyle: TextStyle(color: Color(0xFFFFFFFF)),
                            border: InputBorder.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 7),
                Card(
                  color: Color(0xFF78A083),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 3),
                        FutureBuilder(
                          future: Future.delayed(Duration(milliseconds: 500)),
                          builder: (context, snapshot) {
                            return HtmlEditor(
                              controller: _descriptionController,
                              htmlEditorOptions: HtmlEditorOptions(
                                hint: 'Ketikan Sesuatu...',
                              ),
                              htmlToolbarOptions: HtmlToolbarOptions(
                                toolbarPosition: ToolbarPosition.aboveEditor,
                                toolbarType: ToolbarType.nativeScrollable,
                                // Definisikan fungsi-fungsi yang diperlukan
                              ),
                              otherOptions: OtherOptions(height: 250),
                              // Callbacks dan Plugins
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveNote() async {
    final title = _titleController.text.trim();
    final descriptionHtml = await _descriptionController.getText();

    if (title.isNotEmpty && descriptionHtml.isNotEmpty) {
      try {
        if (widget.note == null) {
          await DatabaseCatatan.instance.createNote(
            title,
            descriptionHtml, // Simpan HTML ke dalam database
            DateTime.now().toIso8601String(),
            widget.folderId,
          );
        } else {
          await DatabaseCatatan.instance.updateNote(
            widget.note!.noteId!,
            title,
            descriptionHtml, // Simpan HTML ke dalam database
            widget.folderId,
          );
        }

        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Catatan berhasil ${widget.note == null ? 'ditambahkan' : 'diperbarui'}'),
            backgroundColor: Colors.green,
          ),
        );
      } catch (e) {
        print('Gagal menyimpan catatan: $e');
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Judul dan deskripsi tidak boleh kosong'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
