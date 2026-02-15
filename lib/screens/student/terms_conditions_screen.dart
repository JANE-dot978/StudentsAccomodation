import 'package:flutter/material.dart';

class TermsConditionsScreen extends StatelessWidget {
  const TermsConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSection(
            'Last Updated',
            'January 2024',
          ),
          _buildSection(
            '1. Introduction',
            'Welcome to Students Accommodations App. These terms and conditions '
                'govern your use of our mobile application and services. By using '
                'our app, you agree to comply with these terms.',
          ),
          _buildSection(
            '2. User Accounts',
            'You are responsible for maintaining the confidentiality of your '
                'account credentials. You agree not to share your password with anyone. '
                'You are responsible for all activities that occur under your account.',
          ),
          _buildSection(
            '3. Booking Policy',
            '• Bookings are subject to landlord approval\n'
                '• You can cancel free of charge up to 7 days before check-in\n'
                '• Cancellations within 3 days are non-refundable\n'
                '• The landlord reserves the right to decline bookings',
          ),
          _buildSection(
            '4. Payment Terms',
            '• Payments are processed through M-Pesa\n'
                '• Payment is required after landlord approval\n'
                '• Refunds are processed within 5-7 business days\n'
                '• Transaction fees may apply',
          ),
          _buildSection(
            '5. User Responsibilities',
            '• Provide accurate information during registration\n'
                '• Respect hostel rules and other residents\n'
                '• Keep your account information current\n'
                '• Not use the service for illegal activities',
          ),
          _buildSection(
            '6. Property Damage',
            'You are liable for damage caused by your negligence or misuse '
                'of the hostel property. Landlords may claim damages through '
                'the app dispute resolution process.',
          ),
          _buildSection(
            '7. Limitation of Liability',
            'Students Accommodations App is provided "as is" without warranties. '
                'We are not liable for direct, indirect, incidental, or '
                'consequential damages arising from your use of the service.',
          ),
          _buildSection(
            '8. Dispute Resolution',
            'Disputes between students and landlords will be handled through '
                'our in-app dispute resolution system. Both parties agree to '
                'attempt resolution before pursuing legal action.',
          ),
          _buildSection(
            '9. Privacy Policy',
            'Your personal information is protected according to our Privacy '
                'Policy. We do not share your data with third parties without consent.',
          ),
          _buildSection(
            '10. Termination',
            'We reserve the right to terminate your account if you violate '
                'these terms or engage in prohibited activities.',
          ),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                const Text(
                  'By using this app, you accept these terms',
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
