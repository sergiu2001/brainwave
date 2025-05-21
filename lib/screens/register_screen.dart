import 'package:brainwave/animations/star_background.dart';
import 'package:brainwave/themes/themes.dart';
import 'package:brainwave/providers/auth_provider.dart';
import 'package:brainwave/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PageController _pageController = PageController();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();

  String _sex = '';
  bool _agreedToTerms = false;

  String get _email => _emailController.text.trim();
  String get _password => _passwordController.text.trim();
  String get _firstName => _firstNameController.text.trim();
  String get _lastName => _lastNameController.text.trim();
  String get _dob => _dobController.text.trim();
  String get _weight => _weightController.text.trim();
  String get _height => _heightController.text.trim();

  Future<void> selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime(2101),
      builder: (BuildContext context, Widget? child) {
        return Theme(data: brainwaveTheme, child: child!);
      },
    );
    if (picked != null) {
      setState(() {
        _dobController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Widget buildFirstPage(bool isLoading) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
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
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter email'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter password'
                  : null,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _pageController.nextPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.ease);
                      }
                    },
              child: isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Next'),
            )
          ],
        ),
      ),
    );
  }

  Widget buildSecondPage(bool isLoading, String? errorMessage) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (errorMessage != null && errorMessage.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(8),
                color: Colors.redAccent.shade400,
                child: Text(
                  errorMessage,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            TextFormField(
              controller: _firstNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'First Name',
              ),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter first name'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _lastNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Last Name',
              ),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter last name'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _dobController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Date of Birth',
                prefixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: selectDate,
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please select date of birth'
                  : null,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: _sex.isEmpty ? null : _sex,
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other'))
              ],
              decoration: const InputDecoration(
                  border: OutlineInputBorder(), labelText: 'Sex'),
              onChanged: (value) {
                setState(() {
                  _sex = value ?? '';
                });
              },
              validator: (value) =>
                  (value == null || value.isEmpty) ? 'Please select sex' : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _weightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Weight (kg)',
              ),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter weight'
                  : null,
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _heightController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Height (cm)',
              ),
              validator: (value) => (value == null || value.isEmpty)
                  ? 'Please enter height'
                  : null,
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
                    onTap: () =>
                        setState(() => _agreedToTerms = !_agreedToTerms),
                    child: const Text(
                      'I agree to the terms and conditions',
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
                  onPressed: isLoading
                      ? null
                      : () {
                          _pageController.previousPage(
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.ease);
                        },
                  child: isLoading
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text('Back'),
                ),
                ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : () async {
                          if (!_agreedToTerms) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text(
                                      'Please agree to the terms and conditions')),
                            );
                            return;
                          }
                          if (_formKey.currentState!.validate()) {
                            final authProvider = context.read<AuthProvider>();
                            await authProvider.register(
                                email: _email,
                                password: _password,
                                firstName: _firstName,
                                lastName: _lastName,
                                dob: _dob,
                                height: _height,
                                weight: _weight,
                                sex: _sex);
                            if (authProvider.errorMessage == null) {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            }
                          }
                        },
                  child: isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Register'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final isLoading = authProvider.isLoading;
    final errorMessage = authProvider.errorMessage;

    return Scaffold(
        appBar: AppBar(
          title: const Text('Register'),
        ),
        body: StarryBackgroundWidget(
            child: Form(
                key: _formKey,
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    buildFirstPage(isLoading),
                    buildSecondPage(isLoading, errorMessage),
                  ],
                ))));
  }
}
