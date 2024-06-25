// import 'package:flutter/material.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:note_app/database/note_database.dart';
// import 'package:note_app/models/note.dart';
// import 'package:note_app/pages/halaman_folder.dart';
// import 'package:note_app/pages/riwayat_note.dart';
// import 'package:note_app/pages/navigasi.dart'; 

// class Riwayat extends StatefulWidget {
//   @override
//   _RiwayatState createState() => _RiwayatState();
// }

// class _RiwayatState extends State<Riwayat> {
//     int _currentIndex = 2;
 
//   // final TextEditingController _folderNameController = TextEditingController();
//   bool showFolderHistory = true;
//   bool showNoteHistory = false;

//   _showConfirmationDialog(String message, Function onConfirm) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Color(0xFFFFFFFF),
//           contentPadding: EdgeInsets.zero,
//           content: Container(
//             decoration: BoxDecoration(
//               color: Color(0xFFFFFFFF),
//               borderRadius: BorderRadius.circular(8.0),
//             ),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Color.fromARGB(255, 62, 92, 70),
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(10.0),
//                       topRight: Radius.circular(10.0),
//                     ),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 8.0),
//                         child: FittedBox(
//                           fit: BoxFit.scaleDown,
//                           child: Text(
//                             'Konfirmasi',
//                             style: TextStyle(
//                               color: Colors.white,
//                               fontSize: 18.0,
//                             ),
//                           ),
//                         ),
//                       ),
//                       IconButton(
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                         icon: Icon(
//                           Icons.close,
//                           color: Colors.white,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     color: Color(0xFFFFFFFF),
//                     borderRadius: BorderRadius.only(
//                       bottomLeft: Radius.circular(8.0),
//                       bottomRight: Radius.circular(8.0),
//                     ),
//                   ),
//                   child: Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Text(
//                           message,
//                           style: TextStyle(color: Colors.black),
//                         ),
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.symmetric(
//                             horizontal: 16.0, vertical: 8.0),
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           children: [
//                             ElevatedButton(
//                               onPressed: () {
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text(
//                                 'Batal',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Color.fromARGB(255, 160, 0, 0)),
//                               ),
//                             ),
//                             SizedBox(width: 10),
//                             ElevatedButton(
//                               onPressed: () {
//                                 onConfirm();
//                                 Navigator.of(context).pop();
//                               },
//                               child: Text(
//                                 'Ya',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               style: ButtonStyle(
//                                 backgroundColor:
//                                     MaterialStateProperty.all<Color>(
//                                         Color.fromARGB(255, 62, 92, 70)),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Color(0xFFFFFFFF),
//       body: Stack(
//         children: [
//           Positioned(
//             left: -4,
//             top: 0,
//             child: Container(
//               width: 437,
//               height: 58,
//               decoration: BoxDecoration(color: Color(0xFF78A083)),
//               child: Stack(
//                 children: [
//                   Positioned(
//                     left: 391.94,
//                     top: 22.85,
//                     child: Container(
//                       width: 28.35,
//                       height: 14.94,
//                       child: Stack(
//                         children: [],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Positioned(
//             left: 0,
//             right:
//                 0, // Add this line to stretch the Positioned widget to the full width of its parent
//             top: 99,
//             child: SizedBox(
//               width: double
//                   .infinity, // Make the SizedBox take the full width of its parent
//               height: 28,
//               child: Center(
//                 // Use Center widget to center the text horizontally and vertically
//                 child: Text(
//                   'Riwayat Hapus',
//                   textAlign: TextAlign.center,
//                   style: TextStyle(
//                     color: Color(0xFF78A083),
//                     fontSize: 30,
//                     fontFamily: 'Inter',
//                     fontWeight: FontWeight.w700,
//                     height: 1.0, // Adjusted line height
//                     letterSpacing: -0.24,
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             left: 0,
//             top: 160,
//             right: 0,
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Column for folders
//                 Column(
//                   children: [
//                     SizedBox(
//                       width: 170,
//                       height: 30,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             showFolderHistory = true;
//                             showNoteHistory = false;
//                           });
//                         },
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.resolveWith<Color>(
//                             (Set<MaterialState> states) {
//                               return showFolderHistory
//                                   ? Color(0xF278A083)
//                                   : Color(0xFF344955);
//                             },
//                           ),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                 topLeft: Radius.circular(10),
//                                 bottomLeft: Radius.circular(10),
//                               ),
//                               side: BorderSide(
//                                 color: showFolderHistory
//                                     ? Color(0xF278A083)
//                                     : Color(0xFF344955),
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                         ),
//                         child: Text(
//                           'Folder',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 SizedBox(width: 0), // Add space between columns
//                 // Column for notes
//                 Column(
//                   children: [
//                     SizedBox(
//                       width: 170,
//                       height: 30,
//                       child: ElevatedButton(
//                         onPressed: () {
//                           setState(() {
//                             showFolderHistory = false;
//                             showNoteHistory = true;
//                           });
//                         },
//                         style: ButtonStyle(
//                           backgroundColor:
//                               MaterialStateProperty.resolveWith<Color>(
//                             (Set<MaterialState> states) {
//                               return showNoteHistory
//                                   ? Color(0xF278A083)
//                                   : Color(0xFF344955);
//                             },
//                           ),
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                             RoundedRectangleBorder(
//                               borderRadius: BorderRadius.only(
//                                 topRight: Radius.circular(10),
//                                 bottomRight: Radius.circular(10),
//                               ),
//                               side: BorderSide(
//                                 color: showNoteHistory
//                                     ? Color(0xF278A083)
//                                     : Color(0xFF344955),
//                                 width: 2,
//                               ),
//                             ),
//                           ),
//                         ),
//                         child: Text(
//                           'Catatan',
//                           style: TextStyle(color: Colors.white),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//           Positioned(
//             left: 10,
//             top: 200,
//             right: 10,
//             child: Center(
//               child: SizedBox(
//                 width: 350,
//                 height: 500,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Expanded(
//                       child: FutureBuilder<List<dynamic>>(
//                         future: showFolderHistory
//                             ? DatabaseCatatan.instance.getAllDeletedFolders()
//                             : DatabaseCatatan.instance.getAllDeletedNotes(),
//                         builder: (context, snapshot) {
//                           if (snapshot.connectionState ==
//                               ConnectionState.waiting) {
//                             return Center(child: CircularProgressIndicator());
//                           } else if (snapshot.hasError) {
//                             return Center(
//                                 child: Text('Error: ${snapshot.error}'));
//                           } else {
//                             final deletedItems = snapshot.data ?? [];
//                             if (deletedItems.isEmpty) {
//                               return Center(
//                                 child: Text(
//                                   'Tidak ada riwayat hapus',
//                                   style: TextStyle(
//                                     color: Color(0xF278A083),
//                                   ),
//                                 ),
//                               );
//                             } else {
//                               return ListView.builder(
//                                 itemCount: deletedItems.length,
//                                 itemBuilder: (context, index) {
//                                   final item = deletedItems[index];
//                                   if (showFolderHistory) {
//                                     final folder = item as Folder;
//                                     return Card(
//                                       color: Color(0xFF78A083),
//                                       elevation: 2,
//                                       margin: EdgeInsets.symmetric(
//                                         horizontal: 10,
//                                         vertical: 5,
//                                       ),
//                                       child: ListTile(
//                                         title: Text(
//                                           folder.namaFolder,
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                         trailing: Row(
//                                           mainAxisSize: MainAxisSize.min,
//                                           children: [
//                                             IconButton(
//                                               icon: Icon(Icons.restore,
//                                                   color: Colors.white),
//                                               onPressed: () {
//                                                 _showConfirmationDialog(
//                                                   "Anda yakin ingin memulihkan folder ini?",
//                                                   () => _restoreFolder(folder),
//                                                 );
//                                               },
//                                             ),
//                                             IconButton(
//                                               icon: Icon(Icons.delete,
//                                                   color: Colors.white),
//                                               onPressed: () {
//                                                 _showConfirmationDialog(
//                                                   "Anda yakin ingin menghapus folder ini secara permanen?",
//                                                   () => deleteFolderPermanently(
//                                                       folder),
//                                                 );
//                                               },
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     );
//                                   } else {
//                                     final note = item as Note;
//                                     return Card(
//                                       color: Color(0xFF78A083),
//                                       margin: EdgeInsets.symmetric(
//                                         horizontal: 10,
//                                         vertical: 5,
//                                       ),
//                                       child: ExpansionTile(
//                                         title: Text(
//                                           note.judul,
//                                           style: TextStyle(color: Colors.white),
//                                         ),
//                                         children: [
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 16,
//                                               vertical: 5,
//                                             ),
//                                             child: Text(
//                                               note.isi,
//                                               style: TextStyle(
//                                                 color: Colors.white,
//                                               ),
//                                               textAlign: TextAlign
//                                                   .start, // Atur teks dari kiri ke kanan
//                                             ),
//                                           ),
//                                           Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                               horizontal: 16,
//                                               vertical: 5,
//                                             ),
//                                             child: Row(
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.end,
//                                               children: [
//                                                 IconButton(
//                                                   icon: Icon(Icons.restore,
//                                                       color: Colors.white),
//                                                   onPressed: () {
//                                                     _showConfirmationDialog(
//                                                       "Anda yakin ingin memulihkan catatan ini?",
//                                                       () => _restoreNote(note),
//                                                     );
//                                                   },
//                                                 ),
//                                                 IconButton(
//                                                   icon: Icon(Icons.delete,
//                                                       color: Colors.white),
//                                                   onPressed: () {
//                                                     _showConfirmationDialog(
//                                                       "Anda yakin ingin menghapus catatan ini secara permanen?",
//                                                       () =>
//                                                           deleteNotePermanently(
//                                                               note),
//                                                     );
//                                                   },
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     );
//                                   }
//                                 },
//                               );
//                             }
//                           }
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),

//     );
//   }

 

//   Future<void> _restoreFolder(Folder folder) async {
//     if (folder.folderId != null) {
//       await DatabaseCatatan.instance.restoreFolder(folder.folderId!);
//       setState(() {});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Folder berhasil dipulihkan'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }

//   Future<void> deleteFolderPermanently(Folder folder) async {
//     if (folder.folderId != null) {
//       await DatabaseCatatan.instance.deleteFolderPermanently(folder.folderId!);
//       setState(() {});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Folder berhasil dihapus secara permanen'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }

//   Future<void> _restoreNote(Note note) async {
//     if (note.noteId != null) {
//       await DatabaseCatatan.instance.restoreNote(note.noteId!);
//       setState(() {});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Catatan berhasil dipulihkan'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }

//   Future<void> deleteNotePermanently(Note note) async {
//     if (note.noteId != null) {
//       await DatabaseCatatan.instance.deleteNotePermanently(note.noteId!);
//       setState(() {});

//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(
//           content: Text('Catatan berhasil dihapus secara permanen'),
//           backgroundColor: Colors.green,
//         ),
//       );
//     }
//   }
// }
