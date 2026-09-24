import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';

class TableManagementScreen extends ConsumerStatefulWidget {
  final int? zoneId;
  const TableManagementScreen({super.key, this.zoneId});

  @override
  ConsumerState<TableManagementScreen> createState() =>
      _TableManagementScreenState();
}

class _TableManagementScreenState extends ConsumerState<TableManagementScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.zoneId != null ? 1 : 0,
    );
    if (widget.zoneId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _addTable(context, initialZoneId: widget.zoneId);
        }
      });
    }
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
        title: 'Table Management',
        showBack: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Zones'),
            Tab(text: 'Tables'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _ZonesTab(),
          _TablesTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (_tabController.index == 0) {
            _addZone(context);
          } else {
            _addTable(context);
          }
        },
        icon: const Icon(Icons.add),
        label: AnimatedBuilder(
          animation: _tabController,
          builder: (_, __) => Text(
            _tabController.index == 0 ? 'Add Zone' : 'Add Table',
          ),
        ),
      ),
    );
  }

  void _addZone(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _ZoneDialog(
        onSave: (name, color) async {
          await ref.read(databaseProvider).insertZone(
                ZonesCompanion.insert(name: name, colorValue: Value(color.toARGB32())),
              );
        },
      ),
    );
  }

  void _addTable(BuildContext context, {int? initialZoneId}) {
    showDialog(
      context: context,
      builder: (ctx) => _TableDialog(
        initialZoneId: initialZoneId,
        onSave: (zoneId, number, name, capacity, shape) async {
          await ref.read(databaseProvider).insertTable(
                RestaurantTablesCompanion.insert(
                  zoneId: zoneId,
                  tableNumber: number,
                  tableLabel: name,
                  capacity: Value(capacity),
                  shape: Value(shape),
                ),
              );
        },
      ),
    );
  }
}

// ─── ZONES TAB ────────────────────────────────────────

class _ZonesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return StreamBuilder<List<Zone>>(
      stream: db.watchAllZones(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: NbLoadingPulse());
        final zones = snap.data!;
        if (zones.isEmpty) {
          return const Center(child: Text('No zones yet. Add one!'));
        }
        return ReorderableListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: zones.length,
          onReorder: (oldIndex, newIndex) async {
            // Reorder zones
            if (newIndex > oldIndex) newIndex--;
            final updated = List<Zone>.from(zones);
            final item = updated.removeAt(oldIndex);
            updated.insert(newIndex, item);
            for (int i = 0; i < updated.length; i++) {
              await db.updateZone(updated[i].copyWith(sortOrder: i));
            }
          },
          itemBuilder: (context, i) {
            final zone = zones[i];
            return Container(
              key: ValueKey(zone.id),
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: ListTile(
                leading: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(zone.colorValue).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.layers_rounded,
                      color: Color(zone.colorValue), size: 20),
                ),
                title: Text(zone.name,
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_rounded,
                          size: 18, color: AppColors.textSecondary),
                      onPressed: () => _editZone(context, ref, db, zone),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded,
                          size: 18, color: AppColors.error),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (_) => NbDialog(
                            title: 'Delete Zone?',
                            customContent: Text(
                              'Delete "${zone.name}"? All tables in this zone will also be deleted.',
                              style: GoogleFonts.manrope(fontSize: 15, color: AppColors.textSecondary),
                            ),
                            primaryButtonText: 'Delete',
                            isDanger: true,
                            onPrimary: () => Navigator.pop(context, true),
                            secondaryButtonText: 'Cancel',
                            onSecondary: () => Navigator.pop(context, false),
                          ),
                        );
                        if (confirm == true) {
                          await db.deleteZone(zone.id);
                        }
                      },
                    ),
                    Icon(Icons.drag_handle_rounded,
                        color: AppColors.textMuted),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editZone(
      BuildContext context, WidgetRef ref, AppDatabase db, Zone zone) {
    showDialog(
      context: context,
      builder: (ctx) => _ZoneDialog(
        initialName: zone.name,
        initialColor: Color(zone.colorValue),
        onSave: (name, color) async {
          await db.updateZone(zone.copyWith(name: name, colorValue: color.toARGB32()));
        },
      ),
    );
  }
}

// ─── TABLES TAB ──────────────────────────────────────

