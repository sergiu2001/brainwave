import 'package:brainwave/background.dart';
import 'package:flutter/material.dart';
import 'auth.dart';
import 'main.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final Auth _auth = Auth();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final PageController _pageController = PageController();

  String _email = "";
  String _password = "";
  String _firstName = "";
  String _lastName = "";
  String _dob = "";
  String _sex = "";
  String _weight = "";
  String _height = "";
  bool _agreedToTerms = false;

Future<void> _selectDate() async {
  DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(1950),
    lastDate: DateTime(2101),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: brainwaveTheme, // Apply the custom theme
        child: child!,
      );
    },
  );
  if (picked != null) {
    setState(() {
      _dobController.text = picked.toString().split(" ")[0];
      _dob = _dobController.text;
    });
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: StarryBackgroundWidget(
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.always,
          child: PageView(
            controller: _pageController,
            children: [
              buildFirstPage(),
              buildSecondPage(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildFirstPage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _email = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _password = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _pageController.animateToPage(
                  1,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.ease,
                );
              },
              child: const Text('Next'),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSecondPage() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your first name';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _firstName = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Last Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your last name';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _lastName = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _dobController,
              decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Date of Birth',
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF6A5ACD)))),
              readOnly: true,
              onTap: () {
                _selectDate();
              },
              onChanged: (value) {
                setState(() {
                  _dob = value;
                });
              },
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField(
              dropdownColor: Color.fromARGB(235, 58, 58, 91),
              value: null,
              items: const [
                DropdownMenuItem(value: null, child: Text("Select")),
                DropdownMenuItem(value: "Male", child: Text("Male")),
                DropdownMenuItem(
                  value: "Female",
                  child: Text("Female"),
                ),
                DropdownMenuItem(value: "Other", child: Text("Other")),
              ],
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Sex',
              ),
              onChanged: (value) {
                setState(() {
                  _sex = value.toString();
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _weightController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Weight',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your weight';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _weight = value;
                });
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Height',
              ),
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your height';
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _height = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _agreedToTerms,
                  onChanged: (bool? value) {
                    setState(() {
                      _agreedToTerms = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _agreedToTerms = !_agreedToTerms;
                      });
                    },
                    child: const Text(
                      'I agree to the terms and conditions and understand the permissions required.',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _pageController.animateToPage(
                      0,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.ease,
                    );
                  },
                  child: const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: _agreedToTerms
                      ? () {
                          if (_formKey.currentState!.validate()) {
                            _auth.registerWithEmailAndPassword(
                                _email,
                                _password,
                                _firstName,
                                _lastName,
                                _sex,
                                _dob,
                                _weight,
                                _height,
                                context);
                          }
                        }
                      : null,
                  child: const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}