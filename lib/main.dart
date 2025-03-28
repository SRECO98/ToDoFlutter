import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import your main screen

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      title: 'To-Do App',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Sets default theme color
      ),
      home: HomeScreen(), // Starts with HomeScreen
    );
  }
}
