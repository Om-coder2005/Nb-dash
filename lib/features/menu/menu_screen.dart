import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide Column;
import 'package:excel/excel.dart' hide Border;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/providers/favorites_provider.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/features/menu/widgets/recipe_sop_dialog.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
        title: 'Menu Management',
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.download_rounded),
            tooltip: 'Download Sample XLSX',
            onPressed: _downloadSample,
          ),
          IconButton(
            icon: const Icon(Icons.upload_file_rounded),
            tooltip: 'Import XLSX',
            onPressed: _importXlsx,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Categories'),
            Tab(text: 'Items'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _CategoriesTab(),
          const _ItemsTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _tabController.index == 0
            ? _addCategory(context)
            : _addItem(context),
        icon: const Icon(Icons.add),
        label: Text(_tabController.index == 0 ? 'Add Category' : 'Add Item'),
      ),
    );
  }

  Future<void> _downloadSample() async {
    try {
      // Create sample xlsx content
      final excel = Excel.createExcel();
      final sheet = excel['Menu'];

      // Headers
      sheet.cell(CellIndex.indexByString('A1')).value = TextCellValue('Category');
      sheet.cell(CellIndex.indexByString('B1')).value = TextCellValue('Item Name');
      sheet.cell(CellIndex.indexByString('C1')).value = TextCellValue('Price');
      sheet.cell(CellIndex.indexByString('D1')).value = TextCellValue('Description');
      sheet.cell(CellIndex.indexByString('E1')).value = TextCellValue('Is Veg (true/false)');

      // Sample data
      final sampleData = [
        ['Starters', 'Paneer Tikka', '280', 'Grilled cottage cheese', 'true'],
        ['Starters', 'Chicken Kebab', '320', 'Tender chicken kebab', 'false'],
        ['Main Course', 'Butter Chicken', '380', 'Creamy butter chicken', 'false'],
        ['Main Course', 'Dal Makhani', '260', 'Rich lentil curry', 'true'],
        ['Breads', 'Naan', '40', 'Leavened flatbread', 'true'],
        ['Beverages', 'Mango Lassi', '120', 'Sweet mango yogurt drink', 'true'],
        ['Desserts', 'Gulab Jamun', '120', 'Sweet milk dumplings', 'true'],
      ];

      for (int i = 0; i < sampleData.length; i++) {
        final row = sampleData[i];
        sheet.cell(CellIndex.indexByString('A${i + 2}')).value = TextCellValue(row[0]);
        sheet.cell(CellIndex.indexByString('B${i + 2}')).value = TextCellValue(row[1]);
        sheet.cell(CellIndex.indexByString('C${i + 2}')).value = TextCellValue(row[2]);
        sheet.cell(CellIndex.indexByString('D${i + 2}')).value = TextCellValue(row[3]);
        sheet.cell(CellIndex.indexByString('E${i + 2}')).value = TextCellValue(row[4]);
      }

      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/sample_menu.xlsx');
      final bytes = excel.encode()!;
      await file.writeAsBytes(bytes);

      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')],
        subject: 'NextBills Sample Menu Template',
      );
    } catch (e) {
      if (mounted) {
        NbToast.show(context, 'Error: $e', type: NbToastType.error);
      }
    }
  }

  Future<void> _importXlsx() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xlsx', 'xls'],
      );
      if (result == null || result.files.single.path == null) return;

      final file = File(result.files.single.path!);
      final bytes = await file.readAsBytes();
      final excel = Excel.decodeBytes(bytes);

      // Parse data
      final parsedItems = <Map<String, dynamic>>[];
      for (final sheetName in excel.tables.keys) {
        final table = excel.tables[sheetName]!;
        for (int rowIndex = 1; rowIndex < table.maxRows; rowIndex++) {
          final row = table.row(rowIndex);
          if (row.isEmpty || row[0]?.value == null) continue;

          parsedItems.add({
            'category': row[0]?.value?.toString() ?? '',
            'name': row[1]?.value?.toString() ?? '',
            'price': double.tryParse(row[2]?.value?.toString() ?? '0') ?? 0.0,
            'description': row[3]?.value?.toString() ?? '',
            'isVeg': (row[4]?.value?.toString() ?? 'true').toLowerCase() == 'true',
          });
        }
      }

      if (parsedItems.isEmpty) {
        if (mounted) {
          NbToast.show(context, 'No valid data found in file', type: NbToastType.error);
        }
        return;
      }

      // Preview dialog
      if (mounted) {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (ctx) => _ImportPreviewDialog(items: parsedItems),
        );

        if (confirmed == true) {
          await _processImport(parsedItems);
        }
      }
    } catch (e) {
      if (mounted) {
        NbToast.show(context, 'Import failed: $e', type: NbToastType.error);
      }
    }
  }

  Future<void> _processImport(List<Map<String, dynamic>> items) async {
    final db = ref.read(databaseProvider);
    final existingCats = await db.getAllCategories();
    final catMap = {for (final c in existingCats) c.name.toLowerCase(): c.id};

    for (final item in items) {
      final catName = item['category'] as String;
      final catKey = catName.toLowerCase();

      int catId;
      if (catMap.containsKey(catKey)) {
        catId = catMap[catKey]!;
      } else {
        catId = await db.insertCategory(MenuCategoriesCompanion.insert(
          name: catName,
          colorValue: const Value(0xFFF59E0B),
        ));
        catMap[catKey] = catId;
      }

      await db.insertMenuItem(MenuItemsCompanion.insert(
        categoryId: catId,
        name: item['name'] as String,
        price: Value(item['price'] as double),
        description: Value(item['description'] as String),
        isVeg: Value(item['isVeg'] as bool),
      ));
    }

    if (mounted) {
      NbToast.show(context, 'Imported ${items.length} items successfully!', type: NbToastType.success);
    }
  }

  void _addCategory(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _CategoryDialog(
        onSave: (name, color) async {
          final db = ref.read(databaseProvider);
          await db.insertCategory(MenuCategoriesCompanion.insert(
            name: name,
            colorValue: Value(color.toARGB32()),
          ));
        },
      ),
    );
  }

  void _addItem(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => _ItemDialog(
        onSave: (categoryId, name, price, description, isVeg, hasHalfFull, halfPrice, defaultSize, image, customVariantsJson) async {
          final db = ref.read(databaseProvider);
          await db.insertMenuItem(MenuItemsCompanion.insert(
            categoryId: categoryId,
            name: name,
            price: Value(price),
            description: Value(description),
            isVeg: Value(isVeg),
            hasHalfFull: Value(hasHalfFull),
            halfPrice: Value(halfPrice),
            defaultSize: Value(defaultSize),
            image: Value(image),
            customVariantsJson: Value(customVariantsJson),
          ));
        },
      ),
    );
  }
}

