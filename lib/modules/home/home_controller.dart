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
  
  /// Lista de itens capturados
  final List<CapturedItem> _items = [];
  
  /// Valor sendo capturado no momento
  double _capturedValue = 0.0;
  
  /// Estado de loading
  bool _loading = false;

  // === GETTERS ===
  
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

  // === MÉTODOS PÚBLICOS ===
  
  /// 📸 Adiciona item capturado automaticamente
  Future<void> addCapturedValue() async {
    if (_capturedValue <= 0) return;
    
    final item = CapturedItem(
      value: _capturedValue,
      type: CaptureType.automatic,
    );
    
    _items.add(item);
    _capturedValue = 0.0;
    notifyListeners();
  }

  /// ✏️ Adiciona item manual
  Future<void> addManualValue(double value, {String? customName}) async {
    if (value <= 0) return;
    
    final item = CapturedItem(
      value: value,
      type: CaptureType.manual,
      customName: customName,
    );
    
    _items.add(item);
    notifyListeners();
  }

  /// ✖️ Adiciona item multiplicado
  Future<void> addMultipliedValue(double baseValue, int multiplier) async {
    if (baseValue <= 0 || multiplier <= 0) return;
    
    final item = CapturedItem(
      value: baseValue,
      type: CaptureType.multiplied,
      multiplier: multiplier,
    );
    
    _items.add(item);
    _capturedValue = 0.0;
    notifyListeners();
  }

  /// 🔢 Define valor sendo capturado
  void setCapturedValue(double value) {
    _capturedValue = value;
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

  /// 💾 Salva estado (para persistência futura)
  Map<String, dynamic> toJson() {
    return {
      'items': _items.map((item) => item.toJson()).toList(),
      'capturedValue': _capturedValue,
    };
  }

  /// 📂 Restaura estado (para persistência futura)
  void fromJson(Map<String, dynamic> json) {
    _items.clear();
    
    final itemsJson = json['items'] as List?;
    if (itemsJson != null) {
      _items.addAll(
        itemsJson.map((json) => CapturedItem.fromJson(json)),
      );
    }
    
    _capturedValue = (json['capturedValue'] as num?)?.toDouble() ?? 0.0;
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
    super.dispose();
  }
}