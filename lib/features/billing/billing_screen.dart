import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:drift/drift.dart' hide Column;

import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_button.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';
import 'package:nextbills/features/order/order_screen.dart';
import 'package:nextbills/features/printer/printer_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr/qr.dart';

class BillingScreen extends ConsumerStatefulWidget {
  final int orderId;
  const BillingScreen({super.key, required this.orderId});

  @override
  ConsumerState<BillingScreen> createState() => _BillingScreenState();
}

class _BillingScreenState extends ConsumerState<BillingScreen>
    with SingleTickerProviderStateMixin {
  Order? _order;
  RestaurantTable? _table;
  double _discount = 0.0;
  String _paymentMethod = 'upi';
  final _discountController = TextEditingController(text: '0');
  final _cashController = TextEditingController();
  final _splitCashController = TextEditingController();
  bool _isPrinting = false;
  int? _billNumber;
  bool _enableGst = false;
  double _cgstRate = 2.5;
  double _sgstRate = 2.5;

  late AnimationController _printAnimationController;
  late Animation<double> _printTranslation;
  late Animation<double> _printOpacity;

  bool _isPercentageDiscount = false;
  double _discountInputVal = 0.0;

  @override
  void initState() {
    super.initState();
    _printAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _printTranslation = Tween<double>(begin: 0.0, end: -350.0).animate(
      CurvedAnimation(parent: _printAnimationController, curve: Curves.easeInOutCubic),
    );
    _printOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(parent: _printAnimationController, curve: Curves.easeIn),
    );
    _loadData();
  }

  @override
  void dispose() {
    _discountController.dispose();
    _cashController.dispose();
    _printAnimationController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final enableGst = prefs.getBool('enable_gst') ?? false;
    final cgstRate = prefs.getDouble('cgst_rate') ?? 2.5;
    final sgstRate = prefs.getDouble('sgst_rate') ?? 2.5;

    final db = ref.read(databaseProvider);
    final orders = await db.watchOpenOrders().first;
    try {
      final order = orders.firstWhere((o) => o.id == widget.orderId);
      final tables = await db.getAllTables();
      final table = tables.firstWhere((t) => t.id == order.tableId);
      
      final bill = await db.getBillForOrder(widget.orderId);
      final billNumber = bill?.billNumber ?? await db.getNextDailyBillNumber(DateTime.now());
      
      if (mounted) {
        setState(() {
          _order = order;
          _table = table;
          _billNumber = billNumber;
          _enableGst = enableGst;
          _cgstRate = cgstRate;
          _sgstRate = sgstRate;
        });
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final itemsAsync = ref.watch(orderItemsProvider(widget.orderId));

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: NbAppBar(
        title: 'Bill — ${_table?.tableNumber ?? ''}',
        showBack: true,
      ),
      body: CallbackShortcuts(
        bindings: {
          const SingleActivator(LogicalKeyboardKey.keyP, control: true): () {
            if (!_isPrinting && _order != null && itemsAsync.hasValue) {
              final items = itemsAsync.value!;
              final subtotal = items.fold<double>(0, (s, i) => s + (i.itemPrice * i.quantity));
              final discount = _discount.clamp(0.0, subtotal);
              final total = subtotal - discount;
              _printAndFreeTable(context, items, subtotal, discount, total);
            }
          },
          const SingleActivator(LogicalKeyboardKey.keyF, control: true): () {
            if (!_isPrinting && _order != null && itemsAsync.hasValue) {
              final items = itemsAsync.value!;
              final subtotal = items.fold<double>(0, (s, i) => s + (i.itemPrice * i.quantity));
              final discount = _discount.clamp(0.0, subtotal);
              final total = subtotal - discount;
              _freeTableOnly(context, items, subtotal, discount, total);
            }
          },
        },
        child: Focus(
          autofocus: true,
          child: itemsAsync.when(
            loading: () => const Center(child: NbLoadingPulse()),
            error: (e, s) => Center(child: Text(e.toString())),
              data: (items) {
                final subtotal = items.fold<double>(0, (s, i) => s + (i.itemPrice * i.quantity));
                final calculatedDiscount = _isPercentageDiscount
                    ? (subtotal * (_discountInputVal / 100))
                    : _discountInputVal;
                final discount = calculatedDiscount.clamp(0.0, subtotal);
                final netSubtotal = (subtotal - discount).clamp(0.0, double.infinity);
                final cgstAmount = _enableGst ? netSubtotal * (_cgstRate / 100) : 0.0;
                final sgstAmount = _enableGst ? netSubtotal * (_sgstRate / 100) : 0.0;
                final total = netSubtotal + cgstAmount + sgstAmount;
                final cashReceived = double.tryParse(_cashController.text) ?? 0.0;
                final change = (cashReceived - total).clamp(0.0, double.infinity);

                final screenWidth = MediaQuery.of(context).size.width;
                final isMobile = screenWidth < 600;

                final previewWidget = SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Bill paper with upward scrolling exit animation on print
                      AnimatedBuilder(
                        animation: _printAnimationController,
                        builder: (context, child) {
                          return Transform.translate(
                            offset: Offset(0.0, _printTranslation.value),
                            child: Opacity(
                              opacity: _printOpacity.value,
                              child: child,
                            ),
                          );
                        },
                        child: _BillPreview(
                          table: _table,
                          items: items,
                          subtotal: subtotal,
                          discount: discount,
                          enableGst: _enableGst,
                          cgstRate: _cgstRate,
                          sgstRate: _sgstRate,
                          cgstAmount: cgstAmount,
                          sgstAmount: sgstAmount,
                          total: total,
                          paymentMethod: _paymentMethod,
                          billNumber: _billNumber,
                        ),
                      ),
                    ],
                  ),
                );

                final splitCash = double.tryParse(_splitCashController.text) ?? 0.0;
                final splitOnline = (total - splitCash).clamp(0.0, total);

                final actionWidget = SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: _PaymentPanel(
                    subtotal: subtotal,
                    discount: discount,
                    isPercentageDiscount: _isPercentageDiscount,
                    enableGst: _enableGst,
                    cgstRate: _cgstRate,
                    sgstRate: _sgstRate,
                    cgstAmount: cgstAmount,
                    sgstAmount: sgstAmount,
                    total: total,
                    cashReceived: cashReceived,
                    change: change,
                    splitCash: splitCash,
                    splitOnline: splitOnline,
                    paymentMethod: _paymentMethod,
                    discountController: _discountController,
                    cashController: _cashController,
                    splitCashController: _splitCashController,
                    isPrinting: _isPrinting,
                    onDiscountChanged: (v) {
                      setState(() {
                        _discountInputVal = double.tryParse(v) ?? 0;
                        _discount = _isPercentageDiscount
                            ? (subtotal * (_discountInputVal / 100))
                            : _discountInputVal;
                      });
                    },
                    onToggleDiscountMode: (isPercent) {
                      setState(() {
                        _isPercentageDiscount = isPercent;
                        _discount = _isPercentageDiscount
                            ? (subtotal * (_discountInputVal / 100))
                            : _discountInputVal;
                      });
                    },
                    onPaymentMethodChanged: (v) {
                      setState(() => _paymentMethod = v ?? 'cash');
                    },
                    onCashChanged: (_) => setState(() {}),
                    onSplitCashChanged: (_) => setState(() {}),
                    onPrintAndPay: () => _printAndFreeTable(context, items, subtotal, discount, total),
                    onFreeTable: () => _freeTableOnly(context, items, subtotal, discount, total),
                  ),
                );

              if (isMobile) {
                return SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 24 + MediaQuery.of(context).viewInsets.bottom),
                  child: Column(
                    children: [
                      previewWidget,
                      const Divider(),
                      actionWidget,
                    ],
                  ),
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 5, child: previewWidget),
                  Container(width: 1, color: AppColors.border),
                  Expanded(flex: 4, child: actionWidget),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _printAndFreeTable(
    BuildContext context,
    List<OrderItem> items,
    double subtotal,
    double discount,
    double total,
  ) async {
    final printerService = ref.read(printerServiceProvider);
    setState(() => _isPrinting = true);

    try {
      final cashReceived = double.tryParse(_cashController.text) ?? total;
      final change = (cashReceived - total).clamp(0.0, double.infinity);

      final prefs = await SharedPreferences.getInstance();
      final hotelName = prefs.getString('hotel_name') ?? 'NextBills';
      final hotelAddress = prefs.getString('hotel_address') ?? '';
      final hotelPhone = prefs.getString('hotel_phone') ?? '';

      final splitCashVal = _paymentMethod == 'split' ? (double.tryParse(_splitCashController.text) ?? 0.0) : 0.0;
      final splitOnlineVal = _paymentMethod == 'split' ? (total - splitCashVal).clamp(0.0, total) : 0.0;

      await printerService.printBill(
        hotelName: hotelName,
        hotelAddress: hotelAddress,
        hotelPhone: hotelPhone,
        tableNumber: _table?.tableNumber ?? '',
        items: items.map((i) => {
          'name': i.itemName,
          'qty': i.quantity,
          'price': i.itemPrice,
        }).toList(),
        subtotal: subtotal,
        discount: discount,
        total: total,
        paymentMethod: _paymentMethod,
        cashReceived: cashReceived,
        change: change.toDouble(),
        splitCash: splitCashVal,
        splitOnline: splitOnlineVal,
        billNumber: _billNumber,
      );

      // Play the beautiful upward scroll exit animation
      await _printAnimationController.forward();

      if (context.mounted) {
        await _freeTableOnly(context, items, subtotal, discount, total);
      }
    } catch (e) {
      if (context.mounted) {
        NbToast.show(context, 'Printer failed: $e', type: NbToastType.error);
      }
    } finally {
      if (mounted) setState(() => _isPrinting = false);
    }
  }

  Future<void> _freeTableOnly(
    BuildContext context,
    List<OrderItem> items,
    double subtotal,
    double discount,
    double total,
  ) async {
    final db = ref.read(databaseProvider);

    try {
      final cashReceived = double.tryParse(_cashController.text) ?? total;
      final change = (cashReceived - total).clamp(0.0, double.infinity);

      // Insert bill
      final itemsData = items.map((i) => {
        'name': i.itemName,
        'qty': i.quantity,
        'price': i.itemPrice,
        'itemSize': i.itemSize,
      }).toList();

      final splitCashVal = _paymentMethod == 'split' ? (double.tryParse(_splitCashController.text) ?? 0.0) : 0.0;
      final splitOnlineVal = _paymentMethod == 'split' ? (total - splitCashVal).clamp(0.0, total) : 0.0;

      // Insert or update bill without re-deducting inventory stock (stock is already deducted live on cart addition)
      await db.upsertBill(BillsCompanion.insert(
        orderId: widget.orderId,
        tableId: _table?.id ?? 0,
        tableLabel: _table?.tableNumber ?? '',
        subtotal: subtotal,
        discount: Value(discount),
        total: total,
        paymentMethod: Value(_paymentMethod),
        amountReceived: Value(_paymentMethod == 'split' ? splitCashVal : cashReceived),
        change: Value(change.toDouble()),
        splitCash: Value(splitCashVal),
        splitOnline: Value(splitOnlineVal),
        itemsJson: jsonEncode(itemsData),
        createdAt: DateTime.now(),
      ));

      // Close order
      if (_order != null) {
        final updated = _order!.copyWith(status: 'billed', updatedAt: DateTime.now());
        await db.updateOrder(updated);
      }

      if (context.mounted) {
        NbToast.show(context, 'Table freed & data saved!', type: NbToastType.success);
        context.goNamed('pos');
      }
    } catch (e) {
      if (context.mounted) {
        NbToast.show(context, 'Error freeing table: $e', type: NbToastType.error);
      }
    }
  }
}

// ─── BILL PREVIEW ────────────────────────────────────

class _BillPreview extends ConsumerWidget {
  final RestaurantTable? table;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final bool enableGst;
  final double cgstRate;
  final double sgstRate;
  final double cgstAmount;
  final double sgstAmount;
  final double total;
  final String paymentMethod;
  final int? billNumber;

  const _BillPreview({
    this.table,
    required this.items,
    required this.subtotal,
    required this.discount,
    this.enableGst = false,
    this.cgstRate = 2.5,
    this.sgstRate = 2.5,
    this.cgstAmount = 0.0,
    this.sgstAmount = 0.0,
    required this.total,
    required this.paymentMethod,
    this.billNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder<Map<String, String?>>(
      future: SharedPreferences.getInstance().then((p) => {
            'name': p.getString('hotel_name') ?? 'NextBills',
            'logo': p.getString('restaurant_logo_base64'),
            'gstin': p.getString('gstin_number'),
          }),
      builder: (context, snap) {
        final hotelName = snap.data?['name'] ?? 'NextBills';
        final logoBase64 = snap.data?['logo'];
        final gstin = snap.data?['gstin'];

        return Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (logoBase64 != null) ...[
                Image.memory(base64Decode(logoBase64),
                    width: 60, height: 60, fit: BoxFit.contain),
                SizedBox(height: 8),
              ],
              Text(
                hotelName,
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              if (gstin != null && gstin.isNotEmpty) ...[
                SizedBox(height: 2),
                Text(
                  'GSTIN: $gstin',
                  style: GoogleFonts.inter(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ],
              SizedBox(height: 2),
              const Divider(color: Colors.black12),

              // Table info
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Table: ${table?.tableNumber ?? '-'}',
                          style: TextStyle(color: Colors.black87, fontSize: 12)),
                      if (billNumber != null)
                        Text('Bill No: $billNumber',
                            style: TextStyle(color: Colors.black87, fontSize: 12, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Text(Fmt.datetime(DateTime.now()),
                      style: TextStyle(color: Colors.black54, fontSize: 11)),
                ],
              ),
              const Divider(color: Colors.black12),

              // Items
              ...items.map((item) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 3),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(item.itemName,
                              style: TextStyle(color: Colors.black87, fontSize: 12)),
                        ),
                        Text(
                          '${item.quantity} x ${Fmt.currencyShort(item.itemPrice)}',
                          style: TextStyle(color: Colors.black54, fontSize: 12),
                        ),
                        SizedBox(width: 12),
                        SizedBox(
                          width: 70,
                          child: Text(
                            Fmt.currencyShort(item.itemPrice * item.quantity),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: Colors.black87,
                                fontSize: 12,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  )),

              const Divider(color: Colors.black12),

              // Totals
              _BillRow('Subtotal', Fmt.currencyShort(subtotal)),
              if (discount > 0) _BillRow('Discount', '- ${Fmt.currencyShort(discount)}'),
              if (enableGst && cgstAmount > 0) _BillRow('CGST (${cgstRate.toStringAsFixed(1)}%)', Fmt.currencyShort(cgstAmount)),
              if (enableGst && sgstAmount > 0) _BillRow('SGST (${sgstRate.toStringAsFixed(1)}%)', Fmt.currencyShort(sgstAmount)),
              const Divider(color: Colors.black),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text('TOTAL',
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16)),
                    const Spacer(),
                    Text(
                      Fmt.currencyShort(total),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.w800, fontSize: 16),
                    ),
                  ],
                ),
              ),
              _BillRow('Payment', paymentMethod.toUpperCase()),
              SizedBox(height: 12),
              Text('Thank you! Visit Again..',
                  style: TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      fontStyle: FontStyle.italic)),
            ],
          ),
        );
      },
    );
  }
}

