import 'package:intl/intl.dart';

class Helpers {
  static String formatCurrency(double value) {
    final formatter = NumberFormat("#,##0.00", "pt_BR");
    return 'R\$ ${formatter.format(value)}';
  }

  static double parseCurrency(String s) {
    String cleaned = s.replaceAll('.', '');
    cleaned = cleaned.replaceAll(RegExp(r'[^0-9,]'), '');
    cleaned = cleaned.replaceAll(',', '.');
    return double.tryParse(cleaned) ?? 0.0;
  }
}
