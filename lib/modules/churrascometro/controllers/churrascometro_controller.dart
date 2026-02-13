import 'package:flutter/material.dart';
import '../models/churrasco_model.dart';

class ChurrascometroController extends ChangeNotifier {
  ChurrascoModel _model = const ChurrascoModel();

  ChurrascoModel get model => _model;

  void updateAdultos(int value) {
    if (value < 0) return;
    _model = _model.copyWith(adultos: value);
    notifyListeners();
  }

  void updateCriancas(int value) {
    if (value < 0) return;
    _model = _model.copyWith(criancas: value);
    notifyListeners();
  }

  void updateDuracao(int value) {
    if (value < 1) return;
    _model = _model.copyWith(duracaoHoras: value);
    notifyListeners();
  }

  void toggleBebidaAlcoolica(bool value) {
    _model = _model.copyWith(bebidaAlcoolica: value);
    notifyListeners();
  }

  void toggleCarvao(bool value) {
    _model = _model.copyWith(carvao: value);
    notifyListeners();
  }

  void toggleGelo(bool value) {
    _model = _model.copyWith(gelo: value);
    notifyListeners();
  }

  void togglePaoDeAlho(bool value) {
    _model = _model.copyWith(paoDeAlho: value);
    notifyListeners();
  }
}
