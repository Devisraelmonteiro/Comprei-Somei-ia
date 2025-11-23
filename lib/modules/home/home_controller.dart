// lib/modules/home/home_controller.dart

import 'package:flutter/material.dart';

import 'data/home_repository.dart';
import 'data/home_datasource.dart';
import 'models/item_model.dart';

class HomeController extends ChangeNotifier {
  final HomeRepository repository = HomeRepository(HomeDatasource());

  List<ItemModel> items = [];
  bool loading = false;
  double total = 0.0;

  // Valor capturado — mockado
  double capturedValue = 0.0;

  HomeController() {
    loadItems();
  }

  Future<void> loadItems() async {
    loading = true;
    notifyListeners();

    items = await repository.getItems();
    calculateTotal();

    loading = false;
    notifyListeners();
  }

  void calculateTotal() {
    total = items.fold(0.0, (sum, item) => sum + item.value);
  }

  Future<void> addCapturedValue() async {
    final item = ItemModel(
      value: capturedValue,
      createdAt: DateTime.now().toString(),
    );

    await repository.saveItem(item);

    items.add(item);
    calculateTotal();
    notifyListeners();
  }

  Future<void> deleteItem(int index) async {
    await repository.deleteItem(index);
    items.removeAt(index);
    calculateTotal();
    notifyListeners();
  }

  Future<void> clearAll() async {
    await repository.clearItems();
    items.clear();
    calculateTotal();
    notifyListeners();
  }

  void setCapturedValue(double value) {
    capturedValue = value;
    notifyListeners();
  }

  // ----------------------------------------------------------
  // 🚀 BACKEND FUTURO
  // ----------------------------------------------------------
  /*
  Future<void> syncWithBackend() async {
    loading = true;
    notifyListeners();

    await repository.syncItemsOnline();

    loading = false;
    notifyListeners();
  }
  */
}
