// help_support_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Contact Section
          const Text(
            'Contact Us',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.email_outlined),
              title: const Text('Email Support'),
              subtitle: const Text('support@studentsaccommodations.com'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _launchURL('mailto:support@studentsaccommodations.com'),
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.phone_outlined),
              title: const Text('Call Us'),
              subtitle: const Text('+254 700 123 456'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _launchURL('tel:+254700123456'),
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.location_on_outlined),
              title: const Text('Visit Our Office'),
              subtitle: const Text('Nairobi, Kenya'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {},
            ),
          ),

          const SizedBox(height: 24),

          // FAQ Section
          const Text(
            'Frequently Asked Questions',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          ExpansionTile(
            title: const Text(
              'How do I book a room?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'To book a room:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Browse available rooms by category (Single, Bedsitter, Shared)\n'
                      '2. Click on a hostel to view details\n'
                      '3. Select your preferred room type and check-in date\n'
                      '4. Accept terms and conditions\n'
                      '5. Click "Confirm Booking"\n'
                      '6. Wait for landlord approval\n'
                      '7. Make payment via M-Pesa STK push\n'
                      '8. Your booking is confirmed!',
                    ),
                  ],
                ),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text(
              'What payment methods are accepted?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'We currently accept:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• M-Pesa (Mobile money)\n'
                      '• STK Push payments\n'
                      '• Bank transfers (under development)\n\n'
                      'Payment is secure and encrypted.',
                    ),
                  ],
                ),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text(
              'Can I cancel my booking?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Cancellation Policy:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Free cancellation up to 7 days before check-in\n'
                      '• 50% refund for cancellations 3-7 days before\n'
                      '• No refund for cancellations within 3 days\n\n'
                      'To cancel, go to "My Bookings" and click the cancel button.',
                    ),
                  ],
                ),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text(
              'How do I report an issue?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'If you encounter any issues:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Take screenshots/photos of the issue\n'
                      '2. Go to Help & Support\n'
                      '3. Email us with details\n'
                      '4. Our team will respond within 24 hours\n\n'
                      'We take all reports seriously and will help resolve them quickly.',
                    ),
                  ],
                ),
              ),
            ],
          ),

          ExpansionTile(
            title: const Text(
              'Is my personal information secure?',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Yes! We use:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Industry-standard encryption (SSL/TLS)\n'
                      '• Secure Firebase database\n'
                      '• PCI compliance for payment processing\n'
                      '• Regular security audits\n\n'
                      'Your data is never shared with third parties without your consent.',
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Support Section
          const Text(
            'Additional Support',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),

          Card(
            child: ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: const Text('Report a Bug'),
              subtitle: const Text('Help us improve the app'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _launchURL('mailto:bugs@studentsaccommodations.com'),
            ),
          ),

          const SizedBox(height: 8),

          Card(
            child: ListTile(
              leading: const Icon(Icons.lightbulb_outlined),
              title: const Text('Feature Request'),
              subtitle: const Text('Suggest new features'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () => _launchURL('mailto:features@studentsaccommodations.com'),
            ),
          ),

          const SizedBox(height: 24),

          Center(
            child: Text(
              'Response time: Usually within 24 hours',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}