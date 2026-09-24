import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/providers/favorites_provider.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/core/utils/keyboard_helper.dart';
import 'dart:async';

class AppShell extends ConsumerWidget {
  final Widget child;
  const AppShell({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(themeModeProvider);
    final bool isDesktop = MediaQuery.of(context).size.width >= 800;
    final String location = GoRouterState.of(context).uri.path;
    final bool isDashboard = location == '/pos' || location == '/';

    return PopScope(
      canPop: isDashboard,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !isDashboard) {
          context.go('/pos');
        }
      },
      child: AnimatedContainer(
        duration: AppDurations.normal,
        color: AppColors.bg,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: isDesktop
            ? Row(
                children: [
                  const _Sidebar(),
                  Expanded(
                    child: Column(
                      children: [
                        const _TopBar(),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(topLeft: Radius.circular(AppRadius.lg)),
                            child: child,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  const _TopBar(),
                  Expanded(child: child),
                  const _BottomNavMobile(),
                ],
              ),
        ),
      ),
    );
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return AnimatedContainer(
      duration: AppDurations.normal,
      width: 250,
      margin: const EdgeInsets.only(left: 16, top: 16, bottom: 16, right: 16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.lgBorder, // 24px radius
        boxShadow: AppShadows.ambient(Theme.of(context).brightness == Brightness.dark),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'assets/logo.png',
                    width: 32,
                    height: 32,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: AppRadius.smBorder,
                      ),
                      child: Icon(Icons.restaurant, color: AppColors.primary, size: 20),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  'NextBills',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard_outlined,
                  label: 'Floor Plan',
                  isSelected: location == '/pos',
                  onTap: () => context.go('/pos'),
                ),
                _SidebarItem(
                  icon: Icons.menu_book_outlined,
                  label: 'Menu',
                  isSelected: location == '/menu',
                  onTap: () => context.go('/menu'),
                ),
                _SidebarItem(
                  icon: Icons.receipt_long_outlined,
                  label: 'Queue',
                  isSelected: location == '/queue',
                  onTap: () => context.go('/queue'),
                ),
                _SidebarItem(
                  icon: Icons.kitchen_outlined,
                  label: 'Kitchen',
                  isSelected: location == '/kitchen',
                  onTap: () => context.go('/kitchen'),
                ),
                _SidebarItem(
                  icon: Icons.print_outlined,
                  label: 'Printers',
                  isSelected: location == '/printer',
                  onTap: () => context.go('/printer'),
                ),
                _SidebarItem(
                  icon: Icons.inventory_2_outlined,
                  label: 'Inventory',
                  isSelected: location == '/inventory',
                  onTap: () => context.go('/inventory'),
                ),
                _SidebarItem(
                  icon: Icons.account_balance_wallet_outlined,
                  label: 'Expenses',
                  isSelected: location == '/expenses',
                  onTap: () => context.go('/expenses'),
                ),
                _SidebarItem(
                  icon: Icons.analytics_outlined,
                  label: 'Reports',
                  isSelected: location == '/reports',
                  onTap: () => context.go('/reports'),
                ),
                _SidebarItem(
                  icon: Icons.settings_outlined,
                  label: 'Settings',
                  isSelected: location == '/settings',
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.md),
            child: _SidebarItem(
              icon: Icons.logout_rounded,
              label: 'Logout',
              isSelected: false,
              onTap: () => context.go('/pin'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 8.0, right: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.pillBorder,
        child: AnimatedContainer(
          duration: AppDurations.fast,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.transparent,
            borderRadius: AppRadius.pillBorder,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : AppColors.textSecondary,
                size: 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopBar extends ConsumerWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SafeArea(
      bottom: false,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: Border(bottom: BorderSide(color: AppColors.border)),
        ),
        child: Row(
          children: [
            const Expanded(
              child: _GlobalSearchBar(),
            ),
          const SizedBox(width: AppSpacing.md),
          IconButton(
            icon: AnimatedSwitcher(
              duration: AppDurations.normal,
              transitionBuilder: (Widget child, Animation<double> animation) {
                return RotationTransition(
                  turns: child.key == const ValueKey('dark')
                      ? Tween<double>(begin: 0.5, end: 1.0).animate(animation)
                      : Tween<double>(begin: -0.5, end: 0.0).animate(animation),
                  child: ScaleTransition(
                    scale: animation,
                    child: FadeTransition(opacity: animation, child: child),
                  ),
                );
              },
              child: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                key: ValueKey(isDark ? 'dark' : 'light'),
                color: isDark ? AppColors.warning : AppColors.textSecondary,
              ),
            ),
            onPressed: () {
              ref.read(themeModeProvider.notifier).state = 
                isDark ? ThemeMode.light : ThemeMode.dark;
            },
          ),
        ],
      ),
    ),
  );
}
}

class _BottomNavMobile extends StatelessWidget {
  const _BottomNavMobile();

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MobileNavItem(
                  icon: Icons.dashboard_outlined,
                  selectedIcon: Icons.dashboard_rounded,
                  label: 'Floor',
                  isSelected: location == '/pos',
                  onTap: () => context.go('/pos'),
                ),
                _MobileNavItem(
                  icon: Icons.restaurant_menu_outlined,
                  selectedIcon: Icons.restaurant_menu_rounded,
                  label: 'Menu',
                  isSelected: location == '/menu',
                  onTap: () => context.go('/menu'),
                ),
                _MobileNavItem(
                  icon: Icons.receipt_long_outlined,
                  selectedIcon: Icons.receipt_long_rounded,
                  label: 'Queue',
                  isSelected: location == '/queue',
                  onTap: () => context.go('/queue'),
                ),
                _MobileNavItem(
                  icon: Icons.table_bar_outlined,
                  selectedIcon: Icons.table_bar_rounded,
                  label: 'Tables',
                  isSelected: location == '/tables',
                  onTap: () => context.go('/tables'),
                ),
                _MobileNavItem(
                  icon: Icons.inventory_2_outlined,
                  selectedIcon: Icons.inventory_2_rounded,
                  label: 'Stock',
                  isSelected: location == '/inventory',
                  onTap: () => context.go('/inventory'),
                ),
                _MobileNavItem(
                  icon: Icons.account_balance_wallet_outlined,
                  selectedIcon: Icons.account_balance_wallet_rounded,
                  label: 'Expenses',
                  isSelected: location == '/expenses',
                  onTap: () => context.go('/expenses'),
                ),
                _MobileNavItem(
                  icon: Icons.analytics_outlined,
                  selectedIcon: Icons.analytics_rounded,
                  label: 'Reports',
                  isSelected: location == '/reports',
                  onTap: () => context.go('/reports'),
                ),
                _MobileNavItem(
                  icon: Icons.print_outlined,
                  selectedIcon: Icons.print_rounded,
                  label: 'Printer',
                  isSelected: location == '/printer',
                  onTap: () => context.go('/printer'),
                ),
                _MobileNavItem(
                  icon: Icons.settings_outlined,
                  selectedIcon: Icons.settings_rounded,
                  label: 'Settings',
                  isSelected: location == '/settings',
                  onTap: () => context.go('/settings'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MobileNavItem extends StatelessWidget {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _MobileNavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Material(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: isSelected ? 12 : 10, vertical: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? selectedIcon : icon,
                  color: isSelected ? AppColors.primary : AppColors.textMuted,
                  size: 20,
                ),
                if (isSelected) ...[
                  const SizedBox(width: 6),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GlobalSearchBar extends ConsumerStatefulWidget {
  const _GlobalSearchBar();

  @override
  ConsumerState<_GlobalSearchBar> createState() => _GlobalSearchBarState();
}

class _GlobalSearchBarState extends ConsumerState<_GlobalSearchBar> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<MenuItem> _matchedItems = [];
  List<RestaurantTable> _matchedTables = [];
  List<Order> _matchedOrders = [];
  bool _showResults = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_onFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    _controller.dispose();
    _hideOverlay();
    super.dispose();
  }

  void _onFocusChange() {
    if (_focusNode.hasFocus) {
      if (_controller.text.isNotEmpty) {
        _search(_controller.text);
      }
    }
  }

  Future<void> _search(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _matchedItems = [];
        _matchedTables = [];
        _matchedOrders = [];
        _showResults = false;
      });
      _hideOverlay();
      return;
    }

    final db = ref.read(databaseProvider);
    final allItems = await db.getAllMenuItems();
    final allTables = await db.getAllTables();
    final allOrders = await db.watchOpenOrders().first;

    final q = query.toLowerCase().trim();

    _matchedItems = allItems.where((i) => i.name.toLowerCase().contains(q)).toList();
    _matchedTables = allTables.where((t) => t.tableNumber.toLowerCase().contains(q) || t.tableLabel.toLowerCase().contains(q)).toList();
    _matchedOrders = allOrders.where((o) {
      final tablesFiltered = allTables.where((t) => t.id == o.tableId);
      final table = tablesFiltered.isNotEmpty ? tablesFiltered.first : null;
      return o.customerName.toLowerCase().contains(q) ||
             o.waiterName.toLowerCase().contains(q) ||
             (table != null && table.tableNumber.toLowerCase().contains(q));
    }).toList();

    _showResults = _matchedItems.isNotEmpty || _matchedTables.isNotEmpty || _matchedOrders.isNotEmpty;
    
    if (_showResults) {
      _showOverlay();
    } else {
      _hideOverlay();
    }
  }

