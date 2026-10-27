import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'add_habit_screen.dart';
import 'detail_screen.dart';

class HabitTrackerScreen extends StatefulWidget {
  final String username;

  const HabitTrackerScreen({super.key, required this.username});

  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final storedName = prefs.getString('name');
    final storedUsername = prefs.getString('username');
    final displayName = (storedName != null && storedName.isNotEmpty)
        ? storedName
        : (storedUsername != null && storedUsername.isNotEmpty
            ? storedUsername
            : (widget.username.isNotEmpty ? widget.username : 'Habit Tracker'));

    final selectedJson = prefs.getString('selectedHabitsMap');
    final completedJson = prefs.getString('completedHabitsMap');

    Map<String, String> loadedSelected = {};
    Map<String, String> loadedCompleted = {};

    if (selectedJson != null && selectedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(selectedJson);
        loadedSelected = decoded.map((k, v) => MapEntry(k, v.toString()));
      } catch (_) {}
    } else {
      // Default initial habits if none saved yet
      loadedSelected = {
        'Wake Up Early': '8BC34A',
        'Meditate': 'FFC107',
        'Read a Book': 'FF9800',
        'Drink Water': '8BC34A',
        'Eat Healthy': '009688',
      };
    }

    if (completedJson != null && completedJson.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(completedJson);
        loadedCompleted = decoded.map((k, v) => MapEntry(k, v.toString()));
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
        name = displayName;
        selectedHabitsMap = loadedSelected;
        completedHabitsMap = loadedCompleted;
      });
    }
  }

  Future<void> _saveHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedHabitsMap', jsonEncode(selectedHabitsMap));
    await prefs.setString('completedHabitsMap', jsonEncode(completedHabitsMap));
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '').trim();
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return Color(int.parse('0x$hexColor'));
  }

  Color _getHabitColor(String habit, Map<String, String> habitsMap) {
    String? colorHex = habitsMap[habit];
    if (colorHex != null) {
      try {
        return _getColorFromHex(colorHex);
      } catch (_) {}
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          name.isNotEmpty ? name : 'Habit Tracker',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        automaticallyImplyLeading: true,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'To Do 📝',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          selectedHabitsMap.isEmpty
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Use the + button to create some habits!',
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AddHabitScreen(),
                              ),
                            ).then((_) {
                              _loadUserData();
                            });
                          },
                          icon: const Icon(Icons.add, color: Colors.white),
                          label: const Text(
                            'Add Habits',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade700,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: selectedHabitsMap.length,
                    itemBuilder: (context, index) {
                      String habit = selectedHabitsMap.keys.elementAt(index);
                      Color habitColor =
                          _getHabitColor(habit, selectedHabitsMap);
                      return Dismissible(
                        key: Key(habit),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          setState(() {
                            String color = selectedHabitsMap.remove(habit)!;
                            completedHabitsMap[habit] = color;
                            _saveHabits();
                          });
                        },
                        background: Container(
                          color: Colors.green,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                'Swipe to Complete',
                                style: TextStyle(color: Colors.white),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.check, color: Colors.white),
                            ],
                          ),
                        ),
                        child: _buildHabitCard(habit, habitColor),
                      );
                    },
                  ),
                ),
          const Divider(),
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Done ✅🎉',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          completedHabitsMap.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(
                    'Swipe right on an activity to mark as done.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: completedHabitsMap.length,
                    itemBuilder: (context, index) {
                      String habit = completedHabitsMap.keys.elementAt(index);
                      Color habitColor =
                          _getHabitColor(habit, completedHabitsMap);
                      return Dismissible(
                        key: Key(habit),
                        direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          setState(() {
                            String color = completedHabitsMap.remove(habit)!;
                            selectedHabitsMap[habit] = color;
                            _saveHabits();
                          });
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            children: [
                              Icon(Icons.undo, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Swipe to Undo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                        child: _buildHabitCard(habit, habitColor,
                            isCompleted: true),
                      );
                    },
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddHabitScreen(),
            ),
          ).then((_) {
            _loadUserData();
          });
        },
        backgroundColor: Colors.blue.shade700,
        tooltip: 'Add Habits',
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHabitCard(String title, Color color,
      {bool isCompleted = false}) {
    final selectedItem = {
      'title': title,
      'description': isCompleted
          ? 'Status: Completed 🎉\nKeep up the great work!'
          : 'Status: To Do 📝\nSwipe left when you finish this habit.',
    };

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: color,
      child: SizedBox(
        height: 60,
        child: ListTile(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailScreen(item: selectedItem),
              ),
            );
          },
          title: Text(
            title.toUpperCase(),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          trailing: isCompleted
              ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
              : null,
        ),
      ),
    );
  }
}
