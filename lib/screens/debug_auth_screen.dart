import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

/// Debug screen to verify user setup
class DebugAuthScreen extends StatelessWidget {
  const DebugAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debug - User Info'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'User Authentication Status:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Logged In:', user != null ? '✅ Yes' : '❌ No'),
            _buildInfoRow('User ID:', user?.uid ?? 'Not available'),
            _buildInfoRow('Email:', user?.email ?? 'Not available'),
            _buildInfoRow('Display Name:', user?.displayName ?? 'Not available'),
            _buildInfoRow('Email Verified:', user?.emailVerified.toString() ?? 'Not available'),
            const SizedBox(height: 24),
            const Text(
              'What to Check:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildCheckItem(
              'User is logged in',
              user != null,
              'If not logged in, you cannot create bookings',
            ),
            _buildCheckItem(
              'User ID available',
              user?.uid != null && user!.uid.isNotEmpty,
              'This is required for Firestore permissions',
            ),
            _buildCheckItem(
              'User profile exists in Firestore',
              true,
              'Check Firebase Console > Firestore > users collection\nLook for document with ID matching your User ID above',
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // Copy user ID to see in logs
                if (user != null) {
                  debugPrint('Current User ID: ${user.uid}');
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('User ID: ${user.uid}'),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No user logged in!'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text('Show User ID'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () {
                // Log user info for debugging
                debugPrint('=== USER DEBUG INFO ===');
                debugPrint('Logged In: ${user != null}');
                debugPrint('User ID: ${user?.uid}');
                debugPrint('Email: ${user?.email}');
                debugPrint('Display Name: ${user?.displayName}');
                debugPrint('========================');
              },
              child: const Text('Log User Info (Check Console)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[700],
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckItem(String title, bool isValid, String description) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.info,
            color: isValid ? Colors.green : Colors.orange,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
