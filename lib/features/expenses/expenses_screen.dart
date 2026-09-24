import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' hide Column;

import 'package:google_fonts/google_fonts.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/providers/database_provider.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/shared/widgets/nb_app_bar.dart';
import 'package:nextbills/shared/widgets/nb_input.dart';
import 'package:nextbills/shared/widgets/nb_dialog.dart';
import 'package:nextbills/shared/widgets/nb_loading.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';

class ExpensesScreen extends ConsumerStatefulWidget {
  const ExpensesScreen({super.key});

  @override
  ConsumerState<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends ConsumerState<ExpensesScreen> {
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  @override
  Widget build(BuildContext context) {
    ref.watch(themeModeProvider);
    final db = ref.watch(databaseProvider);

    return Scaffold(
      backgroundColor: AppColors.bg,
      appBar: NbAppBar(
        title: 'Overhead Expenses Tracker',
        showBack: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range_rounded),
            tooltip: 'Filter Date Range',
            onPressed: () async {
              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime(2030),
                initialDateRange: _dateRange,
              );
              if (range != null) {
                setState(() => _dateRange = range);
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Expense>>(
        future: db.getExpensesInRange(
          DateTime(_dateRange.start.year, _dateRange.start.month, _dateRange.start.day, 0, 0, 0),
          DateTime(_dateRange.end.year, _dateRange.end.month, _dateRange.end.day, 23, 59, 59),
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const NbLoadingPulse();
          final expensesList = snapshot.data!;
          final totalExpenses = expensesList.fold<double>(0.0, (s, e) => s + e.amount);

          return Column(
            children: [
              // Summary Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primary, AppColors.primary.withBlue(220)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 16,
                  runSpacing: 12,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Expenses',
                          style: GoogleFonts.manrope(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          Fmt.currency(totalExpenses),
                          style: GoogleFonts.manrope(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'From ${DateFormat('dd MMM').format(_dateRange.start)} to ${DateFormat('dd MMM yyyy').format(_dateRange.end)}',
                          style: GoogleFonts.manrope(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: Text('Add Expense', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700)),
                      onPressed: () => _showAddExpenseDialog(context, ref),
                    ),
                  ],
                ),
              ),

              // Expenses List
              Expanded(
                child: expensesList.isEmpty
                    ? Center(
                        child: Text(
                          'No overhead expenses recorded in this period.',
                          style: GoogleFonts.manrope(color: AppColors.textMuted, fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: expensesList.length,
                        itemBuilder: (context, index) {
                          final expense = expensesList[index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 10),
                            color: AppColors.card,
                            child: ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: _getCategoryColor(expense.category).withValues(alpha: 0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  _getCategoryIcon(expense.category),
                                  color: _getCategoryColor(expense.category),
                                ),
                              ),
                              title: Row(
                                children: [
                                  Text(expense.title, style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                                  const SizedBox(width: 8),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: AppColors.surface,
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                     child: Text(expense.category, style: GoogleFonts.manrope(fontSize: 11, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
                                  ),
                                ],
                              ),
                              subtitle: Text(
                                '${DateFormat('dd MMM yyyy • hh:mm a').format(expense.date)} • ${expense.paymentMethod.toUpperCase()}',
                                style: GoogleFonts.manrope(fontSize: 11, color: AppColors.textMuted),
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    Fmt.currency(expense.amount),
                                    style: GoogleFonts.manrope(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.error),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline_rounded, color: AppColors.error, size: 18),
                                    onPressed: () async {
                                      await db.deleteExpense(expense.id);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  static void _showAddExpenseDialog(BuildContext context, WidgetRef ref) {
    final titleCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    String category = 'Electricity';
    String paymentMethod = 'cash';
    DateTime expenseDate = DateTime.now();

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          return NbDialog(
            title: 'Record Overhead Expense',
            customContent: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  NbInput(
                    labelText: 'Expense Title (e.g. July Electricity Bill, Gas Cylinder)',
                    controller: titleCtrl,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: NbInput(
                          labelText: 'Amount (₹)',
                          controller: amountCtrl,
                          type: NbInputType.number,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: category,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Electricity', 'Gas', 'Rent', 'Oil & Ingredients', 'Vegetables', 'Staff Salary', 'Maintenance', 'Misc']
                              .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => category = v ?? 'Electricity'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: paymentMethod,
                          decoration: const InputDecoration(
                            labelText: 'Payment Method',
                            border: OutlineInputBorder(),
                          ),
                          items: ['cash', 'upi', 'card', 'bank_transfer']
                              .map((m) => DropdownMenuItem(value: m, child: Text(m.toUpperCase())))
                              .toList(),
                          onChanged: (v) => setState(() => paymentMethod = v ?? 'cash'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          icon: const Icon(Icons.calendar_today_rounded, size: 18),
                          label: Text(DateFormat('dd MMM yyyy').format(expenseDate)),
                          onPressed: () async {
                            final d = await showDatePicker(
                              context: context,
                              initialDate: expenseDate,
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2030),
                            );
                            if (d != null) setState(() => expenseDate = d);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            primaryButtonText: 'Save Expense',
            onPrimary: () async {
              final amt = double.tryParse(amountCtrl.text) ?? 0.0;
              if (titleCtrl.text.trim().isEmpty || amt <= 0) return;
              final db = ref.read(databaseProvider);
              await db.insertExpense(ExpensesCompanion.insert(
                title: titleCtrl.text.trim(),
                amount: amt,
                category: Value(category),
                date: expenseDate,
                paymentMethod: Value(paymentMethod),
                notes: Value(notesCtrl.text.trim()),
              ));
              if (context.mounted) {
                Navigator.pop(ctx);
                NbToast.show(context, 'Expense logged!', type: NbToastType.success);
              }
            },
          );
        },
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'electricity':
        return Colors.amber;
      case 'gas':
        return Colors.deepOrange;
      case 'rent':
        return Colors.purple;
      case 'oil & ingredients':
        return Colors.teal;
      case 'vegetables':
        return Colors.green;
      case 'staff salary':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'electricity':
        return Icons.bolt_rounded;
      case 'gas':
        return Icons.local_fire_department_rounded;
      case 'rent':
        return Icons.store_rounded;
      case 'oil & ingredients':
        return Icons.opacity_rounded;
      case 'vegetables':
        return Icons.eco_rounded;
      case 'staff salary':
        return Icons.badge_rounded;
      default:
        return Icons.receipt_rounded;
    }
  }
}
