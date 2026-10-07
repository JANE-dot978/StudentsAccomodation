import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Last Updated',
            'January 2024',
          ),
          _buildSection(
            '1. Information We Collect',
            'We collect information you provide directly, such as your name, '
                'email address, phone number, and payment details, as well as '
                'booking and usage data generated while you use the app.',
          ),
          _buildSection(
            '2. How We Use Your Information',
            '• To create and manage your account\n'
                '• To process bookings and M-Pesa payments\n'
                '• To communicate booking updates and support requests\n'
                '• To improve the app based on feedback and ratings you submit',
          ),
          _buildSection(
            '3. Data Storage & Security',
            'Your data is stored securely using Firebase, with industry-standard '
                'encryption (SSL/TLS) in transit. Access to your account data is '
                'restricted to you and, where relevant, the landlord for bookings '
                'you make with them.',
          ),
          _buildSection(
            '4. Sharing of Information',
            'We do not sell your personal information. Booking details are shared '
                'only with the landlord you book with, and payment details are shared '
                'only as required to process M-Pesa transactions.',
          ),
          _buildSection(
            '5. Your Choices',
            '• You can review and update your profile information at any time\n'
                '• You can control notification preferences in Settings\n'
                '• You can request account deletion from Privacy & Security settings',
          ),
          _buildSection(
            '6. Data Retention',
            'We retain your account and booking data for as long as your account '
                'is active. If you delete your account, your personal data is removed '
                'from our systems, except where retention is required by law.',
          ),
          _buildSection(
            '7. Changes to This Policy',
            'We may update this Privacy Policy from time to time. Continued use of '
                'the app after changes are posted constitutes acceptance of the revised policy.',
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                const Text(
                  'Your privacy matters to us',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'For questions, contact: legal@studentsaccommodations.com',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
