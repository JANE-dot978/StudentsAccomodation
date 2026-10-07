import 'package:flutter/material.dart';
import '../models/shared_item_model.dart';

IconData categoryIcon(String category) {
  switch (category) {
    case 'furniture':
      return Icons.chair_outlined;
    case 'appliance':
      return Icons.kitchen_outlined;
    case 'utensil':
      return Icons.set_meal_outlined;
    default:
      return Icons.category_outlined;
  }
}

Color conditionColor(String condition) {
  switch (condition) {
    case 'new':
      return Colors.green;
    case 'good':
      return Colors.blue;
    case 'fair':
      return Colors.orange;
    default:
      return Colors.red;
  }
}

class SharedItemCard extends StatelessWidget {
  final SharedItem item;
  final VoidCallback? onTap;
  final Widget? trailing;

  const SharedItemCard({
    super.key,
    required this.item,
    this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
          child: Icon(
            categoryIcon(item.category),
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        title: Text(item.itemName,
            style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          item.description.isEmpty
              ? 'Qty: ${item.quantity} • ${item.condition}'
              : '${item.description}\nQty: ${item.quantity} • ${item.condition}',
        ),
        isThreeLine: item.description.isNotEmpty,
        trailing: trailing ??
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Icon(
                  item.available ? Icons.check_circle : Icons.cancel,
                  color: item.available ? Colors.green : Colors.grey,
                  size: 18,
                ),
                const SizedBox(height: 4),
                Text(
                  item.condition,
                  style: TextStyle(
                    fontSize: 11,
                    color: conditionColor(item.condition),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
      ),
    );
  }
}
