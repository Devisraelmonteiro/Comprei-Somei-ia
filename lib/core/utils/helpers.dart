class Helpers {
  static String formatCurrency(double value) {
    return 'R\$ ${value.toStringAsFixed(2)}';
  }

  static double parseCurrency(String s) {
    // remover R$ e pontuação e converter
    final cleaned = s.replaceAll(RegExp(r'[^0-9,\.]'), '');
    return double.tryParse(cleaned.replaceAll(',', '.')) ?? 0.0;
  }
}