// ─── CATEGORIES TAB ──────────────────────────────────

class _CategoriesTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    return StreamBuilder<List<MenuCategory>>(
      stream: db.watchAllCategories(),
      builder: (context, snap) {
        if (!snap.hasData) return const Center(child: NbLoadingPulse());
        final cats = snap.data!;
        if (cats.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.category_rounded, size: 60, color: AppColors.textMuted),
                const SizedBox(height: 12),
                Text('No categories yet', style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          );
        }
        return ReorderableListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: cats.length,
          onReorder: (oldIndex, newIndex) async {
            if (newIndex > oldIndex) newIndex--;
            final updated = List<MenuCategory>.from(cats);
            final item = updated.removeAt(oldIndex);
            updated.insert(newIndex, item);
            for (int i = 0; i < updated.length; i++) {
              await ref.read(databaseProvider).updateCategory(updated[i].copyWith(sortOrder: i));
            }
          },
          itemBuilder: (context, i) {
            final cat = cats[i];
            return Container(
              key: ValueKey(cat.id),
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
                    color: Color(cat.colorValue).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.category_rounded,
                      color: Color(cat.colorValue), size: 20),
                ),
                title: Text(cat.name,
                    style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit_rounded, size: 18, color: AppColors.textSecondary),
                      onPressed: () => _editCategory(context, ref, cat),
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete_rounded, size: 18, color: AppColors.error),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => NbDialog(
                            title: 'Delete Category?',
                            customContent: Text(
                              'Delete "${cat.name}"? All items in this category will also be deleted.',
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
                          try {
                            await ref.read(databaseProvider).deleteCategory(cat.id);
                          } catch (e) {
                            if (context.mounted) {
                              NbToast.show(context, 'Could not delete category: $e', type: NbToastType.error);
                            }
                          }
                        }
                      },
                    ),
                    Icon(Icons.drag_handle_rounded, color: AppColors.textMuted),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _editCategory(BuildContext context, WidgetRef ref, MenuCategory cat) {
    showDialog(
      context: context,
      builder: (ctx) => _CategoryDialog(
        initialName: cat.name,
        initialColor: Color(cat.colorValue),
        onSave: (name, color) async {
          final updated = cat.copyWith(
            name: name,
            colorValue: color.toARGB32(),
          );
          await ref.read(databaseProvider).updateCategory(updated);
        },
      ),
    );
  }
}

