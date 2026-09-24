import 'dart:convert';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/providers/favorites_provider.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/features/printer/printer_service.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_empty_state.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ─── PROVIDERS ───────────────────────────────────────

final orderItemsProvider = StreamProvider.family<List<OrderItem>, int>((ref, orderId) {
  return ref.watch(databaseProvider).watchOrderItems(orderId);
});

final selectedCategoryProvider = StateProvider.autoDispose<int?>((ref) => null);
final menuSearchProvider = StateProvider.autoDispose<String>((ref) => '');

final categoriesStreamProvider = StreamProvider<List<MenuCategory>>((ref) {
  return ref.watch(databaseProvider).watchAllCategories();
});

// ─── SCREEN ──────────────────────────────────────────

class OrderScreen extends ConsumerStatefulWidget {
  final int tableId;
  final int orderId;

  const OrderScreen({super.key, required this.tableId, required this.orderId});

  @override
  ConsumerState<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen>
    with SingleTickerProviderStateMixin {
  RestaurantTable? _table;
  Order? _order;
  late TabController _mobileTabController;

  @override
  void initState() {
    super.initState();
    _mobileTabController = TabController(length: 2, vsync: this);
    _loadTableAndOrder();
  }

  @override
  void dispose() {
    _mobileTabController.dispose();
    super.dispose();
  }

  Future<void> _loadTableAndOrder() async {
    final db = ref.read(databaseProvider);
    final tables = await db.getAllTables();
    final orders = await db.watchOpenOrders().first;

    if (mounted) {
      setState(() {
        _table = tables.firstWhere((t) => t.id == widget.tableId, orElse: () => tables.first);
        try {
          _order = orders.firstWhere((o) => o.id == widget.orderId);
        } catch (_) {}
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 700;
    final itemsAsync = ref.watch(orderItemsProvider(widget.orderId));
    final items = itemsAsync.valueOrNull ?? [];
    final total = items.fold<double>(0, (sum, i) => sum + (i.itemPrice * i.quantity));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: NbAppBar(
        title: _table != null
            ? '${_table!.tableNumber} — ${_table!.tableLabel}'
            : 'Order',
        showBack: true,
        bottom: !isTablet
            ? TabBar(
                controller: _mobileTabController,
                indicatorColor: AppColors.primary,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textMuted,
                tabs: [
                  const Tab(text: 'Menu Items'),
                  Tab(text: 'Current Order (${items.length})'),
                ],
              )
            : null,
        actions: [
          _KotButton(
            orderId: widget.orderId,
            tableNumber: _table?.tableNumber ?? 'T?',
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.more_vert, color: AppColors.textPrimary),
            color: AppColors.card,
            onSelected: (value) async {
              if (value == 'free') {
                final db = ref.read(databaseProvider);
                if (_order != null) {
                  final newStatus = _order!.status == 'billed' ? 'completed' : 'cancelled';
                  final updated = _order!.copyWith(status: newStatus, updatedAt: DateTime.now());
                  await db.updateOrder(updated);
                }
                if (mounted) context.pop();
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'free',
                child: Row(
                  children: [
                    Icon(Icons.cancel_outlined, color: AppColors.error, size: 20),
                    SizedBox(width: 8),
                    Text('Free Table', style: TextStyle(color: AppColors.error)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: isTablet
          ? Row(
              children: [
                // Left: Menu
                Expanded(
                  flex: 3,
                  child: _MenuPanel(orderId: widget.orderId),
                ),
                Container(width: 1, color: AppColors.border),
                // Right: Cart
                Expanded(
                  flex: 2,
                  child: _CartPanel(
                    orderId: widget.orderId,
                    tableId: widget.tableId,
                    table: _table,
                  ),
                ),
              ],
            )
          : Stack(
              children: [
                TabBarView(
                  controller: _mobileTabController,
                  children: [
                    // Tab 1: Menu Panel
                    Padding(
                      padding: EdgeInsets.only(bottom: items.isNotEmpty ? 70.0 : 0.0),
                      child: _MenuPanel(orderId: widget.orderId),
                    ),
                    // Tab 2: Cart Panel
                    _CartPanel(
                      orderId: widget.orderId,
                      tableId: widget.tableId,
                      table: _table,
                    ),
                  ],
                ),
                // Floating Bottom Summary Bar on Mobile Menu Tab
                if (items.isNotEmpty)
                  AnimatedBuilder(
                    animation: _mobileTabController,
                    builder: (context, child) {
                      if (_mobileTabController.index != 0) return const SizedBox.shrink();
                      return Positioned(
                        bottom: 12 + MediaQuery.of(context).viewInsets.bottom,
                        left: 16,
                        right: 16,
                        child: GestureDetector(
                          onTap: () => _mobileTabController.animateTo(1),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.4),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.shopping_bag_rounded, color: Colors.white, size: 20),
                                    const SizedBox(width: 10),
                                    Text(
                                      '${items.length} Items • ${Fmt.currency(total)}',
                                      style: GoogleFonts.manrope(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 15,
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      'View Order',
                                      style: GoogleFonts.manrope(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w700,
                                        fontSize: 13,
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 16),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
    );
  }
}

// ─── MENU PANEL ──────────────────────────────────────

class _MenuPanel extends ConsumerStatefulWidget {
  final int orderId;
  const _MenuPanel({required this.orderId});

  @override
  ConsumerState<_MenuPanel> createState() => _MenuPanelState();
}

class _MenuPanelState extends ConsumerState<_MenuPanel> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<String>(menuSearchProvider, (previous, next) {
      if (next.isEmpty && _searchController.text.isNotEmpty) {
        _searchController.clear();
      }
    });

    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final selectedCat = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(menuSearchProvider);
    final isSearching = searchQuery.isNotEmpty;

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text(e.toString())),
      data: (categories) {
        final activeCat = selectedCat ?? -1;

        return LayoutBuilder(
          builder: (context, constraints) {
            final fullWidth = constraints.maxWidth;
            final isMobileWidth = fullWidth < 600;

            if (isMobileWidth) {
              return Column(
                children: [
                  // Top Bar Search Bar
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                    child: Row(
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: NbInput(
                              controller: _searchController,
                              type: NbInputType.search,
                              hintText: 'Search menu items...',
                              onChanged: (v) => ref.read(menuSearchProvider.notifier).state = v,
                            ),
                          ),
                        ),
                        if (isSearching) ...[
                          const SizedBox(width: 8),
                          IconButton(
                            icon: const Icon(Icons.close_rounded),
                            color: AppColors.textMuted,
                            onPressed: () {
                              _searchController.clear();
                              ref.read(menuSearchProvider.notifier).state = '';
                              FocusScope.of(context).unfocus();
                            },
                          ),
                        ],
                      ],
                    ),
                  ),
                  Expanded(
                    child: isSearching
                        ? Padding(
                            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                            child: _MenuItemsList(
                              categoryId: activeCat,
                              orderId: widget.orderId,
                              searchQuery: searchQuery,
                            ),
                          )
                        : _buildLeftNormalPanel(categories, activeCat, searchQuery),
                  ),
                ],
              );
            }

            final leftWidth = isSearching ? 320.0 : fullWidth;

            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  curve: Curves.fastOutSlowIn,
                  width: leftWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Bar: Menu Button + Search Bar
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                        child: Row(
                          children: [
                            Container(
                              width: 48,
                              height: 48,
                              decoration: BoxDecoration(
                                color: AppColors.primary,
                                borderRadius: AppRadius.mdBorder,
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.menu_rounded, color: Colors.white),
                                onPressed: () {},
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: SizedBox(
                                height: 48,
                                child: NbInput(
                                  controller: _searchController,
                                  type: NbInputType.search,
                                  hintText: 'Search...',
                                  onChanged: (v) => ref.read(menuSearchProvider.notifier).state = v,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Expanded(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 250),
                          child: isSearching
                              ? _buildLeftSearchingPanel(context, ref)
                              : _buildLeftNormalPanel(categories, activeCat, searchQuery),
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSearching)
                  Expanded(
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 250),
                      opacity: isSearching ? 1.0 : 0.0,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 20, 20, 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Search Results',
                                  style: GoogleFonts.manrope(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _searchController.clear();
                                    ref.read(menuSearchProvider.notifier).state = '';
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: _MenuItemsList(
                                categoryId: activeCat,
                                orderId: widget.orderId,
                                searchQuery: searchQuery,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildLeftNormalPanel(List<MenuCategory> categories, int activeCat, String searchQuery) {
    return _UnifiedMenuScrollView(
      categories: categories,
      activeCat: activeCat,
      orderId: widget.orderId,
      searchQuery: searchQuery,
    );
  }
}

class _UnifiedMenuScrollView extends ConsumerStatefulWidget {
  final List<MenuCategory> categories;
  final int activeCat;
  final int orderId;
  final String searchQuery;

  const _UnifiedMenuScrollView({
    required this.categories,
    required this.activeCat,
    required this.orderId,
    required this.searchQuery,
  });

  @override
  ConsumerState<_UnifiedMenuScrollView> createState() => _UnifiedMenuScrollViewState();
}

class _UnifiedMenuScrollViewState extends ConsumerState<_UnifiedMenuScrollView> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final favs = ref.watch(favoritesProvider);

    return Listener(
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          if (_scrollController.hasClients) {
            final newOffset = _scrollController.offset + pointerSignal.scrollDelta.dy;
            _scrollController.jumpTo(
              newOffset.clamp(
                _scrollController.position.minScrollExtent,
                _scrollController.position.maxScrollExtent,
              ),
            );
          }
        }
      },
      child: FutureBuilder<List<MenuItem>>(
        future: db.getAllMenuItems(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          var items = snap.data!.where((i) => i.isAvailable).toList();

          if (widget.activeCat == -1) {
            items = items.where((i) => favs.contains(i.id)).toList();
          } else {
            items = items.where((i) => i.categoryId == widget.activeCat).toList();
          }

          if (widget.searchQuery.isNotEmpty) {
            items = snap.data!.where((i) =>
              i.isAvailable && i.name.toLowerCase().contains(widget.searchQuery.trim().toLowerCase())
            ).toList();
          }

          final screenWidth = MediaQuery.of(context).size.width;
          final isMobile = screenWidth < 600;

          return CustomScrollView(
            controller: _scrollController,
            slivers: [
              // Category Row Header (Scrolls up together with menu items)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: SizedBox(
                    height: 110,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: widget.categories.length + 1,
                      clipBehavior: Clip.none,
                      itemBuilder: (context, i) {
                        final isFavTab = i == 0;
                        final catId = isFavTab ? -1 : widget.categories[i - 1].id;
                        final catName = isFavTab ? 'Favs' : widget.categories[i - 1].name;
                        final isSelected = catId == widget.activeCat;

                        Widget leadingIcon;
                        if (isFavTab) {
                          leadingIcon = Icon(
                            Icons.favorite_rounded,
                            color: isSelected ? Colors.white : Colors.red,
                            size: 22,
                          );
                        } else {
                          final name = catName.toLowerCase();
                          IconData iconData;
                          if (name.contains('start') || name.contains('appet')) {
                            iconData = Icons.local_pizza_outlined;
                          } else if (name.contains('main') || name.contains('cours')) {
                            iconData = Icons.restaurant_outlined;
                          } else if (name.contains('bread') || name.contains('roti')) {
                            iconData = Icons.bakery_dining_outlined;
                          } else if (name.contains('rice') || name.contains('biry')) {
                            iconData = Icons.rice_bowl_outlined;
                          } else if (name.contains('bev') || name.contains('drink')) {
                            iconData = Icons.local_bar_outlined;
                          } else if (name.contains('dess') || name.contains('sweet')) {
                            iconData = Icons.cake_outlined;
                          } else {
                            iconData = Icons.fastfood_outlined;
                          }
                          leadingIcon = Icon(
                            iconData,
                            color: isSelected ? Colors.white : Color(widget.categories[i - 1].colorValue),
                            size: 22,
                          );
                        }

                        return GestureDetector(
                          onTap: () => ref.read(selectedCategoryProvider.notifier).state = catId,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 16, bottom: 10),
                            width: 80,
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primary : AppColors.surface,
                              borderRadius: BorderRadius.circular(24),
                              boxShadow: isSelected
                                  ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))]
                                  : AppShadows.neumorphic(Theme.of(context).brightness == Brightness.dark),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 48,
                                  height: 48,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: isSelected ? Colors.white.withValues(alpha: 0.2) : AppColors.bg,
                                  ),
                                  child: Center(
                                    child: leadingIcon,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  catName,
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                                    color: isSelected ? Colors.white : AppColors.textPrimary,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(24, 8, 24, 12),
                  child: Text(
                    'Popular Dish',
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),

              // Menu Items Grid
              if (items.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: widget.searchQuery.isNotEmpty
                        ? NbEmptyState(
                            icon: Icons.search_off_rounded,
                            title: 'No results',
                            message: 'No items match "${widget.searchQuery}"',
                          )
                        : (widget.activeCat == -1
                            ? const NbEmptyState(
                                icon: Icons.favorite_border_rounded,
                                title: 'No favorites yet',
                                message: 'Tap the heart icon on any item to add it here!',
                              )
                            : const NbEmptyState(
                                icon: Icons.restaurant_menu_rounded,
                                title: 'Empty category',
                                message: 'No items in this category',
                              )),
                  ),
                )
              else
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: isMobile ? 10 : 16, vertical: 8),
                  sliver: SliverGrid(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 180,
                      mainAxisSpacing: isMobile ? 24 : 32,
                      crossAxisSpacing: isMobile ? 12 : 16,
                      childAspectRatio: isMobile ? 0.78 : 0.75,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, i) => _MenuItemCard(item: items[i], orderId: widget.orderId),
                      childCount: items.length,
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

  Widget _buildLeftSearchingPanel(BuildContext context, WidgetRef ref) {
    return Padding(
      key: const ValueKey('searching'),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Searching Menu',
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Type to filter items. Touch results on the right to add them.',
            style: GoogleFonts.manrope(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                ref.read(menuSearchProvider.notifier).state = '';
                FocusScope.of(context).unfocus();
              },
              icon: const Icon(Icons.close_rounded, size: 18),
              label: const Text('Cancel Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error.withValues(alpha: 0.1),
                foregroundColor: AppColors.error,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

class _MenuItemsList extends ConsumerWidget {
  final int categoryId;
  final int orderId;
  final String searchQuery;

  const _MenuItemsList({required this.categoryId, required this.orderId, required this.searchQuery});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final favs = ref.watch(favoritesProvider);

    return FutureBuilder<List<MenuItem>>(
      future: db.getAllMenuItems(),
      builder: (context, snap) {
        if (!snap.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        var items = snap.data!.where((i) => i.isAvailable).toList();
        
        // Filter by category or favorites
        if (categoryId == -1) {
          items = items.where((i) => favs.contains(i.id)).toList();
        } else {
          items = items.where((i) => i.categoryId == categoryId).toList();
        }

        // Apply search query across whatever active list we have
        if (searchQuery.isNotEmpty) {
          items = snap.data!.where((i) => 
            i.isAvailable && i.name.toLowerCase().contains(searchQuery.trim().toLowerCase())
          ).toList();
        }

        if (items.isEmpty) {
          if (searchQuery.isNotEmpty) {
             return NbEmptyState(
               icon: Icons.search_off_rounded,
               title: 'No results',
               message: 'No items match "$searchQuery"',
             );
          }
          if (categoryId == -1) {
            return const NbEmptyState(
               icon: Icons.favorite_border_rounded,
               title: 'No favorites yet',
               message: 'Tap the heart icon on any item to add it here!',
             );
          }
          return const NbEmptyState(
               icon: Icons.restaurant_menu_rounded,
               title: 'Empty category',
               message: 'No items in this category',
             );
        }

        final screenWidth = MediaQuery.of(context).size.width;
        final isMobile = screenWidth < 600;

        return GridView.builder(
          padding: EdgeInsets.all(isMobile ? 10 : 12),
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: isMobile ? 180 : 180,
            mainAxisSpacing: isMobile ? 24 : 32,
            crossAxisSpacing: isMobile ? 12 : 16,
            childAspectRatio: isMobile ? 0.78 : 0.75,
          ),
          itemCount: items.length,
          itemBuilder: (context, i) {
            final item = items[i];
            return _MenuItemCard(item: item, orderId: orderId);
          },
        );
      },
    );
  }
}

class _PortionDialog extends StatefulWidget {
  final MenuItem item;
  const _PortionDialog({required this.item});

  @override
  State<_PortionDialog> createState() => _PortionDialogState();
}

class _PortionDialogState extends State<_PortionDialog> {
  late String _selectedSize;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.item.defaultSize;
  }

  @override
  Widget build(BuildContext context) {
    return NbDialog(
      title: 'Select portion size',
      customContent: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.item.name,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: ChoiceChip(
                  label: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Half', style: TextStyle(
                          color: _selectedSize == 'half' ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        )),
                        const SizedBox(height: 4),
                        Text(Fmt.currencyShort(widget.item.halfPrice), style: TextStyle(
                          color: _selectedSize == 'half' ? Colors.white70 : AppColors.textMuted,
                          fontSize: 12,
                        )),
                      ],
                    ),
                  ),
                  selected: _selectedSize == 'half',
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  onSelected: (val) {
                    if (val) setState(() => _selectedSize = 'half');
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ChoiceChip(
                  label: Container(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Full', style: TextStyle(
                          color: _selectedSize == 'full' ? Colors.white : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                        )),
                        const SizedBox(height: 4),
                        Text(Fmt.currencyShort(widget.item.price), style: TextStyle(
                          color: _selectedSize == 'full' ? Colors.white70 : AppColors.textMuted,
                          fontSize: 12,
                        )),
                      ],
                    ),
                  ),
                  selected: _selectedSize == 'full',
                  selectedColor: AppColors.primary,
                  backgroundColor: AppColors.surface,
                  onSelected: (val) {
                    if (val) setState(() => _selectedSize = 'full');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      primaryButtonText: 'Add to Cart',
      onPrimary: () => Navigator.pop(context, _selectedSize),
      secondaryButtonText: 'Cancel',
      onSecondary: () => Navigator.pop(context, null),
    );
  }
}

class _MenuItemCard extends ConsumerStatefulWidget {
  final MenuItem item;
  final int orderId;

  const _MenuItemCard({required this.item, required this.orderId});

  @override
  ConsumerState<_MenuItemCard> createState() => _MenuItemCardState();
}

class _MenuItemCardState extends ConsumerState<_MenuItemCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isFav = ref.watch(favoritesProvider).contains(widget.item.id);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          await _addToOrder(ref);
          ref.read(menuSearchProvider.notifier).state = '';
        },
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            // Card Base
            Container(
              margin: const EdgeInsets.only(top: 36),
              padding: const EdgeInsets.fromLTRB(16, 44, 16, 16),
              decoration: BoxDecoration(
                color: _isHovered ? AppColors.primary : AppColors.surface,
                borderRadius: BorderRadius.circular(24),
                boxShadow: _isHovered
                    ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 16, offset: const Offset(0, 8))]
                    : AppShadows.neumorphic(isDark),
              ),
              child: Column(
                children: [
                  Text(
                    widget.item.name,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: _isHovered ? Colors.white : AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        Fmt.currencyShort(widget.item.price),
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: _isHovered ? Colors.white : AppColors.textPrimary,
                        ),
                      ),
                      Container(
                        width: 28,
                        height: 28,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _isHovered ? Colors.white : AppColors.primaryGlow,
                        ),
                        child: Icon(
                          Icons.add, 
                          color: _isHovered ? AppColors.primary : AppColors.primary, 
                          size: 18
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            
            // Overlapping Dish Image / Placeholder
            Positioned(
              top: 0,
              child: Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.item.isVeg ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                  boxShadow: AppShadows.lift(isDark),
                  border: Border.all(color: AppColors.surface, width: 4),
                ),
                child: ClipOval(
                  child: widget.item.image != null && widget.item.image!.isNotEmpty
                      ? Image.memory(
                          base64Decode(widget.item.image!),
                          fit: BoxFit.cover,
                          gaplessPlayback: true,
                          errorBuilder: (context, error, stackTrace) => Center(
                            child: Text(
                              widget.item.name.isNotEmpty ? widget.item.name[0].toUpperCase() : '?',
                              style: GoogleFonts.manrope(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: widget.item.isVeg ? AppColors.success : AppColors.error,
                              ),
                            ),
                          ),
                        )
                      : Center(
                          child: Text(
                            widget.item.name.isNotEmpty ? widget.item.name[0].toUpperCase() : '?',
                            style: GoogleFonts.manrope(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: widget.item.isVeg ? AppColors.success : AppColors.error,
                            ),
                          ),
                        ),
                ),
              ),
            ),

            // Heart Icon Overlay for Favorites
            Positioned(
              top: 42,
              right: 12,
              child: GestureDetector(
                onTap: () {
                  ref.read(favoritesProvider.notifier).toggle(widget.item.id);
                },
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : AppColors.textMuted,
                    size: 14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addToOrder(WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    await _ensureOrderOpen(db, widget.orderId);

    String size = 'full';
    double price = widget.item.price;

    if (widget.item.customVariantsJson.isNotEmpty && widget.item.customVariantsJson != '[]') {
      try {
        final List parsed = jsonDecode(widget.item.customVariantsJson);
        if (parsed.isNotEmpty) {
          final selectedVariantMap = await showDialog<Map<String, dynamic>>(
            context: ref.context,
            builder: (ctx) => NbDialog(
              title: 'Select Variant for ${widget.item.name}',
              primaryButtonText: 'Cancel',
              onPrimary: () => Navigator.pop(ctx),
              customContent: Column(
                mainAxisSize: MainAxisSize.min,
                children: parsed.map<Widget>((v) {
                  final vName = v['name']?.toString() ?? '';
                  final vPrice = (v['price'] as num?)?.toDouble() ?? 0.0;
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    color: AppColors.surface,
                    child: ListTile(
                      title: Text(vName, style: const TextStyle(fontWeight: FontWeight.bold)),
                      trailing: Text('₹${vPrice.toStringAsFixed(0)}', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                      onTap: () => Navigator.pop(ctx, {'name': vName, 'price': vPrice}),
                    ),
                  );
                }).toList(),
              ),
            ),
          );
          if (selectedVariantMap == null) return;
          size = selectedVariantMap['name'] as String;
          price = selectedVariantMap['price'] as double;
        }
      } catch (_) {}
    } else if (widget.item.hasHalfFull) {
      final selectedSize = await showDialog<String>(
        context: ref.context,
        builder: (ctx) => _PortionDialog(item: widget.item),
      );
      if (selectedSize == null) return;
      size = selectedSize;
      price = size == 'half' ? widget.item.halfPrice : widget.item.price;
    }

    final itemName = size == 'half'
        ? '${widget.item.name} (H)'
        : (size != 'full' && size != 'half' ? '${widget.item.name} ($size)' : widget.item.name);

    final existing = await db.getOrderItems(widget.orderId);
    final existingItem = existing.where((i) => i.menuItemId == widget.item.id && i.itemSize == size).toList();
    final currentQtyInCart = existingItem.isNotEmpty ? existingItem.first.quantity : 0;

    final stockError = await db.checkStockAvailability(widget.item.id, size, currentQtyInCart + 1);
    if (stockError != null) {
      if (ref.context.mounted) {
        NbToast.show(ref.context, '⚠️ $stockError', type: NbToastType.error);
      }
      return;
    }

    if (existingItem.isNotEmpty) {
      final updated = existingItem.first.copyWith(
        quantity: existingItem.first.quantity + 1,
        kotSent: false,
      );
      await db.updateOrderItem(updated);
    } else {
      await db.insertOrderItem(OrderItemsCompanion.insert(
        orderId: widget.orderId,
        menuItemId: widget.item.id,
        itemName: itemName,
        itemPrice: price,
        itemSize: Value(size),
        addedAt: DateTime.now(),
      ));
    }

    // Instantly deduct 1 portion from raw material inventory stock
    final alerts = await db.deductInventoryForOrderItem(widget.item.id, size, 1);
    if (ref.context.mounted) {
      if (alerts.isNotEmpty) {
        NbToast.show(ref.context, '⚠️ ${alerts.first}', type: NbToastType.warning);
      } else {
        NbToast.show(ref.context, '$itemName added to cart & stock updated');
      }
    }
  }
}

class _CartPanel extends ConsumerWidget {
  final int orderId;
  final int tableId;
  final RestaurantTable? table;

  const _CartPanel({
    required this.orderId,
    required this.tableId,
    this.table,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(orderItemsProvider(orderId));
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(32),
        boxShadow: AppShadows.lift(isDark),
      ),
      clipBehavior: Clip.antiAlias,
      child: itemsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, s) => Center(child: Text(e.toString())),
        data: (items) {
          final total = items.fold<double>(
              0, (sum, i) => sum + (i.itemPrice * i.quantity));
          final hasNewItems = items.any((i) => i.quantity > i.printedQuantity);

          return Column(
            children: [
              // Cart header
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'My cart',
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: [
                        if (hasNewItems)
                          Container(
                            margin: const EdgeInsets.only(right: 12),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.warning.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              'New',
                              style: GoogleFonts.manrope(
                                fontSize: 10,
                                color: AppColors.warning,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: AppColors.bg,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(Icons.edit_rounded, size: 16, color: AppColors.textPrimary),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Items list
              Expanded(
                child: items.isEmpty
                    ? const NbEmptyState(
                        icon: Icons.shopping_bag_outlined,
                        title: 'Cart is empty',
                        message: 'Tap items to add',
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: items.length,
                        itemBuilder: (context, i) {
                          return _CartItem(item: items[i]);
                        },
                      ),
              ),

              // Total & Actions
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, -5),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // Subtotal Line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Subtotal',
                            style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted)),
                        Text(
                          Fmt.currency(total),
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    // Discount Line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Discount',
                            style: GoogleFonts.manrope(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textMuted)),
                        Text(
                          '0%',
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.success, // using success as green like in UI
                          ),
                        ),
                      ],
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: Divider(),
                    ),
                    // Final Line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Final',
                            style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary)),
                        Text(
                          Fmt.currency(total),
                          style: GoogleFonts.manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        // KOT button
                        Expanded(
                          child: InkWell(
                            onTap: hasNewItems && items.isNotEmpty
                                ? () => _printKot(context, ref, items)
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: hasNewItems ? AppColors.warning : AppColors.surfaceDark,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Center(
                                child: Text(
                                  'KOT',
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Checkout button
                        Expanded(
                          flex: 2,
                          child: InkWell(
                            onTap: items.isNotEmpty
                                ? () => context.pushNamed('billing',
                                    pathParameters: {
                                      'orderId': orderId.toString()
                                    })
                                : null,
                            borderRadius: BorderRadius.circular(16),
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                color: items.isNotEmpty ? AppColors.success : AppColors.surfaceDark,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: items.isNotEmpty 
                                    ? [BoxShadow(color: AppColors.success.withValues(alpha: 0.4), blurRadius: 12, offset: const Offset(0, 4))]
                                    : null,
                              ),
                              child: Center(
                                child: Text(
                                  'Checkout',
                                  style: GoogleFonts.manrope(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Future<void> _printKot(
      BuildContext context, WidgetRef ref, List<OrderItem> items) async {
    final db = ref.read(databaseProvider);
    final newItems = items.where((i) => i.quantity > i.printedQuantity).toList();
    if (newItems.isEmpty) return;

    await _sendKot(
      context: context,
      ref: ref,
      db: db,
      orderId: orderId,
      tableNumber: table?.tableNumber ?? 'T?',
      items: newItems,
    );
  }
}

Future<void> _sendKot({
  required BuildContext context,
  required WidgetRef ref,
  required AppDatabase db,
  required int orderId,
  required String tableNumber,
  required List<OrderItem> items,
}) async {
  final newItems = items.where((i) => i.quantity > i.printedQuantity).toList();
  if (newItems.isEmpty) return;

  final kotNumber = await db.getNextKotNumber();
  final kotData = newItems
      .map((i) => {
            'name': i.itemName,
            'qty': i.quantity - i.printedQuantity,
          })
      .toList();

  await db.insertKotRecord(KotRecordsCompanion.insert(
    orderId: orderId,
    kotNumber: kotNumber,
    itemsJson: jsonEncode(kotData),
    printedAt: DateTime.now(),
  ));
  await db.markKotSent(orderId);

  try {
    await ref.read(printerServiceProvider).printKot(
      tableNumber: tableNumber,
      kotNumber: kotNumber,
      items: kotData,
    );
    if (context.mounted) {
      NbToast.show(context, 'KOT #$kotNumber sent to kitchen', type: NbToastType.success);
    }
  } catch (e) {
    if (context.mounted) {
      NbToast.show(context, 'KOT saved but printer failed: $e', type: NbToastType.error);
    }
  }
}

class _CartItem extends ConsumerWidget {
  final OrderItem item;
  const _CartItem({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return FutureBuilder<MenuItem?>(
      future: db.getMenuItem(item.menuItemId),
      builder: (context, snap) {
        final menuItem = snap.data;
        final hasImage = menuItem?.image != null && menuItem!.image!.isNotEmpty;
        final isVeg = menuItem?.isVeg ?? true;

        return TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0.0, 20 * (1 - value)),
              child: Opacity(
                opacity: value,
                child: child,
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            child: Row(
              children: [
                // Circular Image / Letter Placeholder
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isVeg ? AppColors.success.withValues(alpha: 0.1) : AppColors.error.withValues(alpha: 0.1),
                    image: hasImage
                        ? DecorationImage(
                            image: MemoryImage(base64Decode(menuItem.image!)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: !hasImage
                      ? Center(
                          child: Text(
                            item.itemName.isNotEmpty ? item.itemName[0].toUpperCase() : '?',
                            style: GoogleFonts.manrope(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: isVeg ? AppColors.success : AppColors.error,
                            ),
                          ),
                        )
                      : null,
                ),
            const SizedBox(width: 12),
            
            // Qty & Name
            Expanded(
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => _decreaseQty(context, db, item),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.remove, size: 12, color: AppColors.textMuted),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '${item.quantity} x',
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await _ensureOrderOpen(db, item.orderId);
                      final stockError = await db.checkStockAvailability(item.menuItemId, item.itemSize, 1);
                      if (stockError != null) {
                        if (context.mounted) {
                          NbToast.show(context, '⚠️ $stockError', type: NbToastType.error);
                        }
                        return;
                      }

                      final updated = item.copyWith(quantity: item.quantity + 1, kotSent: false);
                      await db.updateOrderItem(updated);
                      await db.deductInventoryForOrderItem(item.menuItemId, item.itemSize, 1);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGlow,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Icon(Icons.add, size: 12, color: AppColors.primary),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.itemName,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
  
            // Price
            Text(
              Fmt.currencyShort(item.itemPrice * item.quantity),
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
      },
    );
  }

  Future<void> _decreaseQty(BuildContext context, AppDatabase db, OrderItem item) async {
    await _ensureOrderOpen(db, item.orderId);

    // Check if the bill for this order has already been printed
    final existingBill = await db.getBillForOrder(item.orderId);
    final isBilledOrder = existingBill != null;
    final isRemovingItem = item.quantity <= 1;

    // Require Admin PIN if removing item OR if reducing quantity on an already printed bill
    if (isRemovingItem || isBilledOrder) {
      final prefs = await SharedPreferences.getInstance();
      final adminPin = prefs.getString('admin_pin') ?? '1234';

      final pinCtrl = TextEditingController();
      final authorized = await showDialog<bool>(
        context: context,
        builder: (ctx) => NbDialog(
          title: '🔐 Admin Authorization Required',
          customContent: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isBilledOrder
                    ? 'This bill (#${existingBill.billNumber}) has already been printed. Decreasing quantity requires Admin PIN and will be logged in audit history.'
                    : 'Removing an item from an order requires Admin PIN to prevent unauthorized alterations.',
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(height: 12),
              NbInput(
                labelText: 'Enter Admin PIN',
                controller: pinCtrl,
                type: NbInputType.password,
              ),
            ],
          ),
          primaryButtonText: 'Authorize & Update',
          onPrimary: () {
            if (pinCtrl.text.trim() == adminPin) {
              Navigator.pop(ctx, true);
            } else {
              NbToast.show(ctx, 'Invalid Admin PIN!', type: NbToastType.error);
            }
          },
        ),
      );

      if (authorized != true) return;
    }

    // Capture old state for audit log if billed
    final allOrderItems = await db.getOrderItems(item.orderId);
    final oldTotal = allOrderItems.fold<double>(0.0, (s, i) => s + (i.itemPrice * i.quantity));

    if (isRemovingItem) {
      // Restore raw material stock for the removed item
      await db.restoreInventoryForOrderItem(item.menuItemId, item.itemSize, item.quantity);
      await db.deleteOrderItem(item.id);
    } else {
      final newQty = item.quantity - 1;
      final printedQty = item.printedQuantity > newQty ? newQty : item.printedQuantity;
      
      // Restore 1 unit of stock
      await db.restoreInventoryForOrderItem(item.menuItemId, item.itemSize, 1);

      final updated = item.copyWith(
        quantity: newQty,
        printedQuantity: printedQty,
        kotSent: printedQty == newQty,
      );
      await db.updateOrderItem(updated);
    }

    // If bill was already printed, log audit event into EditedBills & EditedBillItems
    if (isBilledOrder) {
      final updatedOrderItems = await db.getOrderItems(item.orderId);
      final newTotal = updatedOrderItems.fold<double>(0.0, (s, i) => s + (i.itemPrice * i.quantity));

      await db.logEditedBill(
        orderId: item.orderId,
        billNumber: existingBill.billNumber ?? 0,
        tableLabel: existingBill.tableLabel,
        originalTotal: oldTotal,
        newTotal: newTotal,
        editedBy: 'Staff (Admin Approved)',
        reason: isRemovingItem ? 'Item removed from printed bill' : 'Quantity decreased from ${item.quantity} to ${item.quantity - 1}',
        editedItemDetails: [
          {
            'name': item.itemName,
            'oldQty': item.quantity,
            'newQty': isRemovingItem ? 0 : item.quantity - 1,
            'price': item.itemPrice,
          }
        ],
      );
    }

    if (context.mounted) {
      NbToast.show(
        context,
        isRemovingItem
            ? 'Item removed & stock restored!'
            : 'Quantity decreased & stock restored!',
        type: NbToastType.info,
      );
    }
  }
}

class _KotButton extends ConsumerWidget {
  final int orderId;
  final String tableNumber;

  const _KotButton({required this.orderId, required this.tableNumber});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final itemsAsync = ref.watch(orderItemsProvider(orderId));
    return itemsAsync.when(
      data: (items) {
        final newCount = items.where((i) => i.quantity > i.printedQuantity).length;
        if (newCount == 0) return const SizedBox();
        return Container(
          margin: const EdgeInsets.only(right: 4),
          child: Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.kitchen_rounded),
                onPressed: () async {
                  await _sendKot(
                    context: context,
                    ref: ref,
                    db: ref.read(databaseProvider),
                    orderId: orderId,
                    tableNumber: tableNumber,
                    items: items,
                  );
                },
                tooltip: 'New items pending KOT',
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.error,
                  ),
                  child: Center(
                    child: Text(
                      '$newCount',
                      style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox(),
      error: (e, s) => const SizedBox(),
    );
  }
}

Future<void> _ensureOrderOpen(AppDatabase db, int orderId) async {
  final results = await (db.select(db.orders)..where((o) => o.id.equals(orderId))).get();
  if (results.isNotEmpty && results.first.status == 'billed') {
    await db.updateOrder(results.first.copyWith(status: 'open', updatedAt: DateTime.now()));
  }
}
