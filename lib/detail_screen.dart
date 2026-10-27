import 'package:flutter/material.dart';
import 'package:habit_tracker/habit_colors.dart';
import 'package:habit_tracker/local_storage.dart';

class DetailScreen extends StatefulWidget {
  final dynamic item;

  const DetailScreen({super.key, required this.item});

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late String habitTitle;
  late String habitDescription;

  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  Map<String, String> previousHabitsMap = {};

  String? currentColorHex;
  String? previousColorHex;
  String selectedColorName = 'Amber';

  @override
  void initState() {
    super.initState();
    habitTitle = widget.item['title'] ?? '';
    habitDescription = widget.item['description'] ?? '';
    _loadHabitColorData();
  }

  Future<void> _loadHabitColorData() async {
    final habitsData = await LocalStorageService.getHabitsData();

    final loadedSelected = habitsData['selected'] ?? {};
    final loadedCompleted = habitsData['completed'] ?? {};
    final loadedPrevious = habitsData['previous'] ?? {};

    String? currentHex = loadedSelected[habitTitle] ?? loadedCompleted[habitTitle];
    String? prevHex = loadedPrevious[habitTitle];

    String initialColorName = 'Amber';
    if (currentHex != null) {
      final Color current = getColorFromHex(currentHex);
      for (var entry in habitColors.entries) {
        if (entry.value.value == current.value) {
          initialColorName = entry.key;
          break;
        }
      }
    }

    if (mounted) {
      setState(() {
        selectedHabitsMap = loadedSelected;
        completedHabitsMap = loadedCompleted;
        previousHabitsMap = loadedPrevious;
        currentColorHex = currentHex;
        previousColorHex = prevHex;
        selectedColorName = initialColorName;
      });
    }
  }

  Future<void> _saveColorData() async {
    await LocalStorageService.saveHabitsData(
      selectedHabitsMap: selectedHabitsMap,
      completedHabitsMap: completedHabitsMap,
      previousHabitsMap: previousHabitsMap,
    );
  }

  Future<void> _changeHabitColor(String newColorName) async {
    final Color newColor = habitColors[newColorName] ?? Colors.amber;
    final String newColorHex = colorToHex(newColor);

    if (currentColorHex == newColorHex) return;

    setState(() {
      if (currentColorHex != null) {
        previousHabitsMap[habitTitle] = currentColorHex!;
        previousColorHex = currentColorHex;
      }

      if (selectedHabitsMap.containsKey(habitTitle)) {
        selectedHabitsMap[habitTitle] = newColorHex;
      }
      if (completedHabitsMap.containsKey(habitTitle)) {
        completedHabitsMap[habitTitle] = newColorHex;
      }

      currentColorHex = newColorHex;
      selectedColorName = newColorName;
    });

    await _saveColorData();
    await LocalStorageService.saveUserAction('Changed color for "$habitTitle" to $newColorName');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Color updated to $newColorName'),
          backgroundColor: Colors.green.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _undoColorChange() async {
    if (previousColorHex == null) return;

    final String oldHex = previousColorHex!;
    final String? currentHex = currentColorHex;

    setState(() {
      if (selectedHabitsMap.containsKey(habitTitle)) {
        selectedHabitsMap[habitTitle] = oldHex;
      }
      if (completedHabitsMap.containsKey(habitTitle)) {
        completedHabitsMap[habitTitle] = oldHex;
      }

      if (currentHex != null) {
        previousHabitsMap[habitTitle] = currentHex;
        previousColorHex = currentHex;
      } else {
        previousHabitsMap.remove(habitTitle);
        previousColorHex = null;
      }

      currentColorHex = oldHex;

      final Color revertedColor = getColorFromHex(oldHex);
      for (var entry in habitColors.entries) {
        if (entry.value.value == revertedColor.value) {
          selectedColorName = entry.key;
          break;
        }
      }
    });

    await _saveColorData();
    await LocalStorageService.saveUserAction('Reverted color for "$habitTitle"');

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Reverted to previous color'),
          backgroundColor: Colors.blue.shade700,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final Color habitColor = currentColorHex != null
        ? getColorFromHex(currentColorHex!)
        : Colors.blue;

    final Color? prevHabitColor = previousColorHex != null
        ? getColorFromHex(previousColorHex!)
        : null;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          habitTitle.isNotEmpty ? habitTitle : 'Habit Details',
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: habitColor,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    habitTitle,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              habitDescription,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 32),
            const Text(
              'Change Habit Color:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                color: habitColor,
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
                      _changeHabitColor(newValue);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (previousColorHex != null)
              OutlinedButton.icon(
                onPressed: _undoColorChange,
                icon: const Icon(Icons.undo, color: Colors.blue),
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Undo Color Change (Revert to ',
                      style: TextStyle(fontSize: 15),
                    ),
                    Container(
                      width: 16,
                      height: 16,
                      decoration: BoxDecoration(
                        color: prevHabitColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey),
                      ),
                    ),
                    const Text(')'),
                  ],
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.blue),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pop(context, true);
              },
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              label: const Text(
                'Back to List',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
