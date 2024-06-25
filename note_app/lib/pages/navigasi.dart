import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';

class AppNavigation extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTap;

  AppNavigation({
    required this.selectedIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Container(
      color: themeProvider.isDarkMode ? Color.fromARGB(255, 42, 44, 60): Colors.white,
      child: CurvedNavigationBar(
        index: selectedIndex,
        height: 70.0,
        items: <Widget>[
          Icon(Icons.folder, size: 30, color: Colors.white),
          Icon(Icons.add, size: 30, color: Colors.white),
          Icon(Icons.history, size: 30, color: Colors.white),
        ],
        color: Color(0xFF78A083), // Default color, will be overridden by themeProvider
        buttonBackgroundColor: Color(0xFF78A083), // Default color, will be overridden by themeProvider
        backgroundColor: Colors.transparent,
        animationCurve: Curves.easeInOut,
        animationDuration: Duration(milliseconds: 800),
        onTap: onTap,
        letIndexChange: (index) => true,
      ),
    );
  }
}
