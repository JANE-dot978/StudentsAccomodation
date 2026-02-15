import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:studentsaccomodations/screens/auth/login_screen.dart';
import '../../providers/auth_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  bool _isEditing = false;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    _nameController.text = user?.displayName ?? '';

    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person, size: 40),
            ),
            const SizedBox(height: 16),

            // Email display
            Text(
              user?.email ?? "No email",
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),

            // Editable full name
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _nameController,
                enabled: _isEditing,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                  suffixIcon: _isEditing
                      ? IconButton(
                          icon: const Icon(Icons.check),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              try {
                                // ✅ Corrected method call
                                await authProvider.updateProfile(
                                    fullName: _nameController.text);
                                setState(() => _isEditing = false);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text("Name updated")),
                                );
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Error: $e")),
                                );
                              }
                            }
                          },
                        )
                      : IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            setState(() => _isEditing = true);
                          },
                        ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter a name";
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 20),

            // Logout button
            ElevatedButton.icon(
              onPressed: () async {
                await authProvider.logout();
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              icon: const Icon(Icons.logout),
              label: const Text("Logout"),
            ),
            const SizedBox(height: 10),

            // Delete account button
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                bool confirm = await showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text("Confirm Deletion"),
                    content: const Text(
                        "Are you sure you want to delete your account? This action cannot be undone."),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text("Cancel"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text("Delete"),
                      ),
                    ],
                  ),
                );

                if (confirm) {
                  try {
                    await authProvider.deleteAccount();
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (_) => const LoginScreen()),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Error deleting account: $e")),
                    );
                  }
                }
              },
              icon: const Icon(Icons.delete),
              label: const Text("Delete Account"),
            ),
          ],
        ),
      ),
    );
  }
}