// ─── ITEMS TAB ───────────────────────────────────────

class _ItemsTab extends ConsumerStatefulWidget {
  const _ItemsTab();

  @override
  ConsumerState<_ItemsTab> createState() => _ItemsTabState();
}

class _ItemsTabState extends ConsumerState<_ItemsTab> {
  String _searchQuery = '';
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: const InputDecoration(
              labelText: 'Search Items',
              prefixIcon: Icon(Icons.search_rounded),
            ),
          ),
        ),
        Expanded(
          child: StreamBuilder<List<MenuItem>>(
            stream: db.watchAllMenuItems(),
            builder: (context, snap) {
              if (!snap.hasData) return const Center(child: NbLoadingPulse());
              var items = snap.data!;
              if (_searchQuery.isNotEmpty) {
                items = items.where((i) =>
                    i.name.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
              }
              if (items.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant_menu_rounded, size: 60, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      Text('No menu items', style: Theme.of(context).textTheme.bodyMedium),
                      const SizedBox(height: 8),
                      Text('Tap + to add or import XLSX',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                );
              }

        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              decoration: BoxDecoration(
                color: AppColors.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (item.image != null && item.image!.isNotEmpty) {
                          final action = await showDialog<String>(
                            context: context,
                            builder: (ctx) => NbDialog(
                              title: 'Item Image',
                              customContent: Text(
                                'Would you like to change or remove the image for ${item.name}?',
                                style: GoogleFonts.inter(color: AppColors.textPrimary),
                              ),
                              primaryButtonText: 'Change',
                              onPrimary: () => Navigator.pop(ctx, 'change'),
                              secondaryButtonText: 'Remove',
                              onSecondary: () => Navigator.pop(ctx, 'remove'),
                            ),
                          );

                          if (action == 'change') {
                            if (context.mounted) await _pickAndSaveItemImage(db, item);
                          } else if (action == 'remove') {
                            final updated = item.copyWith(image: const Value(null));
                            await db.updateMenuItem(updated);
                            if (context.mounted) {
                              NbToast.show(context, 'Image removed successfully', type: NbToastType.success);
                            }
                          }
                        } else {
                          await _pickAndSaveItemImage(db, item);
                        }
                      },
                      child: Tooltip(
                        message: 'Click to add/change image',
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: item.isVeg
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.error.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                            image: item.image != null && item.image!.isNotEmpty
                                ? DecorationImage(
                                    image: MemoryImage(base64Decode(item.image!)),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: item.image == null || item.image!.isEmpty
                              ? Center(
                                  child: Text(
                                    item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
                                    style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: item.isVeg ? AppColors.success : AppColors.error,
                                    ),
                                  ),
                                )
                              : null,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: AppColors.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            Fmt.currencyShort(item.price),
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          icon: Icon(
                            ref.watch(favoritesProvider).contains(item.id)
                                ? Icons.favorite
                                : Icons.favorite_border,
                            color: ref.watch(favoritesProvider).contains(item.id)
                                ? Colors.red
                                : AppColors.textMuted,
                            size: 18,
                          ),
                          onPressed: () {
                            ref.read(favoritesProvider.notifier).toggle(item.id);
                          },
                        ),
                        Transform.scale(
                          scale: 0.8,
                          child: Switch(
                            value: item.isAvailable,
                            onChanged: (v) async {
                              final updated = item.copyWith(isAvailable: v);
                              await ref.read(databaseProvider).updateMenuItem(updated);
                            },
                          ),
                        ),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          icon: Icon(Icons.receipt_long_rounded, size: 18, color: AppColors.primary),
                          tooltip: 'Recipe & Cooking SOP',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => RecipeAndSopDialog(menuItem: item),
                            );
                          },
                        ),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          icon: Icon(Icons.edit_outlined, size: 18, color: AppColors.textMuted),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (ctx) => _ItemDialog(
                                initialItem: item,
                                onSave: (catId, name, price, desc, isVeg, hasHalfFull, halfPrice, defaultSize, image, customVariantsJson) async {
                                  final updated = item.copyWith(
                                    categoryId: catId,
                                    name: name,
                                    price: price,
                                    description: desc,
                                    isVeg: isVeg,
                                    hasHalfFull: hasHalfFull,
                                    halfPrice: halfPrice,
                                    defaultSize: defaultSize,
                                    image: Value(image),
                                    customVariantsJson: customVariantsJson,
                                  );
                                  await ref.read(databaseProvider).updateMenuItem(updated);
                                },
                              ),
                            );
                          },
                        ),
                        IconButton(
                          constraints: const BoxConstraints(),
                          padding: const EdgeInsets.all(6),
                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                          onPressed: () async {
                            await ref.read(databaseProvider).deleteMenuItem(item.id);
                          },
                        ),
                      ],
                    ),
                  ],
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
  }

  Future<void> _pickAndSaveItemImage(AppDatabase db, MenuItem item) async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        final bytes = file.bytes ?? await File(file.path!).readAsBytes();
        final base64Str = base64Encode(bytes);
        final updated = item.copyWith(image: Value(base64Str));
        await db.updateMenuItem(updated);
        if (mounted) {
          NbToast.show(context, 'Image updated successfully!', type: NbToastType.success);
        }
      }
    } catch (e) {
      if (mounted) {
        NbToast.show(context, 'Failed to update image: $e', type: NbToastType.error);
      }
    }
  }
}

