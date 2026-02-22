import 'package:flutter/foundation.dart';
import 'package:comprei_some_ia/modules/home/models/captured_item.dart';

/// 🎮 Controller da home page
/// 
/// Gerencia:
/// - Lista de itens capturados
/// - Total acumulado
/// - Valor sendo capturado
/// - Estado de loading
class HomeController extends ChangeNotifier {
  // === ESTADO ===
  
  double _budget = 0.0;
  final List<PurchaseSummary> _purchases = [];
  
  /// Lista de itens capturados
  final List<CapturedItem> _items = [];
  
  /// Valor sendo capturado no momento
  double _capturedValue = 0.0;
  
  /// Estado de loading
  bool _loading = false;
  
  /// Nome do item da lista selecionado para vincular à captura
  String? _selectedItemNameForCapture;
  
  /// Unidade do item selecionado para vincular à captura
  String? _selectedUnitLabelForCapture;
  
  /// Quantidade do item selecionado para vincular à captura
  int? _selectedQuantityForCapture;

  // === GETTERS ===
  
  double get budget => _budget;
  
  /// Lista imutável de compras finalizadas
  List<PurchaseSummary> get purchases => List.unmodifiable(_purchases);
  
  /// Lista imutável de itens
  List<CapturedItem> get items => List.unmodifiable(_items);
  
  /// Total acumulado
  double get total => _items.fold(
        0.0,
        (sum, item) => sum + item.finalValue,
      );
  
  /// Valor atual sendo capturado
  double get capturedValue => _capturedValue;
  
  /// Estado de loading
  bool get loading => _loading;
  
  /// Nome do item atualmente selecionado para vincular
  String? get selectedItemNameForCapture => _selectedItemNameForCapture;
  
  /// Unidade do item atualmente selecionado para vincular
  String? get selectedUnitLabelForCapture => _selectedUnitLabelForCapture;
  
  /// Quantidade atualmente selecionada para vincular
  int? get selectedQuantityForCapture => _selectedQuantityForCapture;

  // === MÉTODOS PÚBLICOS ===
  
  /// 📸 Adiciona item capturado automaticamente
  Future<void> addCapturedValue() async {
    if (_capturedValue <= 0) return;
    
    final item = CapturedItem(
      value: _capturedValue,
      type: CaptureType.automatic,
      customName: _selectedItemNameForCapture,
      unitLabel: _selectedUnitLabelForCapture,
      quantity: _selectedQuantityForCapture,
    );
    
    _items.insert(0, item); // Adiciona no início da lista
    _capturedValue = 0.0;
    _selectedItemNameForCapture = null;
    _selectedUnitLabelForCapture = null;
    _selectedQuantityForCapture = null;
    notifyListeners();
  }

  /// ✏️ Adiciona item manual
  Future<void> addManualValue(double value, {String? customName}) async {
    if (value <= 0) return;
    
    final item = CapturedItem(
      value: value,
      type: CaptureType.manual,
      customName: customName ?? _selectedItemNameForCapture,
      unitLabel: _selectedUnitLabelForCapture,
      quantity: _selectedQuantityForCapture,
    );
    
    _items.insert(0, item); // Adiciona no início da lista
    _selectedItemNameForCapture = null;
    _selectedUnitLabelForCapture = null;
    _selectedQuantityForCapture = null;
    notifyListeners();
  }

  /// ✖️ Adiciona item multiplicado
  Future<void> addMultipliedValue(double baseValue, int multiplier) async {
    if (baseValue <= 0 || multiplier <= 0) return;
    
    final item = CapturedItem(
      value: baseValue,
      type: CaptureType.multiplied,
      multiplier: multiplier,
      customName: _selectedItemNameForCapture,
      unitLabel: _selectedUnitLabelForCapture,
      quantity: _selectedQuantityForCapture,
    );
    
    _items.insert(0, item); // Adiciona no início da lista
    _capturedValue = 0.0;
    notifyListeners();
  }

  /// 🔢 Define valor sendo capturado
  void setCapturedValue(double value) {
    _capturedValue = value;
    notifyListeners();
  }
  
  /// Define o item da lista selecionado para vincular à próxima captura
  void setSelectedItemForCapture(String? name, {String? unitLabel, int? quantity}) {
    _selectedItemNameForCapture = name;
    _selectedUnitLabelForCapture = unitLabel;
    _selectedQuantityForCapture = quantity;
    notifyListeners();
  }

  /// ❌ Remove item por índice
  void deleteItem(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
      notifyListeners();
    }
  }

  /// ❌ Remove item por ID
  void deleteItemById(String id) {
    _items.removeWhere((item) => item.id == id);
    notifyListeners();
  }

  /// 🗑️ Limpa todos os itens
  void clearAll() {
    _items.clear();
    _capturedValue = 0.0;
    notifyListeners();
  }

  /// ✏️ Atualiza item existente
  void updateItem(String id, CapturedItem updatedItem) {
    final index = _items.indexWhere((item) => item.id == id);
    if (index != -1) {
      _items[index] = updatedItem;
      notifyListeners();
    }
  }

  /// 🔄 Define estado de loading
  void setLoading(bool value) {
    _loading = value;
    notifyListeners();
  }
  
  void setBudget(double value) {
    _budget = value;
    notifyListeners();
  }
  
  void addFinishedPurchase() {
    if (_items.isEmpty) return;
    final summary = PurchaseSummary(
      date: DateTime.now(),
      total: total,
    );
    _purchases.insert(0, summary);
    if (_purchases.length > 4) {
      _purchases.removeRange(4, _purchases.length);
    }
    notifyListeners();
  }

  /// 💾 Salva estado (para persistência futura)
  Map<String, dynamic> toJson() {
    return {
      'items': _items.map((item) => item.toJson()).toList(),
      'capturedValue': _capturedValue,
      'budget': _budget,
      'purchases': _purchases.map((p) => p.toJson()).toList(),
    };
  }

  /// 📂 Restaura estado (para persistência futura)
  void fromJson(Map<String, dynamic> json) {
    _items.clear();
    _purchases.clear();
    
    final itemsJson = json['items'] as List?;
    if (itemsJson != null) {
      _items.addAll(
        itemsJson.map((json) => CapturedItem.fromJson(json)),
      );
    }
    _capturedValue = (json['capturedValue'] as num?)?.toDouble() ?? 0.0;
    _budget = (json['budget'] as num?)?.toDouble() ?? 0.0;
    final purchasesJson = json['purchases'] as List?;
    if (purchasesJson != null) {
      _purchases.addAll(
        purchasesJson.map((json) => PurchaseSummary.fromJson(json)),
      );
    }
    notifyListeners();
  }

  /// 📊 Estatísticas
  Map<String, dynamic> get statistics {
    return {
      'totalItems': _items.length,
      'total': total,
      'automaticCount': _items.where((i) => i.type == CaptureType.automatic).length,
      'manualCount': _items.where((i) => i.type == CaptureType.manual).length,
      'multipliedCount': _items.where((i) => i.type == CaptureType.multiplied).length,
      'averageValue': _items.isEmpty ? 0.0 : total / _items.length,
    };
  }

  @override
  void dispose() {
    _items.clear();
    _purchases.clear();
    super.dispose();
  }
}

class PurchaseSummary {
  final DateTime date;
  final double total;

  PurchaseSummary({
    required this.date,
    required this.total,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'total': total,
    };
  }

  factory PurchaseSummary.fromJson(Map<String, dynamic> json) {
    return PurchaseSummary(
      date: DateTime.parse(json['date'] as String),
      total: (json['total'] as num).toDouble(),
    );
  }
}
