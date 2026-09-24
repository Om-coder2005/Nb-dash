import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: NbAppBar(
        title: 'Inventory & Stock Management',
        showBack: true,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Raw Materials'),
            Tab(text: 'Stock Batches (FIFO)'),
            Tab(text: 'Alerts & Expiry'),
            Tab(text: 'Wastage & Spoilage'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _RawMaterialsTab(),
          _StockBatchesTab(),
          _InventoryAlertsTab(),
          _StockWastageTab(),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 60),
        child: FloatingActionButton.extended(
          onPressed: () {
            if (_tabController.index == 0) {
              _showAddRawItemDialog(context, ref);
            } else if (_tabController.index == 1) {
              _showAddStockBatchDialog(context, ref);
            } else if (_tabController.index == 3) {
              _showRecordWastageDialog(context, ref);
            } else {
              _showAddRawItemDialog(context, ref);
            }
          },
          icon: Icon(
            _tabController.index == 3 ? Icons.delete_sweep_rounded : Icons.add_rounded,
          ),
          label: Text(
            _tabController.index == 0
                ? 'Add Raw Item'
                : (_tabController.index == 1
                    ? 'Add Stock Batch'
                    : (_tabController.index == 3 ? 'Record Wastage' : 'Add Raw Item')),
          ),
        ),
      ),
    );
  }

  static void _showAddRawItemDialog(BuildContext context, WidgetRef ref) {
    final nameCtrl = TextEditingController();
    final unitCtrl = TextEditingController(text: 'pcs');
    final minStockCtrl = TextEditingController(text: '5.0');
    final expiryAlertCtrl = TextEditingController(text: '7');
    String category = 'General';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return NbDialog(
            title: 'Add Raw Material Item',
            customContent: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NbInput(
                    labelText: 'Material Name (e.g. Burger Pattie, Bun, Cheese)',
                    controller: nameCtrl,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: NbInput(
                          labelText: 'Unit (e.g. pcs, kg, g, l, ml)',
                          controller: unitCtrl,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: ['General', 'Dairy', 'Meat & Poultry', 'Vegetables', 'Bakery', 'Beverages', 'Spices & Sauces']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (val) => setState(() => category = val ?? 'General'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: NbInput(
                          labelText: 'Min Stock Alert Threshold',
                          controller: minStockCtrl,
                          type: NbInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: NbInput(
                          labelText: 'Expiry Alert (Days Before)',
                          controller: expiryAlertCtrl,
                          type: NbInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            primaryButtonText: 'Save Item',
            onPrimary: () async {
              if (nameCtrl.text.trim().isEmpty) return;
              final db = ref.read(databaseProvider);
              await db.insertRawItem(RawItemsCompanion.insert(
                name: nameCtrl.text.trim(),
                unit: unitCtrl.text.trim().isEmpty ? 'pcs' : unitCtrl.text.trim(),
                category: Value(category),
                minStockAlert: Value(double.tryParse(minStockCtrl.text) ?? 5.0),
                expiryAlertDays: Value(int.tryParse(expiryAlertCtrl.text) ?? 7),
              ));
              if (context.mounted) {
                Navigator.pop(ctx);
                NbToast.show(context, 'Raw Material added!', type: NbToastType.success);
              }
            },
          );
        },
      ),
    );
  }

  static void _showAddStockBatchDialog(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final rawItems = await db.getAllRawItems();
    if (rawItems.isEmpty) {
      if (context.mounted) {
        NbToast.show(context, 'Please add raw materials first!', type: NbToastType.warning);
      }
      return;
    }

    int selectedRawItemId = rawItems.first.id;
    final qtyCtrl = TextEditingController(text: '28');
    final totalCostCtrl = TextEditingController(text: '250');
    final supplierCtrl = TextEditingController();
    final batchCodeCtrl = TextEditingController(text: 'BATCH-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}');
    DateTime purchaseDate = DateTime.now();
    DateTime? expiryDate = DateTime.now().add(const Duration(days: 30));

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final qty = double.tryParse(qtyCtrl.text) ?? 0.0;
          final totalCost = double.tryParse(totalCostCtrl.text) ?? 0.0;
          final calculatedPerUnit = qty > 0 ? totalCost / qty : 0.0;
          final selectedItem = rawItems.firstWhere((i) => i.id == selectedRawItemId, orElse: () => rawItems.first);

          return NbDialog(
            title: 'Add New Stock Batch (FIFO)',
            customContent: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: selectedRawItemId,
                    decoration: const InputDecoration(
                      labelText: 'Select Raw Material',
                      border: OutlineInputBorder(),
                    ),
                    items: rawItems
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text('${item.name} (${item.unit})'),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedRawItemId = val!),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: NbInput(
                          labelText: 'Quantity Loaded (${selectedItem.unit})',
                          controller: qtyCtrl,
                          type: NbInputType.number,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: NbInput(
                          labelText: 'Total Batch Cost (₹)',
                          controller: totalCostCtrl,
                          type: NbInputType.number,
                          onChanged: (_) => setState(() {}),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Calculated Unit Price:',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                        ),
                        Text(
                          '₹${calculatedPerUnit.toStringAsFixed(2)} / ${selectedItem.unit}',
                          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: NbInput(
                          labelText: 'Batch Code / Bill No.',
                          controller: batchCodeCtrl,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: NbInput(
                          labelText: 'Supplier / Vendor',
                          controller: supplierCtrl,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today_rounded, size: 18),
                          label: Text('Purchased: ${DateFormat('dd MMM yyyy').format(purchaseDate)}'),
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: purchaseDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setState(() => purchaseDate = d);
                          },
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.event_rounded, size: 18),
                          label: Text(expiryDate == null ? 'No Expiry' : 'Exp: ${DateFormat('dd MMM yyyy').format(expiryDate!)}'),
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: expiryDate ?? DateTime.now().add(const Duration(days: 30)),
                              firstDate: DateTime.now(),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setState(() => expiryDate = d);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            primaryButtonText: 'Load Stock Batch',
            onPrimary: () async {
              final qty = double.tryParse(qtyCtrl.text) ?? 0.0;
              final totalCost = double.tryParse(totalCostCtrl.text) ?? 0.0;
              if (qty <= 0) return;

              final costPerUnit = totalCost / qty;
              await db.insertStockBatch(StockBatchesCompanion.insert(
                rawItemId: selectedRawItemId,
                initialQty: qty,
                remainingQty: qty,
                costPerUnit: costPerUnit,
                totalBatchCost: totalCost,
                purchaseDate: purchaseDate,
                expiryDate: Value(expiryDate),
                batchCode: Value(batchCodeCtrl.text.trim()),
                supplier: Value(supplierCtrl.text.trim()),
              ));

              if (context.mounted) {
                Navigator.pop(ctx);
                NbToast.show(context, 'New stock batch added successfully!', type: NbToastType.success);
              }
            },
          );
        },
      ),
    );
  }

  static void _showRecordWastageDialog(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final rawItems = await db.getAllRawItems();
    if (rawItems.isEmpty) {
      if (context.mounted) {
        NbToast.show(context, 'Please add raw materials first!', type: NbToastType.warning);
      }
      return;
    }

    int selectedRawItemId = rawItems.first.id;
    final qtyCtrl = TextEditingController(text: '1');
    final notesCtrl = TextEditingController();
    String reason = 'Spoiled / Damaged';

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final selectedItem = rawItems.firstWhere((i) => i.id == selectedRawItemId, orElse: () => rawItems.first);

          return NbDialog(
            title: 'Record Stock Wastage / Spoilage',
            customContent: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DropdownButtonFormField<int>(
                    initialValue: selectedRawItemId,
                    decoration: const InputDecoration(
                      labelText: 'Select Wasted Raw Material',
                      border: OutlineInputBorder(),
                    ),
                    items: rawItems
                        .map((item) => DropdownMenuItem(
                              value: item.id,
                              child: Text('${item.name} (${item.unit})'),
                            ))
                        .toList(),
                    onChanged: (val) => setState(() => selectedRawItemId = val!),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: NbInput(
                          labelText: 'Quantity Wasted (${selectedItem.unit})',
                          controller: qtyCtrl,
                          type: NbInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: reason,
                          decoration: const InputDecoration(
                            labelText: 'Reason for Wastage',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Spoiled / Damaged', 'Expired', 'Spilled / Dropped', 'Preparation Error', 'Other']
                              .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                              .toList(),
                          onChanged: (val) => setState(() => reason = val ?? 'Spoiled / Damaged'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  NbInput(
                    labelText: 'Notes / Details (Optional)',
                    controller: notesCtrl,
                  ),
                ],
              ),
            ),
            primaryButtonText: 'Record Wastage',
            onPrimary: () async {
              final qty = double.tryParse(qtyCtrl.text) ?? 0.0;
              if (qty <= 0) {
                NbToast.show(context, 'Please enter a valid wasted quantity', type: NbToastType.error);
                return;
              }

              await db.recordStockWastage(
                rawItemId: selectedRawItemId,
                quantityWasted: qty,
                reason: reason,
                notes: notesCtrl.text.trim(),
              );

              if (context.mounted) {
                Navigator.pop(ctx);
                NbToast.show(context, 'Stock wastage recorded and deducted from inventory!', type: NbToastType.warning);
              }
            },
          );
        },
      ),
    );
  }
}

