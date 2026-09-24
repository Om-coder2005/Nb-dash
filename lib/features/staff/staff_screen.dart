import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';


class StaffScreen extends ConsumerStatefulWidget {
  const StaffScreen({super.key});

  @override
  ConsumerState<StaffScreen> createState() => _StaffScreenState();
}

class _StaffScreenState extends ConsumerState<StaffScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
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
        title: 'Staff Management',
        showBack: true,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primary,
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textMuted,
          labelStyle: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 13),
          tabs: const [
            Tab(text: 'Attendance', icon: Icon(Icons.calendar_today_rounded, size: 18)),
            Tab(text: 'Payroll', icon: Icon(Icons.payments_rounded, size: 18)),
            Tab(text: 'Employees', icon: Icon(Icons.people_rounded, size: 18)),
            Tab(text: 'Categories', icon: Icon(Icons.badge_rounded, size: 18)),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _AttendanceTab(),
          _PayrollTab(),
          _EmployeesTab(),
          _CategoriesTab(),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// 1. ATTENDANCE TAB
// ────────────────────────────────────────────────────────────────

class _AttendanceTab extends ConsumerStatefulWidget {
  const _AttendanceTab();

  @override
  ConsumerState<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends ConsumerState<_AttendanceTab> {
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final categoriesAsync = ref.watch(_categoriesProvider);
    final staffAsync = ref.watch(_staffListProvider);

    return Column(
      children: [
        // Date Selector Bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary),
                onPressed: () {
                  setState(() => _selectedDate = _selectedDate.subtract(const Duration(days: 1)));
                },
              ),
              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
                child: Row(
                  children: [
                    Icon(Icons.calendar_month_rounded, color: AppColors.primary, size: 18),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat('EEE, d MMMM yyyy').format(_selectedDate),
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
                onPressed: () {
                  setState(() => _selectedDate = _selectedDate.add(const Duration(days: 1)));
                },
              ),
            ],
          ),
        ),

        // Attendance marking list
        Expanded(
          child: categoriesAsync.when(
            loading: () => const Center(child: NbLoadingPulse()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (categories) {
              return staffAsync.when(
                loading: () => const Center(child: NbLoadingPulse()),
                error: (err, _) => Center(child: Text('Error: $err')),
                data: (staffList) {
                  if (staffList.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.people_outline_rounded, size: 48, color: AppColors.textMuted),
                          const SizedBox(height: 12),
                          Text('No staff members added yet.', style: GoogleFonts.inter(color: AppColors.textMuted)),
                        ],
                      ),
                    );
                  }

                  return StreamBuilder<List<AttendanceData>>(
                    stream: db.watchAttendanceForDate(_selectedDate),
                    builder: (context, attendanceSnap) {
                      final attendanceList = attendanceSnap.data ?? [];
                      final attendanceMap = {for (var a in attendanceList) a.staffId: a};

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: categories.length,
                        itemBuilder: (context, catIdx) {
                          final category = categories[catIdx];
                          final catStaff = staffList.where((s) => s.categoryId == category.id).toList();

                          if (catStaff.isEmpty) return const SizedBox();

                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top: 8, bottom: 12, left: 4),
                                child: Text(
                                  category.name.toUpperCase(),
                                  style: GoogleFonts.manrope(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              ...catStaff.map((staff) {
                                final record = attendanceMap[staff.id];
                                final status = record?.status ?? 'absent';
                                final notes = record?.notes ?? '';

                                return _AttendanceStaffCard(
                                  staff: staff,
                                  status: status,
                                  notes: notes,
                                  onStatusChanged: (newStatus) async {
                                    HapticFeedback.lightImpact();
                                    await db.upsertAttendance(AttendanceCompanion.insert(
                                      staffId: staff.id,
                                      date: _selectedDate,
                                      status: Value(newStatus),
                                      notes: Value(notes),
                                    ));
                                  },
                                  onNotesChanged: (newNotes) async {
                                    await db.upsertAttendance(AttendanceCompanion.insert(
                                      staffId: staff.id,
                                      date: _selectedDate,
                                      status: Value(status),
                                      notes: Value(newNotes),
                                    ));
                                  },
                                );
                              }),
                              Divider(color: AppColors.border, height: 24),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _AttendanceStaffCard extends StatelessWidget {
  final StaffData staff;
  final String status;
  final String notes;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onNotesChanged;

  const _AttendanceStaffCard({
    required this.staff,
    required this.status,
    required this.notes,
    required this.onStatusChanged,
    required this.onNotesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      staff.name,
                      style: GoogleFonts.manrope(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      staff.payType == 'monthly'
                          ? 'Monthly: ${Fmt.currencyShort(staff.monthlySalary)}'
                          : 'Daily Wage',
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  notes.isNotEmpty ? Icons.note_rounded : Icons.note_add_outlined,
                  color: notes.isNotEmpty ? AppColors.primary : AppColors.textMuted,
                  size: 20,
                ),
                onPressed: () => _editNotesDialog(context),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Status buttons row
          Row(
            children: [
              _StatusButton(
                label: 'Present',
                activeColor: AppColors.success,
                isActive: status == 'present',
                onTap: () => onStatusChanged('present'),
              ),
              const SizedBox(width: 6),
              _StatusButton(
                label: 'Present/2',
                activeColor: AppColors.warning,
                isActive: status == 'half_day',
                onTap: () => onStatusChanged('half_day'),
              ),
              const SizedBox(width: 6),
              _StatusButton(
                label: 'Absent',
                activeColor: AppColors.error,
                isActive: status == 'absent',
                onTap: () => onStatusChanged('absent'),
              ),
              const SizedBox(width: 6),
              _StatusButton(
                label: 'Holiday',
                activeColor: AppColors.info,
                isActive: status == 'holiday',
                onTap: () => onStatusChanged('holiday'),
              ),
            ],
          ),
          if (notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Note: $notes',
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: AppColors.warning,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _editNotesDialog(BuildContext context) {
    final controller = TextEditingController(text: notes);
    showDialog(
      context: context,
      builder: (ctx) => NbDialog(
        title: 'Add Notes for ${staff.name}',
        customContent: NbInput(
          controller: controller,
          maxLines: 2,
          hintText: 'Enter attendance notes...',
        ),
        primaryButtonText: 'Save',
        onPrimary: () {
          onNotesChanged(controller.text.trim());
          Navigator.pop(ctx);
        },
        secondaryButtonText: 'Cancel',
        onSecondary: () => Navigator.pop(ctx),
      ),
    );
  }
}

class _StatusButton extends StatelessWidget {
  final String label;
  final Color activeColor;
  final bool isActive;
  final VoidCallback onTap;

  const _StatusButton({
    required this.label,
    required this.activeColor,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? activeColor.withValues(alpha: 0.15) : AppColors.surface,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isActive ? activeColor : AppColors.border,
              width: isActive ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 11,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              color: isActive ? activeColor : AppColors.textMuted,
            ),
          ),
        ),
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// 2. PAYROLL TAB
// ────────────────────────────────────────────────────────────────

class _PayrollTab extends ConsumerStatefulWidget {
  const _PayrollTab();

  @override
  ConsumerState<_PayrollTab> createState() => _PayrollTabState();
}

class _PayrollTabState extends ConsumerState<_PayrollTab> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final staffAsync = ref.watch(_staffListProvider);
    final categoriesAsync = ref.watch(_categoriesProvider);

    return Column(
      children: [
        // Month/Year Selector
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.surface,
            border: Border(bottom: BorderSide(color: AppColors.border)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary),
                onPressed: () {
                  setState(() {
                    if (_selectedMonth == 1) {
                      _selectedMonth = 12;
                      _selectedYear--;
                    } else {
                      _selectedMonth--;
                    }
                  });
                },
              ),
              const SizedBox(width: 16),
              Text(
                '${DateFormat('MMMM').format(DateTime(_selectedYear, _selectedMonth))} $_selectedYear',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
                onPressed: () {
                  setState(() {
                    if (_selectedMonth == 12) {
                      _selectedMonth = 1;
                      _selectedYear++;
                    } else {
                      _selectedMonth++;
                    }
                  });
                },
              ),
            ],
          ),
        ),

        // Payroll List
        Expanded(
          child: staffAsync.when(
            loading: () => const Center(child: NbLoadingPulse()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (staffList) {
              return categoriesAsync.when(
                loading: () => const Center(child: NbLoadingPulse()),
                error: (err, _) => Center(child: Text('Error: $err')),
                data: (categories) {
                  if (staffList.isEmpty) return const Center(child: Text('No staff members.'));

                  final catMap = {for (var c in categories) c.id: c};

                  return StreamBuilder<List<SalaryPayment>>(
                    stream: db.watchMonthlyPayments(_selectedMonth, _selectedYear),
                    builder: (context, paymentSnap) {
                      final payments = paymentSnap.data ?? [];
                      final paymentsMap = {for (var p in payments) p.staffId: p};

                      return ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: staffList.length,
                        itemBuilder: (context, idx) {
                          final staff = staffList[idx];
                          final category = catMap[staff.categoryId];
                          final savedPayment = paymentsMap[staff.id];

                          return FutureBuilder<List<AttendanceData>>(
                            future: db.getStaffAttendanceForMonth(staff.id, _selectedMonth, _selectedYear),
                            builder: (context, attSnap) {
                              final attendance = attSnap.data ?? [];

                              final present = attendance.where((a) => a.status == 'present').length;
                              final halfDay = attendance.where((a) => a.status == 'half_day').length;
                              final absent = attendance.where((a) => a.status == 'absent').length;
                              final holiday = attendance.where((a) => a.status == 'holiday').length;

                              final bonus = savedPayment?.bonus ?? 0.0;
                              final deductions = savedPayment?.deductions ?? 0.0;
                              final holidaysUnpaid = savedPayment?.holidaysUnpaid ?? false;

                              final calculatedSalary = _computeSalary(
                                staff: staff,
                                attendance: attendance,
                                category: category,
                                bonus: bonus,
                                deductions: deductions,
                                holidaysUnpaid: holidaysUnpaid,
                                month: _selectedMonth,
                                year: _selectedYear,
                              );

                              return _PayrollStaffTile(
                                staff: staff,
                                present: present,
                                halfDay: halfDay,
                                absent: absent,
                                holiday: holiday,
                                calculatedSalary: calculatedSalary,
                                savedPayment: savedPayment,
                                onTap: () => _showPayrollDetails(
                                  staff: staff,
                                  attendance: attendance,
                                  category: category,
                                  savedPayment: savedPayment,
                                  calculatedSalary: calculatedSalary,
                                  present: present,
                                  halfDay: halfDay,
                                  absent: absent,
                                  holiday: holiday,
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
            },
          ),
        ),
      ],
    );
  }

  double _computeSalary({
    required StaffData staff,
    required List<AttendanceData> attendance,
    required StaffCategory? category,
    required double bonus,
    required double deductions,
    required bool holidaysUnpaid,
    required int month,
    required int year,
  }) {
    final presentDays = attendance.where((a) => a.status == 'present').length;
    final halfDays = attendance.where((a) => a.status == 'half_day').length;
    final absentDays = attendance.where((a) => a.status == 'absent').length;
    final holidayDays = attendance.where((a) => a.status == 'holiday').length;

    if (staff.payType == 'monthly') {
      final base = staff.monthlySalary;
      final totalDaysInMonth = DateTime(year, month + 1, 0).day;
      final dailyDeductionRate = base / totalDaysInMonth;

      double calculated = base;
      calculated -= absentDays * dailyDeductionRate;
      calculated -= halfDays * dailyDeductionRate * 0.5;

      if (holidaysUnpaid) {
        calculated -= holidayDays * dailyDeductionRate;
      }

      return (calculated + bonus - deductions).clamp(0.0, double.infinity);
    } else {
      final dailyRate = staff.payRate > 0 ? staff.payRate : (category?.defaultDailyRate ?? 0.0);
      final halfDayRate = staff.halfDayRate > 0 ? staff.halfDayRate : (category?.defaultHalfDayRate ?? 0.0);

      double calculated = 0.0;
      calculated += presentDays * dailyRate;
      calculated += halfDays * halfDayRate;

      if (!holidaysUnpaid) {
        calculated += holidayDays * dailyRate;
      }

      return (calculated + bonus - deductions).clamp(0.0, double.infinity);
    }
  }

  void _showPayrollDetails({
    required StaffData staff,
    required List<AttendanceData> attendance,
    required StaffCategory? category,
    required SalaryPayment? savedPayment,
    required double calculatedSalary,
    required int present,
    required int halfDay,
    required int absent,
    required int holiday,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => _PayrollDetailsSheet(
        staff: staff,
        attendance: attendance,
        category: category,
        savedPayment: savedPayment,
        calculatedSalary: calculatedSalary,
        present: present,
        halfDay: halfDay,
        absent: absent,
        holiday: holiday,
        month: _selectedMonth,
        year: _selectedYear,
      ),
    );
  }
}

class _PayrollStaffTile extends StatelessWidget {
  final StaffData staff;
  final int present;
  final int halfDay;
  final int absent;
  final int holiday;
  final double calculatedSalary;
  final SalaryPayment? savedPayment;
  final VoidCallback onTap;

  const _PayrollStaffTile({
    required this.staff,
    required this.present,
    required this.halfDay,
    required this.absent,
    required this.holiday,
    required this.calculatedSalary,
    required this.savedPayment,
    required this.onTap,
  });

  Widget _buildStatusBadge() {
    final paid = savedPayment?.paidAmount ?? 0.0;
    final pending = (calculatedSalary - paid).clamp(0.0, double.infinity);
    if (paid == 0) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.error.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'PENDING',
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.error,
          ),
        ),
      );
    } else if (pending > 0.01) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.warning.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'PARTIAL (${Fmt.currencyShort(pending)} left)',
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.warning,
          ),
        ),
      );
    } else {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          'PAID',
          style: GoogleFonts.manrope(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            color: AppColors.success,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        title: Row(
          children: [
            Expanded(
              child: Text(
                staff.name,
                style: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
              ),
            ),
            _buildStatusBadge(),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${present}P • ${halfDay}H/2 • ${absent}A • ${holiday}H',
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
          ),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              Fmt.currencyShort(calculatedSalary),
              style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.primary),
            ),
            if (savedPayment != null && savedPayment!.paidAmount > 0)
              Text(
                'Paid: ${Fmt.currencyShort(savedPayment!.paidAmount)}',
                style: GoogleFonts.inter(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.w500),
              ),
          ],
        ),
      ),
    );
  }
}

class _PayrollDetailsSheet extends ConsumerStatefulWidget {
  final StaffData staff;
  final List<AttendanceData> attendance;
  final StaffCategory? category;
  final SalaryPayment? savedPayment;
  final double calculatedSalary;
  final int present;
  final int halfDay;
  final int absent;
  final int holiday;
  final int month;
  final int year;

  const _PayrollDetailsSheet({
    required this.staff,
    required this.attendance,
    required this.category,
    required this.savedPayment,
    required this.calculatedSalary,
    required this.present,
    required this.halfDay,
    required this.absent,
    required this.holiday,
    required this.month,
    required this.year,
  });

  @override
  ConsumerState<_PayrollDetailsSheet> createState() => _PayrollDetailsSheetState();
}

class _PayrollDetailsSheetState extends ConsumerState<_PayrollDetailsSheet> {
  late final TextEditingController _bonusController;
  late final TextEditingController _deductionsController;
  late final TextEditingController _notesController;
  
  bool _holidaysUnpaid = false;
  double _bonus = 0.0;
  double _deductions = 0.0;

  @override
  void initState() {
    super.initState();
    _holidaysUnpaid = widget.savedPayment?.holidaysUnpaid ?? false;
    _bonus = widget.savedPayment?.bonus ?? 0.0;
    _deductions = widget.savedPayment?.deductions ?? 0.0;
    _bonusController = TextEditingController(text: _bonus == 0 ? '' : _bonus.toStringAsFixed(0));
    _deductionsController = TextEditingController(text: _deductions == 0 ? '' : _deductions.toStringAsFixed(0));
    _notesController = TextEditingController(text: widget.savedPayment?.notes ?? '');
  }

  @override
  void dispose() {
    _bonusController.dispose();
    _deductionsController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double _getCalculatedSalary() {
    final presentDays = widget.present;
    final halfDays = widget.halfDay;
    final absentDays = widget.absent;
    final holidayDays = widget.holiday;

    if (widget.staff.payType == 'monthly') {
      final base = widget.staff.monthlySalary;
      final totalDaysInMonth = DateTime(widget.year, widget.month + 1, 0).day;
      final dailyDeductionRate = base / totalDaysInMonth;

      double calculated = base;
      calculated -= absentDays * dailyDeductionRate;
      calculated -= halfDays * dailyDeductionRate * 0.5;

      if (_holidaysUnpaid) {
        calculated -= holidayDays * dailyDeductionRate;
      }

      return (calculated + _bonus - _deductions).clamp(0.0, double.infinity);
    } else {
      final dailyRate = widget.staff.payRate > 0 ? widget.staff.payRate : (widget.category?.defaultDailyRate ?? 0.0);
      final halfDayRate = widget.staff.halfDayRate > 0 ? widget.staff.halfDayRate : (widget.category?.defaultHalfDayRate ?? 0.0);

      double calculated = 0.0;
      calculated += presentDays * dailyRate;
      calculated += halfDays * halfDayRate;

      if (!_holidaysUnpaid) {
        calculated += holidayDays * dailyRate;
      }

      return (calculated + _bonus - _deductions).clamp(0.0, double.infinity);
    }
  }

  void _showPaymentDialog(
    BuildContext context,
    double remaining,
    double alreadyPaid,
    double calculated,
    AppDatabase db,
  ) {
    final controller = TextEditingController(text: remaining.toStringAsFixed(0));
    showDialog(
      context: context,
      builder: (ctx) => NbDialog(
        title: 'Record Payment',
        customContent: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total Wages: ${Fmt.currency(calculated)}',
              style: GoogleFonts.inter(color: AppColors.textPrimary, fontSize: 14),
            ),
            Text(
              'Paid So Far: ${Fmt.currency(alreadyPaid)}',
              style: GoogleFonts.inter(color: AppColors.success, fontSize: 13),
            ),
            Text(
              'Remaining Balance: ${Fmt.currency(remaining)}',
              style: GoogleFonts.inter(color: AppColors.warning, fontSize: 13, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            NbInput(
              controller: controller,
              type: NbInputType.number,
              hintText: 'Amount Paid Now (Rs)',
              prefixIcon: Icons.currency_rupee_rounded,
            ),
          ],
        ),
        primaryButtonText: 'Record',
        onPrimary: () async {
          final amt = double.tryParse(controller.text.trim()) ?? 0.0;
          if (amt <= 0) return;
          final newPaidAmount = alreadyPaid + amt;

          await db.upsertSalaryPayment(SalaryPaymentsCompanion.insert(
            staffId: widget.staff.id,
            month: widget.month,
            year: widget.year,
            presentCount: Value(widget.present),
            halfDayCount: Value(widget.halfDay),
            absentCount: Value(widget.absent),
            holidayCount: Value(widget.holiday),
            baseSalary: Value(widget.staff.payType == 'monthly' ? widget.staff.monthlySalary : widget.staff.payRate),
            calculatedSalary: Value(calculated),
            bonus: Value(_bonus),
            deductions: Value(_deductions),
            paidAmount: Value(newPaidAmount),
            paidAt: DateTime.now(),
            notes: Value(_notesController.text.trim()),
            holidaysUnpaid: Value(_holidaysUnpaid),
          ));
          HapticFeedback.mediumImpact();
          if (ctx.mounted) Navigator.pop(ctx); // Close dialog
          if (context.mounted) Navigator.pop(context); // Close sheet
        },
        secondaryButtonText: 'Cancel',
        onSecondary: () => Navigator.pop(ctx),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final calculated = _getCalculatedSalary();
    final isPaid = widget.savedPayment != null && widget.savedPayment!.paidAmount >= calculated;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.staff.name,
                      style: GoogleFonts.manrope(fontSize: 18, fontWeight: FontWeight.w800, color: AppColors.textPrimary),
                    ),
                    Text(
                      'Payroll breakdown for ${DateFormat('MMMM yyyy').format(DateTime(widget.year, widget.month))}',
                      style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              if (isPaid)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.success.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'PAID',
                    style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.success),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.border),

          // Attendance Counts Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _CountStat('Present', '${widget.present}', AppColors.success),
              _CountStat('Half Day', '${widget.halfDay}', AppColors.warning),
              _CountStat('Absent', '${widget.absent}', AppColors.error),
              _CountStat('Holiday', '${widget.holiday}', AppColors.info),
            ],
          ),
          const SizedBox(height: 16),
          Divider(color: AppColors.border),

          // Holiday policy switch
          SwitchListTile(
            title: Text(
              'Unpaid Holidays',
              style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
            ),
            subtitle: Text(
              widget.staff.payType == 'monthly' 
                  ? 'Deduct wage for holiday days' 
                  : 'Do not pay daily wage for holiday days',
              style: GoogleFonts.inter(fontSize: 11, color: AppColors.textMuted),
            ),
            value: _holidaysUnpaid,
            activeThumbColor: AppColors.primary,
            contentPadding: EdgeInsets.zero,
            onChanged: (val) {
              setState(() => _holidaysUnpaid = val);
            },
          ),
          const SizedBox(height: 8),

          // Bonus & Deduction inputs
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _bonusController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Bonus (Rs)',
                    prefixIcon: Icon(Icons.add_circle_outline, size: 16),
                  ),
                  style: TextStyle(color: AppColors.textPrimary),
                  onChanged: (val) {
                    setState(() => _bonus = double.tryParse(val) ?? 0.0);
                  },
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: _deductionsController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Deductions (Rs)',
                    prefixIcon: Icon(Icons.remove_circle_outline, size: 16),
                  ),
                  style: TextStyle(color: AppColors.textPrimary),
                  onChanged: (val) {
                    setState(() => _deductions = double.tryParse(val) ?? 0.0);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Payment notes
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Salary Notes / Remarks',
              prefixIcon: Icon(Icons.comment_outlined, size: 16),
            ),
            style: TextStyle(color: AppColors.textPrimary),
          ),
          const SizedBox(height: 20),

          // Computation summary block
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _ComputeFormula(
                  label: 'Base Pay',
                  value: widget.staff.payType == 'monthly'
                      ? Fmt.currencyShort(widget.staff.monthlySalary)
                      : '${widget.present + (widget.holiday)} Days @ ${Fmt.currencyShort(widget.staff.payRate > 0 ? widget.staff.payRate : (widget.category?.defaultDailyRate ?? 0.0))}',
                ),
                if (widget.staff.payType == 'monthly' && (widget.absent > 0 || widget.halfDay > 0 || (_holidaysUnpaid && widget.holiday > 0))) ...[
                  const SizedBox(height: 6),
                  _ComputeFormula(
                    label: 'Absence Deductions',
                    value: '- ${Fmt.currencyShort(_calculateAbsenceDeductions())}',
                    isNegative: true,
                  ),
                ],
                if (_bonus > 0) ...[
                  const SizedBox(height: 6),
                  _ComputeFormula(
                    label: 'Bonus',
                    value: '+ ${Fmt.currencyShort(_bonus)}',
                    isPositive: true,
                  ),
                ],
                if (_deductions > 0) ...[
                  const SizedBox(height: 6),
                  _ComputeFormula(
                    label: 'Other Deductions',
                    value: '- ${Fmt.currencyShort(_deductions)}',
                    isNegative: true,
                  ),
                ],
                Divider(height: 20, color: AppColors.border),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total Wages', style: GoogleFonts.manrope(fontWeight: FontWeight.w700, fontSize: 15, color: AppColors.textPrimary)),
                    Text(
                      Fmt.currency(calculated),
                      style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 18, color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Payment buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () async {
                    // Save calculation without paying
                    await db.upsertSalaryPayment(SalaryPaymentsCompanion.insert(
                      staffId: widget.staff.id,
                      month: widget.month,
                      year: widget.year,
                      presentCount: Value(widget.present),
                      halfDayCount: Value(widget.halfDay),
                      absentCount: Value(widget.absent),
                      holidayCount: Value(widget.holiday),
                      baseSalary: Value(widget.staff.payType == 'monthly' ? widget.staff.monthlySalary : widget.staff.payRate),
                      calculatedSalary: Value(calculated),
                      bonus: Value(_bonus),
                      deductions: Value(_deductions),
                      paidAmount: Value(widget.savedPayment?.paidAmount ?? 0.0),
                      paidAt: widget.savedPayment?.paidAt ?? DateTime.now(),
                      notes: Value(_notesController.text.trim()),
                      holidaysUnpaid: Value(_holidaysUnpaid),
                    ));
                    if (context.mounted) Navigator.pop(context);
                  },
                  child: const Text('Save Computations'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: isPaid
                      ? null
                      : () {
                          final alreadyPaid = widget.savedPayment?.paidAmount ?? 0.0;
                          final remaining = (calculated - alreadyPaid).clamp(0.0, double.infinity);
                          _showPaymentDialog(context, remaining, alreadyPaid, calculated, db);
                        },
                  icon: const Icon(Icons.payment_rounded, size: 18, color: Colors.black),
                  label: Text(
                    (widget.savedPayment?.paidAmount ?? 0.0) > 0 ? 'Pay Remaining' : 'Pay Salary',
                    style: const TextStyle(color: Colors.black),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  double _calculateAbsenceDeductions() {
    final base = widget.staff.monthlySalary;
    final totalDaysInMonth = DateTime(widget.year, widget.month + 1, 0).day;
    final dailyRate = base / totalDaysInMonth;

    double deduction = 0.0;
    deduction += widget.absent * dailyRate;
    deduction += widget.halfDay * dailyRate * 0.5;

    if (_holidaysUnpaid) {
      deduction += widget.holiday * dailyRate;
    }
    return deduction;
  }
}

class _CountStat extends StatelessWidget {
  final String label;
  final String count;
  final Color color;

  const _CountStat(this.label, this.count, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          count,
          style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: color),
        ),
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

class _ComputeFormula extends StatelessWidget {
  final String label;
  final String value;
  final bool isNegative;
  final bool isPositive;

  const _ComputeFormula({
    required this.label,
    required this.value,
    this.isNegative = false,
    this.isPositive = false,
  });

  @override
  Widget build(BuildContext context) {
    Color valColor = AppColors.textPrimary;
    if (isNegative) valColor = AppColors.error;
    if (isPositive) valColor = AppColors.success;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary)),
        Text(value, style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w600, color: valColor)),
      ],
    );
  }
}

