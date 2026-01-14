import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

/// 🛒 Controller COMPLETO da Lista de Compras
/// 
/// Gerencia:
/// - Items da lista
/// - Estados (finalizada, compartilhada, pode gerar receitas)
/// - Categorias
/// - Comunicação com backend C#
class ShoppingListController extends ChangeNotifier {
  // ═══════════════════════════════════════════════════════════
  // 📊 ESTADO DA LISTA
  // ═══════════════════════════════════════════════════════════
  
  List<ShoppingItem> _items = [];
  String _selectedCategory = 'Alimentos';
  
  // ✅ FLAGS OBRIGATÓRIAS (conforme especificação)
  bool _isFinalized = false;
  bool _isSharedCopy = false;
  bool _canGenerateRecipes = true; // Backend decide o valor real
  
  // Estados auxiliares
  bool _loading = false;
  String? _errorMessage;
  int? _currentListId; // ID da lista no backend

  // ═══════════════════════════════════════════════════════════
  // 🏷️ CATEGORIAS DISPONÍVEIS
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
  // 🔍 GETTERS PÚBLICOS
  // ═══════════════════════════════════════════════════════════

  /// Todos os itens
  List<ShoppingItem> get items => List.unmodifiable(_items);
  
  /// Itens filtrados pela categoria selecionada
  List<ShoppingItem> get filteredItems => _items
      .where((item) => item.category == _selectedCategory)
      .toList();
  
  /// Categoria atualmente selecionada
  String get selectedCategory => _selectedCategory;
  
  /// Está carregando?
  bool get loading => _loading;
  
  /// Mensagem de erro (se houver)
  String? get errorMessage => _errorMessage;
  
  // ✅ FLAGS PRINCIPAIS (ESPECIFICAÇÃO) - EXIGIDAS PELA lista_page.dart
  
  /// Lista tem itens?
  bool get hasItems => _items.isNotEmpty;
  
  /// Lista está finalizada?
  bool get isFinalized => _isFinalized;
  
  /// É uma cópia recebida de outro usuário?
  bool get isSharedCopy => _isSharedCopy;
  
  /// Pode gerar receitas? (Backend decide)
  bool get canGenerateRecipes => _canGenerateRecipes && _isFinalized;

  // ═══════════════════════════════════════════════════════════
  // 📊 ESTATÍSTICAS POR CATEGORIA
  // ═══════════════════════════════════════════════════════════

  /// Quantidade de itens em uma categoria
  int itemsInCategory(String category) {
    return _items.where((item) => item.category == category).length;
  }

  /// Percentual de conclusão de uma categoria
  double completionPercentage(String category) {
    final categoryItems = _items.where((item) => item.category == category);
    if (categoryItems.isEmpty) return 0;
    
    final checkedItems = categoryItems.where((item) => item.isChecked).length;
    return (checkedItems / categoryItems.length) * 100;
  }

  /// Total de itens marcados
  int get checkedItemsCount {
    return _items.where((item) => item.isChecked).length;
  }

  /// Total de itens não marcados
  int get uncheckedItemsCount {
    return _items.where((item) => !item.isChecked).length;
  }

  // ═══════════════════════════════════════════════════════════
  // 🔄 AÇÕES LOCAIS (SEM BACKEND)
  // ═══════════════════════════════════════════════════════════

  /// Seleciona uma categoria
  void selectCategory(String category) {
    if (categories.contains(category)) {
      _selectedCategory = category;
      notifyListeners();
    }
  }

  /// Marca/desmarca um item
  void toggleItemCheck(String id) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = _items[index].copyWith(
        isChecked: !_items[index].isChecked,
      );
      notifyListeners();
      
