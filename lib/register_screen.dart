import 'package:flutter/material.dart';
import 'package:habit_tracker/habit_tracker_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  double _age = 25; // Default age set to 25
  String _country = 'United States';
  List<String> _countries = [];
  List<String> selectedHabits = [];
  List<String> availableHabits = [
    'Wake Up Early',
    'Workout',
    'Drink Water',
    'Meditate',
    'Read a Book',
    'Practice Gratitude',
    'Sleep 8 Hours',
    'Eat Healthy',
    'Journal',
    'Walk 10,000 Steps'
  ];

  @override
  void initState() {
    super.initState();
    _fetchCountries();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _fetchCountries() async {
    List<String> subsetCountries = [
      'United States',
      'Canada',
      'United Kingdom',
      'Australia',
      'India',
      'Germany',
      'France',
      'Japan',
      'China',
      'Brazil',
      'South Africa'
    ];

    setState(() {
      _countries = subsetCountries;
      _countries.sort();
      _country = _countries.isNotEmpty ? _countries[0] : 'United States';
    });
  }

  bool _validateFields() {
    // 1. Trigger Form field validators
    final isFormValid = _formKey.currentState?.validate() ?? false;

    // 2. Read values directly from TextEditingControllers
    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // 3. Check if any required field is empty
    if (name.isEmpty) {
      _showSnackBar('Please enter your name');
      return false;
    }

    if (username.isEmpty) {
      _showSnackBar('Please enter a username');
      return false;
    }

    if (email.isEmpty) {
      _showSnackBar('Please enter an email address');
      return false;
    }

    final emailRegex =
    RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!emailRegex.hasMatch(email)) {
      _showSnackBar('Please enter a valid email address');
      return false;
    }

    if (password.isEmpty) {
      _showSnackBar('Please enter a password');
      return false;
    }

    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters long');
      return false;
    }

    if (selectedHabits.isEmpty) {
      _showSnackBar('Please select at least one habit');
      return false;
    }

    return isFormValid;
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

  bool validateForm() {
    return _validateFields();
  }

  Future<void> saveUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final name = _nameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final age = _age.round();
    final country = _country;

    await prefs.setString('name', name);
    await prefs.setString('username', username);
    await prefs.setString('email', email);
    await prefs.setString('password', password);
    await prefs.setInt('age', age);
    await prefs.setString('country', country);
    await prefs.setStringList('selectedHabits', selectedHabits);
    await prefs.setBool('isRegistered', true);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: const Text(
          'Register',
          style: TextStyle(
            fontSize: 32,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/login');
            }
          },
        ),
      ),
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
            padding:
                const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInputField(
                    controller: _nameController,
                    label: 'Name',
                    placeholder: 'Enter your name',
                    icon: Icons.person,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    controller: _usernameController,
                    label: 'Username',
                    placeholder: 'Enter your username',
                    icon: Icons.alternate_email,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Username is required';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    controller: _emailController,
                    label: 'Email',
                    placeholder: 'Enter your email address',
                    icon: Icons.email,
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex =
                          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
                      if (!emailRegex.hasMatch(value.trim())) {
                        return 'Enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildInputField(
                    controller: _passwordController,
                    label: 'Password',
                    placeholder: 'Enter your password',
                    icon: Icons.lock,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Must be at least 6 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 10),
                  Text('Age: ${_age.round()}',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 18)),
                  Slider(
                    value: _age,
                    min: 21,
                    max: 100,
                    divisions: 79,
                    activeColor: Colors.blue.shade600,
                    inactiveColor: Colors.blue.shade300,
                    onChanged: (double value) {
                      setState(() {
                        _age = value;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  _buildCountryDropdown(),
                  const SizedBox(height: 10),
                  const Text('Select Your Habits',
                      style: TextStyle(color: Colors.white, fontSize: 18)),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: availableHabits.map((habit) {
                      final isSelected = selectedHabits.contains(habit);
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              selectedHabits.remove(habit);
                            } else {
                              selectedHabits.add(habit);
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.blue.shade600
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.blue.shade700),
                          ),
                          child: Text(
                            habit,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.blue.shade700,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (validateForm()) {
                          await saveUserData();
                          if (context.mounted) {
                            _showSnackBar(
                                'Registration successful! User data saved.',
                                isError: false);
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HabitTrackerScreen(username: _usernameController.text),
                              ),
                            );
                          }
                        } else {
                          _showSnackBar('All fields are required');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 80, vertical: 15),
                      ),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        if (Navigator.canPop(context)) {
                          Navigator.pop(context);
                        } else {
                          Navigator.pushReplacementNamed(context, '/login');
                        }
                      },
                      child: const Text(
                        'Already have an account? Log in',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
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

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String placeholder,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: Colors.blue.shade700),
          labelText: label,
          hintText: placeholder,
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        ),
      ),
    );
  }

  Widget _buildCountryDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: DropdownButton<String>(
        value: _country,
        icon: Icon(Icons.arrow_drop_down, color: Colors.blue.shade700),
        isExpanded: true,
        underline: const SizedBox(),
        items: _countries.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            _country = newValue!;
          });
        },
      ),
    );
  }
}