  OverlayEntry? _backdropEntry;

  void _showOverlay() {
    if (_overlayEntry == null) {
      _backdropEntry = OverlayEntry(
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            _focusNode.unfocus();
            _hideOverlay();
          },
          child: const SizedBox.expand(),
        ),
      );
      _overlayEntry = _createOverlayEntry();
      
      final overlayState = Overlay.of(context);
      overlayState.insert(_backdropEntry!);
      overlayState.insert(_overlayEntry!, above: _backdropEntry);
    } else {
      _overlayEntry!.markNeedsBuild();
    }
  }

  void _hideOverlay() {
    _backdropEntry?.remove();
    _backdropEntry = null;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  OverlayEntry _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 4.0),
          child: Material(
            elevation: 8.0,
            borderRadius: BorderRadius.circular(16),
            color: AppColors.surface,
            child: Container(
              constraints: const BoxConstraints(maxHeight: 350),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.border),
                borderRadius: BorderRadius.circular(16),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  children: [
                    if (_matchedTables.isNotEmpty) ...[
                      _buildHeader('Tables'),
                      ..._matchedTables.map((t) => _buildTableResult(t)),
                    ],
                    if (_matchedOrders.isNotEmpty) ...[
                      _buildHeader('Active Orders'),
                      ..._matchedOrders.map((o) => _buildOrderResult(o)),
                    ],
                    if (_matchedItems.isNotEmpty) ...[
                      _buildHeader('Menu Items'),
                      ..._matchedItems.map((i) => _buildMenuItemResult(i)),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: AppColors.textMuted,
          letterSpacing: 1.0,
        ),
      ),
    );
  }

  Widget _buildTableResult(RestaurantTable t) {
    return ListTile(
      leading: const Icon(Icons.table_restaurant_rounded, size: 20),
      title: Text('${t.tableNumber} — ${t.tableLabel}', style: TextStyle(color: AppColors.textPrimary)),
      onTap: () async {
        _controller.clear();
        _focusNode.unfocus();
        _hideOverlay();
        final db = ref.read(databaseProvider);
        final order = await db.getOpenOrderForTable(t.id);
        if (order != null) {
          if (mounted) {
            context.pushNamed('order', pathParameters: {
              'tableId': t.id.toString(),
              'orderId': order.id.toString(),
            });
          }
        } else {
          // Create new order
          final orderId = await db.insertOrder(OrdersCompanion.insert(
            tableId: t.id,
            openedAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ));
          if (mounted) {
            context.pushNamed('order', pathParameters: {
              'tableId': t.id.toString(),
              'orderId': orderId.toString(),
            });
          }
        }
      },
    );
  }

  Widget _buildOrderResult(Order o) {
    return ListTile(
      leading: const Icon(Icons.receipt_long_rounded, size: 20),
      title: Text('Order #${o.id} — ${o.customerName.isNotEmpty ? o.customerName : 'Walk-in'}', style: TextStyle(color: AppColors.textPrimary)),
      subtitle: Text('Status: ${o.status.toUpperCase()}', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
      onTap: () {
        _controller.clear();
        _focusNode.unfocus();
        _hideOverlay();
        context.pushNamed('order', pathParameters: {
          'tableId': o.tableId.toString(),
          'orderId': o.id.toString(),
        });
      },
    );
  }

  Widget _buildMenuItemResult(MenuItem item) {
    return ListTile(
      leading: Icon(
        item.isVeg ? Icons.eco_rounded : Icons.restaurant_rounded,
        color: item.isVeg ? AppColors.success : AppColors.error,
        size: 20,
      ),
      title: Text(item.name, style: TextStyle(color: AppColors.textPrimary)),
      subtitle: Text(Fmt.currencyShort(item.price), style: TextStyle(fontSize: 12, color: AppColors.primary)),
      onTap: () {
        _controller.clear();
        _focusNode.unfocus();
        _hideOverlay();
        _showItemDetailsDialog(item);
      },
    );
  }

  void _showItemDetailsDialog(MenuItem item) {
    showDialog(
      context: context,
      builder: (ctx) => Consumer(
        builder: (context, ref, _) {
          final isFav = ref.watch(favoritesProvider).contains(item.id);
          return NbDialog(
            title: item.name,
            customContent: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      item.hasHalfFull 
                        ? 'Full: ${Fmt.currency(item.price)}\nHalf: ${Fmt.currency(item.halfPrice)}'
                        : Fmt.currency(item.price),
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isFav ? Icons.favorite : Icons.favorite_border,
                        color: isFav ? Colors.red : AppColors.textMuted,
                        size: 28,
                      ),
                      onPressed: () {
                        ref.read(favoritesProvider.notifier).toggle(item.id);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (item.description.isNotEmpty) ...[
                  Text(
                    item.description,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: item.isVeg ? AppColors.success.withValues(alpha: 0.15) : AppColors.error.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        item.isVeg ? 'VEG' : 'NON-VEG',
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: item.isVeg ? AppColors.success : AppColors.error,
                        ),
                      ),
                    ),
                    if (item.hasHalfFull) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGlow,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          'HALF/FULL PORTIONS',
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            primaryButtonText: 'Close',
            onPrimary: () => Navigator.pop(ctx),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: AnimatedContainer(
        duration: AppDurations.normal,
        height: 32,
        decoration: BoxDecoration(
          color: AppColors.bg,
          borderRadius: AppRadius.pillBorder,
          border: Border.all(color: AppColors.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: [
            Icon(Icons.search, color: AppColors.textMuted, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _controller,
                focusNode: _focusNode,
                onChanged: _search,
                onTap: launchWindowsVirtualKeyboard,
                decoration: InputDecoration(
                  hintText: 'Search menus, tables, orders...',
                  border: InputBorder.none,
                  isDense: true,
                  hintStyle: TextStyle(color: AppColors.textMuted),
                ),
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

