import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';

enum KitchenKotStatus {
  newValue('new'),
  preparing('preparing'),
  ready('ready'),
  completed('completed');

  const KitchenKotStatus(this.value);
  final String value;

  static KitchenKotStatus fromString(String? value) {
    switch (value ?? 'new') {
      case 'preparing':
        return KitchenKotStatus.preparing;
      case 'ready':
        return KitchenKotStatus.ready;
      case 'completed':
        return KitchenKotStatus.completed;
      case 'new':
      default:
        return KitchenKotStatus.newValue;
    }
  }

  KitchenKotStatus next() {
    switch (this) {
      case KitchenKotStatus.newValue:
        return KitchenKotStatus.preparing;
      case KitchenKotStatus.preparing:
        return KitchenKotStatus.ready;
      case KitchenKotStatus.ready:
        return KitchenKotStatus.completed;
      case KitchenKotStatus.completed:
        return KitchenKotStatus.completed;
    }
  }
}

class KitchenDisplayRow {
  final int kotId;
  final int orderId;
  final int kotNumber;
  final String tableNumber;
  final String tableLabel;
  final DateTime printedAt;
  final KitchenKotStatus status;
  final List<Map<String, dynamic>> items;

  const KitchenDisplayRow({
    required this.kotId,
    required this.orderId,
    required this.kotNumber,
    required this.tableNumber,
    required this.tableLabel,
    required this.printedAt,
    required this.status,
    required this.items,
  });
}

final kitchenRowsProvider = StreamProvider.autoDispose<List<KitchenDisplayRow>>((ref) {
  final db = ref.watch(databaseProvider);
  return db.watchKitchenKots().asyncMap((kots) async {
    final tableMap = {for (final table in await db.getAllTables()) table.id: table};
    final orderMap = <int, Order>{};
    final allOrders = await db.select(db.orders).get();
    for (final order in allOrders) {
      orderMap[order.id] = order;
    }

    final rows = <KitchenDisplayRow>[];
    for (final kot in kots) {
      final order = orderMap[kot.orderId];
      if (order == null) continue;
      final table = tableMap[order.tableId];
      final tableNumber = table?.tableNumber ?? 'T?';
      final tableLabel = table?.tableLabel ?? 'Table';
      final parsedItems = <Map<String, dynamic>>[];
      try {
        final decoded = jsonDecode(kot.itemsJson) as List<dynamic>;
        for (final item in decoded) {
          if (item is Map<String, dynamic>) {
            parsedItems.add(item);
          } else if (item is Map) {
            parsedItems.add(Map<String, dynamic>.from(item));
          }
        }
      } catch (_) {}

      if (parsedItems.isEmpty) continue;

      rows.add(
        KitchenDisplayRow(
          kotId: kot.id,
          orderId: kot.orderId,
          kotNumber: kot.kotNumber,
          tableNumber: tableNumber,
          tableLabel: tableLabel,
          printedAt: kot.printedAt,
          status: KitchenKotStatus.fromString(kot.kitchenStatus),
          items: parsedItems,
        ),
      );
    }
    return rows;
  });
});