class _TablesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return StreamBuilder<List<RestaurantTable>>(
      stream: db.watchAllTables(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: NbLoadingPulse());
        final tables = snap.data!;
        if (tables.isEmpty) {
          return const Center(child: Text('No tables. Add one!'));
        }
        return StreamBuilder<List<Zone>>(
          stream: db.watchAllZones(),
          builder: (context, zoneSnap) {
            final zones = zoneSnap.data ?? [];
            final zoneMap = {for (final z in zones) z.id: z};
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: tables.length,
              itemBuilder: (context, i) {
                final table = tables[i];
                final zone = zoneMap[table.zoneId];
                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: ListTile(
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: zone != null
                            ? Color(zone.colorValue).withValues(alpha: 0.15)
                            : AppColors.surface,
                        borderRadius: table.shape == 'circle'
                            ? BorderRadius.circular(20)
                            : BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.table_restaurant_rounded,
                        color: zone != null
                            ? Color(zone.colorValue)
                            : AppColors.textMuted,
                        size: 20,
                      ),
                    ),
                    title: Text('${table.tableNumber} — ${table.tableLabel}',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary)),
                    subtitle: Text(
                      '${zone?.name ?? 'No Zone'} · ${table.capacity} covers · ${table.shape}',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.textMuted),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit_rounded,
                              size: 18, color: AppColors.textSecondary),
                          onPressed: () =>
                              _editTable(context, ref, db, table, zones),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_rounded,
                              size: 18, color: AppColors.error),
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => NbDialog(
                                title: 'Delete Table?',
                                customContent: Text(
                                  'Delete "${table.tableNumber} — ${table.tableLabel}"?',
                                  style: GoogleFonts.manrope(fontSize: 15, color: AppColors.textSecondary),
                                ),
                                primaryButtonText: 'Delete',
                                isDanger: true,
                                onPrimary: () => Navigator.pop(ctx, true),
                                secondaryButtonText: 'Cancel',
                                onSecondary: () => Navigator.pop(ctx, false),
                              ),
                            );
                            if (confirm == true) {
                              await db.deleteTable(table.id);
                            }
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

  void _editTable(BuildContext context, WidgetRef ref, AppDatabase db,
      RestaurantTable table, List<Zone> zones) {
    showDialog(
      context: context,
      builder: (ctx) => _TableDialog(
        initialZoneId: table.zoneId,
        initialNumber: table.tableNumber,
        initialName: table.tableLabel,
        initialCapacity: table.capacity,
        initialShape: table.shape,
        zones: zones,
        onSave: (zoneId, number, name, capacity, shape) async {
          final updated = table.copyWith(
            zoneId: zoneId,
            tableNumber: number,
            tableLabel: name,
            capacity: capacity,
            shape: shape,
          );
          await db.updateTable(updated);
        },
      ),
    );
  }
}

// ─── DIALOGS ─────────────────────────────────────────

class _ZoneDialog extends ConsumerStatefulWidget {
  final String? initialName;
  final Color? initialColor;
  final Future<void> Function(String name, Color color) onSave;

  const _ZoneDialog({this.initialName, this.initialColor, required this.onSave});

  @override
  ConsumerState<_ZoneDialog> createState() => _ZoneDialogState();
}

class _ZoneDialogState extends ConsumerState<_ZoneDialog> {
  late TextEditingController _nameController;
  late Color _selectedColor;

