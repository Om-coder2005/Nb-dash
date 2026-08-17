import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' hide Column, Row;

import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';
import 'package:nextbills/core/utils/keyboard_helper.dart';

class RecipeAndSopDialog extends ConsumerStatefulWidget {
  final MenuItem menuItem;

  const RecipeAndSopDialog({super.key, required this.menuItem});

  @override
  ConsumerState<RecipeAndSopDialog> createState() => _RecipeAndSopDialogState();
}

class _RecipeAndSopDialogState extends ConsumerState<RecipeAndSopDialog>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late String _selectedVariant;
  List<String> _variants = ['full'];

  // SOP Controllers
  final _sopTitleCtrl = TextEditingController(text: 'Standard Prep SOP');
  final _prepTimeCtrl = TextEditingController(text: '10');
  final _sopNotesCtrl = TextEditingController();
  List<TextEditingController> _stepControllers = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _initVariants();
  }

  void _initVariants() {
    List<String> customList = [];
    if (widget.menuItem.customVariantsJson.isNotEmpty && widget.menuItem.customVariantsJson != '[]') {
      try {
        final parsed = jsonDecode(widget.menuItem.customVariantsJson) as List<dynamic>;
        for (final v in parsed) {
          final name = v['name']?.toString().trim();
          if (name != null && name.isNotEmpty && !customList.contains(name)) {
            customList.add(name);
          }
        }
      } catch (_) {}
    }

    if (customList.isNotEmpty) {
      _variants = customList;
    } else if (widget.menuItem.hasHalfFull) {
      _variants = ['full', 'half'];
    } else {
      _variants = ['full'];
    }

    _selectedVariant = _variants.first;
    _loadSop();
  }

  Future<void> _loadSop() async {
    final db = ref.read(databaseProvider);
    final sop = await db.getItemSop(widget.menuItem.id, _selectedVariant);
    if (sop != null) {
      _sopTitleCtrl.text = sop.title;
      _prepTimeCtrl.text = sop.prepTimeMins.toString();
      _sopNotesCtrl.text = sop.notes;
      if (sop.instructionsJson.isNotEmpty) {
        try {
          final steps = jsonDecode(sop.instructionsJson) as List<dynamic>;
          _stepControllers = steps.map((s) => TextEditingController(text: s.toString())).toList();
        } catch (_) {
          _stepControllers = [TextEditingController()];
        }
      }
    } else {
      _sopTitleCtrl.text = 'Prep SOP for ${widget.menuItem.name}';
      _prepTimeCtrl.text = '10';
      _sopNotesCtrl.text = '';
      _stepControllers = [
        TextEditingController(text: '1. Prepare fresh ingredients.'),
        TextEditingController(text: '2. Cook/Assemble according to standard procedure.'),
      ];
    }
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _tabController.dispose();
    _sopTitleCtrl.dispose();
    _prepTimeCtrl.dispose();
    _sopNotesCtrl.dispose();
    for (final c in _stepControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final db = ref.watch(databaseProvider);

    return Dialog(
      backgroundColor: AppColors.card,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 750,
        height: 650,
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.menuItem.name,
                      style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      'Recipe (BOM), Costing & Cooking SOP',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Variant Switcher
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text('Select Portion / Variant: ', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 8),
                Expanded(
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: _variants.map((v) {
                      final isSel = v == _selectedVariant;
                      return ChoiceChip(
                        label: Text(v.toUpperCase()),
                        selected: isSel,
                        selectedColor: AppColors.primary,
                        labelStyle: TextStyle(color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 12),
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedVariant = v);
                            _loadSop();
                          }
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Recipe & Raw Material Consumption'),
                Tab(text: 'Standard Operating Procedure (SOP)'),
              ],
            ),
            const SizedBox(height: 12),

            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildRecipeTab(context, db),
                  _buildSopTab(context, db),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecipeTab(BuildContext context, AppDatabase db) {
    return StreamBuilder<List<RecipeItem>>(
      stream: db.watchRecipeItems(widget.menuItem.id, _selectedVariant),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return const NbLoadingPulse();

        return FutureBuilder<double>(
          future: db.getMenuItemCostPrice(widget.menuItem.id, _selectedVariant),
          builder: (context, costSnap) {
            final calculatedCost = costSnap.data ?? 0.0;
            // 150% margin => Cost * 2.5
            final rawSuggestedPrice = calculatedCost * 2.5;
            final suggestedPrice = _suggestPriceEnding(rawSuggestedPrice);

            final recipes = snapshot.data!;

            return Column(
              children: [
                // Top Bar with Cost & 150% Margin Suggestion
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 12,
                    runSpacing: 10,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Estimated Cost: ₹${calculatedCost.toStringAsFixed(2)}',
                            style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success, fontSize: 14),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Suggested Price (150% Margin): ₹$suggestedPrice',
                            style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.primary, fontSize: 13),
                          ),
                        ],
                      ),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.copy_rounded, size: 16),
                            label: const Text('Take Reference'),
                            onPressed: () => _showCloneRecipeDialog(context, db),
                          ),
                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
                            icon: const Icon(Icons.add_rounded, size: 16),
                            label: const Text('Add Ingredient'),
                            onPressed: () => _showAddIngredientDialog(context, db),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Ingredients List
                Expanded(
                  child: recipes.isEmpty
                      ? Center(
                          child: Text(
                            'No raw material consumption added yet for $_selectedVariant variant.\nClick "Add Ingredient" or "Take Reference" to copy from another item.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: AppColors.textMuted),
                          ),
                        )
                      : ListView.builder(
                          itemCount: recipes.length,
                          itemBuilder: (context, i) {
                            final recipe = recipes[i];
                            return FutureBuilder<List<RawItem>>(
                              future: db.getAllRawItems(),
                              builder: (context, rawSnap) {
                                final rawItem = (rawSnap.data ?? []).firstWhere(
                                  (r) => r.id == recipe.rawItemId,
                                  orElse: () => RawItem(
                                    id: 0,
                                    name: 'Unknown',
                                    unit: 'pcs',
                                    minStockAlert: 0,
                                    expiryAlertDays: 7,
                                    category: '',
                                    createdAt: DateTime.now(),
                                  ),
                                );

                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  color: AppColors.surface,
                                  child: ListTile(
                                    leading: Icon(Icons.restaurant_rounded, color: AppColors.primary),
                                    title: Text(rawItem.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                    subtitle: Text('Quantity: ${recipe.quantityRequired} ${recipe.unit}'),
                                    trailing: IconButton(
                                      icon: Icon(Icons.delete_rounded, color: AppColors.error, size: 20),
                                      onPressed: () async {
                                        await db.deleteRecipeItem(recipe.id);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSopTab(BuildContext context, AppDatabase db) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: NbInput(
                  labelText: 'SOP Document Title',
                  controller: _sopTitleCtrl,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: NbInput(
                  labelText: 'Preparation Time (Minutes)',
                  controller: _prepTimeCtrl,
                  type: NbInputType.number,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Step-by-Step Instructions', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              IconButton(
                icon: Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                tooltip: 'Add Step',
                onPressed: () {
                  setState(() {
                    _stepControllers.add(TextEditingController(text: '${_stepControllers.length + 1}. '));
                  });
                },
              ),
            ],
          ),
          ..._stepControllers.asMap().entries.map((entry) {
            final idx = entry.key;
            final ctrl = entry.value;
            return Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                children: [
                  Expanded(
                    child: NbInput(
                      labelText: 'Step ${idx + 1}',
                      controller: ctrl,
                    ),
                  ),
                  if (_stepControllers.length > 1)
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.error),
                      onPressed: () {
                        setState(() {
                          _stepControllers.removeAt(idx);
                        });
                      },
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 12),
          NbInput(
            labelText: 'Chef Notes / Special Cooking Remarks',
            controller: _sopNotesCtrl,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(14),
              ),
              icon: const Icon(Icons.save_rounded),
              label: const Text('Save SOP Guidelines', style: TextStyle(fontWeight: FontWeight.bold)),
              onPressed: () async {
                final stepsJson = jsonEncode(_stepControllers.map((c) => c.text.trim()).where((t) => t.isNotEmpty).toList());
                await db.saveItemSop(ItemSopsCompanion.insert(
                  menuItemId: widget.menuItem.id,
                  variantName: Value(_selectedVariant),
                  title: Value(_sopTitleCtrl.text.trim()),
                  prepTimeMins: Value(int.tryParse(_prepTimeCtrl.text) ?? 10),
                  instructionsJson: Value(stepsJson),
                  notes: Value(_sopNotesCtrl.text.trim()),
                ));
                if (context.mounted) {
                  NbToast.show(context, 'SOP updated successfully!', type: NbToastType.success);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddIngredientDialog(BuildContext context, AppDatabase db) async {
    final rawItems = await db.getAllRawItems();
    if (rawItems.isEmpty) {
      if (context.mounted) NbToast.show(context, 'Please add raw materials first in Inventory management!', type: NbToastType.warning);
      return;
    }

    int selectedRawItemId = rawItems.first.id;
    final qtyCtrl = TextEditingController(text: '1.0');

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          final selectedItem = rawItems.firstWhere((r) => r.id == selectedRawItemId, orElse: () => rawItems.first);

          return NbDialog(
            title: 'Add Recipe Ingredient',
            customContent: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<int>(
                  value: selectedRawItemId,
                  decoration: const InputDecoration(labelText: 'Select Raw Material', border: OutlineInputBorder()),
                  items: rawItems
                      .map((r) => DropdownMenuItem(value: r.id, child: Text('${r.name} (${r.unit})')))
                      .toList(),
                  onChanged: (val) => setState(() => selectedRawItemId = val!),
                ),
                const SizedBox(height: 12),
                NbInput(
                  labelText: 'Quantity Consumed per Item (${selectedItem.unit})',
                  controller: qtyCtrl,
                  type: NbInputType.number,
                ),
              ],
            ),
            primaryButtonText: 'Add to Recipe',
            onPrimary: () async {
              final qty = double.tryParse(qtyCtrl.text) ?? 0.0;
              if (qty <= 0) return;
              await db.insertRecipeItem(RecipeItemsCompanion.insert(
                menuItemId: widget.menuItem.id,
                variantName: Value(_selectedVariant),
                rawItemId: selectedRawItemId,
                quantityRequired: qty,
                unit: Value(selectedItem.unit),
              ));
              if (context.mounted) {
                Navigator.pop(ctx);
                setState(() {});
              }
            },
          );
        },
      ),
    );
  }

  void _showCloneRecipeDialog(BuildContext context, AppDatabase db) async {
    final allMenuItems = await db.getAllMenuItems();
    final candidateItems = allMenuItems.where((m) => m.id != widget.menuItem.id).toList();

    if (candidateItems.isEmpty) {
      if (context.mounted) NbToast.show(context, 'No other menu items available to clone from.', type: NbToastType.warning);
      return;
    }

    int sourceItemId = candidateItems.first.id;
    String sourceVariant = 'full';

    if (!context.mounted) return;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return NbDialog(
            title: 'Take Reference (Clone Recipe)',
            customContent: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select an existing menu item to copy all its raw material ingredients into the current recipe.',
                  style: TextStyle(fontSize: 13, color: AppColors.textMuted),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  value: sourceItemId,
                  decoration: const InputDecoration(labelText: 'Source Menu Item', border: OutlineInputBorder()),
                  items: candidateItems
                      .map((m) => DropdownMenuItem(value: m.id, child: Text(m.name)))
                      .toList(),
                  onChanged: (val) => setState(() => sourceItemId = val!),
                ),
              ],
            ),
            primaryButtonText: 'Import & Copy Recipe',
            onPrimary: () async {
              await db.copyRecipeFromExisting(
                sourceMenuItemId: sourceItemId,
                sourceVariant: sourceVariant,
                targetMenuItemId: widget.menuItem.id,
                targetVariant: _selectedVariant,
              );
              if (context.mounted) {
                Navigator.pop(ctx);
                NbToast.show(context, 'Recipe imported successfully!', type: NbToastType.success);
                this.setState(() {});
              }
            },
          );
        },
      ),
    );
  }

  int _suggestPriceEnding(double val) {
    if (val <= 0) return 0;
    int rounded = val.round();
    int tens = (rounded / 10).floor() * 10;
    int rem = rounded % 10;
    
    if (rem <= 2) {
      return tens > 0 ? (tens - 1) : 5; // e.g. 62 -> 59, 12 -> 9
    } else if (rem <= 7) {
      return tens + 5; // e.g. 63.9 -> 65, 77.2 -> 75
    } else {
      return tens + 9; // e.g. 78 -> 79, 68 -> 69
    }
  }
}