// ────────────────────────────────────────────────────────────────
// 3. EMPLOYEES TAB
// ────────────────────────────────────────────────────────────────

class _EmployeesTab extends ConsumerWidget {
  const _EmployeesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final staffAsync = ref.watch(_staffListProvider);
    final categoriesAsync = ref.watch(_categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: staffAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (staffList) {
          return categoriesAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
            data: (categories) {
              if (categories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.badge_outlined, size: 48, color: AppColors.textMuted),
                      const SizedBox(height: 12),
                      Text(
                        'Please create a Staff Category first.',
                        style: GoogleFonts.inter(color: AppColors.textMuted),
                      ),
                    ],
                  ),
                );
              }

              if (staffList.isEmpty) {
                return Center(
                  child: Text('No employees. Tap button to add.', style: GoogleFonts.inter(color: AppColors.textMuted)),
                );
              }

              final catMap = {for (var c in categories) c.id: c.name};

              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Employees',
                                    style: GoogleFonts.manrope(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${staffList.length} active team member${staffList.length == 1 ? '' : 's'}',
                                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                              decoration: BoxDecoration(
                                color: AppColors.success.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(Icons.circle, size: 8, color: AppColors.success),
                                  const SizedBox(width: 6),
                                  Text('Active', style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.success)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: AppColors.border),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowHeight: 44,
                          dataRowMinHeight: 64,
                          dataRowMaxHeight: 72,
                          horizontalMargin: 20,
                          columnSpacing: 28,
                          headingTextStyle: GoogleFonts.manrope(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textMuted,
                          ),
                          dataTextStyle: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.textPrimary,
                          ),
                          columns: const [
                            DataColumn(label: Text('EMPLOYEE')),
                            DataColumn(label: Text('ROLE')),
                            DataColumn(label: Text('CONTACT')),
                            DataColumn(label: Text('PAY STRUCTURE')),
                            DataColumn(label: Text('JOINED')),
                            DataColumn(label: Text('ACTIONS')),
                          ],
                          rows: staffList.map((staff) {
                            final role = catMap[staff.categoryId] ?? '-';
                            final pay = staff.payType == 'monthly'
                                ? 'Monthly  ${Fmt.currency(staff.monthlySalary)}'
                                : 'Daily  ${Fmt.currency(staff.payRate)}';
                            return DataRow(
                              onSelectChanged: (_) => _showEmployeeAttendanceHistory(context, ref, staff, categories),
                              cells: [
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 17,
                                        backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                                        child: Text(
                                          staff.name.isEmpty ? '?' : staff.name[0].toUpperCase(),
                                          style: GoogleFonts.manrope(fontWeight: FontWeight.w800, color: AppColors.primary),
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      Text(staff.name, style: GoogleFonts.manrope(fontWeight: FontWeight.w700)),
                                    ],
                                  ),
                                ),
                                DataCell(Text(role)),
                                DataCell(Text(staff.phone.isEmpty ? 'Not provided' : staff.phone)),
                                DataCell(Text(pay)),
                                DataCell(Text(DateFormat('d MMM yyyy').format(staff.joiningDate))),
                                DataCell(
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        tooltip: 'Edit employee',
                                        icon: const Icon(Icons.edit_rounded, size: 19),
                                        color: AppColors.textMuted,
                                        onPressed: () => _addEditStaffDialog(context, ref, categories, existing: staff),
                                      ),
                                      IconButton(
                                        tooltip: 'Delete employee',
                                        icon: const Icon(Icons.delete_outline_rounded, size: 19),
                                        color: AppColors.error,
                                        onPressed: () => _confirmDeleteStaff(context, db, staff),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: categoriesAsync.maybeWhen(
        data: (categories) => categories.isNotEmpty
            ? FloatingActionButton(
                onPressed: () => _addEditStaffDialog(context, ref, categories),
                backgroundColor: AppColors.primary,
                child: const Icon(Icons.add, color: Colors.black),
              )
            : null,
        orElse: () => null,
      ),
    );
  }

  void _addEditStaffDialog(
    BuildContext context,
    WidgetRef ref,
    List<StaffCategory> categories, {
    StaffData? existing,
  }) {
    final db = ref.read(databaseProvider);
    final nameController = TextEditingController(text: existing?.name ?? '');
    final phoneController = TextEditingController(text: existing?.phone ?? '');
    
    int selectedCategoryId = existing?.categoryId ?? categories.first.id;
    String payType = existing?.payType ?? 'daily';
    
    final salaryController = TextEditingController(text: existing?.monthlySalary.toStringAsFixed(0) ?? '15000');
    final payRateController = TextEditingController(text: existing?.payRate.toStringAsFixed(0) ?? '500');
    final halfDayRateController = TextEditingController(text: existing?.halfDayRate.toStringAsFixed(0) ?? '250');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(existing == null ? 'Add Employee' : 'Edit Employee', style: GoogleFonts.manrope(color: AppColors.textPrimary)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Full Name'),
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(labelText: 'Phone Number'),
                  style: TextStyle(color: AppColors.textPrimary),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<int>(
                  initialValue: selectedCategoryId,
                  dropdownColor: AppColors.card,
                  decoration: const InputDecoration(labelText: 'Category'),
                  style: TextStyle(color: AppColors.textPrimary),
                  items: categories
                      .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                      .toList(),
                  onChanged: (val) {
                    if (val != null) setDialogState(() => selectedCategoryId = val);
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  initialValue: payType,
                  dropdownColor: AppColors.card,
                  decoration: const InputDecoration(labelText: 'Wage Type'),
                  style: TextStyle(color: AppColors.textPrimary),
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily Wage')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly Salary')),
                  ],
                  onChanged: (val) {
                    if (val != null) setDialogState(() => payType = val);
                  },
                ),
                const SizedBox(height: 12),
                if (payType == 'monthly')
                  TextField(
                    controller: salaryController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Monthly Base Salary (Rs)'),
                    style: TextStyle(color: AppColors.textPrimary),
                  )
                else ...[
                  TextField(
                    controller: payRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Present Day Rate Override (Rs)'),
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: halfDayRateController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Half Day Rate Override (Rs)'),
                    style: TextStyle(color: AppColors.textPrimary),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
            ),
            TextButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;

                final companion = StaffCompanion.insert(
                  categoryId: selectedCategoryId,
                  name: name,
                  phone: Value(phoneController.text.trim()),
                  payType: Value(payType),
                  payRate: Value(double.tryParse(payRateController.text) ?? 0.0),
                  halfDayRate: Value(double.tryParse(halfDayRateController.text) ?? 0.0),
                  monthlySalary: Value(double.tryParse(salaryController.text) ?? 0.0),
                  joiningDate: existing?.joiningDate ?? DateTime.now(),
                  isActive: const Value(true),
                );

                if (existing == null) {
                  await db.insertStaff(companion);
                } else {
                  await db.updateStaff(StaffData(
                    id: existing.id,
                    categoryId: selectedCategoryId,
                    name: name,
                    phone: phoneController.text.trim(),
                    payType: payType,
                    payRate: double.tryParse(payRateController.text) ?? 0.0,
                    halfDayRate: double.tryParse(halfDayRateController.text) ?? 0.0,
                    monthlySalary: double.tryParse(salaryController.text) ?? 0.0,
                    joiningDate: existing.joiningDate,
                    isActive: true,
                  ));
                }

                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text('Save', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDeleteStaff(BuildContext context, AppDatabase db, StaffData staff) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Delete Employee?'),
        content: Text('This will delete all records for ${staff.name}. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await db.deleteStaff(staff.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// 4. CATEGORIES TAB
// ────────────────────────────────────────────────────────────────

class _CategoriesTab extends ConsumerWidget {
  const _CategoriesTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final categoriesAsync = ref.watch(_categoriesProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: categoriesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (categories) {
          if (categories.isEmpty) {
            return Center(
              child: Text('No categories. Tap button to add.', style: GoogleFonts.inter(color: AppColors.textMuted)),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: categories.length,
            itemBuilder: (context, idx) {
              final cat = categories[idx];
              return Card(
                color: AppColors.card,
                margin: const EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: AppColors.border),
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  title: Text(
                    cat.name,
                    style: GoogleFonts.manrope(fontWeight: FontWeight.w600, fontSize: 14, color: AppColors.textPrimary),
                  ),
                  subtitle: Text(
                    'Default Daily: ${Fmt.currencyShort(cat.defaultDailyRate)} • Default Half: ${Fmt.currencyShort(cat.defaultHalfDayRate)}',
                    style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_rounded, color: AppColors.textMuted, size: 20),
                        onPressed: () => _addEditCategoryDialog(context, db, existing: cat),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 20),
                        onPressed: () => _confirmDeleteCategory(context, db, cat),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addEditCategoryDialog(context, db),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: Colors.black),
      ),
    );
  }

  void _addEditCategoryDialog(BuildContext context, AppDatabase db, {StaffCategory? existing}) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    final dailyController = TextEditingController(text: existing?.defaultDailyRate.toStringAsFixed(0) ?? '500');
    final halfController = TextEditingController(text: existing?.defaultHalfDayRate.toStringAsFixed(0) ?? '250');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: Text(existing == null ? 'Add Category' : 'Edit Category', style: GoogleFonts.manrope(color: AppColors.textPrimary)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Category Name'),
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: dailyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Default Daily Rate (Rs)'),
              style: TextStyle(color: AppColors.textPrimary),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: halfController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Default Half-Day Rate (Rs)'),
              style: TextStyle(color: AppColors.textPrimary),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          TextButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isEmpty) return;

              final companion = StaffCategoriesCompanion.insert(
                name: name,
                defaultDailyRate: Value(double.tryParse(dailyController.text) ?? 0.0),
                defaultHalfDayRate: Value(double.tryParse(halfController.text) ?? 0.0),
              );

              if (existing == null) {
                await db.insertStaffCategory(companion);
              } else {
                await db.updateStaffCategory(StaffCategory(
                  id: existing.id,
                  name: name,
                  defaultDailyRate: double.tryParse(dailyController.text) ?? 0.0,
                  defaultHalfDayRate: double.tryParse(halfController.text) ?? 0.0,
                ));
              }

              if (ctx.mounted) Navigator.pop(ctx);
            },
            child: Text('Save', style: TextStyle(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCategory(BuildContext context, AppDatabase db, StaffCategory cat) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Delete Category?'),
        content: Text('Warning: This will delete the category "${cat.name}" and ALL employees inside it.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await db.deleteStaffCategory(cat.id);
              if (ctx.mounted) Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ────────────────────────────────────────────────────────────────
// RIVERPOD STREAMS
// ────────────────────────────────────────────────────────────────

final _categoriesProvider = StreamProvider.autoDispose<List<StaffCategory>>((ref) {
  return ref.watch(databaseProvider).watchAllStaffCategories();
});

final _staffListProvider = StreamProvider.autoDispose<List<StaffData>>((ref) {
  return ref.watch(databaseProvider).watchAllStaff();
});

void _showEmployeeAttendanceHistory(
  BuildContext context,
  WidgetRef ref,
  StaffData staff,
  List<StaffCategory> categories,
) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: AppColors.bg,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (context) => _EmployeeAttendanceHistorySheet(
      staff: staff,
      categories: categories,
    ),
  );
}

class _EmployeeAttendanceHistorySheet extends ConsumerStatefulWidget {
  final StaffData staff;
  final List<StaffCategory> categories;

  const _EmployeeAttendanceHistorySheet({
    required this.staff,
    required this.categories,
  });

  @override
  ConsumerState<_EmployeeAttendanceHistorySheet> createState() =>
      _EmployeeAttendanceHistorySheetState();
}

class _EmployeeAttendanceHistorySheetState
    extends ConsumerState<_EmployeeAttendanceHistorySheet> {
  int _selectedMonth = DateTime.now().month;
  int _selectedYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final categoryName = widget.categories
        .firstWhere((c) => c.id == widget.staff.categoryId,
            orElse: () => const StaffCategory(id: 0, name: 'Unknown', defaultDailyRate: 0, defaultHalfDayRate: 0))
        .name;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return StreamBuilder<List<AttendanceData>>(
          stream: db.watchStaffAttendanceForMonth(widget.staff.id, _selectedMonth, _selectedYear),
          builder: (context, attendanceSnap) {
            final attendanceList = attendanceSnap.data ?? [];
            final attendanceMap = {for (var a in attendanceList) a.date.day: a};

            // Calculate stats
            final presentCount = attendanceList.where((a) => a.status == 'present').length;
            final halfDayCount = attendanceList.where((a) => a.status == 'half_day').length;
            final absentCount = attendanceList.where((a) => a.status == 'absent').length;
            final holidayCount = attendanceList.where((a) => a.status == 'holiday').length;

            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Pull handler
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),

                  // Profile Header
                  Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary.withValues(alpha: 0.1),
                          border: Border.all(color: AppColors.primary, width: 1.5),
                        ),
                        child: Center(
                          child: Text(
                            widget.staff.name.isNotEmpty ? widget.staff.name[0].toUpperCase() : 'S',
                            style: GoogleFonts.manrope(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.staff.name,
                              style: GoogleFonts.manrope(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '$categoryName • ${widget.staff.phone}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(color: AppColors.border),

                  // Month Selector Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(Icons.chevron_left_rounded, color: AppColors.textPrimary),
                        onPressed: () {
                          setState(() {
                            if (_selectedMonth == 1) {
                              _selectedMonth = 12;
                              _selectedYear--;
                            } else {
                              _selectedMonth--;
                            }
                          });
                        },
                      ),
                      Text(
                        '${DateFormat('MMMM').format(DateTime(_selectedYear, _selectedMonth))} $_selectedYear',
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.chevron_right_rounded, color: AppColors.textPrimary),
                        onPressed: () {
                          setState(() {
                            if (_selectedMonth == 12) {
                              _selectedMonth = 1;
                              _selectedYear++;
                            } else {
                              _selectedMonth++;
                            }
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // Quick Monthly Summary Cards
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildMiniStatCard('Present', presentCount, AppColors.success),
                      _buildMiniStatCard('Half Day', halfDayCount, AppColors.warning),
                      _buildMiniStatCard('Absent', absentCount, AppColors.error),
                      _buildMiniStatCard('Holiday', holidayCount, AppColors.info),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Calendar Grid Label
                  Text(
                    'ATTENDANCE CALENDAR',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Calendar
                  _buildCalendarGrid(attendanceMap),

                  const SizedBox(height: 24),

                  // Attendance Notes Section
                  Text(
                    'REMARKS / NOTES',
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildNotesList(attendanceList),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildMiniStatCard(String label, int count, Color color) {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
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

  Widget _buildCalendarGrid(Map<int, AttendanceData> attendanceMap) {
    final daysInMonth = DateTime(_selectedYear, _selectedMonth + 1, 0).day;
    final firstDayOfMonth = DateTime(_selectedYear, _selectedMonth, 1);
    final firstDayOffset = firstDayOfMonth.weekday == 7 ? 0 : firstDayOfMonth.weekday;

    final weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          // Weekday headers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: weekDays.map((d) {
              return Expanded(
                child: Text(
                  d,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textMuted,
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),
          Divider(color: AppColors.border, height: 1),
          const SizedBox(height: 8),

          // Days Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemCount: daysInMonth + firstDayOffset,
            itemBuilder: (context, index) {
              if (index < firstDayOffset) {
                return const SizedBox();
              }

              final day = index - firstDayOffset + 1;
              final record = attendanceMap[day];
              final status = record?.status;
              final hasNotes = record?.notes != null && record!.notes.isNotEmpty;

              Color bg = AppColors.surface;
              Color borderCol = AppColors.border;
              Color textCol = AppColors.textPrimary;
              IconData? icon;

              if (status == 'present') {
                bg = AppColors.success.withValues(alpha: 0.15);
                borderCol = AppColors.success;
                textCol = AppColors.success;
                icon = Icons.check_circle_outline_rounded;
              } else if (status == 'half_day') {
                bg = AppColors.warning.withValues(alpha: 0.15);
                borderCol = AppColors.warning;
                textCol = AppColors.warning;
                icon = Icons.star_half_rounded;
              } else if (status == 'absent') {
                bg = AppColors.error.withValues(alpha: 0.15);
                borderCol = AppColors.error;
                textCol = AppColors.error;
                icon = Icons.cancel_outlined;
              } else if (status == 'holiday') {
                bg = AppColors.info.withValues(alpha: 0.15);
                borderCol = AppColors.info;
                textCol = AppColors.info;
                icon = Icons.beach_access_rounded;
              }

              final cellDate = DateTime(_selectedYear, _selectedMonth, day);
              final isToday = DateUtils.isSameDay(cellDate, DateTime.now());

              return GestureDetector(
                onTap: () => _editDayAttendanceDialog(cellDate, record),
                child: Container(
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isToday ? AppColors.primary : borderCol,
                      width: isToday ? 2.0 : 1.0,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        '$day',
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: isToday || status != null ? FontWeight.bold : FontWeight.normal,
                          color: textCol,
                        ),
                      ),
                      if (hasNotes)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                      if (icon != null)
                        Positioned(
                          bottom: 2,
                          child: Icon(
                            icon,
                            size: 10,
                            color: textCol,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildNotesList(List<AttendanceData> list) {
    final listWithNotes = list.where((a) => a.notes.isNotEmpty).toList();
    listWithNotes.sort((a, b) => b.date.compareTo(a.date));

    if (listWithNotes.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Text(
          'No special remarks logged for this month.',
          style: GoogleFonts.inter(fontSize: 12, color: AppColors.textMuted, fontStyle: FontStyle.italic),
          textAlign: TextAlign.center,
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: listWithNotes.length,
      itemBuilder: (context, idx) {
        final item = listWithNotes[idx];
        Color badgeColor = AppColors.success;
        if (item.status == 'half_day') badgeColor = AppColors.warning;
        if (item.status == 'absent') badgeColor = AppColors.error;
        if (item.status == 'holiday') badgeColor = AppColors.info;

        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    DateFormat('EEE, d MMM yyyy').format(item.date),
                    style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      item.status.toUpperCase(),
                      style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.bold, color: badgeColor),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                item.notes,
                style: GoogleFonts.inter(fontSize: 12, color: AppColors.textSecondary),
              ),
            ],
          ),
        );
      },
    );
  }

  void _editDayAttendanceDialog(DateTime date, AttendanceData? existing) {
    final db = ref.read(databaseProvider);
    String selectedStatus = existing?.status ?? 'present';
    final notesController = TextEditingController(text: existing?.notes ?? '');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: AppColors.card,
          title: Text(
            'Mark Attendance: ${DateFormat('d MMMM yyyy').format(date)}',
            style: GoogleFonts.manrope(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _dialogStatusBtn(setDialogState, 'Present', 'present', AppColors.success, selectedStatus, (val) {
                    selectedStatus = val;
                  }),
                  _dialogStatusBtn(setDialogState, 'Half', 'half_day', AppColors.warning, selectedStatus, (val) {
                    selectedStatus = val;
                  }),
                  _dialogStatusBtn(setDialogState, 'Absent', 'absent', AppColors.error, selectedStatus, (val) {
                    selectedStatus = val;
                  }),
                  _dialogStatusBtn(setDialogState, 'Holiday', 'holiday', AppColors.info, selectedStatus, (val) {
                    selectedStatus = val;
                  }),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: notesController,
                decoration: const InputDecoration(
                  labelText: 'Remarks / Notes',
                  hintText: 'Enter notes if any...',
                ),
                style: TextStyle(color: AppColors.textPrimary),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
            ),
            TextButton(
              onPressed: () async {
                await db.upsertAttendance(AttendanceCompanion.insert(
                  staffId: widget.staff.id,
                  date: date,
                  status: Value(selectedStatus),
                  notes: Value(notesController.text.trim()),
                ));
                HapticFeedback.lightImpact();
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: Text('Save', style: TextStyle(color: AppColors.primary)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dialogStatusBtn(
    StateSetter setDialogState,
    String label,
    String statusValue,
    Color color,
    String currentSelected,
    ValueChanged<String> onChanged,
  ) {
    final isSelected = currentSelected == statusValue;
    return GestureDetector(
      onTap: () {
        setDialogState(() {
          onChanged(statusValue);
        });
      },
      child: Column(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: isSelected ? color.withValues(alpha: 0.15) : AppColors.surface,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? color : AppColors.border,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: Icon(
              statusValue == 'present'
                  ? Icons.check_circle_outline_rounded
                  : statusValue == 'half_day'
                      ? Icons.star_half_rounded
                      : statusValue == 'absent'
                          ? Icons.cancel_outlined
                          : Icons.beach_access_rounded,
              color: isSelected ? color : AppColors.textMuted,
              size: 18,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected ? color : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