// ─────────────────────────────────────────────
// RAW MATERIALS TAB
// ─────────────────────────────────────────────
class _RawMaterialsTab extends ConsumerWidget {
  const _RawMaterialsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder<List<RawItem>>(
      stream: db.watchRawItems(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const NbLoadingPulse();
        final rawItems = snapshot.data!;
        if (rawItems.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.inventory_2_outlined, size: 64, color: AppColors.textMuted),
                const SizedBox(height: 16),
                Text('No Raw Material Items Configured', style: TextStyle(fontSize: 18, color: AppColors.textMuted)),
                const SizedBox(height: 8),
                Text('Click "Add Raw Item" to register items like Patties, Buns, Milk, Cheese.', style: TextStyle(color: AppColors.textMuted)),
              ],
            ),
          );
        }

        return StreamBuilder<List<StockBatche>>(
          stream: db.watchStockBatches(),
          builder: (context, batchSnap) {
            final batches = batchSnap.data ?? [];

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: rawItems.length,
              itemBuilder: (context, index) {
                final item = rawItems[index];
                final itemBatches = batches.where((b) => b.rawItemId == item.id && b.remainingQty > 0).toList();
                final totalQty = itemBatches.fold<double>(0.0, (sum, b) => sum + b.remainingQty);
                final isLowStock = totalQty <= item.minStockAlert;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: AppColors.card,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        final isCompact = constraints.maxWidth < 450;
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: isLowStock ? AppColors.error.withValues(alpha: 0.15) : AppColors.primary.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(
                                    isLowStock ? Icons.warning_amber_rounded : Icons.inventory_rounded,
                                    color: isLowStock ? AppColors.error : AppColors.primary,
                                    size: 20,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.surface,
                                          borderRadius: BorderRadius.circular(6),
                                          border: Border.all(color: AppColors.border),
                                        ),
                                        child: Text(item.category, style: TextStyle(fontSize: 11, color: AppColors.textMuted)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Flex(
                              direction: isCompact ? Axis.vertical : Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                              children: [
                                Wrap(
                                  spacing: 16,
                                  runSpacing: 4,
                                  children: [
                                    Text('Active Batches: ${itemBatches.length}', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                    Text('Min Alert: ${item.minStockAlert} ${item.unit}', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                  ],
                                ),
                                if (isCompact) const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment: isCompact ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${totalQty.toStringAsFixed(totalQty.truncateToDouble() == totalQty ? 0 : 2)} ${item.unit}',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isLowStock ? AppColors.error : AppColors.success,
                                      ),
                                    ),
                                    if (isLowStock) ...[
                                      const SizedBox(width: 8),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: AppColors.error.withValues(alpha: 0.15),
                                          borderRadius: BorderRadius.circular(4),
                                        ),
                                        child: const Text('LOW STOCK', style: TextStyle(color: AppColors.error, fontSize: 10, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// STOCK BATCHES TAB (FIFO DISPLAY)
// ─────────────────────────────────────────────
class _StockBatchesTab extends ConsumerWidget {
  const _StockBatchesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder<List<StockBatche>>(
      stream: db.watchStockBatches(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const NbLoadingPulse();
        final batches = snapshot.data!;
        if (batches.isEmpty) {
          return Center(
            child: Text('No Stock Batches loaded yet.', style: TextStyle(color: AppColors.textMuted, fontSize: 16)),
          );
        }

        return FutureBuilder<List<RawItem>>(
          future: db.getAllRawItems(),
          builder: (context, rawSnap) {
            final rawItemsMap = {for (var item in rawSnap.data ?? []) item.id: item};

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: batches.length,
              itemBuilder: (context, index) {
                final batch = batches[index];
                final rawItem = rawItemsMap[batch.rawItemId];
                final unitStr = rawItem?.unit ?? 'pcs';
                final itemName = rawItem?.name ?? 'Item #${batch.rawItemId}';
                final isDepleted = batch.remainingQty <= 0;

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  color: isDepleted ? AppColors.card.withValues(alpha: 0.5) : AppColors.card,
                  elevation: isDepleted ? 0 : 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        LayoutBuilder(
                          builder: (context, constraints) {
                            final isCompact = constraints.maxWidth < 450;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Flex(
                                  direction: isCompact ? Axis.vertical : Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.center,
                                  children: [
                                    Wrap(
                                      crossAxisAlignment: WrapCrossAlignment.center,
                                      spacing: 8,
                                      runSpacing: 4,
                                      children: [
                                        Icon(Icons.local_shipping_outlined, color: isDepleted ? AppColors.textMuted : AppColors.primary, size: 20),
                                        Text(
                                          itemName,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            decoration: isDepleted ? TextDecoration.lineThrough : null,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: AppColors.primary.withValues(alpha: 0.1),
                                            borderRadius: BorderRadius.circular(6),
                                          ),
                                          child: Text(
                                            batch.batchCode.isEmpty ? 'BATCH #${batch.id}' : batch.batchCode,
                                            style: TextStyle(fontSize: 11, color: AppColors.primary, fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (isCompact) const SizedBox(height: 6),
                                    Text(
                                      '₹${batch.costPerUnit.toStringAsFixed(2)} / $unitStr',
                                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Flex(
                                  direction: isCompact ? Axis.vertical : Axis.horizontal,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('Purchased: ${DateFormat('dd MMM yyyy').format(batch.purchaseDate)}', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                        if (batch.expiryDate != null)
                                          Text(
                                            'Expiry Date: ${DateFormat('dd MMM yyyy').format(batch.expiryDate!)}',
                                            style: TextStyle(fontSize: 12, color: batch.expiryDate!.isBefore(DateTime.now()) ? AppColors.error : AppColors.textMuted),
                                          ),
                                        if (batch.supplier.isNotEmpty)
                                          Text('Supplier: ${batch.supplier}', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                                      ],
                                    ),
                                    if (isCompact) const SizedBox(height: 8),
                                    Column(
                                      crossAxisAlignment: isCompact ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          'Remaining: ${batch.remainingQty.toStringAsFixed(batch.remainingQty.truncateToDouble() == batch.remainingQty ? 0 : 2)} / ${batch.initialQty.toStringAsFixed(0)} $unitStr',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: isDepleted ? AppColors.textMuted : AppColors.textPrimary,
                                          ),
                                        ),
                                        Text(
                                          'Total Batch Value: ₹${batch.totalBatchCost.toStringAsFixed(0)}',
                                          style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// ALERTS & EXPIRY TAB
// ─────────────────────────────────────────────
class _InventoryAlertsTab extends ConsumerWidget {
  const _InventoryAlertsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder<List<RawItem>>(
      stream: db.watchRawItems(),
      builder: (context, rawSnap) {
        if (!rawSnap.hasData) return const NbLoadingPulse();
        final rawItems = rawSnap.data!;

        return StreamBuilder<List<StockBatche>>(
          stream: db.watchStockBatches(),
          builder: (context, batchSnap) {
            final batches = batchSnap.data ?? [];
            final now = DateTime.now();

            final lowStockItems = <Map<String, dynamic>>[];
            final nearExpiryBatches = <Map<String, dynamic>>[];

            for (final item in rawItems) {
              final activeBatches = batches.where((b) => b.rawItemId == item.id && b.remainingQty > 0).toList();
              final totalQty = activeBatches.fold<double>(0.0, (s, b) => s + b.remainingQty);
              if (totalQty <= item.minStockAlert) {
                lowStockItems.add({'item': item, 'currentQty': totalQty});
              }

              for (final batch in activeBatches) {
                if (batch.expiryDate != null) {
                  final daysLeft = batch.expiryDate!.difference(now).inDays;
                  if (daysLeft <= item.expiryAlertDays) {
                    nearExpiryBatches.add({
                      'item': item,
                      'batch': batch,
                      'daysLeft': daysLeft,
                    });
                  }
                }
              }
            }

            if (lowStockItems.isEmpty && nearExpiryBatches.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle_outline_rounded, size: 64, color: AppColors.success),
                    const SizedBox(height: 16),
                    const Text('Inventory Healthy!', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.success)),
                    const SizedBox(height: 8),
                    Text('No low stock or expiring batches detected.', style: TextStyle(color: AppColors.textMuted)),
                  ],
                ),
              );
            }

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (lowStockItems.isNotEmpty) ...[
                  const Text('LOW STOCK WARNINGS', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  ...lowStockItems.map((data) {
                    final RawItem item = data['item'];
                    final double qty = data['currentQty'];
                    return Card(
                      color: AppColors.error.withValues(alpha: 0.08),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.warning_amber_rounded, color: AppColors.error),
                        title: Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Min alert threshold: ${item.minStockAlert} ${item.unit}'),
                        trailing: Text(
                          'Available: $qty ${item.unit}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error, fontSize: 16),
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 24),
                ],
                if (nearExpiryBatches.isNotEmpty) ...[
                  const Text('EXPIRY WARNINGS', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.warning, letterSpacing: 1.2)),
                  const SizedBox(height: 8),
                  ...nearExpiryBatches.map((data) {
                    final RawItem item = data['item'];
                    final StockBatche batch = data['batch'];
                    final int daysLeft = data['daysLeft'];
                    return Card(
                      color: AppColors.warning.withValues(alpha: 0.08),
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: const Icon(Icons.event_busy_rounded, color: AppColors.warning),
                        title: Text('${item.name} (${batch.batchCode})', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Remaining Qty: ${batch.remainingQty} ${item.unit}'),
                        trailing: Text(
                          daysLeft < 0 ? 'EXPIRED' : 'Expiring in $daysLeft days',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: daysLeft < 0 ? AppColors.error : AppColors.warning,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ],
            );
          },
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// WASTAGE & SPOILAGE TAB
// ─────────────────────────────────────────────
class _StockWastageTab extends ConsumerWidget {
  const _StockWastageTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return StreamBuilder<List<StockWastageData>>(
      stream: db.watchStockWastage(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const NbLoadingPulse();
        final wastageList = snapshot.data!;

        if (wastageList.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.delete_outline_rounded, size: 64, color: AppColors.textMuted),
                const SizedBox(height: 16),
                Text('No Stock Wastage Recorded', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textMuted)),
                const SizedBox(height: 8),
                Text('Tap "Record Wastage" to log spoiled, spilled or expired stock.', style: TextStyle(color: AppColors.textMuted)),
              ],
            ),
          );
        }

        return FutureBuilder<List<RawItem>>(
          future: db.getAllRawItems(),
          builder: (context, rawSnap) {
            final rawItems = rawSnap.data ?? [];
            final totalWastageCost = wastageList.fold<double>(0.0, (s, w) => s + w.wastageCost);

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: wastageList.length + 1,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Total Recorded Wastage Loss',
                              style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.error, fontSize: 14),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '${wastageList.length} items logged',
                              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                            ),
                          ],
                        ),
                        Text(
                          '₹${totalWastageCost.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error, fontSize: 20),
                        ),
                      ],
                    ),
                  );
                }

                final wastage = wastageList[index - 1];
                final rawItem = rawItems.firstWhere(
                  (r) => r.id == wastage.rawItemId,
                  orElse: () => RawItem(
                    id: 0,
                    name: 'Raw Material',
                    unit: 'units',
                    minStockAlert: 0,
                    expiryAlertDays: 7,
                    category: '',
                    createdAt: DateTime.now(),
                  ),
                );

                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  color: AppColors.card,
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.error.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.delete_forever_rounded, color: AppColors.error, size: 20),
                    ),
                    title: Text(rawItem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(
                      '${wastage.quantityWasted} ${rawItem.unit} — ${wastage.reason}\n${DateFormat('dd MMM yyyy, hh:mm a').format(wastage.date)}${wastage.notes.isNotEmpty ? ' (${wastage.notes})' : ''}',
                      style: TextStyle(fontSize: 12, color: AppColors.textMuted),
                    ),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${wastage.wastageCost.toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.error, fontSize: 15),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete_outline_rounded, size: 16, color: AppColors.textMuted),
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          onPressed: () async {
                            await db.deleteStockWastage(wastage.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
