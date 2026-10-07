import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/booking_model.dart';
import '../../models/maintanance_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/maintanance_provider.dart';

const _categories = ['electrical', 'plumbing', 'cleaning', 'general'];
const _priorities = ['low', 'medium', 'high', 'urgent'];

Color _statusColor(String status) {
  switch (status) {
    case 'in_progress':
      return Colors.blue;
    case 'completed':
      return Colors.green;
    case 'cancelled':
      return Colors.grey;
    default:
      return Colors.orange;
  }
}

Color _priorityColor(String priority) {
  switch (priority) {
    case 'urgent':
      return Colors.red;
    case 'high':
      return Colors.deepOrange;
    case 'medium':
      return Colors.orange;
    default:
      return Colors.blueGrey;
  }
}

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> {
  @override
  void initState() {
    super.initState();
    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    if (uid != null) {
      final provider =
          Provider.of<MaintenanceProvider>(context, listen: false);
      Future.microtask(() => provider.fetchStudentReports(uid));
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    final maintenanceProvider = Provider.of<MaintenanceProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Requests')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: uid == null
            ? null
            : () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const _ReportMaintenanceScreen(),
                  ),
                ).then((_) => maintenanceProvider.fetchStudentReports(uid)),
        icon: const Icon(Icons.add),
        label: const Text('Report Issue'),
      ),
      body: maintenanceProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : maintenanceProvider.maintenanceRequests.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.build_outlined,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No maintenance requests yet',
                        style: TextStyle(
                            fontSize: 16, color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: maintenanceProvider.maintenanceRequests.length,
                  itemBuilder: (context, index) {
                    final request =
                        maintenanceProvider.maintenanceRequests[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: ListTile(
                        title: Text(request.title,
                            style:
                                const TextStyle(fontWeight: FontWeight.w600)),
                        subtitle: Text(request.description,
                            maxLines: 2, overflow: TextOverflow.ellipsis),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Chip(
                              label: Text(
                                request.status.replaceAll('_', ' '),
                                style: const TextStyle(
                                    fontSize: 11, color: Colors.white),
                              ),
                              backgroundColor: _statusColor(request.status),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              request.priority,
                              style: TextStyle(
                                fontSize: 11,
                                color: _priorityColor(request.priority),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

class _ReportMaintenanceScreen extends StatefulWidget {
  const _ReportMaintenanceScreen();

  @override
  State<_ReportMaintenanceScreen> createState() =>
      _ReportMaintenanceScreenState();
}

class _ReportMaintenanceScreenState extends State<_ReportMaintenanceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _category = _categories.first;
  String _priority = _priorities[1];
  Booking? _selectedBooking;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_selectedBooking == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select which booking this is about')),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;
    final booking = _selectedBooking!;
    final maintenance = Maintenance(
      id: '',
      hostelId: booking.hostelId,
      landlordId: booking.landlordId,
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      priority: _priority,
      status: 'pending',
      reportedDate: DateTime.now(),
      reportedBy: uid,
      createdAt: Timestamp.now(),
    );

    final id = await Provider.of<MaintenanceProvider>(context, listen: false)
        .reportMaintenance(maintenance);

    if (!mounted) return;
    setState(() => _isSubmitting = false);

    if (id != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maintenance request submitted!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit request. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid;

    return Scaffold(
      appBar: AppBar(title: const Text('Report an Issue')),
      body: uid == null
          ? const Center(child: Text('Please log in again'))
          : StreamBuilder<List<Booking>>(
              stream: Provider.of<BookingProvider>(context, listen: false)
                  .getStudentBookingsStream(uid),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final bookings = (snapshot.data ?? [])
                    .where((b) => b.status == 'approved')
                    .toList();

                if (bookings.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'You need an approved booking before you can report a maintenance issue.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DropdownButtonFormField<Booking>(
                          initialValue: _selectedBooking,
                          decoration: InputDecoration(
                            labelText: 'Which booking is this about?',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          items: bookings
                              .map((b) => DropdownMenuItem(
                                    value: b,
                                    child: Text(
                                        '${b.roomType} • ${b.checkInDate.toLocal().toString().split(' ').first}'),
                                  ))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _selectedBooking = value),
                          validator: (value) =>
                              value == null ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _titleController,
                          decoration: InputDecoration(
                            labelText: 'Title',
                            hintText: 'e.g. Leaking tap in bathroom',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _descriptionController,
                          maxLines: 4,
                          decoration: InputDecoration(
                            labelText: 'Description',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _category,
                          decoration: InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _categories
                              .map((c) => DropdownMenuItem(
                                  value: c, child: Text(c)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _category = value!),
                        ),
                        const SizedBox(height: 16),
                        DropdownButtonFormField<String>(
                          initialValue: _priority,
                          decoration: InputDecoration(
                            labelText: 'Priority',
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          items: _priorities
                              .map((p) => DropdownMenuItem(
                                  value: p, child: Text(p)))
                              .toList(),
                          onChanged: (value) =>
                              setState(() => _priority = value!),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12)),
                            ),
                            child: _isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2, color: Colors.white),
                                  )
                                : const Text('Submit Request'),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
