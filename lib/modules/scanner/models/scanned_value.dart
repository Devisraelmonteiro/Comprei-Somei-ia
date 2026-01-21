class ScannedValue {
  final double value;
  final String rawText;

  ScannedValue({
    required this.value,
    required this.rawText,
  });

  ScannedValue copyWith({
    double? value,
    String? rawText,
  }) {
    return ScannedValue(
      value: value ?? this.value,
      rawText: rawText ?? this.rawText,
    );
  }
}
