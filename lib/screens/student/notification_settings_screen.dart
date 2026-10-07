import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _isLoading = true;
  Map<String, bool> _preferences = {
    'bookingUpdates': true,
    'promotions': true,
    'maintenanceUpdates': true,
  };

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final userData = await authProvider.getUserData();
    final saved = userData?['notificationPreferences'];
    if (mounted) {
      setState(() {
        if (saved is Map) {
          _preferences = {
            'bookingUpdates': saved['bookingUpdates'] ?? true,
            'promotions': saved['promotions'] ?? true,
            'maintenanceUpdates': saved['maintenanceUpdates'] ?? true,
          };
        }
        _isLoading = false;
      });
    }
  }

  Future<void> _setPreference(String key, bool value) async {
    setState(() => _preferences[key] = value);
    try {
      await Provider.of<AuthProvider>(context, listen: false)
          .updateNotificationPreferences(_preferences);
    } catch (e) {
      if (mounted) {
        setState(() => _preferences[key] = !value);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                SwitchListTile(
                  title: const Text('Booking Updates'),
                  subtitle: const Text(
                      'Booking confirmations, approvals, and payment status'),
                  value: _preferences['bookingUpdates'] ?? true,
                  onChanged: (v) => _setPreference('bookingUpdates', v),
                ),
                SwitchListTile(
                  title: const Text('Promotions & Offers'),
                  subtitle: const Text('Discounts and new listing alerts'),
                  value: _preferences['promotions'] ?? true,
                  onChanged: (v) => _setPreference('promotions', v),
                ),
                SwitchListTile(
                  title: const Text('Maintenance Updates'),
                  subtitle:
                      const Text('Updates on your maintenance requests'),
                  value: _preferences['maintenanceUpdates'] ?? true,
                  onChanged: (v) => _setPreference('maintenanceUpdates', v),
                ),
              ],
            ),
    );
  }
}
