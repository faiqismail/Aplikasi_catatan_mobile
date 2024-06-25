import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:note_app/models/note.dart';

class DatabaseCatatan {
  static final DatabaseCatatan instance = DatabaseCatatan._init();
  static final String tableFolders = 'folders';
  static final String tablenote = 'notes';
  static Database? _database;

  DatabaseCatatan._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('trinote.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDb,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDb(Database db, int version) async {
    final String sqlFolders = '''
    CREATE TABLE folders(
      folder_id INTEGER PRIMARY KEY AUTOINCREMENT,
      nama_folder TEXT NOT NULL,
      is_deleted INTEGER DEFAULT 0, 
      deleted_at TEXT
    )
  ''';
    await db.execute(sqlFolders);

    final String sqlNotes = '''
    CREATE TABLE notes(
      note_id INTEGER PRIMARY KEY AUTOINCREMENT,
      judul TEXT NOT NULL,
      isi TEXT NOT NULL,
      time TEXT NOT NULL,
      folder_id INTEGER,
      is_deleted INTEGER DEFAULT 0,
      deleted_at TEXT,
      FOREIGN KEY (folder_id) REFERENCES folders(folder_id)
    )
  ''';
    await db.execute(sqlNotes);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      await _onUpgradeFolders(db);
      await _onUpgradeNotes(db);
    }
  }

  Future<void> _onUpgradeFolders(Database db) async {
    await db.execute('''
    ALTER TABLE folders 
    ADD COLUMN is_deleted INTEGER DEFAULT 0
  ''');
    await db.execute('''
    ALTER TABLE folders 
    ADD COLUMN deleted_at TEXT
  ''');
  }

  Future<void> _onUpgradeNotes(Database db) async {
    await db.execute('''
    ALTER TABLE notes 
    ADD COLUMN is_deleted INTEGER DEFAULT 0
  ''');
    await db.execute('''
    ALTER TABLE notes 
    ADD COLUMN deleted_at TEXT
  ''');
  }

  Future<int> createFolder(String namaFolder) async {
    try {
      final db = await database;
      final id = await db.insert('folders', {'nama_folder': namaFolder});
      print('ID Folder yang disimpan: $id');
      return id;
    } catch (e) {
      print('Error createFolder: $e');
      throw e;
    }
  }

  Future<int> createNote(
      String judul, String isi, String time, int folderId) async {
    final db = await database;
    final id = await db.insert('notes',
        {'judul': judul, 'isi': isi, 'time': time, 'folder_id': folderId});
    return id;
  }

  Future<List<Folder>> getAllFolders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'folders',
      where: 'is_deleted = ?',
      whereArgs: [0], // Hanya ambil folder yang belum dihapus
    );
    return List.generate(maps.length, (i) {
      return Folder(
        folderId: maps[i]['folder_id'],
        namaFolder: maps[i]['nama_folder'],
      );
    });
  }

  Future<List<Folder>> getAllDeletedFolders() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'folders',
      where: 'is_deleted = ?',
      whereArgs: [1], // Hanya ambil folder yang sudah dihapus
    );
    return List.generate(maps.length, (i) {
      return Folder(
        folderId: maps[i]['folder_id'],
        namaFolder: maps[i]['nama_folder'],
      );
    });
  }

  Future<List<Note>> getAllDeletedNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'is_deleted = ?',
      whereArgs: [1],
    );

    return List.generate(maps.length, (i) {
      return Note(
        noteId: maps[i][NoteFields.noteId],
        judul: maps[i][NoteFields.judul],
        isi: maps[i][NoteFields.isi],
        time: DateTime.parse(maps[i][NoteFields.time]),
        folderId: maps[i][NoteFields.folderId],
      );
    });
  }

  Future<List<Note>> getAllNotes() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('notes', where: 'is_deleted = ?', whereArgs: [0]);
    return List.generate(maps.length, (i) {
      return Note(
        noteId: maps[i][NoteFields.noteId],
        judul: maps[i][NoteFields.judul],
        isi: maps[i][NoteFields.isi],
        time: DateTime.parse(maps[i][NoteFields.time]),
        folderId: maps[i][NoteFields.folderId],
      );
    });
  }

  Future<void> deleteFolder(int folderId) async {
    final db = await database;
    final currentTime = DateTime.now().toIso8601String();
    await db.update('folders', {'is_deleted': 1, 'deleted_at': currentTime},
        where: 'folder_id = ?', whereArgs: [folderId]);
  }

  Future<void> restoreFolder(int folderId) async {
    final db = await database;
    await db.update('folders', {'is_deleted': 0, 'deleted_at': null},
        where: 'folder_id = ?', whereArgs: [folderId]);
  }

  Future<void> deleteNote(int noteId) async {
    try {
      final db = await database;
      final currentTime = DateTime.now().toIso8601String();
      await db.update(
        'notes',
        {'is_deleted': 1, 'deleted_at': currentTime},
        where: 'note_id = ?',
        whereArgs: [noteId],
      );
      print('Catatan dengan ID $noteId berhasil dihapus.');
    } catch (e) {
      print('Error saat menghapus catatan: $e');
      throw e;
    }
  }

  Future<void> restoreNote(int noteId) async {
    final db = await database;
    await db.update('notes', {'is_deleted': 0, 'deleted_at': null},
        where: 'note_id = ?', whereArgs: [noteId]);
  }

  Future<Note?> getNoteById(int noteId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'note_id = ? ',
      whereArgs: [noteId],
    );

    if (maps.isNotEmpty) {
      return Note(
        noteId: maps.first[NoteFields.noteId],
        judul: maps.first[NoteFields.judul],
        isi: maps.first[NoteFields.isi],
        time: DateTime.parse(maps.first[NoteFields.time]),
        folderId: maps.first[NoteFields.folderId],
      );
    }

    return null;
  }

  Future<List<Note>> getNotesByFolder(int folderId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'notes',
      where: 'is_deleted = ? AND folder_id = ?',
      whereArgs: [0, folderId],
    );

    return List.generate(maps.length, (i) {
      return Note(
        noteId: maps[i][NoteFields.noteId],
        judul: maps[i][NoteFields.judul],
        isi: maps[i][NoteFields.isi],
        time: DateTime.parse(maps[i][NoteFields.time]),
        folderId: maps[i][NoteFields.folderId],
      );
    });
  }

  // Metode untuk menghapus atau memulihkan catatan
  Future<void> toggleNoteDeletedStatus(int noteId, bool isDeleted) async {
    final db = await database;
    await db.update(
      'notes',
      {'is_deleted': isDeleted ? 1 : 0},
      where: 'note_id = ?',
      whereArgs: [noteId],
    );
  }

  // Metode untuk menghapus atau memulihkan folder
  Future<void> toggleFolderDeletedStatus(int folderId, bool isDeleted) async {
    final db = await database;
    await db.update(
      'folders',
      {'is_deleted': isDeleted ? 1 : 0},
      where: 'folder_id = ?',
      whereArgs: [folderId],
    );
  }

  // Metode untuk memperbarui catatan
  Future<void> updateNote(
      int noteId, String title, String description, int folderId) async {
    final db = await database;
    final currentTime = DateTime.now().toIso8601String();
    await db.update(
      'notes',
      {
        'judul': title,
        'isi': description,
        'time': currentTime,
        'folder_id': folderId
      },
      where: 'note_id = ?',
      whereArgs: [noteId],
    );
  }

  Future<void> updateFolder(int folderId, String updatedFolderName) async {
    final db = await database;
    await db.update(
      'folders',
      {'nama_folder': updatedFolderName},
      where: 'folder_id = ?',
      whereArgs: [folderId],
    );
  }

  Future<int> countNotesInFolder(int folderId) async {
    final db = await database;
    final result = await db.rawQuery('''
    SELECT COUNT(*) as count FROM notes WHERE folder_id = ? AND is_deleted = ?
  ''', [folderId, 0]);
    return Sqflite.firstIntValue(result) ?? 0;
  }

  Future<void> deleteFolderPermanently(int folderId) async {
    final db = await database;
    await db.delete(
      'folders',
      where: 'folder_id = ?',
      whereArgs: [folderId],
    );
  }

  Future<void> deleteNotePermanently(int noteId) async {
    final db = await database;
    await db.delete(
      'notes',
      where: 'note_id = ?',
      whereArgs: [noteId],
    );
  }
}
