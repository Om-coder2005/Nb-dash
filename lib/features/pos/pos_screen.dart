import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_empty_state.dart';
import 'package:nextbills/shared/widgets/nb_button.dart';
import 'package:nextbills/shared/widgets/nb_card.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/features/order/order_screen.dart';

// Providers
final zonesProvider = StreamProvider<List<Zone>>((ref) {
  return ref.watch(databaseProvider).watchAllZones();
});

final selectedZoneProvider = StateProvider<int?>((ref) => null);

final openOrdersProvider = StreamProvider<List<Order>>((ref) {
  return ref.watch(databaseProvider).watchOpenOrders();
});

final openOrderTotalsProvider = StreamProvider<Map<int, double>>((ref) {
  return ref.watch(databaseProvider).watchOpenOrderTotals();
});

final queueCountProvider = StreamProvider<int>((ref) {
  return ref.watch(databaseProvider).watchActiveQueue().map((l) => l.length);
});

final tableQuickLookProvider = StateProvider<bool>((ref) => true);

class PosScreen extends ConsumerStatefulWidget {
  const PosScreen({super.key});

  @override
  ConsumerState<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends ConsumerState<PosScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 1, vsync: this);
    _loadQuickLookSetting();
  }

  Future<void> _loadQuickLookSetting() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      ref.read(tableQuickLookProvider.notifier).state = prefs.getBool('enable_table_quick_look') ?? true;
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
    final zonesAsync = ref.watch(zonesProvider);
    final openOrdersAsync = ref.watch(openOrdersProvider);
    final size = MediaQuery.of(context).size;
    final isTablet = size.width > 600;

    return zonesAsync.when(
      loading: () => const Scaffold(
        body: Center(child: NbLoadingPulse()),
      ),
      error: (e, s) => Scaffold(body: Center(child: Text(e.toString()))),
      data: (zones) {
        if (_tabController.length != zones.length) {
          _tabController.dispose();
          _tabController = TabController(length: zones.length, vsync: this);
        }

        return Scaffold(
          backgroundColor: AppColors.bg,
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(60),
            child: Container(
              color: AppColors.surface,
              child: Row(
                children: [
                  Expanded(
                    child: zones.isEmpty
                        ? const SizedBox()
                        : TabBar(
                            controller: _tabController,
                            isScrollable: true,
                            tabAlignment: TabAlignment.start,
                            dividerColor: Colors.transparent,
                            indicatorColor: AppColors.primary,
                            labelColor: AppColors.primary,
                            unselectedLabelColor: AppColors.textSecondary,
                            tabs: zones
                                .map((z) => Tab(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 8,
                                            height: 8,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(z.colorValue),
                                            ),
                                          ),
                                          SizedBox(width: 8),
                                          Text(z.name),
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                  ),
                  // Stats chip
                  openOrdersAsync.when(
                    data: (orders) => Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGlow,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.restaurant_rounded,
                              size: 14, color: AppColors.primary),
                          SizedBox(width: 6),
                          Text(
                            '${orders.length} Active',
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    loading: () => SizedBox(),
                    error: (e, s) => SizedBox(),
                  ),
                  // Queue chip
                  ref.watch(queueCountProvider).when(
                    data: (count) => count > 0 ? GestureDetector(
                      onTap: () => context.pushNamed('queue'),
                      child: Container(
                        margin: EdgeInsets.only(right: 16),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.error.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.error.withOpacity(0.3)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_alt_rounded,
                                size: 14, color: AppColors.error),
                            SizedBox(width: 6),
                            Text(
                              '$count Waiting',
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.error,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ) : SizedBox(),
                    loading: () => SizedBox(),
                    error: (e, s) => SizedBox(),
                  ),
                ],
              ),
            ),
          ),

          body: zones.isEmpty
              ? _buildEmptyState(context)
              : TabBarView(
                  controller: _tabController,
                  children: zones
                      .map((zone) => _ZoneFloorPlan(zone: zone))
                      .toList(),
                ),
        );
      },
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return NbEmptyState(
      icon: Icons.table_restaurant_rounded,
      title: 'No zones or tables',
      message: 'Go to Settings → Table Management to get started',
      actionText: 'Manage Tables',
      onAction: () => context.pushNamed('tables'),
    );
  }
}

