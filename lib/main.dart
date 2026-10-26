import 'package:flutter/material.dart';
import 'package:habit_tracker/habit_tracker_screen.dart';
import 'package:habit_tracker/register_screen.dart';

import 'login_screen.dart';

void main() {
  runApp(HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  const HabitTrackerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
      routes:{
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        // '/habit_tracker': (context) => HabitTrackerScreen(username: '',),
      },
    );
  }
}