  final colors = [
    const Color(0xFF3B82F6),
    const Color(0xFF10B981),
    const Color(0xFF8B5CF6),
    const Color(0xFFEF4444),
    const Color(0xFFF59E0B),
    const Color(0xFFEC4899),
    const Color(0xFF06B6D4),
    const Color(0xFFF97316),
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _selectedColor = widget.initialColor ?? colors.first;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return NbDialog(
      title: widget.initialName != null ? 'Edit Zone' : 'Add Zone',
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NbInput(
            controller: _nameController,
            hintText: 'Zone Name',
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: colors.map((c) {
              final isSelected = c.toARGB32() == _selectedColor.toARGB32();
              return GestureDetector(
                onTap: () => setState(() => _selectedColor = c),
                child: Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: c,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(color: Colors.white, width: 3)
                        : null,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
      primaryButtonText: 'Save',
      onPrimary: () async {
        if (_nameController.text.trim().isEmpty) return;
        await widget.onSave(_nameController.text.trim(), _selectedColor);
        if (context.mounted) Navigator.pop(context);
      },
      secondaryButtonText: 'Cancel',
      onSecondary: () => Navigator.pop(context),
    );
  }
}

class _TableDialog extends ConsumerStatefulWidget {
  final int? initialZoneId;
  final String? initialNumber;
  final String? initialName;
  final int? initialCapacity;
  final String? initialShape;
  final List<Zone>? zones;
  final Future<void> Function(
      int zoneId, String number, String name, int capacity, String shape) onSave;

  const _TableDialog({
    this.initialZoneId,
    this.initialNumber,
    this.initialName,
    this.initialCapacity,
    this.initialShape,
    this.zones,
    required this.onSave,
  });

  @override
  ConsumerState<_TableDialog> createState() => _TableDialogState();
}

class _TableDialogState extends ConsumerState<_TableDialog> {
  late TextEditingController _numberController;
  late TextEditingController _nameController;
  int _capacity = 4;
  String _shape = 'square';
  int? _selectedZoneId;

  @override
  void initState() {
    super.initState();
    _numberController =
        TextEditingController(text: widget.initialNumber ?? '');
    _nameController = TextEditingController(text: widget.initialName ?? '');
    _capacity = widget.initialCapacity ?? 4;
    _shape = widget.initialShape ?? 'square';
    _selectedZoneId = widget.initialZoneId;
  }

  @override
  void dispose() {
    _numberController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return NbDialog(
      title: widget.initialNumber != null ? 'Edit Table' : 'Add Table',
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FutureBuilder<List<Zone>>(
            future: widget.zones != null
                ? Future.value(widget.zones!)
                : db.getAllZones(),
            builder: (context, snap) {
              if (!snap.hasData) return const NbLoadingPulse();
              final zones = snap.data!;
              if (zones.isEmpty) return Text('Please add a Zone first', style: GoogleFonts.inter(color: AppColors.textPrimary));
              
              if (_selectedZoneId == null && zones.isNotEmpty) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted) setState(() => _selectedZoneId = zones.first.id);
                });
              }
              
              final effectiveZoneId = zones.any((z) => z.id == _selectedZoneId)
                  ? _selectedZoneId
                  : (zones.isNotEmpty ? zones.first.id : null);

              return DropdownButtonFormField<int>(
                initialValue: effectiveZoneId,
                decoration: InputDecoration(
                  labelText: 'Zone',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                ),
                style: GoogleFonts.inter(color: AppColors.textPrimary),
                items: zones
                    .map((z) => DropdownMenuItem(value: z.id, child: Text(z.name)))
                    .toList(),
                onChanged: (v) => setState(() => _selectedZoneId = v),
                dropdownColor: AppColors.card,
              );
            },
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: NbInput(
                  controller: _numberController,
                  hintText: 'Table No.',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: NbInput(
                  controller: _nameController,
                  hintText: 'Table Name',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Capacity: ', style: GoogleFonts.inter(color: AppColors.textPrimary)),
              IconButton(
                onPressed: () {
                  if (_capacity > 1) setState(() => _capacity--);
                },
                icon: Icon(Icons.remove_circle_outline, color: AppColors.textSecondary),
              ),
              Text('$_capacity', style: GoogleFonts.manrope(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              IconButton(
                onPressed: () => setState(() => _capacity++),
                icon: Icon(Icons.add_circle_outline, color: AppColors.textSecondary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Shape: ', style: GoogleFonts.inter(color: AppColors.textPrimary)),
              const SizedBox(width: 8),
              ChoiceChip(
                label: Text('Square', style: TextStyle(color: _shape == 'square' ? AppColors.bg : AppColors.textPrimary)),
                selected: _shape == 'square',
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                onSelected: (_) => setState(() => _shape = 'square'),
              ),
              const SizedBox(width: 8),
              ChoiceChip(
                label: Text('Round', style: TextStyle(color: _shape == 'circle' ? AppColors.bg : AppColors.textPrimary)),
                selected: _shape == 'circle',
                selectedColor: AppColors.primary,
                backgroundColor: AppColors.surface,
                onSelected: (_) => setState(() => _shape = 'circle'),
              ),
            ],
          ),
        ],
      ),
      primaryButtonText: 'Save',
      onPrimary: () async {
        if (_numberController.text.trim().isEmpty) return;
        if (_selectedZoneId == null) return;
        await widget.onSave(
          _selectedZoneId!,
          _numberController.text.trim(),
          _nameController.text.trim().isEmpty
              ? 'Table ${_numberController.text.trim()}'
              : _nameController.text.trim(),
          _capacity,
          _shape,
        );
        if (context.mounted) Navigator.pop(context);
      },
      secondaryButtonText: 'Cancel',
      onSecondary: () => Navigator.pop(context),
    );
  }
}
