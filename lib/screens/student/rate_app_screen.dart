import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/auth_provider.dart';

class RateAppScreen extends StatefulWidget {
  const RateAppScreen({super.key});

  @override
  State<RateAppScreen> createState() => _RateAppScreenState();
}

class _RateAppScreenState extends State<RateAppScreen> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  bool _submitted = false;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating')),
      );
      return;
    }

    setState(() => _submitted = true);

    try {
      final uid =
          Provider.of<AuthProvider>(context, listen: false).user?.uid;
      await FirebaseFirestore.instance.collection('appFeedback').add({
        'type': 'rating',
        'uid': uid,
        'rating': _rating.toInt(),
        'feedback': _feedbackController.text.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thank you for your feedback!'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        setState(() => _submitted = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit: $e')),
        );
      }
    }
  }

  Future<void> _sendFeedback(String type, String title) async {
    final controller = TextEditingController();
    final message = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          maxLines: 4,
          autofocus: true,
          decoration: InputDecoration(
            hintText: type == 'bug'
                ? 'Describe the issue you ran into...'
                : 'Describe the feature you\'d like to see...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Send'),
          ),
        ],
      ),
    );

    if (message == null || message.isEmpty || !mounted) return;

    try {
      final uid =
          Provider.of<AuthProvider>(context, listen: false).user?.uid;
      await FirebaseFirestore.instance.collection('appFeedback').add({
        'type': type,
        'uid': uid,
        'message': message,
        'createdAt': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Thanks! We received your message.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send: $e')),
        );
      }
    }
  }

  void _shareApp() {
    Share.share(
      'Check out this app for finding student hostels and accommodation!',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate App'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Header
            const SizedBox(height: 16),
            Icon(
              Icons.star,
              size: 80,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 24),
            const Text(
              'How would you rate our app?',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Your feedback helps us improve',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),

            // Star Rating
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: GestureDetector(
                    onTap: () => setState(() => _rating = (index + 1).toDouble()),
                    child: Icon(
                      _rating >= (index + 1) ? Icons.star : Icons.star_border,
                      size: 48,
                      color: _rating >= (index + 1)
                          ? Colors.amber
                          : Colors.grey.shade400,
                    ),
                  ),
                );
              }),
            ),

            const SizedBox(height: 8),
            Text(
              _rating > 0
                  ? _getRatingLabel(_rating.toInt())
                  : 'Select a rating',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _rating > 0
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey,
              ),
            ),

            const SizedBox(height: 32),

            // Feedback Text Field
            TextField(
              controller: _feedbackController,
              maxLines: 6,
              enabled: !_submitted,
              decoration: InputDecoration(
                hintText: 'Share your feedback (optional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 2,
                  ),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
              ),
            ),

            const SizedBox(height: 24),

            // Rating Description
            if (_rating > 0) ...[
              _buildRatingCard(_rating.toInt()),
              const SizedBox(height: 24),
            ],

            // Submit Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submitted ? null : _submitRating,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _submitted
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Submit Rating',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 16),

            // Additional Options
            const Divider(height: 32),
            const Text(
              'Other ways to help',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildHelpButton(
                  context,
                  Icons.bug_report_outlined,
                  'Report\nBug',
                  () => _sendFeedback('bug', 'Report a Bug'),
                ),
                _buildHelpButton(
                  context,
                  Icons.lightbulb_outlined,
                  'Suggest\nFeature',
                  () => _sendFeedback('feature', 'Suggest a Feature'),
                ),
                _buildHelpButton(
                  context,
                  Icons.share_outlined,
                  'Share\nApp',
                  _shareApp,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingCard(int rating) {
    Color color;
    String message;
    IconData icon;

    switch (rating) {
      case 5:
        color = Colors.green;
        message = 'Amazing! We\'re thrilled you\'re enjoying the app!';
        icon = Icons.sentiment_very_satisfied;
        break;
      case 4:
        color = Colors.lightGreen;
        message = 'Great! Glad you\'re having a good experience.';
        icon = Icons.sentiment_satisfied;
        break;
      case 3:
        color = Colors.orange;
        message = 'Good! Help us improve by sharing your suggestions.';
        icon = Icons.sentiment_neutral;
        break;
      case 2:
        color = Colors.deepOrange;
        message = 'We\'d love to know what could be better.';
        icon = Icons.sentiment_dissatisfied;
        break;
      default:
        color = Colors.red;
        message = 'We\'re sorry. Please tell us what went wrong.';
        icon = Icons.sentiment_very_dissatisfied;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 14,
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHelpButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: Theme.of(context).colorScheme.primary,
              size: 24,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }
}
