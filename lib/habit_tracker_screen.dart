import 'package:flutter/material.dart';
import 'package:habit_tracker/add_habit_screen.dart';
import 'package:habit_tracker/detail_screen.dart';
import 'package:habit_tracker/habit_colors.dart';
import 'package:habit_tracker/local_storage.dart';
import 'package:habit_tracker/login_screen.dart';
import 'package:habit_tracker/notificatons_screen.dart';
import 'package:habit_tracker/personal_info_screen.dart';
import 'package:habit_tracker/reports_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HabitTrackerScreen extends StatefulWidget {
  final String username;

  const HabitTrackerScreen({super.key, required this.username});

  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  Map<String, String> selectedHabitsMap = {};
  Map<String, String> completedHabitsMap = {};
  Map<String, dynamic> userProfile = {};
  List<String> userActions = [];
  String name = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final profile = await LocalStorageService.getUserProfile();
    final habits = await LocalStorageService.getHabitsData();
    final actions = await LocalStorageService.getUserActions();

    final storedName = profile['name'] as String;
    final storedUsername = profile['username'] as String;
    final displayName = (storedName.isNotEmpty)
        ? storedName
        : (storedUsername.isNotEmpty
            ? storedUsername
            : (widget.username.isNotEmpty ? widget.username : 'Habit Tracker'));

    if (mounted) {
      setState(() {
        userProfile = profile;
        name = displayName;
        selectedHabitsMap = habits['selected'] ?? {};
        completedHabitsMap = habits['completed'] ?? {};
        userActions = actions;
      });
    }
  }

  Future<void> _saveHabits() async {
    await LocalStorageService.saveHabitsData(
      selectedHabitsMap: selectedHabitsMap,
      completedHabitsMap: completedHabitsMap,
    );
  }

  Color _getHabitColor(String habit, Map<String, String> habitsMap) {
    String? colorHex = habitsMap[habit];
    if (colorHex != null) {
      try {
        return getColorFromHex(colorHex);
      } catch (_) {}
    }
    return Colors.blue;
  }

  @override
  Widget build(BuildContext context) {
    final country = userProfile['country'] as String? ?? '';
    final age = userProfile['age'] as double? ?? 25.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name.isNotEmpty ? name : 'Habit Tracker',
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            // Conditional rendering for user profile subtitle
            if (country.isNotEmpty)
              Text(
                '📍 $country • Age ${age.round()}',
                style: const TextStyle(fontSize: 12, color: Colors.white70),
              ),
          ],
        ),
        automaticallyImplyLeading: true,
      ),
      drawer: Drawer(
    child: ListView(
    padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
          ),
          child: Text(
            'Menu',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.settings),
          title: const Text('Configure'),
          onTap: () async {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddHabitScreen(),
              ),
            ).then((updatedHabits) {
              _loadUserData(); // Reload data after returning
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text('Personal Info'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const PersonalInfoScreen()),
            ).then((_) {
              _loadUserData(); // Reload data after returning
            });
          },
        ),

        ListTile(
          leading: const Icon(Icons.analytics),
          title: const Text('Reports'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const ReportsScreen()),
            );
          },
        ),

        ListTile(
          leading: Icon(Icons.notifications),
          title: Text('Notifications'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => NotificationsScreen()),
            );
          },
        ),

        ListTile(
        leading: const Icon(Icons.logout),
        title: const Text('Sign Out'),
        onTap: () {
          _signOut(context);
        },
      )
        ],
    ),
    ),
      body: Column(
        children: [
          // Conditional rendering for Recent Activity Log if actions exist
          if (userActions.isNotEmpty)
            Material(
              color: Colors.blue.shade50,
              child: ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 16),
                title: Text(
                  'Recent Activity (${userActions.length})',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                children: userActions.reversed.take(4).map((action) {
                  return ListTile(
                    dense: true,
                    leading: Icon(Icons.history, size: 18, color: Colors.blue.shade700),
                    title: Text(
                      action,
                      style: const TextStyle(fontSize: 13),
                    ),
                  );
                }).toList(),
              ),
            ),

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
                        onDismissed: (direction) async {
                          setState(() {
                            String color = selectedHabitsMap.remove(habit)!;
                            completedHabitsMap[habit] = color;
                          });
                          await _saveHabits();
                          await LocalStorageService.saveUserAction('Completed habit "$habit"');
                          _loadUserData();
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
                        onDismissed: (direction) async {
                          setState(() {
                            String color = completedHabitsMap.remove(habit)!;
                            selectedHabitsMap[habit] = color;
                          });
                          await _saveHabits();
                          await LocalStorageService.saveUserAction('Reverted completion for "$habit"');
                          _loadUserData();
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
            ).then((_) {
              _loadUserData();
            });
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

  void _signOut(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    if (context.mounted) {
      Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
    }
  }

}
