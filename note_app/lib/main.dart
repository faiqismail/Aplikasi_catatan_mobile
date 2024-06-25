import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:note_app/pages/start_page.dart';
import 'package:note_app/pages/theme_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Color.fromARGB(255, 62, 92, 70),
              secondary: Color(0xFF78A083),
            ),
          ),
          darkTheme: ThemeData(
            colorScheme: ColorScheme.dark(
              primary: Color.fromARGB(255, 62, 92, 70),
              secondary: Color(0xFF78A083),
            ),
          ),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: NotePage(),
        );
      },
    );
  }
}