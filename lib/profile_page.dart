import 'package:brainwave/auth.dart';
import 'package:flutter/material.dart';
import 'background.dart';

class ProfilePage extends StatefulWidget {
  final String userProfile;
  const ProfilePage({super.key, required this.userProfile});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, String> _infos = {};
  final Auth _auth = Auth();

  Future<void> getUser() async {
    Map<String, dynamic> user = await _auth.getUser();
    setState(() {
      _infos = user.map((key, value) => MapEntry(key, value.toString()));
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getUser();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StarryBackgroundWidget(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(widget.userProfile),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Profile Information',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                _infos.isNotEmpty
                    ? Column(
                        children: _infos.entries.map((entry) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 0.1),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Icon(_getIconForLabel(entry.key)),
                                title: Text(
                                  _formatLabel(entry.key),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  entry.value,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      )
                    : const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getIconForLabel(String label) {
    switch (label) {
      case 'dob':
        return Icons.cake;
      case 'email':
        return Icons.email;
      case 'firstName':
        return Icons.person;
      case 'height':
        return Icons.height;
      case 'lastName':
        return Icons.person_outline;
      case 'sex':
        return Icons.wc;
      case 'weight':
        return Icons.fitness_center;
      default:
        return Icons.info;
    }
  }

  String _formatLabel(String label) {
    switch (label) {
      case 'dob':
        return 'Date of Birth';
      case 'email':
        return 'Email';
      case 'firstName':
        return 'First Name';
      case 'height':
        return 'Height (cm)';
      case 'lastName':
        return 'Last Name';
      case 'sex':
        return 'Sex';
      case 'weight':
        return 'Weight (kg)';
      default:
        return label;
    }
  }
}
