import 'package:flutter/material.dart';
import 'package:habit_tracker/habit_tracker_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  // Default credentials
  final String defaultUsername = 'testuser';
  final String defaultPassword = 'password123';

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  bool validateForm() {
    final isFormValid = _key.currentState?.validate() ?? false;

    final input = _usernameController.text.trim();
    final password = _passwordController.text;

    if (input.isEmpty) {
      _showSnackBar('Please enter your email or username');
      return false;
    }

    if (password.isEmpty) {
      _showSnackBar('Please enter your password');
      return false;
    }

    if (input.contains('@')) {
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(input)) {
        _showSnackBar('Please enter a valid email address');
        return false;
      }
    }

    return isFormValid;
  }

  Future<bool> authenticateUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final enteredInput = _usernameController.text.trim();
    final enteredPassword = _passwordController.text;

    final storedEmail = prefs.getString('email');
    final storedUsername = prefs.getString('username');
    final storedPassword = prefs.getString('password');

    final isEmailMatch = storedEmail != null && storedEmail.toLowerCase() == enteredInput.toLowerCase();

    final isUsernameMatch = storedUsername != null && storedUsername.toLowerCase() == enteredInput.toLowerCase();
    final isDefaultMatch =
        (enteredInput == defaultUsername || enteredInput == 'test@example.com') &&
            enteredPassword == defaultPassword;

    if ((isEmailMatch || isUsernameMatch) && storedPassword == enteredPassword) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('currentUser', storedUsername ?? enteredInput);
      _showSnackBar('Login successful!', isError: false);
      return true;
    } else if (isDefaultMatch) {
      await prefs.setBool('isLoggedIn', true);
      await prefs.setString('currentUser', defaultUsername);
      _showSnackBar('Login successful!', isError: false);
      return true;
    } else {
      if (storedUsername == null && storedEmail == null) {
        _showSnackBar(
            'No registered account found. Please sign up or use default credentials ("$defaultUsername" / "$defaultPassword").');
      } else {
        _showSnackBar('Invalid email/username or password. Please try again.');
      }
      return false;
    }
  }

  void handleLogin() async {
    if (validateForm()) {
      final isAuthenticated = await authenticateUser();
      if (isAuthenticated && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HabitTrackerScreen(
              username: _usernameController.text.trim(),
            ),
          ),
        );
      }
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red.shade700 : Colors.green.shade700,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade700, Colors.blue.shade900],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _key,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Habitt',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _usernameController,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter an email or username';
                        }
                        if (value.contains('@')) {
                          final emailRegex = RegExp(
                              r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                          if (!emailRegex.hasMatch(value.trim())) {
                            return 'Please enter a valid email address';
                          }
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.email, color: Colors.blue.shade700),
                        labelText: 'Email or Username',
                        hintText: 'Enter Email or Username',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        prefixIcon:
                            Icon(Icons.lock, color: Colors.blue.shade700),
                        labelText: 'Password',
                        hintText: 'Enter Password',
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 15),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        // Logic for forgot password can be added here
                      },
                      child: const Text(
                        'Forgot password?',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: handleLogin,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 80, vertical: 15),
                    ),
                    child: const Text(
                      'Log in',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'or',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 70, vertical: 15),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
