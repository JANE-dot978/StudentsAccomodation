import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/hostel_model.dart';
import '../../models/shared_item_model.dart';
import '../../providers/auth_provider.dart';
import '../../providers/hostel_provider.dart';
import '../../providers/shared_item_provider.dart';
import '../../widgets/shared_item_card.dart';

const _categories = ['furniture', 'appliance', 'utensil', 'other'];
const _conditions = ['new', 'good', 'fair', 'poor'];

class SharedItemsScreen extends StatelessWidget {
  const SharedItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final landlordId =
        Provider.of<AuthProvider>(context, listen: false).user?.uid ?? '';
    final hostelProvider = Provider.of<HostelProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(title: const Text('Shared Items')),
      body: StreamBuilder<List<HostelModel>>(
        stream: hostelProvider.getLandlordHostels(landlordId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final hostels = snapshot.data ?? [];
          if (hostels.isEmpty) {
            return Center(
              child: Text(
                'Add a property first to manage its shared items',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: hostels.length,
            itemBuilder: (context, index) {
              final hostel = hostels[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: const Icon(Icons.apartment_outlined),
                  title: Text(hostel.name),
                  subtitle: Text(hostel.location),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => _HostelSharedItemsScreen(
                        hostelId: hostel.id,
                        hostelName: hostel.name,
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class _HostelSharedItemsScreen extends StatefulWidget {
  final String hostelId;
  final String hostelName;

  const _HostelSharedItemsScreen({
    required this.hostelId,
    required this.hostelName,
  });

  @override
  State<_HostelSharedItemsScreen> createState() =>
      _HostelSharedItemsScreenState();
}

class _HostelSharedItemsScreenState extends State<_HostelSharedItemsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SharedItemProvider>(context, listen: false);
    Future.microtask(() => provider.fetchAllHostelItems(widget.hostelId));
  }

  void _refresh() {
    Provider.of<SharedItemProvider>(context, listen: false)
        .fetchAllHostelItems(widget.hostelId);
  }

  Future<void> _openForm({SharedItem? existing}) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _ItemFormSheet(
        hostelId: widget.hostelId,
        existing: existing,
      ),
    );

    if (result == true) _refresh();
  }

  Future<void> _delete(SharedItem item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Remove "${item.itemName}" from this hostel?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !mounted) return;

    final success = await Provider.of<SharedItemProvider>(context, listen: false)
        .deleteItem(item.id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(success ? 'Item removed' : 'Failed to remove item')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final sharedItemProvider = Provider.of<SharedItemProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text(widget.hostelName)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openForm(),
        icon: const Icon(Icons.add),
        label: const Text('Add Item'),
      ),
      body: sharedItemProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : sharedItemProvider.items.isEmpty
              ? Center(
                  child: Text(
                    'No shared items yet — tap "Add Item" to list one',
                    style: TextStyle(color: Colors.grey.shade600),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sharedItemProvider.items.length,
                  itemBuilder: (context, index) {
                    final item = sharedItemProvider.items[index];
                    return SharedItemCard(
                      item: item,
                      onTap: () => _openForm(existing: item),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _delete(item),
                      ),
                    );
                  },
                ),
    );
  }
}

class _ItemFormSheet extends StatefulWidget {
  final String hostelId;
  final SharedItem? existing;

  const _ItemFormSheet({required this.hostelId, this.existing});

  @override
  State<_ItemFormSheet> createState() => _ItemFormSheetState();
}

class _ItemFormSheetState extends State<_ItemFormSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late String _category;
  late String _condition;
  late int _quantity;
  late bool _available;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _nameController = TextEditingController(text: existing?.itemName ?? '');
    _descriptionController =
        TextEditingController(text: existing?.description ?? '');
    _category = existing?.category ?? _categories.first;
    _condition = existing?.condition ?? _conditions[1];
    _quantity = existing?.quantity ?? 1;
    _available = existing?.available ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isSaving = true);

    final uid = Provider.of<AuthProvider>(context, listen: false).user?.uid ?? '';
    final provider = Provider.of<SharedItemProvider>(context, listen: false);
    final existing = widget.existing;

    final item = SharedItem(
      id: existing?.id ?? '',
      hostelId: widget.hostelId,
      roomId: existing?.roomId ?? '',
      itemName: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      category: _category,
      condition: _condition,
      itemImage: existing?.itemImage ?? '',
      createdBy: existing?.createdBy ?? uid,
      createdAt: existing?.createdAt ?? Timestamp.now(),
      quantity: _quantity,
      available: _available,
    );

    final success = existing == null
        ? (await provider.addItem(item)) != null
        : await provider.updateItem(existing.id, item);

    if (!mounted) return;
    setState(() => _isSaving = false);

    if (success) {
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save item. Please try again.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 20,
        bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.existing == null ? 'Add Shared Item' : 'Edit Shared Item',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                  hintText: 'e.g. Study Table',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _category,
                      decoration: InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _categories
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) => setState(() => _category = value!),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _condition,
                      decoration: InputDecoration(
                        labelText: 'Condition',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      items: _conditions
                          .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (value) => setState(() => _condition = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Text('Quantity'),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline),
                    onPressed: _quantity > 1
                        ? () => setState(() => _quantity--)
                        : null,
                  ),
                  Text('$_quantity', style: const TextStyle(fontSize: 16)),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline),
                    onPressed: () => setState(() => _quantity++),
                  ),
                ],
              ),
              SwitchListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Available'),
                value: _available,
                onChanged: (value) => setState(() => _available = value),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _save,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                        )
                      : Text(widget.existing == null ? 'Add Item' : 'Save Changes'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
