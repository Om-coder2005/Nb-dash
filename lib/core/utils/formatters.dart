import 'package:intl/intl.dart';

class Fmt {
  static final _currency = NumberFormat('#,##,##0.00', 'en_IN');
  static final _date = DateFormat('dd MMM yyyy');
  static final _time = DateFormat('hh:mm a');
  static final _datetime = DateFormat('dd MMM yyyy, hh:mm a');

  static String currency(double amount) => 'Rs ${_currency.format(amount)}';
  static String currencyShort(double amount) => 'Rs ${amount.toStringAsFixed(2)}';
  static String date(DateTime d) => _date.format(d);
  static String time(DateTime d) => _time.format(d);
  static String datetime(DateTime d) => _datetime.format(d);

  static String duration(DateTime from) {
    final diff = DateTime.now().difference(from);
    if (diff.inHours > 0) return '${diff.inHours}h ${diff.inMinutes % 60}m';
    return '${diff.inMinutes}m';
  }
}
