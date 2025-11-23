// modules/home/data/home_datasource.dart

import 'dart:async';
import '../models/item_model.dart';
import '../../../shared/mock/home_mock_data.dart';

class HomeDatasource {
  /// 🔥 MOCK: Busca de itens localmente (funcional 100%)
  Future<List<ItemModel>> getItemsMock() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return mockItems;
  }

  /// 🔥 MOCK: Adiciona item localmente
  Future<void> saveItemMock(ItemModel item) async {
    await Future.delayed(const Duration(milliseconds: 100));
    mockItems.add(item);
  }

  /// 🔥 MOCK: Remove item localmente
  Future<void> deleteItemMock(int index) async {
    await Future.delayed(const Duration(milliseconds: 100));
    mockItems.removeAt(index);
  }

  /// 🔥 MOCK: Limpa lista
  Future<void> clearItemsMock() async {
    await Future.delayed(const Duration(milliseconds: 100));
    mockItems.clear();
  }

  // ----------------------------------------------------------
  // 🚀 FUTURO (BACKEND REAL) - DEIXAR COMENTADO
  // ----------------------------------------------------------

  /*
  final ApiClient api;

  HomeDatasource(this.api);

  Future<List<ItemModel>> getItemsFromApi() async {
    final response = await api.get('/items');
    return ItemModel.fromList(response.data);
  }

  Future<void> saveItemOnline(ItemModel item) async {
    await api.post('/items', item.toJson());
  }

  Future<void> deleteItemOnline(int id) async {
    await api.delete('/items/$id');
  }

  Future<void> clearItemsOnline() async {
    await api.delete('/items');
  }
  */
}
