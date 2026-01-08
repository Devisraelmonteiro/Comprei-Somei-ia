import 'package:uuid/uuid.dart';

/// 🛒 Modelo de item da lista de compras
/// 
/// Representa um produto na lista com suas propriedades:
/// - Nome e quantidade
/// - Categoria
/// - Status de conclusão
/// - Timestamp de criação
class ShoppingItem {
  /// ID único do item
  final String id;
  
  /// Nome do produto
  String name;
  
  /// Quantidade desejada
  int quantity;
  
  /// Categoria (Alimentos, Limpeza, Higiene, etc)
  String category;
  
  /// Se o item já foi comprado/marcado
  bool isChecked;
  
  /// Data de criação
  final DateTime createdAt;
  
  ShoppingItem({
    String? id,
    required this.name,
    this.quantity = 1,
    this.category = 'Alimentos',
    this.isChecked = false,
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  /// Cria cópia com valores opcionais alterados
  ShoppingItem copyWith({
    String? name,
    int? quantity,
    String? category,
    bool? isChecked,
  }) {
    return ShoppingItem(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
      createdAt: createdAt,
    );
  }

  /// Converte para JSON para persistência
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category,
      'isChecked': isChecked,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Cria instância a partir de JSON
  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id'] as String,
      name: json['name'] as String,
      quantity: json['quantity'] as int? ?? 1,
      category: json['category'] as String? ?? 'Alimentos',
      isChecked: json['isChecked'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  @override
  String toString() {
    return 'ShoppingItem(id: $id, name: $name, qty: $quantity, category: $category, checked: $isChecked)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ShoppingItem && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}