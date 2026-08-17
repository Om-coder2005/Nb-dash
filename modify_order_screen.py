import re

with open('lib/features/order/order_screen.dart', 'r', encoding='utf-8') as f:
    content = f.read()

# 1. Replace _MenuPanelState build
menu_panel_state_start = content.find('  @override\n  Widget build(BuildContext context) {', content.find('class _MenuPanelState'))
menu_panel_state_end = content.find('class _MenuItemsList', menu_panel_state_start)

new_menu_panel_state = """  @override
  Widget build(BuildContext context) {
    ref.listen<String>(menuSearchProvider, (previous, next) {
      if (next.isEmpty && _searchController.text.isNotEmpty) {
        _searchController.clear();
      }
    });

    final categoriesAsync = ref.watch(categoriesStreamProvider);
    final selectedCat = ref.watch(selectedCategoryProvider);
    final searchQuery = ref.watch(menuSearchProvider);

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, s) => Center(child: Text(e.toString())),
      data: (categories) {
        final activeCat = selectedCat ?? -1;

        return Column(
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

            // Store Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppShadows.lift(true),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          'Bell',
                          style: GoogleFonts.manrope(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bell fresh',
                            style: GoogleFonts.manrope(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'Fresh & healthy food recipe',
                            style: GoogleFonts.manrope(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _buildBannerStat('24', 'Total item'),
                    Container(width: 1, height: 40, color: Colors.white24, margin: const EdgeInsets.symmetric(horizontal: 16)),
                    _buildBannerStat('09', 'Category'),
                  ],
                ),
              ),
            ),

            // Category Row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
              child: SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length + 1,
                  clipBehavior: Clip.none,
                  itemBuilder: (context, i) {
                    final isFavTab = i == 0;
                    final catId = isFavTab ? -1 : categories[i - 1].id;
                    final catName = isFavTab ? 'Favs' : categories[i - 1].name;
                    final isSelected = catId == activeCat;
                    
                    final List<String> placeholders = ['🥗', '🍕', '🥩', '🥤', '🍔', '🍰'];
                    final emoji = isFavTab ? '❤️' : placeholders[i % placeholders.length];

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
                              ? [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]
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
                                color: isSelected ? Colors.white.withOpacity(0.2) : AppColors.bg,
                              ),
                              child: Center(
                                child: Text(emoji, style: const TextStyle(fontSize: 24)),
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

            Padding(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 4),
              child: Text(
                'Popular Dish',
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // Menu items
            Expanded(
              child: _MenuItemsList(categoryId: activeCat, orderId: widget.orderId, searchQuery: searchQuery),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBannerStat(String val, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(val, style: GoogleFonts.manrope(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: GoogleFonts.manrope(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}

"""

content = content[:menu_panel_state_start] + new_menu_panel_state + content[menu_panel_state_end:]

# 2. Update GridView delegate in _MenuItemsList
grid_delegate_start = content.find('gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(')
grid_delegate_end = content.find('),', grid_delegate_start) + 2

new_grid_delegate = """gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 180,
            mainAxisSpacing: 32, // More spacing for overlapping images
            crossAxisSpacing: 16,
            childAspectRatio: 0.75, // Taller cards
          ),"""

content = content[:grid_delegate_start] + new_grid_delegate + content[grid_delegate_end:]

# 3. Replace _MenuItemCard
menu_item_card_start = content.find('class _MenuItemCard extends ConsumerWidget {')
menu_item_card_end = content.find('class _CartPanel extends ConsumerWidget {')