// ─── DIALOGS ─────────────────────────────────────────

class _CategoryDialog extends ConsumerStatefulWidget {
  final String? initialName;
  final Color? initialColor;
  final Future<void> Function(String name, Color color) onSave;

  const _CategoryDialog({
    this.initialName,
    this.initialColor,
    required this.onSave,
  });

  @override
  ConsumerState<_CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends ConsumerState<_CategoryDialog> {
  late TextEditingController _nameController;
  late Color _selectedColor;

  final colors = [
    const Color(0xFFEF4444),
    const Color(0xFFF59E0B),
    const Color(0xFFF97316),
    const Color(0xFF10B981),
    const Color(0xFF3B82F6),
    const Color(0xFF8B5CF6),
    const Color(0xFFEC4899),
    const Color(0xFF06B6D4),
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
      title: widget.initialName != null ? 'Edit Category' : 'Add Category',
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          NbInput(
            controller: _nameController,
            hintText: 'Category Name',
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
                    boxShadow: isSelected
                        ? [BoxShadow(color: c.withValues(alpha: 0.6), blurRadius: 8)]
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
        if (_nameController.text.trim().isEmpty) {
          NbToast.show(context, 'Category name cannot be empty!', type: NbToastType.error);
          return;
        }
        await widget.onSave(_nameController.text.trim(), _selectedColor);
        if (context.mounted) Navigator.pop(context);
      },
      secondaryButtonText: 'Cancel',
      onSecondary: () => Navigator.pop(context),
    );
  }
}

class _ItemDialog extends ConsumerStatefulWidget {
  final MenuItem? initialItem;
  final Future<void> Function(
      int categoryId,
      String name,
      double price,
      String description,
      bool isVeg,
      bool hasHalfFull,
      double halfPrice,
      String defaultSize,
      String? image,
      String customVariantsJson) onSave;

