import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Split Payment Calculations & Edge Cases', () {
    test('Standard split payment: Total 500, Cash 200 => Online 300', () {
      const double total = 500.0;
      const double cashInput = 200.0;
      const double splitCash = cashInput;
      final double splitOnline = (total - splitCash).clamp(0.0, total);

      expect(splitCash, equals(200.0));
      expect(splitOnline, equals(300.0));
      expect(splitCash + splitOnline, equals(total));
    });

    test('Edge case: Cash input exceeds Total (Overpayment)', () {
      const double total = 500.0;
      const double cashInput = 600.0;
      const double splitCash = cashInput;
      final double splitOnline = (total - splitCash).clamp(0.0, total);
      final double change = (cashInput - total).clamp(0.0, double.infinity);

      expect(splitCash, equals(600.0));
      expect(splitOnline, equals(0.0));
      expect(change, equals(100.0));
    });

    test('Edge case: Cash input is 0 (Full Online via Split)', () {
      const double total = 350.0;
      const double cashInput = 0.0;
      const double splitCash = cashInput;
      final double splitOnline = (total - splitCash).clamp(0.0, total);

      expect(splitCash, equals(0.0));
      expect(splitOnline, equals(350.0));
    });

    test('Edge case: Negative Cash input defaults gracefully', () {
      const double total = 250.0;
      final double cashInput = double.tryParse('-50') ?? 0.0;
      final double splitCash = cashInput.clamp(0.0, double.infinity);
      final double splitOnline = (total - splitCash).clamp(0.0, total);

      expect(splitCash, equals(0.0));
      expect(splitOnline, equals(250.0));
    });
  });

  group('Report Revenue Aggregation with Split Bills', () {
    test('Accurately aggregates Cash, Card, UPI, and Split bills', () {
      // Mock Bill data structures
      final bills = [
        {'method': 'cash', 'total': 100.0, 'splitCash': 0.0, 'splitOnline': 0.0},
        {'method': 'upi', 'total': 200.0, 'splitCash': 0.0, 'splitOnline': 0.0},
        {'method': 'card', 'total': 300.0, 'splitCash': 0.0, 'splitOnline': 0.0},
        {'method': 'split', 'total': 500.0, 'splitCash': 150.0, 'splitOnline': 350.0},
      ];

      final cashTotal = bills.fold<double>(0, (s, b) {
        if (b['method'] == 'cash') return s + (b['total'] as double);
        if (b['method'] == 'split') return s + (b['splitCash'] as double);
        return s;
      });

      final cardTotal = bills.fold<double>(0, (s, b) {
        if (b['method'] == 'card') return s + (b['total'] as double);
        return s;
      });

      final upiTotal = bills.fold<double>(0, (s, b) {
        if (b['method'] == 'upi') return s + (b['total'] as double);
        if (b['method'] == 'split') return s + (b['splitOnline'] as double);
        return s;
      });

      expect(cashTotal, equals(250.0)); // 100 + 150
      expect(cardTotal, equals(300.0)); // 300
      expect(upiTotal, equals(550.0));  // 200 + 350
      expect(cashTotal + cardTotal + upiTotal, equals(1100.0)); // Total revenue
    });
  });

  group('Recipe & Custom Variant Logic', () {
    List<String> initVariants({
      required bool hasHalfFull,
      required String customVariantsJson,
    }) {
      List<String> customList = [];
      if (customVariantsJson.isNotEmpty && customVariantsJson != '[]') {
        try {
          final parsed = jsonDecode(customVariantsJson) as List<dynamic>;
          for (final v in parsed) {
            final name = v['name']?.toString().trim();
            if (name != null && name.isNotEmpty && !customList.contains(name)) {
              customList.add(name);
            }
          }
        } catch (_) {}
      }

      if (customList.isNotEmpty) {
        return customList;
      } else if (hasHalfFull) {
        return ['full', 'half'];
      } else {
        return ['full'];
      }
    }

    test('Omits FULL option when custom variants exist', () {
      final jsonStr = jsonEncode([
        {'name': '12 inch', 'price': 200},
        {'name': '8 inch', 'price': 100},
      ]);
      final variants = initVariants(hasHalfFull: false, customVariantsJson: jsonStr);

      expect(variants, equals(['12 inch', '8 inch']));
      expect(variants.contains('full'), isFalse);
    });

    test('Returns full & half when hasHalfFull is true and no custom variants', () {
      final variants = initVariants(hasHalfFull: true, customVariantsJson: '[]');

      expect(variants, equals(['full', 'half']));
    });

    test('Returns default full when no options enabled', () {
      final variants = initVariants(hasHalfFull: false, customVariantsJson: '');

      expect(variants, equals(['full']));
    });
  });

  group('UPI URI Generation Format', () {
    test('Generates valid UPI URI with correct payee, amount and currency', () {
      const upiId = 'testmerchant@upi';
      const payeeName = 'Hotel NextBills';
      const double splitOnlineAmount = 350.0;

      final upiUri = 'upi://pay?pa=$upiId&pn=${Uri.encodeComponent(payeeName)}&am=${splitOnlineAmount.toStringAsFixed(2)}&cu=INR';

      expect(upiUri, contains('pa=testmerchant@upi'));
      expect(upiUri, contains('pn=Hotel%20NextBills'));
      expect(upiUri, contains('am=350.00'));
      expect(upiUri, contains('cu=INR'));
    });
  });
}