      // Sincroniza com backend (opcional)
      _syncItemWithBackend(_items[index]);
    }
  }

  /// Adiciona um item (local + backend)
  Future<void> addItem(ShoppingItem item) async {
    // Adiciona localmente primeiro
    _items.add(item);
    notifyListeners();
    
    // Tenta salvar no backend
    try {
      await _saveItemToBackend(item);
    } catch (e) {
      print('Erro ao salvar item: $e');
      // Item fica salvo localmente mesmo se backend falhar
    }
  }

  /// Atualiza um item
  Future<void> updateItem(ShoppingItem item) async {
    final index = _items.indexWhere((i) => i.id == item.id);
    if (index != -1) {
      _items[index] = item;
      notifyListeners();
      
      try {
        await _updateItemOnBackend(item);
      } catch (e) {
        print('Erro ao atualizar item: $e');
      }
    }
  }

  /// Remove um item
  Future<void> deleteItem(String id) async {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
    
    try {
      await _deleteItemOnBackend(id);
    } catch (e) {
      print('Erro ao deletar item: $e');
    }
  }

  /// Limpa todos os itens
  void clearItems() {
    _items.clear();
    _isFinalized = false;
    _canGenerateRecipes = true;
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════════
  // 🌐 CONFIGURAÇÃO DO BACKEND
  // ═══════════════════════════════════════════════════════════

  static const String baseUrl = 'https://seu-backend.com/api';
  String? _authToken; // JWT token do usuário logado

  /// Define o token de autenticação
  void setAuthToken(String token) {
    _authToken = token;
    notifyListeners();
  }

  /// Headers padrão para requisições
  Map<String, String> get _headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    if (_authToken != null) 'Authorization': 'Bearer $_authToken',
  };

  // ═══════════════════════════════════════════════════════════
  // 🌐 COMUNICAÇÃO COM BACKEND C# - BÁSICO
  // ═══════════════════════════════════════════════════════════

  /// Carrega itens do backend
  Future<void> loadItems() async {
    _loading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/shopping-items'),
        headers: _headers,
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        _items = data.map((item) => ShoppingItem.fromJson(item)).toList();
        _errorMessage = null;
      } else {
        _errorMessage = 'Erro ao carregar lista';
      }
    } catch (e) {
      _errorMessage = 'Erro de conexão: $e';
      print('Erro ao carregar itens: $e');
      // Continua com lista vazia em caso de erro
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Salva item no backend
  Future<void> _saveItemToBackend(ShoppingItem item) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/shopping-items'),
        headers: _headers,
        body: json.encode(item.toJson()),
      );

      if (response.statusCode != 201) {
        throw Exception('Erro ao salvar item');
      }
    } catch (e) {
      print('Erro ao salvar no backend: $e');
      // Não propaga erro - item fica salvo localmente
    }
  }

  /// Atualiza item no backend
  Future<void> _updateItemOnBackend(ShoppingItem item) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/shopping-items/${item.id}'),
        headers: _headers,
        body: json.encode(item.toJson()),
      );

      if (response.statusCode != 200) {
        throw Exception('Erro ao atualizar item');
      }
    } catch (e) {
      print('Erro ao atualizar no backend: $e');
    }
  }

  /// Deleta item no backend
  Future<void> _deleteItemOnBackend(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/shopping-items/$id'),
        headers: _headers,
      );

      if (response.statusCode != 204 && response.statusCode != 200) {
        throw Exception('Erro ao deletar item');
      }
    } catch (e) {
      print('Erro ao deletar no backend: $e');
    }
  }

  /// Sincroniza item com backend (usado no toggle)
  Future<void> _syncItemWithBackend(ShoppingItem item) async {
    try {
      await http.patch(
        Uri.parse('$baseUrl/shopping-items/${item.id}/check'),
        headers: _headers,
        body: json.encode({'isChecked': item.isChecked}),
      );
    } catch (e) {
      print('Erro ao sincronizar: $e');
    }
  }

  // ═══════════════════════════════════════════════════════════
  // ✅ FINALIZAR LISTA (AÇÃO PRINCIPAL 1) - EXIGIDO PELA lista_page.dart
  // ═══════════════════════════════════════════════════════════

  /// Finaliza a lista (marca como concluída)
  /// Backend valida e marca como "finalized"
  Future<void> finalizeList() async {
    if (_items.isEmpty) {
      throw Exception('Lista vazia não pode ser finalizada');
    }

    _loading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lists/finalize'),
        headers: _headers,
        body: json.encode({
          'listId': _currentListId,
          'items': _items.map((item) => item.toJson()).toList(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _isFinalized = true;
        _currentListId = data['listId']; // Backend retorna o ID
        _canGenerateRecipes = data['canGenerateRecipes'] ?? true;
        notifyListeners();
      } else {
        throw Exception('Erro ao finalizar lista');
      }
    } catch (e) {
      // Modo offline: marca como finalizada localmente
      _isFinalized = true;
      notifyListeners();
      print('Erro ao finalizar (modo offline): $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ═══════════════════════════════════════════════════════════
  // 📤 COMPARTILHAR LISTA (AÇÃO PRINCIPAL 2) - EXIGIDO PELA lista_page.dart
  // ═══════════════════════════════════════════════════════════

  /// Compartilha a lista com outro usuário
  /// Backend cria uma cópia e envia
  Future<void> shareList(String emailOrCode) async {
    if (!_isFinalized) {
      throw Exception('Lista precisa estar finalizada');
    }

    if (emailOrCode.trim().isEmpty) {
      throw Exception('Email ou código inválido');
    }

    _loading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/lists/share'),
        headers: _headers,
        body: json.encode({
          'listId': _currentListId,
          'recipient': emailOrCode.trim(),
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        // Sucesso - lista compartilhada
        return;
      } else if (response.statusCode == 404) {
        throw Exception('Usuário não encontrado');
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Erro ao compartilhar');
      }
    } catch (e) {
      throw Exception('$e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ═══════════════════════════════════════════════════════════
  // 🍳 GERAR RECEITAS COM IA (AÇÃO PRINCIPAL 3) - EXIGIDO PELA lista_page.dart
  // ═══════════════════════════════════════════════════════════

  /// Gera receitas usando IA
  /// Backend valida regras e chama API da IA
  Future<List<Recipe>> generateRecipes() async {
    if (!_isFinalized) {
      throw Exception('Finalize a lista para gerar receitas');
    }

    if (_items.isEmpty) {
      throw Exception('Lista vazia');
    }

    _loading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/recipes/generate'),
        headers: _headers,
        body: json.encode({
          'listId': _currentListId,
          'items': _items.map((item) => item.name).toList(),
        }),
      ).timeout(const Duration(seconds: 30)); // IA pode demorar

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final recipes = (data['recipes'] as List)
            .map((recipe) => Recipe.fromJson(recipe))
            .toList();
        
        // Backend já marcou como "usado"
        _canGenerateRecipes = false;
        notifyListeners();
        
        return recipes;
        
      } else if (response.statusCode == 400) {
        // Backend bloqueou
        final error = json.decode(response.body);
        final message = error['message'] ?? '';
        
        if (message.contains('já')) {
          throw Exception('Sugestões já utilizadas para esta lista');
        } else if (message.contains('limite')) {
          throw Exception('Sugestões indisponíveis no momento');
        } else {
          throw Exception(message);
        }
      } else {
        throw Exception('Erro ao gerar receitas');
      }
    } catch (e) {
      throw Exception('$e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ═══════════════════════════════════════════════════════════
  // 📥 RECEBER LISTA COMPARTILHADA
  // ═══════════════════════════════════════════════════════════

  /// Carrega uma lista compartilhada por outro usuário
  Future<void> loadSharedList(String shareCode) async {
    _loading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/lists/shared/$shareCode'),
        headers: _headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _items = (data['items'] as List)
            .map((item) => ShoppingItem.fromJson(item))
            .toList();
        _isSharedCopy = true;
        _isFinalized = true;
        _canGenerateRecipes = false; // Cópias não geram receitas
      } else {
        throw Exception('Lista não encontrada ou expirada');
      }
    } catch (e) {
      throw Exception('Erro ao carregar lista: $e');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  // ═══════════════════════════════════════════════════════════
  // 🔄 RESET
  // ═══════════════════════════════════════════════════════════

  /// Reseta o controller (nova lista)
  void reset() {
    _items.clear();
    _selectedCategory = 'Alimentos';
    _isFinalized = false;
    _isSharedCopy = false;
    _canGenerateRecipes = true;
    _loading = false;
    _errorMessage = null;
    _currentListId = null;
    notifyListeners();
  }
}

// ═══════════════════════════════════════════════════════════
// 📝 MODELO: SHOPPING ITEM
// ═══════════════════════════════════════════════════════════

class ShoppingItem {
  final String id;
  final String name;
  final int quantity;
  final String category;
  final bool isChecked;
  final DateTime createdAt;

  ShoppingItem({
    String? id,
    required this.name,
    required this.quantity,
    required this.category,
    this.isChecked = false,
    DateTime? createdAt,
  })  : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

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
    );
  }
}

// ═══════════════════════════════════════════════════════════
// 📝 MODELO: RECIPE
// ═══════════════════════════════════════════════════════════

class Recipe {
  final String title;
  final String content;

  Recipe({
    required this.title,
    required this.content,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      title: json['title'] ?? '',
      content: json['content'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'content': content,
    };
  }
}