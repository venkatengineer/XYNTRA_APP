import 'package:flutter/material.dart';
import 'widgets/bottom_nav.dart';

void main() {
  runApp(const XyntraApp());
}

class XyntraApp extends StatelessWidget {
  const XyntraApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Xyntra',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        brightness: Brightness.dark,

        scaffoldBackgroundColor: Colors.black,

        primaryColor: const Color(0xFFFFC107), // Gold

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black,
          foregroundColor: Color(0xFFFFC107),
          elevation: 0,
        ),

        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.black,
          selectedItemColor: Color(0xFFFFC107),
          unselectedItemColor: Colors.grey,
        ),

        iconTheme: const IconThemeData(
          color: Color(0xFFFFC107),
        ),

        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          titleLarge: TextStyle(
            color: Color(0xFFFFC107),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      home: const BottomNav(),
    );
  }
}