class _BillRow extends StatelessWidget {
  final String label;
  final String value;
  const _BillRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label,
              style: TextStyle(color: Colors.black54, fontSize: 12)),
          const Spacer(),
          Text(value,
              style: TextStyle(
                  color: Colors.black87, fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

// ─── PAYMENT PANEL ───────────────────────────────────

class _PaymentPanel extends StatelessWidget {
  final double subtotal;
  final double discount;
  final bool isPercentageDiscount;
  final bool enableGst;
  final double cgstRate;
  final double sgstRate;
  final double cgstAmount;
  final double sgstAmount;
  final double total;
  final double cashReceived;
  final double change;
  final double splitCash;
  final double splitOnline;
  final String paymentMethod;
  final TextEditingController discountController;
  final TextEditingController cashController;
  final TextEditingController splitCashController;
  final bool isPrinting;
  final ValueChanged<String> onDiscountChanged;
  final ValueChanged<bool> onToggleDiscountMode;
  final ValueChanged<String?> onPaymentMethodChanged;
  final ValueChanged<String> onCashChanged;
  final ValueChanged<String> onSplitCashChanged;
  final VoidCallback onPrintAndPay;
  final VoidCallback onFreeTable;

  const _PaymentPanel({
    required this.subtotal,
    required this.discount,
    this.isPercentageDiscount = false,
    this.enableGst = false,
    this.cgstRate = 2.5,
    this.sgstRate = 2.5,
    this.cgstAmount = 0.0,
    this.sgstAmount = 0.0,
    required this.total,
    required this.cashReceived,
    required this.change,
    required this.splitCash,
    required this.splitOnline,
    required this.paymentMethod,
    required this.discountController,
    required this.cashController,
    required this.splitCashController,
    required this.isPrinting,
    required this.onDiscountChanged,
    required this.onToggleDiscountMode,
    required this.onPaymentMethodChanged,
    required this.onCashChanged,
    required this.onSplitCashChanged,
    required this.onPrintAndPay,
    required this.onFreeTable,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Payment',
              style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary)),
          SizedBox(height: 16),

          // Totals summary
          _SummaryRow('Subtotal', Fmt.currency(subtotal)),
          if (discount > 0) _SummaryRow('Discount', '- ${Fmt.currency(discount)}'),
          if (enableGst && cgstAmount > 0) _SummaryRow('CGST (${cgstRate.toStringAsFixed(1)}%)', Fmt.currency(cgstAmount)),
          if (enableGst && sgstAmount > 0) _SummaryRow('SGST (${sgstRate.toStringAsFixed(1)}%)', Fmt.currency(sgstAmount)),
          Divider(color: AppColors.border, height: 20),
          Row(
            children: [
              Text('Total',
                  style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary)),
              const Spacer(),
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

          SizedBox(height: 16),

          // Discount Input with Flat (Rs) / Percentage (%) Toggle
          Row(
            children: [
              Expanded(
                child: NbInput(
                  controller: discountController,
                  type: NbInputType.number,
                  onChanged: onDiscountChanged,
                  hintText: isPercentageDiscount ? 'Discount (%)' : 'Discount (Rs)',
                  prefixIcon: isPercentageDiscount ? Icons.percent_rounded : Icons.discount_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: AppColors.border),
                ),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => onToggleDiscountMode(false),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: !isPercentageDiscount ? AppColors.primary : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(left: Radius.circular(9)),
                        ),
                        child: Text(
                          '₹ Flat',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: !isPercentageDiscount ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onToggleDiscountMode(true),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        decoration: BoxDecoration(
                          color: isPercentageDiscount ? AppColors.primary : Colors.transparent,
                          borderRadius: const BorderRadius.horizontal(right: Radius.circular(9)),
                        ),
                        child: Text(
                          '% Off',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: isPercentageDiscount ? Colors.white : AppColors.textMuted,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),

          // Payment method
          Text('Payment Method',
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textSecondary)),
          SizedBox(height: 8),
          Row(
            children: ['cash', 'card', 'upi', 'split'].map((method) {
              final isSelected = paymentMethod == method;
              final icons = {
                'cash': Icons.money_rounded,
                'card': Icons.credit_card_rounded,
                'upi': Icons.phone_android_rounded,
                'split': Icons.call_split_rounded,
              };
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 6),
                  child: GestureDetector(
                    onTap: () => onPaymentMethodChanged(method),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppColors.primaryGlow
                            : AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : AppColors.border,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Column(
                        children: [
                          Icon(icons[method]!,
                              size: 20,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textMuted),
                          SizedBox(height: 4),
                          Text(
                            method.toUpperCase(),
                            style: GoogleFonts.manrope(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.textMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          if (paymentMethod == 'cash') ...[
            SizedBox(height: 16),
            NbInput(
              controller: cashController,
              type: NbInputType.number,
              onChanged: onCashChanged,
              hintText: 'Cash Received (Rs)',
              prefixIcon: Icons.money_rounded,
            ),
            if (change > 0) ...[
              SizedBox(height: 8),
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.success.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: AppColors.success.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    Icon(Icons.change_circle_outlined,
                        color: AppColors.success, size: 18),
                    SizedBox(width: 8),
                    Text('Change: ${Fmt.currency(change)}',
                        style: GoogleFonts.manrope(
                            fontWeight: FontWeight.w700,
                            color: AppColors.success,
                            fontSize: 14)),
                  ],
                ),
              ),
            ],
          ] else if (paymentMethod == 'split') ...[
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: NbInput(
                    controller: splitCashController,
                    type: NbInputType.number,
                    onChanged: onSplitCashChanged,
                    hintText: 'Cash Paid (Rs)',
                    prefixIcon: Icons.money_rounded,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Online Paid', style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted)),
                        const SizedBox(height: 2),
                        Text(
                          '₹${splitOnline.toStringAsFixed(2)}',
                          style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (splitOnline > 0) ...[
              const SizedBox(height: 12),
              Center(
                child: _UpiQrWidget(
                  amount: splitOnline,
                ),
              ),
            ],
          ] else if (paymentMethod == 'upi') ...[
            if (total > 0) ...[
              const SizedBox(height: 16),
              Center(
                child: _UpiQrWidget(
                  amount: total,
                ),
              ),
            ],
          ],

          SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: NbButton(
              onPressed: isPrinting ? null : onPrintAndPay,
              icon: Icons.print_rounded,
              text: isPrinting ? 'Printing & Saving...' : 'Print & Free Table',
              type: NbButtonType.primary,
              isLoading: isPrinting,
            ),
          ),
          
          SizedBox(height: 12),
          
          SizedBox(
            width: double.infinity,
            child: NbButton(
              onPressed: onFreeTable,
              icon: Icons.check_circle_outline,
              text: 'Free Without Printing',
              type: NbButtonType.danger,
            ),
          ),
          const SizedBox(height: 16),
          Center(
            child: Text(
              'Shortcuts: Ctrl+P to Print  |  Ctrl+F to Free Only',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(
                fontSize: 10,
                color: AppColors.textMuted,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Text(label,
              style: GoogleFonts.inter(
                  fontSize: 13, color: AppColors.textSecondary)),
          const Spacer(),
          Text(value,
              style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary)),
        ],
      ),
    );
  }
}

class _UpiQrWidget extends StatelessWidget {
  final double amount;

  const _UpiQrWidget({required this.amount});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox();
        final prefs = snap.data!;
        final upiId = (prefs.getString('upi_id') ?? '').trim();
        final hotelName = prefs.getString('hotel_name') ?? 'NextBills';
        final soundboxTr = (prefs.getString('soundbox_tr') ?? '').trim();

        if (upiId.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Text(
              'Configure UPI ID in Settings to display live QR code',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
            ),
          );
        }

        final payeeName = soundboxTr.isNotEmpty ? soundboxTr : hotelName;
        final upiUri = 'upi://pay?pa=$upiId&pn=${Uri.encodeComponent(payeeName)}&am=${amount.toStringAsFixed(2)}&cu=INR${soundboxTr.isNotEmpty ? '&tr=${Uri.encodeComponent(soundboxTr)}' : ''}';

        final qrCode = QrCode.fromData(data: upiUri, errorCorrectLevel: QrErrorCorrectLevel.M);
        final qrImage = QrImage(qrCode);

        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomPaint(
                size: const Size(140, 140),
                painter: _QrPainter(qrImage),
              ),
              const SizedBox(height: 8),
              Text(
                'Scan to Pay ₹${amount.toStringAsFixed(2)} via UPI',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _QrPainter extends CustomPainter {
  final QrImage qrImage;
  _QrPainter(this.qrImage);

  @override
  void paint(Canvas canvas, Size size) {
    final double moduleSize = size.width / qrImage.moduleCount;
    final paint = Paint()..color = Colors.black;
    final bgPaint = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), bgPaint);

    for (int x = 0; x < qrImage.moduleCount; x++) {
      for (int y = 0; y < qrImage.moduleCount; y++) {
        if (qrImage.isDark(y, x)) {
          canvas.drawRect(
            Rect.fromLTWH(x * moduleSize, y * moduleSize, moduleSize, moduleSize),
            paint,
          );
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
