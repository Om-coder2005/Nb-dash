import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/features/kitchen/kitchen_display_state.dart';

class KitchenDisplayScreen extends ConsumerStatefulWidget {
  const KitchenDisplayScreen({super.key});

  @override
  ConsumerState<KitchenDisplayScreen> createState() => _KitchenDisplayScreenState();
}

class _KitchenDisplayScreenState extends ConsumerState<KitchenDisplayScreen> {
  KitchenKotStatus? _filter;

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final rowsAsync = ref.watch(kitchenRowsProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          'KITCHEN',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,
            letterSpacing: 1.2,
            color: AppColors.textPrimary,
          ),
        ),
        actions: [
          _buildStatusPill('Live', AppColors.success),
          const SizedBox(width: 8),
          _buildStatusPill('Clock', AppColors.primary),
          const SizedBox(width: 12),
        ],
      ),
      body: rowsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text('Error: $e')),
        data: (rows) {
            final filtered = _filter == null
              ? rows
              : rows.where((r) => r.status == _filter).toList();
          final counts = {
            'new': rows.where((r) => r.status == KitchenKotStatus.newValue).length,
            'preparing': rows.where((r) => r.status == KitchenKotStatus.preparing).length,
            'ready': rows.where((r) => r.status == KitchenKotStatus.ready).length,
            'completed': rows.where((r) => r.status == KitchenKotStatus.completed).length,
          };

          final visible = filtered;

          return Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  border: Border(bottom: BorderSide(color: AppColors.border)),
                ),
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'All',
                      count: rows.length,
                      selected: _filter == null,
                      onTap: () => setState(() => _filter = null),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'New',
                      count: counts['new'] ?? 0,
                      selected: _filter == KitchenKotStatus.newValue,
                      onTap: () => setState(() => _filter = KitchenKotStatus.newValue),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Preparing',
                      count: counts['preparing'] ?? 0,
                      selected: _filter == KitchenKotStatus.preparing,
                      onTap: () => setState(() => _filter = KitchenKotStatus.preparing),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Ready',
                      count: counts['ready'] ?? 0,
                      selected: _filter == KitchenKotStatus.ready,
                      onTap: () => setState(() => _filter = KitchenKotStatus.ready),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Completed',
                      count: counts['completed'] ?? 0,
                      selected: _filter == KitchenKotStatus.completed,
                      onTap: () => setState(() => _filter = KitchenKotStatus.completed),
                    ),
                    const Spacer(),
                    _buildStatusPill('Open ${rows.length}', AppColors.primary),
                    const SizedBox(width: 8),
                    _buildStatusPill('Ready ${counts['ready'] ?? 0}', AppColors.success),
                    const SizedBox(width: 8),
                    _buildStatusPill(DateFormat.Hm().format(DateTime.now()), AppColors.info),
                  ],
                ),
              ),
              Expanded(
                child: visible.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.kitchen_rounded, size: 52, color: AppColors.textMuted),
                            const SizedBox(height: 12),
                            Text('No KOTs in this queue', style: GoogleFonts.manrope(color: AppColors.textMuted)),
                          ],
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 360,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.82,
                        ),
                        itemCount: visible.length,
                        itemBuilder: (context, index) {
                          final row = visible[index];
                          return _KitchenKotCard(row: row, onStatusAdvance: () async {
                            final db = ref.read(databaseProvider);
                            await db.updateKotKitchenStatus(row.kotId, row.status.next().value);
                          });
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatusPill(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: selected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                fontWeight: FontWeight.w700,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: selected ? 0.18 : 0.08),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                count.toString(),
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: selected ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KitchenKotCard extends StatelessWidget {
  final KitchenDisplayRow row;
  final VoidCallback onStatusAdvance;

  const _KitchenKotCard({required this.row, required this.onStatusAdvance});

  Color get _statusColor {
    switch (row.status) {
      case KitchenKotStatus.newValue:
        return AppColors.warning;
      case KitchenKotStatus.preparing:
        return AppColors.info;
      case KitchenKotStatus.ready:
        return AppColors.success;
      case KitchenKotStatus.completed:
        return AppColors.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final elapsed = DateTime.now().difference(row.printedAt);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _statusColor.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [BoxShadow(color: _statusColor.withValues(alpha: 0.08), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'KOT #${row.kotNumber}',
                    style: GoogleFonts.manrope(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                _StatusBadge(color: _statusColor, label: row.status.name.toUpperCase()),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.table_restaurant_rounded, size: 16, color: AppColors.textMuted),
                const SizedBox(width: 6),
                Text(
                  '${row.tableNumber} • ${row.tableLabel}',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              '${elapsed.inMinutes} min ago',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              height: 1,
              color: AppColors.border,
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: row.items.map((item) {
                  final qty = item['qty'] ?? 1;
                  final name = item['name'] ?? 'Item';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$qty×',
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w800,
                            color: _statusColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            name.toString(),
                            style: GoogleFonts.manrope(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: row.status == KitchenKotStatus.completed ? AppColors.textMuted : _statusColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: row.status == KitchenKotStatus.completed ? null : onStatusAdvance,
                child: Text(
                  row.status == KitchenKotStatus.newValue
                      ? 'Start Preparing'
                      : row.status == KitchenKotStatus.preparing
                          ? 'Mark Ready'
                          : 'Complete KOT',
                  style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Color color;
  final String label;

  const _StatusBadge({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w800,
          color: color,
        ),
      ),
    );
  }
}
