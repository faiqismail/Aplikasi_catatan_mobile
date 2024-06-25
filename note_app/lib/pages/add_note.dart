import 'package:flutter/material.dart';
import 'package:html_editor_enhanced/html_editor.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/database/note_database.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:async';


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


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.judul ?? '');

  }

  @override
  void dispose() {
 

    _titleController.dispose();
    super.dispose();
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
          content: Text('Tidak Ada Catatan yang ada '),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _saveNoteAndExit() async {
    final title = _titleController.text.trim();
    final descriptionHtml = await _descriptionController.getText();

    if (title.isNotEmpty || descriptionHtml.isNotEmpty) {
      try {
        if (widget.note == null) {
          await DatabaseCatatan.instance.createNote(
            title,
            descriptionHtml,
            DateTime.now().toIso8601String(),
            widget.folderId,
          );
        } else {
          await DatabaseCatatan.instance.updateNote(
            widget.note!.noteId!,
            title,
            descriptionHtml,
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menyimpan catatan: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      Navigator.pop(context); // Kembali tanpa menyimpan jika tidak ada yang terisi
    }
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF78A083),
        automaticallyImplyLeading: false,
        toolbarHeight: 20,
      ),
      body: Container(
        color: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60): Colors.white,
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
                        onPressed: _saveNoteAndExit,
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
                 shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 3),
                      HtmlEditor(
                        
                        controller: _descriptionController,
                        htmlEditorOptions: HtmlEditorOptions(
                          hint: 'Ketikan Sesuatu...',
                          initialText: widget.note?.isi ?? '',

                        ),
                        
                        htmlToolbarOptions: HtmlToolbarOptions(
                          toolbarPosition: ToolbarPosition.aboveEditor,
                          toolbarType: ToolbarType.nativeScrollable,
                          onButtonPressed: (ButtonType type, bool? status, Function? updateStatus) {
                            print("button '${describeEnum(type)}' pressed, the current selected status is $status");
                            return true;
                          },
                          onDropdownChanged: (DropdownType type, dynamic changed, Function(dynamic)? updateSelectedItem) {
                            print("dropdown '${describeEnum(type)}' changed to $changed");
                            return true;
                          },
                          mediaLinkInsertInterceptor: (String url, InsertFileType type) {
                            print(url);
                            return true;
                          },
                          mediaUploadInterceptor: (PlatformFile file, InsertFileType type) async {
                            print(file.name); //filename
                            print(file.size); //size in bytes
                            print(file.extension); //file extension (eg jpeg or mp4)
                            return true;
                          },
                        ),
                        otherOptions: OtherOptions(height: 250),
                        callbacks: Callbacks(onBeforeCommand: (String? currentHtml) {
                          print('html before change is $currentHtml');
                        }, onChangeContent: (String? changed) {
                          print('content changed to $changed');
                        }, onChangeCodeview: (String? changed) {
                          print('code changed to $changed');
                        }, onChangeSelection: (EditorSettings settings) {
                          print('parent element is ${settings.parentElement}');
                          print('font name is ${settings.fontName}');
                        }, onDialogShown: () {
                          print('dialog shown');
                        }, onEnter: () {
                          print('enter/return pressed');
                        }, onFocus: () {
                          print('editor focused');
                        }, onBlur: () {
                          print('editor unfocused');
                        }, onBlurCodeview: () {
                          print('codeview either focused or unfocused');
                        }, onInit: () {
                          print('init');
                        },
                            onImageUploadError: (FileUpload? file, String? base64Str, UploadError error) {
                          print(describeEnum(error));
                          print(base64Str ?? '');
                          if (file != null) {
                            print(file.name);
                            print(file.size);
                            print(file.type);
                          }
                        }, onKeyDown: (int? keyCode) {
                          print('$keyCode key downed');
                          print('current character count: ${_descriptionController.characterCount}');
                        }, onKeyUp: (int? keyCode) {
                          print('$keyCode key released');
                        }, onMouseDown: () {
                          print('mouse downed');
                        }, onMouseUp: () {
                          print('mouse released');
                        }, onNavigationRequestMobile: (String url) {
                          print(url);
                          return NavigationActionPolicy.ALLOW;
                        }, onPaste: () {
                          print('pasted into editor');
                        }, onScroll: () {
                          print('editor scrolled');
                        }),
                        plugins: [
                          SummernoteAtMention(
                            getSuggestionsMobile: (String value) {
                              var mentions = <String>['test1', 'test2', 'test3'];
                              return mentions.where((element) => element.contains(value)).toList();
                            },
                            mentionsWeb: ['test1', 'test2', 'test3'],
                            onSelect: (String value) {
                              print(value);
                            },
                          ),
                        ],
                        
                      ),
                    ],
                    
                  ),
                ),
              ),
            
            ],
            
          ),
        ),
      ),
    );
  }

 
}