  const _ItemDialog({this.initialItem, required this.onSave});

  @override
  ConsumerState<_ItemDialog> createState() => _ItemDialogState();
}

class _ItemDialogState extends ConsumerState<_ItemDialog> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _descController;
  late TextEditingController _halfPriceController;
  int? _categoryId;
  bool _isVeg = true;
  bool _hasHalfFull = false;
  String _defaultSize = 'full';
  String? _imageBase64;
  bool _hasCustomVariants = false;
  final List<Map<String, TextEditingController>> _customVariantControllers = [];
  final ScrollController _variantScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialItem?.name ?? '');
    _priceController = TextEditingController(text: widget.initialItem?.price.toString() ?? '');
    _descController = TextEditingController(text: widget.initialItem?.description ?? '');
    _halfPriceController = TextEditingController(text: widget.initialItem?.halfPrice.toString() ?? '');
    _categoryId = widget.initialItem?.categoryId;
    _isVeg = widget.initialItem?.isVeg ?? true;
    _hasHalfFull = widget.initialItem?.hasHalfFull ?? false;
    _defaultSize = widget.initialItem?.defaultSize ?? 'full';
    _imageBase64 = widget.initialItem?.image;

    // Load existing custom variants if available
    if (widget.initialItem?.customVariantsJson != null && widget.initialItem!.customVariantsJson.isNotEmpty) {
      try {
        final List parsed = jsonDecode(widget.initialItem!.customVariantsJson);
        if (parsed.isNotEmpty) {
          _hasCustomVariants = true;
          for (final item in parsed) {
            _customVariantControllers.add({
              'name': TextEditingController(text: item['name']?.toString() ?? ''),
              'price': TextEditingController(text: item['price']?.toString() ?? ''),
            });
          }
        }
      } catch (_) {}
    }

    if (_customVariantControllers.isEmpty) {
      _addCustomVariantField();
    }
  }

  void _addCustomVariantField() {
    setState(() {
      _customVariantControllers.add({
        'name': TextEditingController(),
        'price': TextEditingController(),
      });
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_variantScrollController.hasClients) {
        _variantScrollController.animateTo(
          _variantScrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _removeCustomVariantField(int index) {
    if (_customVariantControllers.length > 1) {
      setState(() {
        final removed = _customVariantControllers.removeAt(index);
        removed['name']?.dispose();
        removed['price']?.dispose();
      });
    }
  }

  @override
  void dispose() {
    _variantScrollController.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _descController.dispose();
    _halfPriceController.dispose();
    for (final controllers in _customVariantControllers) {
      controllers['name']?.dispose();
      controllers['price']?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return NbDialog(
      title: widget.initialItem != null ? 'Edit Menu Item' : 'Add Menu Item',
      customContent: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                    image: _imageBase64 != null && _imageBase64!.isNotEmpty
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(_imageBase64!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: _imageBase64 == null || _imageBase64!.isEmpty
                      ? Icon(Icons.image_rounded, color: AppColors.textMuted, size: 20)
                      : null,
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  onPressed: () async {
                    try {
                      final result = await FilePicker.platform.pickFiles(
                        type: FileType.image,
                        allowMultiple: false,
                      );
                      if (result != null && result.files.isNotEmpty) {
                        final file = result.files.first;
                        final bytes = file.bytes ?? await File(file.path!).readAsBytes();
                        setState(() {
                          _imageBase64 = base64Encode(bytes);
                        });
                      }
                    } catch (e) {
                      if (context.mounted) {
                        NbToast.show(context, 'Failed to pick image: $e', type: NbToastType.error);
                      }
                    }
                  },
                  icon: const Icon(Icons.photo_library_rounded, size: 14),
                  label: Text('Upload Image', style: GoogleFonts.inter(fontSize: 12)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.surface,
                    foregroundColor: AppColors.textPrimary,
                    elevation: 0,
                    side: BorderSide(color: AppColors.border),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                ),
                if (_imageBase64 != null && _imageBase64!.isNotEmpty) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                    onPressed: () => setState(() => _imageBase64 = null),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<List<MenuCategory>>(
              future: db.getAllCategories(),
              builder: (context, snap) {
                if (!snap.hasData) return const NbLoadingPulse();
                final cats = snap.data!;
                if (cats.isEmpty) return Text('Please add a Category first', style: GoogleFonts.inter(color: AppColors.textPrimary));
                
                if (_categoryId == null && cats.isNotEmpty) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (mounted) setState(() => _categoryId = cats.first.id);
                  });
                }
                
                final effectiveCatId = cats.any((c) => c.id == _categoryId)
                    ? _categoryId
                    : (cats.isNotEmpty ? cats.first.id : null);

                return DropdownButtonFormField<int>(
                  initialValue: effectiveCatId,
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: TextStyle(color: AppColors.textSecondary),
                    enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                    focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                  ),
                  style: GoogleFonts.inter(color: AppColors.textPrimary),
                  items: cats
                      .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                      .toList(),
                  onChanged: (v) => setState(() => _categoryId = v),
                  dropdownColor: AppColors.card,
                );
              },
            ),
            const SizedBox(height: 12),
            NbInput(
              controller: _nameController,
              hintText: 'Item Name',
            ),
            const SizedBox(height: 12),
            CheckboxListTile(
              title: Text('Half/Full Pricing Scheme', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14)),
              value: _hasHalfFull,
              onChanged: (val) {
                setState(() {
                  _hasHalfFull = val ?? false;
                  if (_hasHalfFull) _hasCustomVariants = false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primary,
            ),
            CheckboxListTile(
              title: Text('Custom Category/Option Pricing Scheme (e.g. 8", 12", 60ml)', style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14)),
              value: _hasCustomVariants,
              onChanged: (val) {
                setState(() {
                  _hasCustomVariants = val ?? false;
                  if (_hasCustomVariants) _hasHalfFull = false;
                });
              },
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              activeColor: AppColors.primary,
            ),
            if (!_hasHalfFull && !_hasCustomVariants) ...[
              NbInput(
                controller: _priceController,
                type: NbInputType.number,
                hintText: 'Price (Rs)',
                prefixIcon: Icons.currency_rupee_rounded,
              ),
            ] else if (_hasHalfFull) ...[
              Row(
                children: [
                  Expanded(
                    child: NbInput(
                      controller: _halfPriceController,
                      type: NbInputType.number,
                      hintText: 'Half Price (Rs)',
                      prefixIcon: Icons.currency_rupee_rounded,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: NbInput(
                      controller: _priceController,
                      type: NbInputType.number,
                      hintText: 'Full Price (Rs)',
                      prefixIcon: Icons.currency_rupee_rounded,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: _defaultSize,
                decoration: InputDecoration(
                  labelText: 'Default Portion Size',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.border)),
                  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: AppColors.primary)),
                ),
                style: GoogleFonts.inter(color: AppColors.textPrimary),
                items: const [
                  DropdownMenuItem(value: 'half', child: Text('Half')),
                  DropdownMenuItem(value: 'full', child: Text('Full')),
                ],
                onChanged: (v) => setState(() => _defaultSize = v ?? 'full'),
                dropdownColor: AppColors.card,
              ),
            ] else if (_hasCustomVariants) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Custom Pricing Options & Variants', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.textPrimary, fontSize: 13)),
                    const SizedBox(height: 8),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 140),
                      child: SingleChildScrollView(
                        controller: _variantScrollController,
                        child: Column(
                          children: [
                            ..._customVariantControllers.asMap().entries.map((entry) {
                              final idx = entry.key;
                              final map = entry.value;
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: NbInput(
                                        controller: map['name'],
                                        hintText: 'Option (e.g. 12 inch)',
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      flex: 1,
                                      child: NbInput(
                                        controller: map['price'],
                                        type: NbInputType.number,
                                        hintText: 'Price (Rs)',
                                        prefixIcon: Icons.currency_rupee_rounded,
                                      ),
                                    ),
                                    if (_customVariantControllers.length > 1) ...[
                                      const SizedBox(width: 4),
                                      IconButton(
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                                        icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.error, size: 20),
                                        onPressed: () => _removeCustomVariantField(idx),
                                      ),
                                    ],
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        icon: const Icon(Icons.add_rounded, size: 16),
                        label: const Text('Add Option'),
                        onPressed: _addCustomVariantField,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            NbInput(
              controller: _descController,
              hintText: 'Description (optional)',
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Text('Type: ', style: GoogleFonts.inter(color: AppColors.textPrimary)),
                TextButton.icon(
                  onPressed: () => setState(() => _isVeg = true),
                  icon: Icon(Icons.eco_rounded,
                      color: _isVeg ? AppColors.success : AppColors.textMuted),
                  label: Text('Veg', style: TextStyle(
                      color: _isVeg ? AppColors.success : AppColors.textMuted)),
                ),
                TextButton.icon(
                  onPressed: () => setState(() => _isVeg = false),
                  icon: Icon(Icons.restaurant_rounded,
                      color: !_isVeg ? AppColors.error : AppColors.textMuted),
                  label: Text('Non-Veg', style: TextStyle(
                      color: !_isVeg ? AppColors.error : AppColors.textMuted)),
                ),
              ],
            ),
          ],
        ),
      ),
      primaryButtonText: 'Save',
      onPrimary: () async {
        if (_nameController.text.trim().isEmpty) {
          NbToast.show(context, 'Item name cannot be empty!', type: NbToastType.error);
          return;
        }
        if (_categoryId == null) {
          NbToast.show(context, 'Please select a valid category.', type: NbToastType.error);
          return;
        }

        // Process Custom Variants JSON
        String customVariantsJson = '[]';
        double basePrice = double.tryParse(_priceController.text) ?? 0;

        if (_hasCustomVariants) {
          final List<Map<String, dynamic>> variantsList = [];
          for (final ctrlMap in _customVariantControllers) {
            final name = ctrlMap['name']?.text.trim() ?? '';
            final pr = double.tryParse(ctrlMap['price']?.text.trim() ?? '') ?? 0.0;
            if (name.isNotEmpty) {
              variantsList.add({'name': name, 'price': pr});
            }
          }
          if (variantsList.isNotEmpty) {
            customVariantsJson = jsonEncode(variantsList);
            basePrice = variantsList.first['price'] as double;
          }
        }

        final price = basePrice;
        final halfPrice = _hasHalfFull ? (double.tryParse(_halfPriceController.text) ?? 0) : 0.0;
        await widget.onSave(
          _categoryId!,
          _nameController.text.trim(),
          price,
          _descController.text.trim(),
          _isVeg,
          _hasHalfFull,
          halfPrice,
          _defaultSize,
          _imageBase64,
          customVariantsJson,
        );
        if (context.mounted) Navigator.pop(context);
      },
      secondaryButtonText: 'Cancel',
      onSecondary: () => Navigator.pop(context),
    );
  }
}

// ─── IMPORT PREVIEW DIALOG ───────────────────────────

class _ImportPreviewDialog extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  const _ImportPreviewDialog({required this.items});

  @override
  Widget build(BuildContext context) {
    return NbDialog(
      title: 'Import ${items.length} Items?',
      customContent: SizedBox(
        width: 300,
        height: 300,
        child: ListView.builder(
          itemCount: items.take(10).length,
          itemBuilder: (context, i) {
            final item = items[i];
            return ListTile(
              dense: true,
              title: Text(item['name'] as String,
                  style: GoogleFonts.inter(fontSize: 13, color: AppColors.textPrimary)),
              subtitle: Text('${item['category']} — Rs ${item['price']}',
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
              leading: Icon(
                (item['isVeg'] as bool) ? Icons.eco_rounded : Icons.restaurant_rounded,
                color: (item['isVeg'] as bool) ? AppColors.success : AppColors.error,
                size: 16,
              ),
            );
          },
        ),
      ),
      primaryButtonText: 'Import All',
      onPrimary: () => Navigator.pop(context, true),
      secondaryButtonText: 'Cancel',
      onSecondary: () => Navigator.pop(context, false),
    );
  }
}
