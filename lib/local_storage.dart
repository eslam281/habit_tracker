import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  // 1. User Profile Data: Save & Retrieve
  static Future<void> saveUserProfile({
    required String name,
    required String username,
    required String email,
    required double age,
    required String country,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setDouble('age', age);
    await prefs.setString('country', country);
    await prefs.setBool('isRegistered', true);
  }

  static Future<Map<String, dynamic>> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'name': prefs.getString('name') ?? '',
      'username': prefs.getString('username') ?? '',
      'email': prefs.getString('email') ?? '',
      'age': prefs.getDouble('age') ?? 25.0,
      'country': prefs.getString('country') ?? 'United States',
      'isRegistered': prefs.getBool('isRegistered') ?? false,
      'isLoggedIn': prefs.getBool('isLoggedIn') ?? false,
    };
  }

  // 2. User Actions: Save & Retrieve
  static Future<void> saveUserAction(String action) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> actions = prefs.getStringList('userActions') ?? [];
    final timestamp = DateTime.now().toString().substring(11, 16);
    actions.add('$action ($timestamp)');
    await prefs.setStringList('userActions', actions);
  }

  static Future<List<String>> getUserActions() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('userActions') ?? [];
  }

  static Future<void> clearUserActions() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('userActions');
  }

  // 3. Habits Data: Save & Retrieve
  static Future<void> saveHabitsData({
    required Map<String, String> selectedHabitsMap,
    required Map<String, String> completedHabitsMap,
    Map<String, String>? previousHabitsMap,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedHabitsMap', jsonEncode(selectedHabitsMap));
    await prefs.setString('completedHabitsMap', jsonEncode(completedHabitsMap));
    if (previousHabitsMap != null) {
      await prefs.setString('previousHabitsMap', jsonEncode(previousHabitsMap));
    }
  }

  static Future<Map<String, Map<String, String>>> getHabitsData() async {
    final prefs = await SharedPreferences.getInstance();

    final selectedRaw = prefs.getString('selectedHabitsMap');
    final completedRaw = prefs.getString('completedHabitsMap');
    final previousRaw = prefs.getString('previousHabitsMap');

    Map<String, String> loadedSelected = {};
    Map<String, String> loadedCompleted = {};
    Map<String, String> loadedPrevious = {};

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

    if (previousRaw != null && previousRaw.isNotEmpty) {
      try {
        final Map<String, dynamic> decoded = jsonDecode(previousRaw);
        loadedPrevious = decoded.map((k, v) => MapEntry(k, v.toString()));
      } catch (_) {}
    }

    return {
      'selected': loadedSelected,
      'completed': loadedCompleted,
      'previous': loadedPrevious,
    };
  }
}
