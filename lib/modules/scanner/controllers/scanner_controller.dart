import 'package:flutter/foundation.dart';
import '../models/scanned_value.dart';

class ScannerController extends ChangeNotifier {
  ScannedValue? _scannedValue;
  bool _isLocked = false;

  ScannedValue? get scannedValue => _scannedValue;
  bool get isLocked => _isLocked;

  /// Chamado pelo OCR
  void onValueDetected(ScannedValue value) {
    if (_isLocked) return;

    _scannedValue = value;
    _isLocked = true; // TRAVA ao detectar
    notifyListeners();
  }

  /// Usuário confirma
  void confirm() {
    // FUTURO: enviar para backend
    _unlock();
  }

  /// Usuário cancela
  void cancel() {
    _scannedValue = null;
    _unlock();
  }

  /// Usuário multiplica valor
  void multiply(int quantity) {
    if (_scannedValue == null) return;

    _scannedValue = _scannedValue!.copyWith(
      value: _scannedValue!.value * quantity,
    );
    notifyListeners();
  }

  void _unlock() {
    _isLocked = false;
    notifyListeners();
  }
}
