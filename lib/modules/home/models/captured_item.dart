import 'dart:math';

/// 📦 Modelo de item capturado
/// 
/// Representa um preço capturado pelo scanner ou adicionado manualmente
class CapturedItem {
  /// ID único do item
  final String id;
  
  /// Valor do item
  final double value;
  
  /// Data/hora da captura
  final DateTime capturedAt;
  
  /// Se foi capturado automaticamente ou manualmente
  final CaptureType type;
  
  /// Multiplicador aplicado (se houver)
  final int multiplier;
  
  /// Nome customizado (opcional, para itens manuais)
  final String? customName;

  CapturedItem({
    String? id,
    required this.value,
    DateTime? capturedAt,
    this.type = CaptureType.automatic,
    this.multiplier = 1,
    this.customName,
  })  : id = id ?? '${DateTime.now().microsecondsSinceEpoch}${Random().nextInt(9999)}',
        capturedAt = capturedAt ?? DateTime.now();

  /// Valor final (com multiplicador aplicado)
  double get finalValue => value * multiplier;

  /// Label para exibição
  String get displayLabel {
    if (customName != null && customName!.isNotEmpty) return customName!;
    return type == CaptureType.automatic ? 'Preço Capturado' : 'Valor Manual';
  }

  /// Cria cópia com alterações
  CapturedItem copyWith({
    String? id,
    double? value,
    DateTime? capturedAt,
    CaptureType? type,
    int? multiplier,
    String? customName,
  }) {
    return CapturedItem(
      id: id ?? this.id,
      value: value ?? this.value,
      capturedAt: capturedAt ?? this.capturedAt,
      type: type ?? this.type,
      multiplier: multiplier ?? this.multiplier,
      customName: customName ?? this.customName,
    );
  }

  /// Converte para JSON (para persistência)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'value': value,
      'capturedAt': capturedAt.toIso8601String(),
      'type': type.name,
      'multiplier': multiplier,
      'customName': customName,
    };
  }

  /// Cria a partir de JSON
  factory CapturedItem.fromJson(Map<String, dynamic> json) {
    return CapturedItem(
      id: json['id'] as String,
      value: (json['value'] as num).toDouble(),
      capturedAt: DateTime.parse(json['capturedAt'] as String),
      type: CaptureType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => CaptureType.automatic,
      ),
      multiplier: json['multiplier'] as int? ?? 1,
      customName: json['customName'] as String?,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is CapturedItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'CapturedItem(id: $id, value: $value, multiplier: $multiplier, finalValue: $finalValue)';
  }
}

/// 🎯 Tipo de captura
enum CaptureType {
  /// Capturado automaticamente pelo scanner
  automatic,
  
  /// Adicionado manualmente via calculadora
  manual,
  
  /// Multiplicado a partir de um valor capturado
  multiplied,
}
