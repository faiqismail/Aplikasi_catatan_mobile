import 'package:flutter/material.dart';
import 'package:note_app/database/note_database.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/pages/halaman_note.dart';
import 'package:note_app/pages/navigasi.dart';  
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'package:flutter_html/flutter_html.dart';

class CatatanPage extends StatefulWidget {
  @override
  _CatatanPageState createState() => _CatatanPageState();
}

class _CatatanPageState extends State<CatatanPage> {
  
  late List<Folder> _folders;
  bool _isLoading = false;
  final TextEditingController _folderNameController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  int _selectedIndex = 0;

  Future<void> _refreshFolders() async {
    setState(() {
      _isLoading = true;
    });

    _folders = await DatabaseCatatan.instance.getAllFolders();

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshFolders();
  }

  _showeditDialog(BuildContext context, Folder folder) {
    TextEditingController _folderNameController =
        TextEditingController(text: folder.namaFolder);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        final themeProvider = Provider.of<ThemeProvider>(context);
return AlertDialog(
  backgroundColor: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,
  contentPadding: EdgeInsets.zero,
  content: Container(
    width: 400,
    decoration: BoxDecoration(
      color: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,
      borderRadius: BorderRadius.circular(16.0),
    ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF78A083),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 8.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Edit Folder            ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _folderNameController,
                          decoration: InputDecoration(
                            hintText: "Nama Folder",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Color(0xFF78A083),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                if (folder.folderId != null) {
                                  await DatabaseCatatan.instance
                                      .deleteFolder(folder.folderId!);
                                  Navigator.of(context).pop();
                                  _refreshFolders();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Folder dihapus'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              child: Text('Hapus'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.red),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            ),
                            SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: () async {
                                String updatedFolderName =
                                    _folderNameController.text;
                                if (folder.folderId != null) {
                                  await DatabaseCatatan.instance.updateFolder(
                                      folder.folderId!, updatedFolderName);
                                  Navigator.of(context).pop();
                                  _refreshFolders();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Folder diedit'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );
                                }
                              },
                              child: Text('Selesai'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF78A083)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  _showAddDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
         final themeProvider = Provider.of<ThemeProvider>(context);
        return AlertDialog(
         backgroundColor: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
               color: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,
              borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF78A083),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Masukkan Nama Folder        ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextField(
                          controller: _folderNameController,
                          decoration: InputDecoration(
                            hintText: "",
                            hintStyle: TextStyle(color: Colors.grey),
                            filled: true,
                            fillColor: Color(0xFF78A083),
                          ),
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () async {
                                String _tempFolderName =
                                    _folderNameController.text;
                                await DatabaseCatatan.instance
                                    .createFolder(_tempFolderName);
                                Navigator.of(context).pop();
                                _refreshFolders();

                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Text('Folder berhasil ditambahkan'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              child: Text('Simpan'),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xFF78A083)),
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

void _onItemTapped(int index) {
  if (index == 0) {
    // Tetap di halaman ini
  } else if (index == 1) {
    _showAddDialog(context);
  } else if (index == 2) {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        pageBuilder: (context, animation1, animation2) => RiwayatPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
       backgroundColor: themeProvider.isDarkMode ?Color.fromARGB(255, 42, 44, 60) : Colors.white, // Sesuaikan latar belakang dengan status tema
    
      body: RefreshIndicator(
        onRefresh: _refreshFolders,
        child: Container(
          width: 430,
          height: 932,
          clipBehavior: Clip.antiAlias,
           decoration: BoxDecoration(color: themeProvider.isDarkMode ? Color.fromARGB(255, 42, 44, 60) : Colors.white), // Sesuaikan latar belakang dengan status tema
        
          child: Stack(
            children: [
              Positioned(
                left: -4,
                top: 0,
                child: Container(
                  width: 437,
                  height: 58,
                  decoration: BoxDecoration(color: Color(0xFF78A083)),
                  child: Stack(
                    children: [
                      Positioned(
                        left: 391.94,
                        top: 22.85,
                        child: Container(
                          width: 28.35,
                          height: 14.94,
                          child: Stack(
                            children: [
                              // Child stack content here
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                top: 70,
                child: SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: Center(
                    child: Text(
                      'Folder',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xFF78A083),
                        fontSize: 30,
                        fontFamily: 'Inter',
                        fontWeight: FontWeight.w700,
                        height: 1.0,
                        letterSpacing: -0.24,
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: 15,
                top: 120,
                right: 15,
                bottom: 20,
                child: Column(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width - 10,
                      height: 50,
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: "Cari Nama Folder",
                          hintStyle: TextStyle(
                              color: const Color.fromARGB(255, 255, 255, 255)),
                          filled: true,
                          fillColor: Color(0xFFC6DBCC),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          prefixIcon: Icon(Icons.search, color: Colors.white),
                        ),
                        style: TextStyle(color: Colors.white),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    Expanded(
                      child: _isLoading
                          ? Center(child: CircularProgressIndicator())
                          : _folders.isEmpty
                              ? Center(
                                  child: Text(
                                    'Data Folder Kosong!',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount: _folders.length,
                                  itemBuilder: (context, index) {
                                    final folder = _folders[index];
                                    if (_searchController.text.isEmpty ||
                                        folder.namaFolder
                                            .toLowerCase()
                                            .contains(_searchController.text
                                                .toLowerCase())) {
                                      return GestureDetector(
                                        onTap: () async {
                                          await Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  HalamanCatatan(
                                                      folder: folder),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: 50,
                                          height: 86,
                                          padding: EdgeInsets.all(8),
                                          margin: EdgeInsets.all(8),
                                          decoration: BoxDecoration(
                                            color: Color(0xFF78A083),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Expanded(
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      ' ${folder.namaFolder}',
                                                      style: TextStyle(
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color:
                                                            Color(0xFFFFFFFF),
                                                      ),
                                                    ),
                                                    SizedBox(height: 8),
                                                    FutureBuilder<int>(
                                                      future: DatabaseCatatan
                                                          .instance
                                                          .countNotesInFolder(
                                                              folder.folderId!),
                                                      builder:
                                                          (context, snapshot) {
                                                        if (snapshot
                                                                .connectionState ==
                                                            ConnectionState
                                                                .done) {
                                                          if (snapshot
                                                              .hasError) {
                                                            return Text(
                                                              'Error',
                                                              style: TextStyle(
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                            );
                                                          } else {
                                                            return Text(
                                                              '${snapshot.data} Catatan',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                            );
                                                          }
                                                        } else {
                                                          return CircularProgressIndicator();
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.menu,
                                                    color: Color(0xFFFFFFFF)),
                                                onPressed: () {
                                                  _showeditDialog(
                                                      context, folder);
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: AppNavigation(
        selectedIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class RiwayatPage extends StatefulWidget {
  @override
  _RiwayatPageState createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {

  bool showFolderHistory = true;
  bool showNoteHistory = false;

  _showConfirmationDialog(String message, Function onConfirm) {
    
    showDialog(
      
      context: context,
      builder: (BuildContext context) {
         final themeProvider = Provider.of<ThemeProvider>(context);
        return AlertDialog(
          backgroundColor: Color(0xFFFFFFFF),
          contentPadding: EdgeInsets.zero,
          content: Container(
            decoration: BoxDecoration(
              color: Color(0xFFFFFFFF),
               borderRadius: BorderRadius.circular(16.0),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 62, 92, 70),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10.0),
                      topRight: Radius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Text(
                            'Konfirmasi',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(
                          Icons.close,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  
                  decoration: BoxDecoration(

                   color: themeProvider.isDarkMode ? const Color.fromARGB(255, 30, 30, 30) : Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(8.0),
                      bottomRight: Radius.circular(8.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          message,
                          style: TextStyle(color: Color(0xFF78A083)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Batal',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 160, 0, 0)),
                              ),
                            ),
                            SizedBox(width: 10),
                            ElevatedButton(
                              onPressed: () {
                                onConfirm();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                'Ya',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color.fromARGB(255, 62, 92, 70)),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _restoreFolder(Folder folder) async {
    if (folder.folderId != null) {
      await DatabaseCatatan.instance.restoreFolder(folder.folderId!);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Folder berhasil dipulihkan'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> deleteFolderPermanently(Folder folder) async {
    if (folder.folderId != null) {
      await DatabaseCatatan.instance.deleteFolderPermanently(folder.folderId!);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Folder berhasil dihapus secara permanen'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> _restoreNote(Note note) async {
    if (note.noteId != null) {
      await DatabaseCatatan.instance.restoreNote(note.noteId!);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan berhasil dipulihkan'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  Future<void> deleteNotePermanently(Note note) async {
    if (note.noteId != null) {
      await DatabaseCatatan.instance.deleteNotePermanently(note.noteId!);
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Catatan berhasil dihapus secara permanen'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
     final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      backgroundColor: themeProvider.isDarkMode ? const Color.fromARGB(255, 42, 44, 60) : Colors.white,

      body: Stack(
        children: [
          Positioned(
            left: -4,
            top: 0,
            child: Container(
              width: 437,
              height: 58,
              decoration: BoxDecoration(color: Color(0xFF78A083)),
              child: Stack(
                children: [
                  Positioned(
                    left: 391.94,
                    top: 22.85,
                    child: Container(
                      width: 28.35,
                      height: 14.94,
                      child: Stack(
                        children: [],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            top: 70,
            child: SizedBox(
              width: double.infinity,
              height: 28,
              child: Center(
                child: Text(
                  'Riwayat Hapus',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF78A083),
                    fontSize: 30,
                    fontFamily: 'Inter',
                    fontWeight: FontWeight.w700,
                    height: 1.0,
                    letterSpacing: -0.24,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            top: 130,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 170,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showFolderHistory = true;
                            showNoteHistory = false;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return showFolderHistory
                                  ? Color(0xF278A083)
                                  : Color(0xFF344955);
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                              side: BorderSide(
                                color: showFolderHistory
                                    ? Color(0xF278A083)
                                    : Color(0xFF344955),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'Folder',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 0),
                Column(
                  children: [
                    SizedBox(
                      width: 170,
                      height: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showFolderHistory = false;
                            showNoteHistory = true;
                          });
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.resolveWith<Color>(
                            (Set<MaterialState> states) {
                              return showNoteHistory
                                  ? Color(0xF278A083)
                                  : Color(0xFF344955);
                            },
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                              side: BorderSide(
                                color: showNoteHistory
                                    ? Color(0xF278A083)
                                    : Color(0xFF344955),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        child: Text(
                          'Catatan',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
                    Positioned(
            left: 10,
            top: 170,
            right: 10,
            child: Center(
             child: SizedBox(
  width: 350,
  height: 560,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: FutureBuilder<List<dynamic>>(
          future: showFolderHistory
              ? DatabaseCatatan.instance.getAllDeletedFolders()
              : DatabaseCatatan.instance.getAllDeletedNotes(),
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child: Text('Error: ${snapshot.error}'));
            } else {
              final deletedItems = snapshot.data ?? [];
              if (deletedItems.isEmpty) {
                return Center(
                  child: Text(
                    'Tidak ada riwayat hapus',
                    style: TextStyle(
                      color: Color(0xF278A083),
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: deletedItems.length,
                  itemBuilder: (context, index) {
                    final item = deletedItems[index];
                    if (showFolderHistory) {
                      final folder = item as Folder;
                      return Card(
                        color: Color(0xFF78A083),
                        elevation: 2,
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ListTile(
                          title: Text(
                            folder.namaFolder,
                            style: TextStyle(color: Colors.white),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.restore,
                                    color: Colors.white),
                                onPressed: () {
                                  _showConfirmationDialog(
                                    "Anda yakin ingin memulihkan folder ini?",
                                    () => _restoreFolder(folder),
                                  );
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete,
                                    color: Colors.white),
                                onPressed: () {
                                  _showConfirmationDialog(
                                    "Anda yakin ingin menghapus folder ini secara permanen?",
                                    () => deleteFolderPermanently(
                                        folder),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      final note = item as Note;
                      return Card(
                        color: Color(0xFF78A083),
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        child: ExpansionTile(
                          title: Text(
                            note.judul,
                            style: TextStyle(color: Colors.white),
                          ),
                          children: [
Padding(
  padding: const EdgeInsets.symmetric(
    horizontal: 16,
    vertical: 5,
  ),
  child: Html(
    data: note.isi,
    style: {
      "body": Style(
        color: Colors.white,
      ),
    },
  ),
),


                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 5,
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.restore,
                                        color: Colors.white),
                                    onPressed: () {
                                      _showConfirmationDialog(
                                        "Anda yakin ingin memulihkan catatan ini?",
                                        () => _restoreNote(note),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete,
                                        color: Colors.white),
                                    onPressed: () {
                                      _showConfirmationDialog(
                                        "Anda yakin ingin menghapus catatan ini secara permanen?",
                                        () =>
                                            deleteNotePermanently(
                                                note),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                );
              }
            }
          },
        ),
      ),
    ],
  ),
),

            ),
          ),
        ],
      ),
     bottomNavigationBar: AppNavigation(
  selectedIndex: 2, // Riwayat page index
  onTap: (index) {
    if (index == 0) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (context, animation1, animation2) => CatatanPage(),
          transitionDuration: Duration.zero,
          reverseTransitionDuration: Duration.zero,
        ),
      );
    } else if (index == 1) {
 showDialog(
  context: context,
  builder: (context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: EdgeInsets.zero,
      content: Container(
        decoration: ShapeDecoration(
          color: themeProvider.isDarkMode ? Color.fromARGB(255, 30, 30, 30) : Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0), // Sudut tumpul di seluruh sisi
          ),
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Color(0xFF78A083),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16.0), // Sudut tumpul di kiri atas
                      topRight: Radius.circular(16.0), // Sudut tumpul di kanan atas
                    ),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 20.0),
                  child: Center(
                    child: Text(
                      'Pemberitahuan',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    'input folder di halaman folder',
                    style: TextStyle(
                      color: Color(0xFF78A083),
                      fontSize: 16.0,
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 8.0,
              right: 8.0,
              child: IconButton(
                icon: Icon(Icons.close),
                color: Colors.white,
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
    );
  },
);




    }
  },
),

    );
  }
}
