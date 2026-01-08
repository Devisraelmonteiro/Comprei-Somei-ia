import 'package:comprei_some_ia/modules/lista/models/shopping_item.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

/// 📋 Controller da Lista de Compras
/// 
/// Responsabilidades:
/// - Gerenciar estado dos itens
/// - Persistir dados localmente
/// - Calcular estatísticas por categoria
/// - Notificar mudanças na UI
class ShoppingListController extends ChangeNotifier {
  // === CATEGORIAS DISPONÍVEIS ===
  
  static const List<String> categories = [
    'Alimentos',
    'Limpeza',
    'Higiene',
    'Bebidas',
    'Frios',
    'Hortifruti',
  ];
  
  // === ESTADO ===
  
  List<ShoppingItem> _items = [];
  String _selectedCategory = 'Alimentos';
  bool _loading = false;
  
  // === GETTERS ===
  
  /// Lista imutável de todos os itens
  List<ShoppingItem> get items => List.unmodifiable(_items);
  
  /// Categoria atualmente selecionada
  String get selectedCategory => _selectedCategory;
  
  /// Se está carregando dados
  bool get loading => _loading;
  
  /// Itens da categoria selecionada
  List<ShoppingItem> get filteredItems {
    return _items
        .where((item) => item.category == _selectedCategory)
        .toList()
      ..sort((a, b) {
        // Não concluídos primeiro
        if (a.isChecked != b.isChecked) {
          return a.isChecked ? 1 : -1;
        }
        // Depois por data de criação (mais recentes primeiro)
        return b.createdAt.compareTo(a.createdAt);
      });
  }
  
  /// Total de itens
  int get totalItems => _items.length;
  
  /// Itens não concluídos
  int get pendingItems => _items.where((item) => !item.isChecked).length;
  
  /// Itens concluídos
  int get completedItems => _items.where((item) => item.isChecked).length;
  
  // === ESTATÍSTICAS POR CATEGORIA ===
  
  /// Total de itens na categoria
  int itemsInCategory(String category) {
    return _items.where((item) => item.category == category).length;
  }
  
  /// Itens concluídos na categoria
  int completedInCategory(String category) {
    return _items
        .where((item) => item.category == category && item.isChecked)
        .length;
  }
  
  /// Porcentagem de conclusão da categoria
  double completionPercentage(String category) {
    final total = itemsInCategory(category);
    if (total == 0) return 0.0;
    
    final completed = completedInCategory(category);
    return (completed / total) * 100;
  }
  
  // === AÇÕES ===
  
  /// Seleciona uma categoria
  void selectCategory(String category) {
    if (!categories.contains(category)) return;
    
    _selectedCategory = category;
    notifyListeners();
    debugPrint('📂 [ShoppingList] Categoria selecionada: $category');
  }
  
  /// Adiciona novo item
  Future<void> addItem(ShoppingItem item) async {
    _items.add(item);
    notifyListeners();
    await _persist();
    debugPrint('➕ [ShoppingList] Item adicionado: ${item.name}');
  }
  
  /// Atualiza item existente
  Future<void> updateItem(ShoppingItem updatedItem) async {
    final index = _items.indexWhere((item) => item.id == updatedItem.id);
    if (index == -1) return;
    
    _items[index] = updatedItem;
    notifyListeners();
    await _persist();
    debugPrint('✏️ [ShoppingList] Item atualizado: ${updatedItem.name}');
  }
  
  /// Remove item
  Future<void> deleteItem(String id) async {
    final removedItem = _items.firstWhere((item) => item.id == id);
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    await _persist();
    debugPrint('🗑️ [ShoppingList] Item removido: ${removedItem.name}');
  }
  
  /// Marca/desmarca item como concluído
  Future<void> toggleItemCheck(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index == -1) return;
    
    _items[index] = _items[index].copyWith(
      isChecked: !_items[index].isChecked,
    );
    notifyListeners();
    await _persist();
    debugPrint('✅ [ShoppingList] Item ${_items[index].isChecked ? 'concluído' : 'desmarcado'}: ${_items[index].name}');
  }
  
  /// Limpa todos os itens
  Future<void> clearAll() async {
    _items.clear();
    notifyListeners();
    await _persist();
    debugPrint('🗑️ [ShoppingList] Todos os itens removidos');
  }
  
  /// Limpa itens concluídos
  Future<void> clearCompleted() async {
    _items.removeWhere((item) => item.isChecked);
    notifyListeners();
    await _persist();
    debugPrint('🗑️ [ShoppingList] Itens concluídos removidos');
  }
  
  // === PERSISTÊNCIA ===
  
  /// Carrega itens do SharedPreferences
  Future<void> loadItems() async {
    _loading = true;
    notifyListeners();
    
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString('shopping_list_items');
      
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        _items = jsonList
            .map((json) => ShoppingItem.fromJson(json))
            .toList();
        
        debugPrint('📥 [ShoppingList] ${_items.length} itens carregados');
      }
    } catch (e) {
      debugPrint('❌ [ShoppingList] Erro ao carregar: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
  
  /// Persiste itens no SharedPreferences
  Future<void> _persist() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonList = _items.map((item) => item.toJson()).toList();
      final jsonString = json.encode(jsonList);
      
      await prefs.setString('shopping_list_items', jsonString);
      debugPrint('💾 [ShoppingList] ${_items.length} itens salvos');
    } catch (e) {
      debugPrint('❌ [ShoppingList] Erro ao salvar: $e');
    }
  }
}