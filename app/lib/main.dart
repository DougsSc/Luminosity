import 'file:///C:/Users/Doug/AndroidStudioProjects/Luminosity/app/lib/pages/home_page.dart';
import 'package:flutter/material.dart';

void main() => runApp(
  MaterialApp(
    home: HomePage(),
    title: 'Luminosity',
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