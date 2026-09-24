import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nextbills/app/theme.dart';
import 'package:nextbills/core/database/database.dart';
import 'package:nextbills/core/utils/formatters.dart';
import 'package:nextbills/features/printer/printer_service.dart';
import 'package:nextbills/shared/widgets/nb_toast.dart';

class PrintPreviewDialog extends ConsumerWidget {
  final int orderId;
  final String tableNumber;
  final String title;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double total;
  final String paymentMethod;
  final double cashReceived;
  final double change;
  final int? billNumber;

  const PrintPreviewDialog({
    super.key,
    required this.orderId,
    required this.tableNumber,
    required this.title,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.cashReceived,
    required this.change,
    this.billNumber,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const hotelName = 'NextBills';
    const hotelAddress = 'Restaurant & Bar';
    const hotelPhone = 'Contact Support';

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Container(
        width: 620,
        constraints: const BoxConstraints(maxHeight: 760),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 14),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                border: Border(bottom: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: GoogleFonts.manrope(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          hotelName,
                          style: GoogleFonts.manrope(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Center(
                        child: Text(
                          hotelAddress,
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Center(
                        child: Text(
                          'Phone: $hotelPhone',
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            billNumber != null ? 'Bill #$billNumber' : 'Bill Preview',
                            style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                          ),
                          Text(
                            'Table: $tableNumber',
                            style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Date: ${DateTime.now().toLocal().toString().substring(0, 16)}',
                        style: GoogleFonts.manrope(fontSize: 12, color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 1,
                        color: AppColors.border,
                      ),
                      const SizedBox(height: 12),
                      ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.itemName}',
                                style: GoogleFonts.manrope(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            Text(
                              Fmt.currency(item.itemPrice * item.quantity),
                              style: GoogleFonts.manrope(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      )),
                      const SizedBox(height: 12),
                      Container(
                        height: 1,
                        color: AppColors.border,
                      ),
                      const SizedBox(height: 12),
                      _ReceiptRow(label: 'Subtotal', value: Fmt.currency(subtotal)),
                      _ReceiptRow(label: 'Discount', value: Fmt.currency(discount)),
                      _ReceiptRow(label: 'Total', value: Fmt.currency(total), bold: true),
                      _ReceiptRow(label: 'Payment', value: paymentMethod.toUpperCase()),
                      if (cashReceived > 0) _ReceiptRow(label: 'Received', value: Fmt.currency(cashReceived)),
                      if (change > 0) _ReceiptRow(label: 'Change', value: Fmt.currency(change), positive: true),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: BorderSide(color: AppColors.border),
                        foregroundColor: AppColors.textPrimary,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Close'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        final printerService = ref.read(printerServiceProvider);
                        try {
                          await printerService.printBill(
                            hotelName: hotelName,
                            hotelAddress: hotelAddress,
                            hotelPhone: hotelPhone,
                            tableNumber: tableNumber,
                            items: items.map((i) => {'name': i.itemName, 'qty': i.quantity, 'price': i.itemPrice}).toList(),
                            subtotal: subtotal,
                            discount: discount,
                            total: total,
                            paymentMethod: paymentMethod,
                            cashReceived: cashReceived,
                            change: change,
                            billNumber: billNumber,
                          );
                          if (context.mounted) {
                            NbToast.show(context, 'Bill printed successfully', type: NbToastType.success);
                          }
                        } catch (e) {
                          if (context.mounted) {
                            NbToast.show(context, 'Print failed: $e', type: NbToastType.error);
                          }
                        }
                      },
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Print Bill'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  final bool positive;

  const _ReceiptRow({
    required this.label,
    required this.value,
    this.bold = false,
    this.positive = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: bold ? FontWeight.w800 : FontWeight.w600,
              color: positive ? AppColors.success : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
