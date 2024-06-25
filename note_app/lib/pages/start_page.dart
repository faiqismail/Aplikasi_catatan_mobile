import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'halaman_folder.dart';

class NotePage extends StatelessWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
        backgroundColor: themeProvider.isDarkMode
          ? Color.fromARGB(255, 42, 44, 60)
          : Colors.white,
      appBar: AppBar(
        
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Menggunakan operator ternary untuk menetapkan warna latar belakang
      
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Center(
                child: Text(
                  'Selamat Datang\nDi TriNotes',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Text(
                  'CARA PEMAKAIAN APLIKASI',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: 10),
              buildInstructionWithIcon(
                context,
                '1',
                'Silakan untuk membuat folder terlebih dahulu dengan klik ikon + di navigasi.',
                Icons.add,
              ),
              buildInstructionWithIcon(
                context,
                '2',
                'Lalu klik folder yang telah dibuat.',
                Icons.folder,
              ),
              buildInstructionWithIcon(
                context,
                '3',
                'Setelah itu, buat catatan dengan mengklik ikon + di navigasi.',
                Icons.add,
              ),
              buildInstruction(
                context,
                '4',
                'Folder dan catatan yang telah dihapus akan masuk ke riwayat hapus.',
              ),
              buildInstructionWithIcon(
                context,
                '5',
                'Untuk mengembalikan data yang sudah dihapus, klik ikon pulihkan yang berada di riwayat hapus.',
                Icons.restore,
              ),
              buildInstructionWithIcon(
                context,
                '6',
                'Untuk menghapus data secara permanen, klik ikon delete yang berada di riwayat hapus.',
                Icons.delete,
              ),
              buildInstructionWithIcon(
                context,
                '7',
                'Jika ingin merubah ke ke dark mode maka pencet icon di pojok kanan atas di halaman start.',
                Icons.brightness_6,
              ),
              SizedBox(height: 10),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CatatanPage()),
                    );
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        Theme.of(context).colorScheme.secondary),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 10.0),
                    child: Text(
                      'Start',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInstruction(BuildContext context, String number, String text, {IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.secondary,
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          SizedBox(width: 10),
          if (icon != null)
            CircleAvatar(
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                icon,
                size: 25,
                color: Colors.white,
              ),
            ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildInstructionWithIcon(BuildContext context, String number, String text, IconData icon) {
    return buildInstruction(context, number, text, icon: icon);
  }
}