class _ZoneFloorPlan extends ConsumerWidget {
  final Zone zone;
  const _ZoneFloorPlan({required this.zone});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final openOrdersAsync = ref.watch(openOrdersProvider);

    return StreamBuilder<List<RestaurantTable>>(
      stream: db.watchTablesByZone(zone.id),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Center(child: NbLoadingPulse());
        }
        final tables = snap.data!;

        if (tables.isEmpty) {
          return NbEmptyState(
            icon: Icons.table_restaurant_rounded,
            title: 'No tables in ${zone.name}',
            message: 'Add tables to start serving customers.',
            actionText: 'Add Table',
            onAction: () => context.pushNamed(
              'tables',
              queryParameters: {'zoneId': zone.id.toString()},
            ),
          );
        }

        final isQuickLookEnabled = ref.watch(tableQuickLookProvider);

        return openOrdersAsync.when(
          loading: () => Center(child: NbLoadingPulse()),
          error: (e, s) => Center(child: Text(e.toString())),
          data: (openOrders) {
            final openTableIds = openOrders.map((o) => o.tableId).toSet();
            final screenWidth = MediaQuery.of(context).size.width;
            final isMobile = screenWidth < 600;

            return Padding(
              padding: EdgeInsets.all(isMobile ? 12 : 16),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: isMobile ? 180 : 170,
                  mainAxisSpacing: isMobile ? 12 : 16,
                  crossAxisSpacing: isMobile ? 12 : 16,
                  mainAxisExtent: isQuickLookEnabled ? (isMobile ? 210 : 235) : 155,
                ),
                itemCount: tables.length,
                itemBuilder: (context, i) {
                  final table = tables[i];
                  final isOccupied = openTableIds.contains(table.id);
                  final order = isOccupied
                      ? openOrders.firstWhere((o) => o.tableId == table.id)
                      : null;
                  return _TableCard(
                    table: table,
                    isOccupied: isOccupied,
                    order: order,
                    zoneColor: Color(zone.colorValue),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class _TableCard extends ConsumerStatefulWidget {
  final RestaurantTable table;
  final bool isOccupied;
  final Order? order;
  final Color zoneColor;

  const _TableCard({
    required this.table,
    required this.isOccupied,
    this.order,
    required this.zoneColor,
  });

  @override
  ConsumerState<_TableCard> createState() => _TableCardState();
}

class _TableCardState extends ConsumerState<_TableCard> {
  bool _isHovered = false;
  bool _enableQuickLook = true;

  @override
  void initState() {
    super.initState();
    _loadQuickLookPref();
  }

  Future<void> _loadQuickLookPref() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() {
        _enableQuickLook = prefs.getBool('enable_table_quick_look') ?? true;
      });
    }
  }

  Color get statusColor {
    if (!widget.isOccupied) return AppColors.tableFree;
    if (widget.order?.status == 'billed') return AppColors.tableBilled;
    return AppColors.tableOccupied;
  }

  Widget _buildRectangularOrderList(List<OrderItem> items, bool isDark) {
    if (items.isEmpty) return const SizedBox.shrink();

    final displayItems = items.take(2).toList();
    final remainingCount = items.length - displayItems.length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 1,
            margin: const EdgeInsets.only(bottom: 6),
            color: statusColor.withOpacity(0.2),
          ),
          for (var item in displayItems)
            Padding(
              padding: const EdgeInsets.only(bottom: 2),
              child: Row(
                children: [
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.itemName}',
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          if (remainingCount > 0)
            Padding(
              padding: const EdgeInsets.only(top: 1, left: 9),
              child: Text(
                '+$remainingCount more items',
                style: GoogleFonts.manrope(
                  fontSize: 9,
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCircularHangingTicket(List<OrderItem> items, bool isDark) {
    if (items.isEmpty) return const SizedBox.shrink();

    final displayItems = items.take(2).toList();
    final remainingCount = items.length - displayItems.length;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 14,
          height: 4,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.4),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        Container(
          width: 135,
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(isDark ? 0.22 : 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: statusColor.withOpacity(0.35),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: statusColor.withOpacity(0.12),
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var item in displayItems)
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 9, color: statusColor),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${item.quantity}x ${item.itemName}',
                          style: GoogleFonts.manrope(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              if (remainingCount > 0)
                Padding(
                  padding: const EdgeInsets.only(left: 13),
                  child: Text(
                    '+$remainingCount more',
                    style: GoogleFonts.manrope(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    double totalAmount = 0.0;
    if (widget.isOccupied && widget.order != null) {
      final totals = ref.watch(openOrderTotalsProvider).valueOrNull;
      totalAmount = totals?[widget.order!.id] ?? 0.0;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isCircle = widget.table.shape == 'circle';

    if (isCircle) {
      return MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: () => _handleTap(context, ref, db),
          onDoubleTap: () => _showContextMenu(context, ref, db),
          onSecondaryTap: () => _showContextMenu(context, ref, db),
          onLongPress: () => _showContextMenu(context, ref, db),
          child: AnimatedContainer(
            duration: AppDurations.normal,
            transform: _isHovered ? (Matrix4.identity()..translate(0.0, -4.0)) : Matrix4.identity(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Top Circle Card
                Container(
                  width: 145,
                  height: 145,
                  decoration: BoxDecoration(
                    color: widget.isOccupied ? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight) : AppColors.bg,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: widget.isOccupied ? statusColor : (isDark ? Colors.transparent : AppColors.border),
                      width: widget.isOccupied ? 2 : 1,
                    ),
                    boxShadow: widget.isOccupied
                        ? [
                            BoxShadow(
                              color: statusColor.withOpacity(isDark ? 0.2 : 0.15),
                              blurRadius: 12,
                              spreadRadius: 2,
                            ),
                          ]
                        : (_isHovered ? AppShadows.lift(isDark) : AppShadows.neumorphic(isDark)),
                  ),
                  child: Stack(
                    children: [
                      // Status Dot
                      Positioned(
                        top: 12,
                        right: 18,
                        child: Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: statusColor,
                            boxShadow: [
                              BoxShadow(
                                color: statusColor.withOpacity(0.6),
                                blurRadius: 5,
                                spreadRadius: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Circle Content
                      Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: widget.isOccupied
                                    ? statusColor.withOpacity(0.15)
                                    : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                                borderRadius: AppRadius.smBorder,
                              ),
                              child: Icon(
                                Icons.table_restaurant_rounded,
                                color: !widget.isOccupied ? AppColors.textMuted : statusColor,
                                size: 18,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              widget.table.tableNumber,
                              style: GoogleFonts.manrope(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              widget.table.tableLabel,
                              style: GoogleFonts.inter(
                                fontSize: 10,
                                color: AppColors.textMuted,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (widget.isOccupied && widget.order != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                Fmt.currencyShort(totalAmount),
                                style: GoogleFonts.manrope(
                                  fontSize: 11.5,
                                  color: statusColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 1),
                              Text(
                                Fmt.duration(widget.order!.openedAt),
                                style: GoogleFonts.manrope(
                                  fontSize: 9.5,
                                  color: AppColors.textMuted,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                            if (!widget.isOccupied)
                              Text(
                                '${widget.table.capacity} covers',
                                style: GoogleFonts.inter(
                                  fontSize: 9.5,
                                  color: AppColors.textMuted,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Hanging Ticket Tag below Circle
                if (_enableQuickLook && widget.isOccupied && widget.order != null)
                  ref.watch(orderItemsProvider(widget.order!.id)).when(
                    data: (items) => _buildCircularHangingTicket(items, isDark),
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                  ),
              ],
            ),
          ),
        ),
      );
    }

    // Rectangular Table Card Layout
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _handleTap(context, ref, db),
        onDoubleTap: () => _showContextMenu(context, ref, db),
        onSecondaryTap: () => _showContextMenu(context, ref, db),
        onLongPress: () => _showContextMenu(context, ref, db),
        child: AnimatedContainer(
          duration: AppDurations.normal,
          transform: _isHovered ? (Matrix4.identity()..translate(0.0, -4.0)) : Matrix4.identity(),
          decoration: BoxDecoration(
            color: widget.isOccupied ? (isDark ? AppColors.surfaceDark : AppColors.surfaceLight) : AppColors.bg,
            borderRadius: AppRadius.mdBorder,
            border: Border.all(
              color: widget.isOccupied ? statusColor : (isDark ? Colors.transparent : AppColors.border),
              width: widget.isOccupied ? 2 : 1,
            ),
            boxShadow: widget.isOccupied
                ? [
                    BoxShadow(
                      color: statusColor.withOpacity(isDark ? 0.2 : 0.15),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                    if (_isHovered) ...AppShadows.lift(isDark),
                  ]
                : (_isHovered ? AppShadows.lift(isDark) : AppShadows.neumorphic(isDark)),
          ),
          child: Stack(
            children: [
              // Status Indicator Dot
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: statusColor,
                    boxShadow: [
                      BoxShadow(
                        color: statusColor.withOpacity(0.6),
                        blurRadius: 6,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                ),
              ),

              // Rectangular Content
              Positioned.fill(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: widget.isOccupied && _enableQuickLook 
                        ? MainAxisAlignment.start 
                        : MainAxisAlignment.center,
                    children: [
                      if (widget.isOccupied && _enableQuickLook) const SizedBox(height: 4),
                      // Table icon
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: widget.isOccupied
                              ? statusColor.withOpacity(0.15)
                              : (isDark ? AppColors.surfaceDark : AppColors.surfaceLight),
                          borderRadius: AppRadius.smBorder,
                        ),
                        child: Icon(
                          Icons.table_restaurant_rounded,
                          color: !widget.isOccupied ? AppColors.textMuted : statusColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        widget.table.tableNumber,
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.table.tableLabel,
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (widget.isOccupied && widget.order != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          Fmt.currencyShort(totalAmount),
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          Fmt.duration(widget.order!.openedAt),
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            color: AppColors.textMuted,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_enableQuickLook)
                          ref.watch(orderItemsProvider(widget.order!.id)).when(
                            data: (items) => _buildRectangularOrderList(items, isDark),
                            loading: () => const SizedBox.shrink(),
                            error: (_, __) => const SizedBox.shrink(),
                          ),
                      ],

                      if (!widget.isOccupied) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${widget.table.capacity} covers',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleTap(
      BuildContext context, WidgetRef ref, AppDatabase db) async {
    if (widget.isOccupied && widget.order != null) {
      // Navigate to existing order
      if (context.mounted) {
        context.pushNamed('order',
            pathParameters: {
              'tableId': widget.table.id.toString(),
              'orderId': widget.order!.id.toString(),
            });
      }
    } else {
      // Create new order
      final orderId = await db.insertOrder(OrdersCompanion.insert(
        tableId: widget.table.id,
        openedAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ));
      if (context.mounted) {
        context.pushNamed('order',
            pathParameters: {
              'tableId': widget.table.id.toString(),
              'orderId': orderId.toString(),
            });
      }
    }
  }

  void _showContextMenu(
      BuildContext context, WidgetRef ref, AppDatabase db) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _TableContextMenu(
        table: widget.table,
        order: widget.order,
        isOccupied: widget.isOccupied,
        onViewOrder: () {
          Navigator.pop(ctx);
          if (widget.order != null) {
            context.pushNamed('order',
                pathParameters: {
                  'tableId': widget.table.id.toString(),
                  'orderId': widget.order!.id.toString(),
                });
          }
        },
        onViewBill: () {
          Navigator.pop(ctx);
          if (widget.order != null) {
            context.pushNamed('billing',
                pathParameters: {'orderId': widget.order!.id.toString()});
          }
        },
        onMarkFree: () async {
          Navigator.pop(ctx);
          if (widget.order != null) {
            final order = widget.order!;
            if (order.status != 'billed' && order.status != 'completed') {
              // Restore inventory for all items in unbilled order before marking free / cancelling
              final items = await db.getOrderItems(order.id);
              for (final item in items) {
                await db.restoreInventoryForOrderItem(
                  item.menuItemId,
                  item.itemSize ?? 'full',
                  item.quantity,
                );
              }
            }

            final newStatus = order.status == 'billed' ? 'completed' : 'cancelled';
            final updated = order.copyWith(status: newStatus, updatedAt: DateTime.now());
            await db.updateOrder(updated);
            if (context.mounted) {
              NbToast.show(
                context,
                order.status != 'billed'
                    ? 'Table freed & inventory restored!'
                    : 'Table cleared successfully',
                type: NbToastType.success,
              );
            }
          }
        },
      ),
    );
  }
}

class _TableContextMenu extends StatelessWidget {
  final RestaurantTable table;
  final Order? order;
  final bool isOccupied;
  final VoidCallback onViewOrder;
  final VoidCallback onViewBill;
  final VoidCallback onMarkFree;

  const _TableContextMenu({
    required this.table,
    this.order,
    required this.isOccupied,
    required this.onViewOrder,
    required this.onViewBill,
    required this.onMarkFree,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${table.tableNumber} — ${table.tableLabel}',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 4),
          Text(
            isOccupied ? 'Occupied' : 'Available',
            style: GoogleFonts.inter(
              fontSize: 13,
              color: isOccupied ? AppColors.tableOccupied : AppColors.tableFree,
            ),
          ),
          SizedBox(height: 20),
          if (isOccupied) ...[
            _ActionTile(
              icon: Icons.receipt_long_rounded,
              label: 'View / Edit Order',
              color: AppColors.primary,
              onTap: onViewOrder,
            ),
            SizedBox(height: 8),
            _ActionTile(
              icon: Icons.payment_rounded,
              label: 'Print & Pay Bill',
              color: AppColors.tableBilled,
              onTap: onViewBill,
            ),
            SizedBox(height: 8),
            if (order!.status == 'billed')
              _ActionTile(
                icon: Icons.check_circle_outline_rounded,
                label: 'Clear Table (Complete)',
                color: AppColors.success,
                onTap: onMarkFree,
              )
            else
              _ActionTile(
                icon: Icons.cancel_outlined,
                label: 'Cancel Order & Mark Free',
                color: AppColors.error,
                onTap: onMarkFree,
              ),
          ] else
            _ActionTile(
              icon: Icons.add_circle_outline_rounded,
              label: 'New Order',
              color: AppColors.success,
              onTap: onViewOrder,
            ),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      tileColor: color.withOpacity(0.08),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 20),
      ),
      title: Text(label,
          style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary)),
    );
  }
}


void _showAdminAccessDialog(BuildContext context, String targetRoute) async {
  final prefs = await SharedPreferences.getInstance();
  final correctPin = prefs.getString('admin_pin') ?? '9469';
  
  if (!context.mounted) return;

  final tc = TextEditingController();
  
  showDialog(
    context: context,
    builder: (context) => NbDialog(
      title: 'Admin Access',
      customContent: NbInput(
        controller: tc,
        type: NbInputType.password,
        hintText: 'Enter Admin PIN',
        autofocus: true,
        onSubmitted: () {
          Navigator.pop(context);
          if (tc.text == correctPin) {
            context.pushNamed(targetRoute);
          } else {
            NbToast.show(context, 'Incorrect PIN', type: NbToastType.error);
          }
        },
      ),
      primaryButtonText: 'Submit',
      onPrimary: () {
        Navigator.pop(context);
        if (tc.text == correctPin) {
          context.pushNamed(targetRoute);
        } else {
          NbToast.show(context, 'Incorrect PIN', type: NbToastType.error);
        }
      },
      secondaryButtonText: 'Cancel',
      onSecondary: () => Navigator.pop(context),
    ),
  );
}
