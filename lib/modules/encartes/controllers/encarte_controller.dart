import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../models/encarte_model.dart';

class EncarteController extends ChangeNotifier {
  List<EncarteModel> _encartes = [];
  bool _isLoading = false;

  List<EncarteModel> get encartes => _encartes;
  bool get isLoading => _isLoading;

  EncarteController() {
    loadEncartes();
  }

  Future<void> loadEncartes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final String? encartesJson = prefs.getString('encartes_list');

      if (encartesJson != null) {
        final List<dynamic> decodedList = jsonDecode(encartesJson);
        _encartes = decodedList.map((e) => EncarteModel.fromMap(e)).toList();
        
        // Ordenar: Favoritos primeiro, depois por data de criação (mais recentes)
        _sortEncartes();
      }
    } catch (e) {
      debugPrint('Erro ao carregar encartes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEncarte(String name, String url) async {
    final newEncarte = EncarteModel(
      id: const Uuid().v4(),
      name: name,
      url: _formatUrl(url),
    );

    _encartes.insert(0, newEncarte);
    _sortEncartes();
    await _saveEncartes();
    notifyListeners();
  }

  Future<void> updateEncarte(EncarteModel encarte) async {
    final index = _encartes.indexWhere((e) => e.id == encarte.id);
    if (index != -1) {
      _encartes[index] = encarte;
      _sortEncartes();
      await _saveEncartes();
      notifyListeners();
    }
  }

  Future<void> removeEncarte(String id) async {
    _encartes.removeWhere((e) => e.id == id);
    await _saveEncartes();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _encartes.indexWhere((e) => e.id == id);
    if (index != -1) {
      final encarte = _encartes[index];
      _encartes[index] = encarte.copyWith(isFavorite: !encarte.isFavorite);
      _sortEncartes();
      await _saveEncartes();
      notifyListeners();
    }
  }

  String _formatUrl(String url) {
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      return 'https://$url';
    }
    return url;
  }

  void _sortEncartes() {
    _encartes.sort((a, b) {
      if (a.isFavorite && !b.isFavorite) return -1;
      if (!a.isFavorite && b.isFavorite) return 1;
      return b.createdAt.compareTo(a.createdAt);
    });
  }

  Future<void> _saveEncartes() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encodedList = jsonEncode(_encartes.map((e) => e.toMap()).toList());
      await prefs.setString('encartes_list', encodedList);
    } catch (e) {
      debugPrint('Erro ao salvar encartes: $e');
    }
  }
}
