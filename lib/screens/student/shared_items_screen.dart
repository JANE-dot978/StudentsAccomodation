import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shared_item_provider.dart';
import '../../widgets/shared_item_card.dart';

class SharedItemsScreen extends StatefulWidget {
  final String hostelId;
  final String hostelName;

  const SharedItemsScreen({
    super.key,
    required this.hostelId,
    required this.hostelName,
  });

  @override
  State<SharedItemsScreen> createState() => _SharedItemsScreenState();
}

class _SharedItemsScreenState extends State<SharedItemsScreen> {
  @override
  void initState() {
    super.initState();
    final provider = Provider.of<SharedItemProvider>(context, listen: false);
    Future.microtask(() => provider.fetchHostelItems(widget.hostelId));
  }

  @override
  Widget build(BuildContext context) {
    final sharedItemProvider = Provider.of<SharedItemProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('Shared Items • ${widget.hostelName}')),
      body: sharedItemProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : sharedItemProvider.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.inventory_2_outlined,
                          size: 64, color: Colors.grey.shade400),
                      const SizedBox(height: 16),
                      Text(
                        'No shared items listed for this hostel yet',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: sharedItemProvider.items.length,
                  itemBuilder: (context, index) =>
                      SharedItemCard(item: sharedItemProvider.items[index]),
                ),
    );
  }
}
