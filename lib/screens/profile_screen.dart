import 'package:brainwave/animations/star_background.dart';
import 'package:brainwave/models/app_user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  final String userProfile;

  const ProfileScreen({super.key, required this.userProfile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    final authProvider = context.read<AuthProvider>();
    if (authProvider.user == null) {
      authProvider.loadUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;
    final isLoading = authProvider.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: StarryBackgroundWidget(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : user == null
                ? const Center(child: Text('No user data found.'))
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(widget.userProfile),
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

                        ..._buildProfileFields(user).map((field) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Card(
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: Icon(field.icon),
                                title: Text(
                                  field.label,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle: Text(
                                  field.value,
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
      ),
    );
  }

  List<ProfileField> _buildProfileFields(AppUser user) {
    return [
      ProfileField(
        icon: Icons.email,
        label: 'Email',
        value: user.email,
      ),
      ProfileField(
        icon: Icons.person,
        label: 'First Name',
        value: user.firstName,
      ),
      ProfileField(
        icon: Icons.person_outline,
        label: 'Last Name',
        value: user.lastName,
      ),
      ProfileField(
        icon: Icons.cake,
        label: 'Date of Birth',
        value: user.dob,
      ),
      ProfileField(
        icon: Icons.wc,
        label: 'Sex',
        value: user.sex,
      ),
      ProfileField(
        icon: Icons.fitness_center,
        label: 'Weight (kg)',
        value: user.weight,
      ),
      ProfileField(
        icon: Icons.height,
        label: 'Height (cm)',
        value: user.height,
      ),
    ];
  }
}

class ProfileField {
  final IconData icon;
  final String label;
  final String value;

  ProfileField({
    required this.icon,
    required this.label,
    required this.value,
  });
}
