import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  late DateTimeRange _dateRange;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 6)),
      end: now,
    );
  }

  Future<void> _exportPdfReport(
    BuildContext context,
    List<Bill> bills,
    double totalRevenue,
    double avgTicket,
    List<MapEntry<String, int>> topSelling,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final hotelName = prefs.getString('hotel_name') ?? 'NextBills Restaurant';
      final hotelAddress = prefs.getString('hotel_address') ?? '';
      final hotelPhone = prefs.getString('hotel_phone') ?? '';
      final gstin = prefs.getString('gstin_number') ?? '';

      final pdf = pw.Document();
      final dateStr = '${_dateRange.start.day}/${_dateRange.start.month}/${_dateRange.start.year} - ${_dateRange.end.day}/${_dateRange.end.month}/${_dateRange.end.year}';

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          build: (pw.Context ctx) {
            return [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(hotelName, style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
                      if (gstin.isNotEmpty) pw.Text('GSTIN: $gstin', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
                      if (hotelAddress.isNotEmpty) pw.Text(hotelAddress, style: const pw.TextStyle(fontSize: 10)),
                      if (hotelPhone.isNotEmpty) pw.Text('Tel: $hotelPhone', style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text('SALES REPORT', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.indigo900)),
                      pw.Text('Date Range: $dateStr', style: const pw.TextStyle(fontSize: 10)),
                      pw.Text('Generated: ${DateTime.now().toString().substring(0, 16)}', style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                    ],
                  ),
                ],
              ),
              pw.SizedBox(height: 14),
              pw.Divider(thickness: 1, color: PdfColors.grey300),
              pw.SizedBox(height: 14),

              // Executive Summary Cards
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius: pw.BorderRadius.circular(8),
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                  children: [
                    pw.Column(
                      children: [
                        pw.Text('Total Revenue', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                        pw.SizedBox(height: 4),
                        pw.Text('Rs ${totalRevenue.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.green800)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('Total Bills', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                        pw.SizedBox(height: 4),
                        pw.Text('${bills.length}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                      ],
                    ),
                    pw.Column(
                      children: [
                        pw.Text('Avg Order Value', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                        pw.SizedBox(height: 4),
                        pw.Text('Rs ${avgTicket.toStringAsFixed(2)}', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.purple800)),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 16),

              // Top Selling Items Section
              if (topSelling.isNotEmpty) ...[
                pw.Text('Top Selling Items', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 6),
                pw.Table.fromTextArray(
                  headers: ['Rank', 'Item Name', 'Qty Sold'],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 9),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.indigo700),
                  cellStyle: const pw.TextStyle(fontSize: 8.5),
                  cellAlignment: pw.Alignment.centerLeft,
                  data: List.generate(topSelling.length, (i) {
                    return ['#${i + 1}', topSelling[i].key, '${topSelling[i].value}'];
                  }),
                ),
                pw.SizedBox(height: 16),
              ],

              // Detailed Sales Register Table
              pw.Text('Sales Register', style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Table.fromTextArray(
                headers: ['Bill #', 'Date / Time', 'Table', 'Pay Mode', 'Subtotal', 'Discount', 'Total'],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white, fontSize: 8.5),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.blueGrey800),
                cellStyle: const pw.TextStyle(fontSize: 8),
                cellAlignment: pw.Alignment.centerLeft,
                data: bills.map((b) {
                  final dtStr = b.createdAt.toString().substring(0, 16);
                  return [
                    '#${b.billNumber}',
                    dtStr,
                    'T-${b.tableLabel}',
                    b.paymentMethod.toUpperCase(),
                    'Rs ${b.subtotal.toStringAsFixed(2)}',
                    '- Rs ${b.discount.toStringAsFixed(2)}',
                    'Rs ${b.total.toStringAsFixed(2)}',
                  ];
                }).toList(),
              ),

              pw.SizedBox(height: 20),
              pw.Divider(thickness: 0.5, color: PdfColors.grey400),
              pw.Center(
                child: pw.Text('Generated by NextBills POS System', style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey600)),
              ),
            ];
          },
        ),
      );

      final pdfBytes = await pdf.save();

      if (Platform.isWindows) {
        final outputFile = await FilePicker.platform.saveFile(
          dialogTitle: 'Save Sales Report PDF',
          fileName: 'NextBills_SalesReport_${DateTime.now().millisecondsSinceEpoch}.pdf',
          type: FileType.custom,
          allowedExtensions: ['pdf'],
        );

        if (outputFile != null) {
          final file = File(outputFile);
          await file.writeAsBytes(pdfBytes);
          if (context.mounted) {
            NbToast.show(context, 'PDF Report exported successfully!', type: NbToastType.success);
          }
        }
      } else {
        final tempDir = await getTemporaryDirectory();
        final fileName = 'NextBills_SalesReport_${DateTime.now().millisecondsSinceEpoch}.pdf';
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(pdfBytes);

        await Share.shareXFiles(
          [XFile(file.path, mimeType: 'application/pdf')],
          subject: 'NextBills Sales Report PDF',
          text: 'NextBills Sales Report PDF',
        );
        if (context.mounted) {
          NbToast.show(context, 'PDF Report ready to view/share!', type: NbToastType.success);
        }
      }
    } catch (e) {
      if (context.mounted) {
        NbToast.show(context, 'Failed to export PDF: $e', type: NbToastType.error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final db = ref.watch(databaseProvider);

    return FutureBuilder<List<Bill>>(
      future: db.getBillsForDateRange(_dateRange.start, _dateRange.end),
      builder: (context, snap) {
        if (!snap.hasData) {
          return Scaffold(
            backgroundColor: AppColors.bg,
            appBar: const NbAppBar(
              title: 'Reports & Analytics',
              showBack: true,
            ),
            body: const Center(child: NbLoadingPulse()),
          );
        }
        final bills = snap.data!;
        final totalRevenue = bills.fold<double>(0, (s, b) => s + b.total);
        final avgTicket = bills.isEmpty ? 0.0 : totalRevenue / bills.length;

        // Process top selling items
        final Map<String, int> itemCounts = {};
        final Map<String, double> itemRevenues = {};
        
        for (final bill in bills) {
          try {
            final decoded = jsonDecode(bill.itemsJson);
            if (decoded is! List) continue;
            final items = decoded;
            for (final item in items) {
              final name = item['name'] as String;
              final qty = (item['qty'] as num).toInt();
              final price = (item['price'] as num).toDouble();
              itemCounts[name] = (itemCounts[name] ?? 0) + qty;
              itemRevenues[name] = (itemRevenues[name] ?? 0) + (qty * price);
            }
          } catch (_) {}
        }

        final sortedItems = itemCounts.entries.toList()
          ..sort((a, b) => b.value.compareTo(a.value));
        final topSelling = sortedItems.take(5).toList();

        return FutureBuilder<List<Expense>>(
          future: db.getExpensesInRange(
            DateTime(_dateRange.start.year, _dateRange.start.month, _dateRange.start.day, 0, 0, 0),
            DateTime(_dateRange.end.year, _dateRange.end.month, _dateRange.end.day, 23, 59, 59),
          ),
          builder: (context, expSnap) {
            final expensesList = expSnap.data ?? [];
            final totalExpenses = expensesList.fold<double>(0.0, (s, e) => s + e.amount);

            return StreamBuilder<List<StockWastageData>>(
              stream: db.watchStockWastage(),
              builder: (context, wastageSnap) {
                final wastageList = wastageSnap.data ?? [];
                final periodWastage = wastageList.where((w) =>
                    w.date.isAfter(_dateRange.start.subtract(const Duration(seconds: 1))) &&
                    w.date.isBefore(_dateRange.end.add(const Duration(days: 1)))).toList();
                final totalWastage = periodWastage.fold<double>(0.0, (s, w) => s + w.wastageCost);

                return FutureBuilder<double>(
                  future: _calculateTotalCogs(db, bills),
                  builder: (context, cogsSnap) {
                    final totalCogs = cogsSnap.data ?? 0.0;
                    final grossProfit = totalRevenue - totalCogs;
                    final netProfit = grossProfit - totalExpenses - totalWastage;

                    return Scaffold(
                      backgroundColor: AppColors.bg,
                      appBar: NbAppBar(
                        title: 'Reports & Analytics',
                        showBack: true,
                        actions: [
                          IconButton(
                            icon: Icon(Icons.picture_as_pdf_rounded, color: AppColors.primary),
                            onPressed: () => _exportPdfReport(context, bills, totalRevenue, avgTicket, topSelling),
                            tooltip: 'Export PDF Report',
                          ),
                          IconButton(
                            icon: const Icon(Icons.date_range_rounded),
                            onPressed: () => _selectDateRange(context),
                            tooltip: 'Filter by Date Range',
                          ),
                        ],
                      ),
                      body: ListView(
                        padding: const EdgeInsets.all(16),
                        children: [
                          // Header
                          _DateRangeHeader(dateRange: _dateRange),
                          const SizedBox(height: 16),

                          // Net Profitability Banner
                          Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: netProfit >= 0
                                    ? [AppColors.success, AppColors.success.withBlue(180)]
                                    : [AppColors.error, AppColors.error.withRed(180)],
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Net Profit (Selected Period)',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.85), fontSize: 13, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      Fmt.currency(netProfit),
                                      style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Sales: ${Fmt.currency(totalRevenue)}  •  COGS: ${Fmt.currency(totalCogs)}  •  Expenses: ${Fmt.currency(totalExpenses)}  •  Wastage: ${Fmt.currency(totalWastage)}',
                                      style: TextStyle(color: Colors.white.withValues(alpha: 0.9), fontSize: 11),
                                    ),
                                  ],
                                ),
                                Icon(
                                  netProfit >= 0 ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                                  color: Colors.white,
                                  size: 48,
                                ),
                              ],
                            ),
                          ),
                      const SizedBox(height: 16),

                      // Summary KPIs
                      Row(
                        children: [
                          Expanded(
                            child: _StatCard(
                              label: 'Total Revenue',
                              value: Fmt.currency(totalRevenue),
                              icon: Icons.account_balance_wallet_rounded,
                              color: AppColors.success,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'COGS Stock Cost',
                              value: Fmt.currency(totalCogs),
                              icon: Icons.inventory_2_rounded,
                              color: AppColors.warning,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Overhead Expenses',
                              value: Fmt.currency(totalExpenses),
                              icon: Icons.receipt_rounded,
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _StatCard(
                              label: 'Avg Ticket',
                              value: Fmt.currency(avgTicket),
                              icon: Icons.trending_up_rounded,
                              color: AppColors.info,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

              // Revenue Chart
              if (bills.isNotEmpty && _dateRange.duration.inDays > 0) ...[
                const _SectionLabel('Revenue Trend'),
                const SizedBox(height: 12),
                _RevenueChartCard(bills: bills, dateRange: _dateRange),
                const SizedBox(height: 24),
              ],

              // Top Selling Items
              if (topSelling.isNotEmpty) ...[
                const _SectionLabel('Top Selling Items'),
                const SizedBox(height: 12),
                _TopSellingCard(topSelling: topSelling, itemRevenues: itemRevenues),
                const SizedBox(height: 24),
              ],

              // Payment Methods
              if (bills.isNotEmpty) ...[
                const _SectionLabel('Payment Methods'),
                const SizedBox(height: 12),
                _PaymentBreakdown(bills: bills),
                const SizedBox(height: 24),
              ],

                          // Raw Order History
                          const _SectionLabel('Order History'),
                          const SizedBox(height: 12),
                          if (bills.isEmpty)
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.all(40),
                                child: Column(
                                  children: [
                                    Icon(Icons.history_rounded, size: 48, color: AppColors.textMuted.withValues(alpha: 0.5)),
                                    const SizedBox(height: 12),
                                    Text('No revenue data for this range',
                                        style: GoogleFonts.inter(color: AppColors.textMuted)),
                                  ],
                                ),
                              ),
                            )
                          else
                            ...bills.map((bill) => _BillListItem(bill: bill)),
                        ],
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  Future<double> _calculateTotalCogs(AppDatabase db, List<Bill> bills) async {
    double totalCogs = 0.0;
    try {
      final allMenuItems = await db.getAllMenuItems();
      final menuMap = <String, MenuItem>{for (var m in allMenuItems) m.name.toLowerCase().trim(): m};

      for (final bill in bills) {
        try {
          final decoded = jsonDecode(bill.itemsJson);
          if (decoded is! List) continue;
          for (final item in decoded) {
            final rawName = (item['name'] as String? ?? '').trim();
            final qty = (item['qty'] as num? ?? 0).toInt();
            final variant = (item['itemSize'] as String? ?? item['size'] as String? ?? 'full').trim();
            if (rawName.isEmpty || qty <= 0) continue;

            MenuItem? menuItem = menuMap[rawName.toLowerCase()];

            // Fallback matching if item name has variant appended (e.g. "Chicken Curry (Half)")
            if (menuItem == null) {
              final cleanedName = rawName.split('(').first.trim().toLowerCase();
              menuItem = menuMap[cleanedName];
            }

            if (menuItem != null) {
              final costPerUnit = await db.getMenuItemCostPrice(menuItem.id, variant.isEmpty ? 'full' : variant);
              totalCogs += costPerUnit * qty;
            }
          }
        } catch (_) {}
      }
    } catch (_) {}
    return totalCogs;
  }

  Future<void> _selectDateRange(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.primary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }
}

class _DateRangeHeader extends StatelessWidget {
  final DateTimeRange dateRange;
  const _DateRangeHeader({required this.dateRange});

  @override
  Widget build(BuildContext context) {
    final isSingleDay = dateRange.start.year == dateRange.end.year &&
        dateRange.start.month == dateRange.end.month &&
        dateRange.start.day == dateRange.end.day;

    final text = isSingleDay
        ? Fmt.date(dateRange.start)
        : '${Fmt.date(dateRange.start)}  -  ${Fmt.date(dateRange.end)}';

    return Row(
      children: [
        Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 22),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.04),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 16),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _RevenueChartCard extends StatelessWidget {
  final List<Bill> bills;
  final DateTimeRange dateRange;

  const _RevenueChartCard({required this.bills, required this.dateRange});

  @override
  Widget build(BuildContext context) {
    // Group bills by day
    final Map<int, double> dailyRevenue = {};
    final totalDays = dateRange.duration.inDays + 1;
    
    for (int i = 0; i < totalDays; i++) {
        dailyRevenue[i] = 0.0;
    }

    for (var bill in bills) {
      final diff = bill.createdAt.difference(dateRange.start).inDays;
      if (diff >= 0 && diff <= dateRange.duration.inDays) {
        dailyRevenue[diff] = (dailyRevenue[diff] ?? 0) + bill.total;
      }
    }

    final spots = dailyRevenue.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList();
        
    double rawMaxY = dailyRevenue.values.fold<double>(0, (m, v) => v > m ? v : m);
    if (rawMaxY.isNaN || rawMaxY.isInfinite) rawMaxY = 0;
    final maxY = rawMaxY == 0 ? 100.0 : rawMaxY * 1.2;
    final horizontalInterval = maxY / 4;

    return Container(
      height: 220,
      padding: const EdgeInsets.only(top: 24, right: 24, left: 12, bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: horizontalInterval < 1 ? 1 : horizontalInterval,
            getDrawingHorizontalLine: (value) => FlLine(
              color: AppColors.border.withValues(alpha: 0.5),
              strokeWidth: 1,
              dashArray: [5, 5],
            ),
          ),
          titlesData: FlTitlesData(
            show: true,
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                interval: (totalDays / 5).ceilToDouble(),
                getTitlesWidget: (value, meta) {
                  if (value.toInt() < 0 || value.toInt() >= totalDays) return const SizedBox();
                  final d = dateRange.start.add(Duration(days: value.toInt()));
                  return Text(
                    '${d.day}/${d.month}',
                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                  );
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                interval: horizontalInterval < 1 ? 1 : horizontalInterval,
                reservedSize: 42,
                getTitlesWidget: (value, meta) {
                  return Text(
                    Fmt.currencyShort(value),
                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                  );
                },
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          minX: 0,
          maxX: (totalDays - 1).toDouble(),
          minY: 0,
          maxY: maxY == 0 ? 100 : maxY,
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: totalDays <= 14),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TopSellingCard extends StatelessWidget {
  final List<MapEntry<String, int>> topSelling;
  final Map<String, double> itemRevenues;

  const _TopSellingCard({required this.topSelling, required this.itemRevenues});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: topSelling.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;
          final revenue = itemRevenues[item.key] ?? 0.0;
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: AppColors.primary.withValues(alpha: 0.1),
              radius: 16,
              child: Text(
                '#${index + 1}',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                ),
              ),
            ),
            title: Text(
              item.key,
              style: GoogleFonts.inter(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            subtitle: Text(
              '${item.value} units sold',
              style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
            ),
            trailing: Text(
              Fmt.currency(revenue),
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppColors.success),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PaymentBreakdown extends StatelessWidget {
  final List<Bill> bills;
  const _PaymentBreakdown({required this.bills});

  @override
  Widget build(BuildContext context) {
    final cashTotal = bills.fold<double>(0, (s, b) {
      if (b.paymentMethod == 'cash') return s + b.total;
      if (b.paymentMethod == 'split') return s + b.splitCash;
      return s;
    });
    final cardTotal = bills.fold<double>(0, (s, b) {
      if (b.paymentMethod == 'card') return s + b.total;
      return s;
    });
    final upiTotal = bills.fold<double>(0, (s, b) {
      if (b.paymentMethod == 'upi') return s + b.total;
      if (b.paymentMethod == 'split') return s + b.splitOnline;
      return s;
    });

    return Row(
      children: [
        _PaymentChip('Cash', cashTotal, Icons.money_rounded, AppColors.success),
        const SizedBox(width: 8),
        _PaymentChip('Card', cardTotal, Icons.credit_card_rounded, AppColors.info),
        const SizedBox(width: 8),
        _PaymentChip('UPI', upiTotal, Icons.phone_android_rounded, const Color(0xFFF59E0B)),
      ],
    );
  }
}

class _PaymentChip extends StatelessWidget {
  final String label;
  final double amount;
  final IconData icon;
  final Color color;

  const _PaymentChip(this.label, this.amount, this.icon, this.color);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 8),
            Text(
              Fmt.currencyShort(amount),
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            Text(label,
                style: GoogleFonts.inter(
                    fontSize: 11, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _BillListItem extends StatelessWidget {
  final Bill bill;
  const _BillListItem({required this.bill});

  void _showDetails(BuildContext context) {
    List<dynamic> items = [];
    try {
      items = jsonDecode(bill.itemsJson);
    } catch (_) {}
    
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order Details — Table ${bill.tableLabel}${bill.billNumber != null ? ' (Bill #${bill.billNumber})' : ''}',
                style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
            Text('${Fmt.date(bill.createdAt)} at ${Fmt.time(bill.createdAt)}', 
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
            const SizedBox(height: 16),
            Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (context, i) {
                  final item = items[i];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${item['qty']}x ${item['name']}',
                            style: GoogleFonts.inter(color: AppColors.textPrimary)),
                        Text(Fmt.currency(item['price'] * item['qty']),
                            style: GoogleFonts.inter(fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
                      ],
                    ),
                  );
                },
              ),
            ),
            Divider(height: 32, color: AppColors.border),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  bill.paymentMethod == 'split'
                      ? 'SPLIT (Cash: ₹${bill.splitCash.toStringAsFixed(0)} | Online: ₹${bill.splitOnline.toStringAsFixed(0)})'
                      : 'Total Paid via ${bill.paymentMethod.toUpperCase()}',
                  style: GoogleFonts.inter(color: AppColors.textMuted),
                ),
                Text(Fmt.currency(bill.total),
                    style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.primary)),
              ],
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final methodIcons = {
      'cash': Icons.money_rounded,
      'card': Icons.credit_card_rounded,
      'upi': Icons.phone_android_rounded,
      'split': Icons.call_split_rounded,
    };

    return GestureDetector(
      onTap: () => _showDetails(context),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                methodIcons[bill.paymentMethod] ?? Icons.payment_rounded,
                color: AppColors.success,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Table ${bill.tableLabel}${bill.billNumber != null ? ' • Bill #${bill.billNumber}' : ''}',
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '${Fmt.date(bill.createdAt)} • ${Fmt.time(bill.createdAt)}',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  Fmt.currency(bill.total),
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  bill.paymentMethod == 'split'
                      ? 'SPLIT (Cash ₹${bill.splitCash.toStringAsFixed(0)} • UPI ₹${bill.splitOnline.toStringAsFixed(0)})'
                      : bill.paymentMethod.toUpperCase(),
                  style: GoogleFonts.inter(
                      fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ],
        ),
      )
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        text.toUpperCase(),
        style: GoogleFonts.manrope(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
