import 'package:app/pages/home/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    home: HomePage(),
    title: 'Weather Monitor',
    theme: ThemeData(
      brightness: Brightness.light,
      appBarTheme: AppBarTheme(brightness: Brightness.dark),
      scaffoldBackgroundColor: Colors.white,
      backgroundColor: Colors.white,
      primaryColor: Colors.cyan,
      accentColor: Colors.cyanAccent,
      cursorColor: Colors.cyan,
      canvasColor: Colors.transparent,
    ),
    debugShowCheckedModeBanner: false,
  ),
);