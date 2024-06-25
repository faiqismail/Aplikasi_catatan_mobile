const String tableFolders = 'folders';

class FolderFields {
  static const String folderId = 'folder_id';
  static const String namaFolder = 'nama_folder';
}

class Folder {
  final int? folderId;
  final String namaFolder;

  Folder({
    this.folderId,
    required this.namaFolder,
  });

  Folder copy({
    int? folderId,
    String? namaFolder,
  }) {
    return Folder(
      folderId: folderId ?? this.folderId,
      namaFolder: namaFolder ?? this.namaFolder,
    );
  }

 static Folder fromJson(Map<String, Object?> json) {
  return Folder(
    folderId: json[FolderFields.folderId] as int,
    namaFolder: json[FolderFields.namaFolder] as String,
  );
}


  Map<String, Object?> toJson() {
    return {
      FolderFields.folderId: folderId,
      FolderFields.namaFolder: namaFolder,
    };
  }
}

const String tableNotes = 'notes';

class NoteFields {
  static const String noteId = 'note_id';
  static const String judul = 'judul';
  static const String isi = 'isi';
  static const String time = 'time';
  static const String folderId = 'folder_id';
}

class Note {
  final int? noteId;
  final String judul;
  final String isi;
  final DateTime time;
  final int folderId;

  Note({
    this.noteId,
    required this.judul,
    required this.isi,
    required this.time,
    required this.folderId,
  });

  Note copy({
    int? noteId,
    String? judul,
    String? isi,
    DateTime? time,
    int? folderId,
  }) {
    return Note(
      noteId: noteId ?? this.noteId,
      judul: judul ?? this.judul,
      isi: isi ?? this.isi,
      time: time ?? this.time,
      folderId: folderId ?? this.folderId,
    );
  }
  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      noteId: json[NoteFields.noteId] as int?,
      judul: json[NoteFields.judul] as String,
      isi: json[NoteFields.isi] as String,
      time: DateTime.parse(json[NoteFields.time] as String),
      folderId: json[NoteFields.folderId] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      NoteFields.noteId: noteId,
      NoteFields.judul: judul,
      NoteFields.isi: isi,
      NoteFields.time: time.toIso8601String(),
      NoteFields.folderId: folderId,
    };
  }
}



