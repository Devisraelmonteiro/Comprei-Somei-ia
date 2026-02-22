import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 🛒 ShoppingListController - ÚNICO CONTROLLER NECESSÁRIO
/// 
/// Gerencia:
/// - Items da lista com SharedPreferences
/// - Estados (finalizada, compartilhada, pode gerar receitas)
/// - 6 Categorias
class ShoppingListController extends ChangeNotifier {
  // ═══════════════════════════════════════════════════════════
  // ESTADO
  // ═══════════════════════════════════════════════════════════
  
  List<ShoppingItem> _items = [];
  String _selectedCategory = 'Alimentos';
  bool _isFinalized = false;
  bool _isSharedCopy = false;
  bool _canGenerateRecipes = true;
  bool _loading = false;

  // ═══════════════════════════════════════════════════════════
  // CATEGORIAS (6 COMPLETAS)
  // ═══════════════════════════════════════════════════════════
  
  static const List<String> categories = [
    'Alimentos',
    'Limpeza',
    'Higiene',
    'Bebidas',
    'Frios',
    'Hortifruti',
  ];

  // ═══════════════════════════════════════════════════════════
  // GETTERS
  // ═══════════════════════════════════════════════════════════

  List<ShoppingItem> get items => List.unmodifiable(_items);
  
  List<ShoppingItem> get filteredItems => _items
      .where((item) => item.category == _selectedCategory)
      .toList();
  
  String get selectedCategory => _selectedCategory;
  bool get loading => _loading;
  bool get hasItems => _items.isNotEmpty;
  bool get isFinalized => _isFinalized;
  bool get isSharedCopy => _isSharedCopy;
  bool get canGenerateRecipes => _canGenerateRecipes && _isFinalized;

  // ═══════════════════════════════════════════════════════════
  // ESTATÍSTICAS
  // ═══════════════════════════════════════════════════════════

  int itemsInCategory(String category) {
    return _items.where((item) => item.category == category).length;
  }

  double completionPercentage(String category) {
    final categoryItems = _items.where((item) => item.category == category);
    if (categoryItems.isEmpty) return 0;
    final checkedItems = categoryItems.where((item) => item.isChecked).length;
    return (checkedItems / categoryItems.length) * 100;
  }

  // ═══════════════════════════════════════════════════════════
  // AÇÕES
  // ═══════════════════════════════════════════════════════════

  void selectCategory(String category) {
    if (categories.contains(category)) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  void toggleItemCheck(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        isChecked: !_items[index].isChecked,
      );
      notifyListeners();
      _persist();
    }
  }
  
  /// Marca/desmarca explicitamente um item
  void setItemCheck(String id, bool checked) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(isChecked: checked);
      notifyListeners();
      _persist();
    }
  }

  Future<void> addItem(ShoppingItem item) async {
    _items.add(item);
    notifyListeners();
    await _persist();
    debugPrint('➕ Item: ${item.name}');
  }

  Future<void> updateItem(ShoppingItem item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
      await _persist();
    }
  }

  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    await _persist();
  }

  // ═══════════════════════════════════════════════════════════
  // PERSISTÊNCIA (SharedPreferences)
  // ═══════════════════════════════════════════════════════════

  Future<void> loadItems() async {
    _loading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('shopping_list_items');

      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _items = jsonList.map((json) => ShoppingItem.fromJson(json)).toList();
        debugPrint('📥 Carregado: ${_items.length} itens');
      }
    } catch (e) {
      debugPrint('❌ Erro ao carregar: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _items.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      await prefs.setString('shopping_list_items', jsonString);
      debugPrint('💾 Salvo: ${_items.length} itens');
    } catch (e) {
      debugPrint('❌ Erro ao salvar: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // MÉTODOS DO RODAPÉ
  // ═══════════════════════════════════════════════════════════

  Future<void> finalizeList() async {
    if (_items.isEmpty) throw Exception('Lista vazia');
    _isFinalized = true;
    notifyListeners();
  }

  Future<void> shareList(String emailOrCode) async {
    if (!_isFinalized) throw Exception('Lista precisa estar finalizada');
    if (emailOrCode.trim().isEmpty) throw Exception('Email inválido');
    await Future.delayed(const Duration(milliseconds: 300));
  }

  Future<List<Recipe>> generateRecipes() async {
    if (!_isFinalized) throw Exception('Finalize a lista');
    if (_items.isEmpty) throw Exception('Lista vazia');
    
    await Future.delayed(const Duration(milliseconds: 500));
    
    return [
      Recipe(
        title: 'Receita com ${_items.first.name}',
        content: 'Use ${_items.first.name} para preparar uma refeição deliciosa e nutritiva.',
      ),
      Recipe(
        title: 'Prato Rápido e Fácil',
        content: 'Combine os ingredientes da sua lista para uma receita prática do dia a dia.',
      ),
      Recipe(
        title: 'Sugestão Especial',
        content: 'Experimente novas combinações com os produtos disponíveis na sua despensa.',
      ),
    ];
  }
}

// ═══════════════════════════════════════════════════════════
// MODELOS
// ═══════════════════════════════════════════════════════════

class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final String category;
  final bool isChecked;
  final DateTime createdAt;
  final double? unitPrice; // preço unitário (ex: por unidade/pacote)
  final String? unitLabel; // ex: un, pacote, kg, g, L
  final double? totalPrice; // valor total (quantity * unitPrice)

  ShoppingItem({
    String? id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isChecked = false,
    DateTime? createdAt,
    this.unitPrice,
    this.unitLabel,
    this.totalPrice,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  ShoppingItem copyWith({
    String? name,
    int? quantity,
    String? category,
    bool? isChecked,
    double? unitPrice,
    String? unitLabel,
    double? totalPrice,
  }) {
    return ShoppingItem(
      id: id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      category: category ?? this.category,
      isChecked: isChecked ?? this.isChecked,
      createdAt: createdAt,
      unitPrice: unitPrice ?? this.unitPrice,
      unitLabel: unitLabel ?? this.unitLabel,
      totalPrice: totalPrice ?? this.totalPrice,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'quantity': quantity,
    'category': category,
    'isChecked': isChecked,
    'createdAt': createdAt.toIso8601String(),
    'unitPrice': unitPrice,
    'unitLabel': unitLabel,
    'totalPrice': totalPrice,
  };

  factory ShoppingItem.fromJson(Map<String, dynamic> json) {
    return ShoppingItem(
      id: json['id']?.toString(),
      name: json['name'] ?? '',
      quantity: json['quantity'] ?? 1,
      category: json['category'] ?? 'Alimentos',
      isChecked: json['isChecked'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
      unitPrice: (json['unitPrice'] as num?)?.toDouble(),
      unitLabel: json['unitLabel'] as String?,
      totalPrice: (json['totalPrice'] as num?)?.toDouble(),
    );
  }
}

class Recipe {
  final String title;
  final String content;

  Recipe({required this.title, required this.content});

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }
}
