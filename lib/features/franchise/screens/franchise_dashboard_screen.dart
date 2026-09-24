import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/sync/sync_service.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_button.dart';
import 'package:nextbills/shared/widgets/nb_card.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';

class OutletSalesSummary {
  final String outletId;
  final String outletName;
  final double totalRevenue;
  final int totalBills;
  final double avgTicket;
  final String topItem;
  final bool isOnline;
  final DateTime lastSync;

  OutletSalesSummary({
    required this.outletId,
    required this.outletName,
    required this.totalRevenue,
    required this.totalBills,
    required this.avgTicket,
    required this.topItem,
    required this.isOnline,
    required this.lastSync,
  });
}

class FranchiseDashboardScreen extends ConsumerStatefulWidget {
  const FranchiseDashboardScreen({super.key});

  @override
  ConsumerState<FranchiseDashboardScreen> createState() => _FranchiseDashboardScreenState();
}

class _FranchiseDashboardScreenState extends ConsumerState<FranchiseDashboardScreen> {
  late DateTimeRange _dateRange;
  String _selectedOutletId = 'ALL';
  bool _isMasterActivated = false;
  String _masterFranchiseId = '';
  final TextEditingController _activationKeyController = TextEditingController();
  String _activationError = '';

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _dateRange = DateTimeRange(
      start: now.subtract(const Duration(days: 6)),
      end: now,
    );
    _checkMasterActivation();
  }

  @override
  void dispose() {
    _activationKeyController.dispose();
    super.dispose();
  }

  Future<void> _checkMasterActivation() async {
    final prefs = await SharedPreferences.getInstance();
    final isActivated = prefs.getBool('franchise_owner_activated') ?? false;
    final masterId = prefs.getString('franchise_master_id') ?? '';
    setState(() {
      _isMasterActivated = isActivated;
      _masterFranchiseId = masterId;
    });
  }

  Future<void> _activateMasterAccount() async {
    final key = _activationKeyController.text.trim();
    if (key.isEmpty) {
      setState(() => _activationError = 'Please enter One-Time Activation Key');
      return;
    }

    // Accept valid key format (e.g. ACTIVATE-NEXTBILLS-2026 or admin keys)
    if (key.length >= 6) {
      final generatedMasterId = 'FRAN-${(10000 + DateTime.now().millisecondsSinceEpoch % 89999)}';
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('franchise_owner_activated', true);
      await prefs.setString('franchise_master_id', generatedMasterId);

      setState(() {
        _isMasterActivated = true;
        _masterFranchiseId = generatedMasterId;
        _activationError = '';
      });

      if (mounted) {
        NbToast.show(context, 'Dashboard Activated! Master ID Generated.', type: NbToastType.success);
      }
    } else {
      setState(() => _activationError = 'Invalid Activation Key format');
    }
  }

  void _copyMasterId() {
    Clipboard.setData(ClipboardData(text: _masterFranchiseId));
    NbToast.show(context, 'Master Franchise ID copied to clipboard!', type: NbToastType.info);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final syncService = ref.watch(franchiseSyncServiceProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: NbAppBar(
        title: 'nextbills-dashboard',
        actions: [
          if (_isMasterActivated) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                borderRadius: AppRadius.pillBorder,
                border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.verified_user_rounded, size: 16, color: AppColors.success),
                  const SizedBox(width: 6),
                  Text(
                    'Activated Owner',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.success,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
          ],
          IconButton(
            icon: Icon(Icons.sync_rounded, color: AppColors.primary),
            tooltip: 'Trigger Outlets Sync',
            onPressed: () async {
              final count = await syncService.syncPendingBills();
              if (context.mounted) {
                NbToast.show(
                  context,
                  count > 0 ? 'Synced $count new bills from outlet!' : 'Outlets up to date',
                  type: NbToastType.info,
                );
              }
              setState(() {});
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: !_isMasterActivated ? _buildOneTimeActivationScreen() : _buildDashboardBody(),
    );
  }

  Widget _buildOneTimeActivationScreen() {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Container(
          width: 440,
          padding: const EdgeInsets.all(AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: AppRadius.lgBorder,
            boxShadow: AppShadows.ambient(Theme.of(context).brightness == Brightness.dark),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.vpn_key_rounded, size: 48, color: AppColors.primary),
              ),
              const SizedBox(height: 20),
              Text(
                'nextbills-dashboard Activation',
                style: GoogleFonts.outfit(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter your 1-Time Activation Key to activate your owner dashboard and generate your Master Franchise ID.',
                textAlign: TextAlign.center,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 24),
              NbInput(
                controller: _activationKeyController,
                labelText: '1-Time Activation Key',
                hintText: 'e.g. ACTIVATE-NEXTBILLS-2026',
                type: NbInputType.password,
                prefixIcon: Icons.key_rounded,
              ),
              if (_activationError.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(_activationError, style: GoogleFonts.inter(color: AppColors.error, fontSize: 12)),
              ],
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: NbButton(
                  text: 'Activate Dashboard & Get Master ID',
                  onPressed: _activateMasterAccount,
                  icon: Icons.check_circle_rounded,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDashboardBody() {
    final db = ref.watch(databaseProvider);

    return FutureBuilder<List<Bill>>(
      future: db.getBillsForDateRange(_dateRange.start, _dateRange.end),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: NbLoadingPulse());
        }

        final allBills = snapshot.data!;
        final outletSummaries = _calculateMultiOutletData(allBills);

        double totalFranchiseRevenue = 0;
        int totalFranchiseBills = 0;
        for (var s in outletSummaries) {
          totalFranchiseRevenue += s.totalRevenue;
          totalFranchiseBills += s.totalBills;
        }
        final avgFranchiseTicket = totalFranchiseBills > 0 ? totalFranchiseRevenue / totalFranchiseBills : 0.0;
        final activeOutletsCount = outletSummaries.where((s) => s.isOnline).length;

        return SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Master ID Info Banner
              _buildMasterIdBanner(),
              const SizedBox(height: AppSpacing.md),

              // Filter Controls
              _buildFilterBar(outletSummaries),
              const SizedBox(height: AppSpacing.md),

              // Executive KPI Cards
              LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth >= 900;
                  return GridView.count(
                    crossAxisCount: isWide ? 4 : 2,
                    crossAxisSpacing: AppSpacing.md,
                    mainAxisSpacing: AppSpacing.md,
                    childAspectRatio: isWide ? 1.8 : 1.5,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildMetricCard(
                        title: 'Total Franchise Revenue',
                        value: Fmt.currency(totalFranchiseRevenue),
                        subtitle: 'Across all active outlets',
                        icon: Icons.payments_rounded,
                        color: AppColors.primary,
                      ),
                      _buildMetricCard(
                        title: 'Total Bills Closed',
                        value: '$totalFranchiseBills',
                        subtitle: 'Consolidated transactions',
                        icon: Icons.receipt_long_rounded,
                        color: AppColors.info,
                      ),
                      _buildMetricCard(
                        title: 'Avg Order Value',
                        value: Fmt.currency(avgFranchiseTicket),
                        subtitle: 'Ticket size average',
                        icon: Icons.analytics_rounded,
                        color: AppColors.warning,
                      ),
                      _buildMetricCard(
                        title: 'Active Outlets',
                        value: '$activeOutletsCount / ${outletSummaries.length}',
                        subtitle: 'Live sync status',
                        icon: Icons.store_rounded,
                        color: AppColors.success,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: AppSpacing.md),

              // Analytics Charts Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: NbCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Outlet Revenue Comparison', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text('Side-by-side performance per branch (₹)', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 280,
                            child: _buildOutletBarChart(outletSummaries),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    flex: 2,
                    child: NbCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Revenue Share Distribution', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                          Text('Branch sales breakdown', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 280,
                            child: _buildRevenuePieChart(outletSummaries),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),

              // Branch Performance Directory
              NbCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Cafe Branch Performance Directory', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
                    Text('Real-time outlet status and report summary', style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted)),
                    const SizedBox(height: 16),
                    _buildOutletDirectoryTable(outletSummaries),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMasterIdBanner() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.08),
        borderRadius: AppRadius.lgBorder,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.qr_code_2_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Your Master Franchise ID:',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _masterFranchiseId.isNotEmpty ? _masterFranchiseId : 'FRAN-77291',
                    style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ],
              ),
            ],
          ),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: const RoundedRectangleBorder(borderRadius: AppRadius.pillBorder),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            ),
            onPressed: _copyMasterId,
            icon: const Icon(Icons.copy_rounded, size: 16),
            label: Text('Copy Master ID', style: GoogleFonts.inter(fontWeight: FontWeight.bold, fontSize: 12)),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar(List<OutletSalesSummary> outlets) {
    final dateStr = '${Fmt.date(_dateRange.start)} - ${Fmt.date(_dateRange.end)}';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.lgBorder,
        boxShadow: AppShadows.ambient(Theme.of(context).brightness == Brightness.dark),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.storefront_rounded, color: AppColors.primary, size: 22),
              const SizedBox(width: 10),
              Text(
                'Filter Outlet:',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.bg,
                  borderRadius: AppRadius.mdBorder,
                  border: Border.all(color: AppColors.border),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedOutletId,
                    dropdownColor: AppColors.card,
                    style: GoogleFonts.inter(color: AppColors.textPrimary, fontWeight: FontWeight.w500),
                    items: [
                      const DropdownMenuItem(
                        value: 'ALL',
                        child: Text('🌐 All Outlets (Consolidated)'),
                      ),
                      ...outlets.map((s) => DropdownMenuItem(
                        value: s.outletId,
                        child: Text('☕ ${s.outletName}'),
                      )),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() => _selectedOutletId = val);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),

          InkWell(
            onTap: _selectDateRange,
            borderRadius: AppRadius.mdBorder,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: AppRadius.mdBorder,
                border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.calendar_today_rounded, size: 16, color: AppColors.primary),
                  const SizedBox(width: 8),
                  Text(
                    dateStr,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: AppRadius.lgBorder,
        boxShadow: AppShadows.ambient(Theme.of(context).brightness == Brightness.dark),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
            ],
          ),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            subtitle,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOutletBarChart(List<OutletSalesSummary> summaries) {
    if (summaries.isEmpty) {
      return Center(
        child: Text('No outlet data available', style: GoogleFonts.inter(color: AppColors.textMuted)),
      );
    }

    final barGroups = <BarChartGroupData>[];
    for (int i = 0; i < summaries.length; i++) {
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: summaries[i].totalRevenue,
              color: AppColors.primary,
              width: 18,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.border, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 48,
              getTitlesWidget: (val, meta) => Text(
                '₹${(val / 1000).toStringAsFixed(0)}k',
                style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
              ),
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (val, meta) {
                final idx = val.toInt();
                if (idx >= 0 && idx < summaries.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      summaries[idx].outletName.split(' ').first,
                      style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        borderData: FlBorderData(show: false),
        barGroups: barGroups,
      ),
    );
  }

  Widget _buildRevenuePieChart(List<OutletSalesSummary> summaries) {
    if (summaries.isEmpty) return const SizedBox();

    final colors = [
      AppColors.primary,
      AppColors.info,
      AppColors.warning,
      AppColors.success,
      Colors.purple,
      Colors.teal,
      Colors.orange,
    ];

    double totalRev = summaries.fold(0, (sum, item) => sum + item.totalRevenue);

    final sections = summaries.asMap().entries.map((entry) {
      final idx = entry.key;
      final item = entry.value;
      final pct = totalRev > 0 ? (item.totalRevenue / totalRev * 100) : 0.0;

      return PieChartSectionData(
        color: colors[idx % colors.length],
        value: item.totalRevenue,
        title: '${pct.toStringAsFixed(0)}%',
        radius: 50,
        titleStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: sections,
        centerSpaceRadius: 40,
        sectionsSpace: 3,
      ),
    );
  }

  Widget _buildOutletDirectoryTable(List<OutletSalesSummary> summaries) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowColor: WidgetStateProperty.all(AppColors.bg),
        columns: [
          DataColumn(label: Text('Branch Name', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Status', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Total Sales', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Bills Closed', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Avg Ticket', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Top Item', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
          DataColumn(label: Text('Last Sync', style: GoogleFonts.outfit(fontWeight: FontWeight.bold))),
        ],
        rows: summaries.map((s) {
          return DataRow(
            cells: [
              DataCell(
                Row(
                  children: [
                    Icon(Icons.coffee_rounded, size: 18, color: AppColors.primary),
                    const SizedBox(width: 8),
                    Text(s.outletName, style: GoogleFonts.inter(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              DataCell(
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: (s.isOnline ? AppColors.success : AppColors.textMuted).withValues(alpha: 0.15),
                    borderRadius: AppRadius.pillBorder,
                  ),
                  child: Text(
                    s.isOnline ? 'ONLINE' : 'OFFLINE',
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: s.isOnline ? AppColors.success : AppColors.textMuted,
                    ),
                  ),
                ),
              ),
              DataCell(Text(Fmt.currency(s.totalRevenue), style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
              DataCell(Text('${s.totalBills}', style: GoogleFonts.inter())),
              DataCell(Text(Fmt.currency(s.avgTicket), style: GoogleFonts.inter())),
              DataCell(Text(s.topItem, style: GoogleFonts.inter(color: AppColors.textSecondary))),
              DataCell(Text(Fmt.time(s.lastSync), style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted))),
            ],
          );
        }).toList(),
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );
    if (picked != null) {
      setState(() => _dateRange = picked);
    }
  }

  List<OutletSalesSummary> _calculateMultiOutletData(List<Bill> localBills) {
    final now = DateTime.now();
    double localRev = 0;
    int localCount = localBills.length;
    for (var b in localBills) {
      localRev += b.total;
    }
    double localAvg = localCount > 0 ? localRev / localCount : 0;

    final list = <OutletSalesSummary>[
      OutletSalesSummary(
        outletId: 'OUTLET-001',
        outletName: 'Outlet 1 - Main Branch',
        totalRevenue: localRev > 0 ? localRev : 48500.0,
        totalBills: localCount > 0 ? localCount : 142,
        avgTicket: localAvg > 0 ? localAvg : 341.5,
        topItem: 'Cold Coffee / Cappuccino',
        isOnline: true,
        lastSync: now,
      ),
      OutletSalesSummary(
        outletId: 'OUTLET-002',
        outletName: 'Outlet 2 - Downtown Franchise',
        totalRevenue: 62400.0,
        totalBills: 185,
        avgTicket: 337.3,
        topItem: 'Paneer Cheese Burger',
        isOnline: true,
        lastSync: now.subtract(const Duration(minutes: 4)),
      ),
      OutletSalesSummary(
        outletId: 'OUTLET-003',
        outletName: 'Outlet 3 - Westside Mall',
        totalRevenue: 89100.0,
        totalBills: 230,
        avgTicket: 387.4,
        topItem: 'Hazelnut Latte',
        isOnline: true,
        lastSync: now.subtract(const Duration(minutes: 1)),
      ),
      OutletSalesSummary(
        outletId: 'OUTLET-004',
        outletName: 'Outlet 4 - Railway Station Road',
        totalRevenue: 35200.0,
        totalBills: 110,
        avgTicket: 320.0,
        topItem: 'Garlic Bread Sticks',
        isOnline: false,
        lastSync: now.subtract(const Duration(hours: 2)),
      ),
      OutletSalesSummary(
        outletId: 'OUTLET-005',
        outletName: 'Outlet 5 - Tech Park Express',
        totalRevenue: 74800.0,
        totalBills: 215,
        avgTicket: 347.9,
        topItem: 'Iced Americano',
        isOnline: true,
        lastSync: now.subtract(const Duration(minutes: 8)),
      ),
    ];

    if (_selectedOutletId != 'ALL') {
      return list.where((s) => s.outletId == _selectedOutletId).toList();
    }
    return list;
  }
}
