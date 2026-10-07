import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/maintanance_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/maintanance_provider.dart';

const _statusFilters = ['all', 'pending', 'in_progress', 'completed', 'cancelled'];

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
  String _filter = 'all';

  @override
  void initState() {
    super.initState();
    final landlordId =
        Provider.of<AuthProvider>(context, listen: false).user?.uid;
    if (landlordId != null) {
      final provider =
          Provider.of<MaintenanceProvider>(context, listen: false);
      Future.microtask(() => provider.fetchLandlordMaintenance(landlordId));
    }
  }

  Future<void> _refresh() async {
    final landlordId =
        Provider.of<AuthProvider>(context, listen: false).user?.uid;
    if (landlordId != null) {
      await Provider.of<MaintenanceProvider>(context, listen: false)
          .fetchLandlordMaintenance(landlordId);
    }
  }

  Future<void> _updateStatus(Maintenance request, String newStatus) async {
    final success = await Provider.of<MaintenanceProvider>(context, listen: false)
        .updateStatus(request.id, newStatus);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(success
              ? 'Marked as ${newStatus.replaceAll('_', ' ')}'
              : 'Failed to update status'),
        ),
      );
    }
  }

  void _showDetails(Maintenance request) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.title,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                Chip(
                  label: Text(request.status.replaceAll('_', ' ')),
                  backgroundColor:
                      _statusColor(request.status).withOpacity(0.15),
                  labelStyle:
                      TextStyle(color: _statusColor(request.status)),
                ),
                Chip(
                  label: Text(request.priority),
                  backgroundColor:
                      _priorityColor(request.priority).withOpacity(0.15),
                  labelStyle:
                      TextStyle(color: _priorityColor(request.priority)),
                ),
                Chip(label: Text(request.category)),
              ],
            ),
            const SizedBox(height: 16),
            Text(request.description),
            const SizedBox(height: 24),
            if (request.status != 'completed' && request.status != 'cancelled')
              Row(
                children: [
                  if (request.status == 'pending')
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _updateStatus(request, 'in_progress');
                        },
                        child: const Text('Start'),
                      ),
                    ),
                  if (request.status == 'pending') const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _updateStatus(request, 'completed');
                      },
                      child: const Text('Mark Completed'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.red),
                      onPressed: () {
                        Navigator.pop(context);
                        _updateStatus(request, 'cancelled');
                      },
                      child: const Text('Cancel'),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final maintenanceProvider = Provider.of<MaintenanceProvider>(context);
    final requests = _filter == 'all'
        ? maintenanceProvider.maintenanceRequests
        : maintenanceProvider.maintenanceRequests
            .where((r) => r.status == _filter)
            .toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Maintenance Requests')),
      body: Column(
        children: [
          SizedBox(
            height: 48,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              children: _statusFilters
                  .map((f) => Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: Text(f.replaceAll('_', ' ')),
                          selected: _filter == f,
                          onSelected: (_) => setState(() => _filter = f),
                        ),
                      ))
                  .toList(),
            ),
          ),
          Expanded(
            child: maintenanceProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : requests.isEmpty
                    ? Center(
                        child: Text(
                          'No maintenance requests',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: _refresh,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: requests.length,
                          itemBuilder: (context, index) {
                            final request = requests[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              child: ListTile(
                                onTap: () => _showDetails(request),
                                title: Text(request.title,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w600)),
                                subtitle: Text(request.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis),
                                trailing: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Chip(
                                      label: Text(
                                        request.status.replaceAll('_', ' '),
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: Colors.white),
                                      ),
                                      backgroundColor:
                                          _statusColor(request.status),
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
                      ),
          ),
        ],
      ),
    );
  }
}