new_menu_item_card = """class _MenuItemCard extends ConsumerStatefulWidget {
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

    // Use a placeholder list based on id
    final List<String> placeholders = ['🥗', '🍕', '🥩', '🥤', '🍔', '🍰'];
    final emoji = placeholders[widget.item.id % placeholders.length];

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
                    ? [BoxShadow(color: AppColors.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 8))]
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
                  Text(
                    '60 calories • 4 persons', // Dummy text to match UI
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w500,
                      color: _isHovered ? Colors.white70 : AppColors.textMuted,
                    ),
                    textAlign: TextAlign.center,
                  ),
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
                  color: AppColors.bg,
                  boxShadow: AppShadows.lift(isDark),
                  border: Border.all(color: AppColors.surface, width: 4),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 32)),
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

    // Check if item already in order
    final existing = await db.getOrderItems(widget.orderId);
    final existingItem = existing.where((i) => i.menuItemId == widget.item.id).toList();

    if (existingItem.isNotEmpty) {
      // Increment qty
      final updated = existingItem.first.copyWith(
        quantity: existingItem.first.quantity + 1,
      );
      await db.updateOrderItem(updated);
    } else {
      await db.insertOrderItem(OrderItemsCompanion.insert(
        orderId: widget.orderId,
        menuItemId: widget.item.id,
        itemName: widget.item.name,
        itemPrice: widget.item.price,
        addedAt: DateTime.now(),
      ));
    }
    NbToast.show(ref.context, '${widget.item.name} added');
  }
}

"""
content = content[:menu_item_card_start] + new_menu_item_card + content[menu_item_card_end:]

# 4. Update Cart Panel
cart_panel_start = content.find('class _CartPanel extends ConsumerWidget {')
cart_panel_end = content.find('class _CartItem extends ConsumerWidget {')

new_cart_panel = """class _CartPanel extends ConsumerWidget {
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
          final hasNewItems = items.any((i) => !i.kotSent);

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
                              color: AppColors.warning.withOpacity(0.15),
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
                    ? NbEmptyState(
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
                      color: Colors.black.withOpacity(0.03),
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
                                    ? [BoxShadow(color: AppColors.success.withOpacity(0.4), blurRadius: 12, offset: const Offset(0, 4))]
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
    final newItems = items.where((i) => !i.kotSent).toList();
    if (newItems.isEmpty) return;

    // Save KOT record
    final kotNumber = await db.getNextKotNumber(orderId);
    final kotData = newItems.map((i) => {
      'name': i.itemName,
      'qty': i.quantity,
    }).toList();

    await db.insertKotRecord(KotRecordsCompanion.insert(
      orderId: orderId,
      kotNumber: kotNumber,
      itemsJson: jsonEncode(kotData),
      printedAt: DateTime.now(),
    ));
    await db.markKotSent(orderId);

    // Print
    final printerService = ref.read(printerServiceProvider);
    final tableName = table?.tableNumber ?? 'T?';
    
    try {
      await printerService.printKot(
        tableNumber: tableName,
        kotNumber: kotNumber,
        items: newItems.map((i) => {
          'name': i.itemName,
          'qty': i.quantity,
        }).toList(),
      );

      if (context.mounted) {
        NbToast.show(
          context, 
          'KOT #$kotNumber sent to kitchen', 
          type: NbToastType.success
        );
      }
    } catch (e) {
      if (context.mounted) {
        NbToast.show(
          context, 
          'KOT saved but printer failed: $e', 
          type: NbToastType.error
        );
      }
    }
  }
}

"""
content = content[:cart_panel_start] + new_cart_panel + content[cart_panel_end:]

# 5. Update CartItem
cart_item_start = content.find('class _CartItem extends ConsumerWidget {')
cart_item_end = content.find('class _KotButton extends ConsumerWidget {')

new_cart_item = """class _CartItem extends ConsumerWidget {
  final OrderItem item;
  const _CartItem({required this.item});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    // Placeholder image
    final List<String> placeholders = ['🥗', '🍕', '🥩', '🥤', '🍔', '🍰'];
    final emoji = placeholders[item.menuItemId % placeholders.length];

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          // Circular Image Placeholder
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.bg,
            ),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 12),
          
          // Qty & Name
          Expanded(
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => _decreaseQty(db, item),
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
                    final updated = item.copyWith(quantity: item.quantity + 1);
                    await db.updateOrderItem(updated);
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
    );
  }

  Future<void> _decreaseQty(AppDatabase db, OrderItem item) async {
    await _ensureOrderOpen(db, item.orderId);
    if (item.quantity <= 1) {
      await db.deleteOrderItem(item.id);
    } else {
      final updated = item.copyWith(quantity: item.quantity - 1);
      await db.updateOrderItem(updated);
    }
  }
}

"""

content = content[:cart_item_start] + new_cart_item + content[cart_item_end:]


with open('lib/features/order/order_screen.dart', 'w', encoding='utf-8') as f:
    f.write(content)

print("Modification complete")
