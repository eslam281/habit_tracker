import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'habit_colors.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {
  final TextEditingController _habitController = TextEditingController();
  Color selectedColor = habitColors['Amber']!;
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  String selectedColorName = 'Amber'; // Default color name

  @override
  void initState() {
    super.initState();
    _loadHabits();
  }

  @override
  void dispose() {
    _habitController.dispose();
    super.dispose();
  }

  Future<void> _loadHabits() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final selectedRaw = prefs.getString('selectedHabitsMap');
    final completedRaw = prefs.getString('completedHabitsMap');

    Map<String, String> loadedSelected = {};
    Map<String, String> loadedCompleted = {};

    if (selectedRaw != null && selectedRaw.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(selectedRaw);
        loadedSelected = decoded.map((k, v) => MapEntry(k, v.toString()));
      } catch (_) {}
    } else {
      loadedSelected = {
        'Wake Up Early': '8BC34A',
        'Meditate': 'FFC107',
        'Read a Book': 'FF9800',
        'Drink Water': '8BC34A',
        'Eat Healthy': '009688',
      };
    }

    if (completedRaw != null && completedRaw.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(completedRaw);
        loadedCompleted = decoded.map((k, v) => MapEntry(k, v.toString()));
      } catch (_) {}
    }

    if (mounted) {
      setState(() {
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

  Future<void> _addHabit() async {
    final habitName = _habitController.text.trim();
    if (habitName.isEmpty) return;

    final colorHex = colorToHex(selectedColor);

    setState(() {
      selectedHabitsMap[habitName] = colorHex;
      _habitController.clear();
      selectedColorName = 'Amber';
      selectedColor = habitColors['Amber']!;
    });

    await _saveHabits();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Habit "$habitName" added!'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> allHabitsMap = {...selectedHabitsMap, ...completedHabitsMap};

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context, true),
        ),
        title: const Text(
          'Configure Habits',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _habitController,
              decoration: const InputDecoration(
                hintText: 'Habit Name',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
              onSubmitted: (_) => _addHabit(),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Color:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: selectedColor,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade400),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedColorName,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.black54),
                  dropdownColor: Colors.white,
                  items: habitColors.keys.map((String colorName) {
                    return DropdownMenuItem<String>(
                      value: colorName,
                      child: Row(
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: habitColors[colorName],
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            colorName,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  selectedItemBuilder: (BuildContext context) {
                    return habitColors.keys.map((String colorName) {
                      return Center(
                        child: Text(
                          colorName,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList();
                  },
                  onChanged: (String? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedColorName = newValue;
                        selectedColor = habitColors[selectedColorName]!;
                      });
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _addHabit,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
              child: const Text(
                'Add Habit',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: allHabitsMap.entries.map((entry) {
                  final habitName = entry.key;
                  final habitColor = getColorFromHex(entry.value);
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 20,
                        backgroundColor: habitColor,
                      ),
                      title: Text(
                        habitName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete, color: Colors.redAccent),
                        onPressed: () async {
                          setState(() {
                            selectedHabitsMap.remove(habitName);
                            completedHabitsMap.remove(habitName);
                          });
                          await _saveHabits();
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
